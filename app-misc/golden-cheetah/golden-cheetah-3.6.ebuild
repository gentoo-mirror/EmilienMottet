EAPI=8

DESCRIPTION="GoldenCheetah - Performance Software for Cyclists (AppImage)"
HOMEPAGE="http://www.goldencheetah.org/"
SRC_URI="https://github.com/GoldenCheetah/GoldenCheetah/releases/download/v3.6/GoldenCheetah_v3.6_x64.AppImage"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}/GoldenCheetah_v3.6_x64.AppImage" "${S}/"
}

src_prepare() {
	default
	chmod +x "${S}/GoldenCheetah_v3.6_x64.AppImage"
}

src_install() {
	into /opt/golden-cheetah
	doexe "${S}/GoldenCheetah_v3.6_x64.AppImage"
	dosym /opt/golden-cheetah/GoldenCheetah_v3.6_x64.AppImage /usr/bin/golden-cheetah
}

pkg_postinst() {
	einfo "GoldenCheetah (AppImage) has been installed. Run it via 'golden-cheetah' command."
}
