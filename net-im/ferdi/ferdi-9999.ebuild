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

src_unpack() {
	git-r3_src_unpack
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
								 "Network;InstantMessaging" "${ELECTRON_APP_INSTALL_PATH}/ferdi ${cmd_args} \"\$@\""
	fperms 0755 ${ELECTRON_APP_INSTALL_PATH}/ferdi
	npm-utils_install_licenses
}
