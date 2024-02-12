EAPI=8
inherit systemd

DESCRIPTION="Thales/Gemalto SafeNet Authentication Client for eToken 5110/5300 & IDPrime"
HOMEPAGE="https://cpl.thalesgroup.com/access-management/security-applications/authentication-client-token-management"
SRC_URI="https://nullroute.lt/tmp/2023/pkg/SAC_Linux_10.8.105_R1_GA.zip"

LICENSE="custom"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+gui +systemd"

DEPEND="app-arch/unzip
	   net-misc/curl
	   sys-apps/systemd"

RDEPEND="sys-apps/pcsc-lite
		 app-crypt/ccid
		 gui? ( x11-libs/gtk+:3 )"

BDEPEND="app-arch/dpkg"

S="${WORKDIR}"

src_prepare() {
	default
	# Unzip to get the .deb package
	local _dir="${WORKDIR}/SAC Linux ${PV} R1 GA"
	local _deb_path="Installation/Standard/Ubuntu-2204"
	local _deb=""

	if ! use gui; then
		_deb_path="Installation/withoutUI/Ubuntu-2204"
	fi

	_deb="${_dir}/${_deb_path}/safenetauthenticationclient_${PV}_amd64.deb"

	# Extract the DEB package
	dpkg-deb -x "${_deb}" "${S}" || die "Failed to extract ${_deb}"
	mv "${S}/usr/lib" "${S}/usr/lib64"
}

src_install() {
	default

	# Install all files from the DEB package
	doins -r etc usr

	# Make files in /usr/bin executable
	fperms 0755 /usr/bin/SACSrv
	fperms 0755 /usr/bin/SACMonitor
	fperms 0755 /usr/bin/SACTools

	if use systemd; then
		# Install the systemd service file
		insinto /etc/systemd/system
		doins "${FILESDIR}/safenetauthenticationclient.service"
		# Ensure the service file is properly named and in the right location
		systemd_dounit "${D}/etc/systemd/system/safenetauthenticationclient.service"
		# Remove the old init.d file if present
		rm -f "${D}/etc/init.d/safenetauthenticationclient" || die "Failed to remove old init script"
	fi

	# If gui is not used, remove GUI-related files
	if ! use gui; then
		rm -rf "${ED}/usr/share/applications" || die
		rm -rf "${ED}/usr/share/icons" || die
	fi

	# Create missing soname symlinks
	dosym libIDClassicSISTokenEngine.so.10.8.1050 /usr/lib64/libIDClassicSISTokenEngine.so.10
	dosym libIDPVSlotEngine.so.10.8.1050 /usr/lib64/libIDPVSlotEngine.so.10
	dosym libIDPrimePKCS11.so.10.8.1050 /usr/lib64/libIDPrimePKCS11.so.10
	dosym libIDPrimeSISTokenEngine.so.10.8.1050 /usr/lib64/libIDPrimeSISTokenEngine.so.10
	dosym libIDPrimeTokenEngine.so.10.8.1050 /usr/lib64/libIDPrimeTokenEngine.so.10
	dosym libSACLog.so.10.8.1050 /usr/lib64/libSACLog.so.10
	dosym libeTokenHID.so.10.8.1050 /usr/lib64/libeTokenHID.so.10
}

pkg_postinst() {
	if use systemd; then
		elog "Please start the safenetauthenticationclient service using:"
		elog "systemctl start safenetauthenticationclient"
	fi
}
