# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

_PN="${PN/-bin/}"
ELECTRON_APP_ELECTRON_V="18.1.0"

inherit electron-app git-r3

DESCRIPTION="Combine your favorite messaging services into one application"
HOMEPAGE="https://getferdi.com"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="wayland"
KEYWORDS="~amd64"
EGIT_REPO_URI="https://github.com/getferdi/ferdi.git"

RDEPEND="
wayland? ( dev-libs/wayland )"
BDEPEND+=" net-libs/nodejs[npm]"
DEPEND="!net-im/ferdi-bin"

# src_prepare() {
# 	echo "${FILESDIR}/${_PN}.desktop"
# 	default
# }

# src_install() {
# 	declare FERDI_HOME=/opt/${_PN}

# 	dodir ${FERDI_HOME%/*}

# 	insinto ${FERDI_HOME}
# 	doins -r opt/${_PN^}/*

# 	exeinto ${FERDI_HOME}
# 	exeopts -m0755
# 	doexe "opt/${_PN^}/${_PN}"

# 	dosym "${FERDI_HOME}/${_PN}" "/usr/bin/${PN}"

# 	newmenu usr/share/applications/${_PN}.desktop ${PN}.desktop

# 	for _size in 16 24 32 48 64 96 128 256 512; do
# 		newicon -s ${_size} "usr/share/icons/hicolor/${_size}x${_size}/apps/${_PN}.png" "${PN}.png"
# 	done

# 	# desktop eclass does not support installing 1024x1024 icons
# 	insinto /usr/share/icons/hicolor/1024x1024/apps
# 	newins "usr/share/icons/hicolor/1024x1024/apps/${_PN}.png" "${PN}.png"

# 	# Installing 128x128 icon in /usr/share/pixmaps for legacy DEs
# 	newicon "usr/share/icons/hicolor/128x128/apps/${_PN}.png" "${PN}.png"

# 	insinto /usr/share/licenses/${PN}
# 	for _license in 'LICENSE.electron.txt' 'LICENSES.chromium.html'; do
# 	doins opt/${_PN^}/$_license
# 	done
# }

# PATCHES=(
# 	"${FILESDIR}/0001-fix-package.json-.npmrc.patch"
# )

# src_prepare() {
# 	echo "src PREPARE"
# 	default
# }

src_unpack() {
	git-r3_src_unpack
	# sed -E -i -e "s|engine-strict = true|engine-strict = false|" "${S}/.npmrc"
	# sed -i 's/is-ci || husky install/is-ci || husky install || true/g' "${S}/package.json"
	pushd "${S}" || die
	eapply "${FILESDIR}/0001-fix-package.json-.npmrc.patch"
	popd || die
	electron-app_src_unpack
}

electron-app_src_compile() {
	cd "${S}" || die
	export PATH="${S}/node_modules/.bin:${PATH}"
	npm run build -- -l dir || die
}

src_install() {
	local cmd_args=""
	export ELECTRON_APP_INSTALL_PATH="/opt/${PN}"
	if use wayland ; then
		cmd_args+=" -enable-features=WebRTCPipeWireCapturer --enable-features=UseOzonePlatform --ozone-platform=wayland"
	fi

	electron-app_desktop_install "out/linux-unpacked/*" "src/assets/logo.png" "${MY_PN}" \
								 "Network;InstantMessaging" "${ELECTRON_APP_INSTALL_PATH}/ferdi \"\$@\""
	fperms 0755 ${ELECTRON_APP_INSTALL_PATH}/ferdi
	npm-utils_install_licenses
}

# pkg_postinst() {
# 	xdg_desktop_database_update
# 	xdg_mimeinfo_database_update
# }

# pkg_postrm() {
# 	xdg_desktop_database_update
# 	xdg_mimeinfo_database_update
# }
