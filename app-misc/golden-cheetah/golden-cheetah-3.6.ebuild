# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

MY_PN="GoldenCheetah"
MY_PV="${PV}" # Exemple de version ajustée directement
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Cycling performance software"
HOMEPAGE="http://www.goldencheetah.org/"
SRC_URI="https://github.com/GoldenCheetah/${MY_PN}/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="vlc antplus"

DEPEND="
	sci-libs/gsl
	dev-qt/qtopengl:5
	dev-qt/qtconcurrent:5
	dev-qt/qtmultimedia:5[widgets]
	dev-qt/qtprintsupport:5
	dev-qt/qtscript:5
	dev-qt/qtserialport:5
	dev-qt/qtsvg:5
	dev-qt/qttranslations:5
	dev-qt/qtwebengine:5
	dev-qt/qtwebchannel:5
	dev-qt/qtlocation:5
	dev-qt/qtbluetooth:5
	dev-qt/qtcharts:5
	dev-qt/qtchooser
	dev-qt/qtsql:5
	dev-lang/R
	sys-devel/flex
	sys-devel/bison
	antplus? ( dev-libs/libusb-compat )
	vlc? ( media-video/vlc )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	eapply_user

	sed -e "s:#QMAKE_LRELEASE:QMAKE_LRELEASE:" src/gcconfig.pri.in >src/gcconfig.pri || die
	sed -i "s:#QMAKE_MOVE = cp:QMAKE_MOVE = cp:" src/gcconfig.pri || die
	sed -i "s:#QMAKE_LEX  = flex:QMAKE_LEX  = flex:" src/gcconfig.pri || die
	sed -i "s:#QMAKE_YACC = bison:QMAKE_YACC = bison:" src/gcconfig.pri || die
	sed -i "s:#CONFIG += release:CONFIG += release:" src/gcconfig.pri || die

	# add in libz support, needed because something something QT on Gentoo
	sed -i "s:#LIBZ_INCLUDE.*:LIBZ_INCLUDE = yes:" src/gcconfig.pri || die
	sed -i "s:#LIBZ_LIBS.*:LIBZ_LIBS = -lz:" src/gcconfig.pri || die

	sed -i "s:#GSL_INCLUDES = /usr/include:GSL_INCLUDES = /usr/include:" src/gcconfig.pri || die
	sed -i "s:#GSL_LIBS = -lgsl -lgslcblas -lm:GSL_LIBS = -lgsl -lgslcblas -lm:" src/gcconfig.pri || die

	# add in libusb support, for ANT+ usb dongles
	# requires libusb-compat
	if use antplus; then
		sed -i "s:#LIBUSB_INSTALL.*:LIBUSB_INSTALL = yes:" src/gcconfig.pri || die
		sed -i "s:#LIBUSB_INCLUDE.*:LIBUSB_INCLUDE = /usr/include:" src/gcconfig.pri || die
		sed -i "s:#LIBUSB_LIBS.*:LIBUSB_LIBS = -lusb:" src/gcconfig.pri || die
	fi

	if use vlc; then
		# add in VLC support
		sed -i "s:#VLC_INSTALL.*:VLC_INSTALL = yes:" src/gcconfig.pri || die
		sed -i "s:#VLC_INCLUDE.*:VLC_INCLUDE = /usr/include:" src/gcconfig.pri || die
		sed -i "s:#VLC_LIBS.*:VLC_LIBS = -lvlc -lvlccore:" src/gcconfig.pri || die
		sed -i "s:DEFINES += GC_VIDEO_NONE:#DEFINES += GC_VIDEO_VLC:" src/gcconfig.pri || die
	else
		sed -i "s:DEFINES += GC_VIDEO_VLC:#DEFINES += GC_VIDEO_NONE:" src/gcconfig.pri || die
	fi

	sed -e "s:/usr/local/:/usr/:" qwt/qwtconfig.pri.in >qwt/qwtconfig.pri || die
}

src_configure() {
	eqmake5 -recursive
}

src_install() {
	emake DESTDIR="${D}" INSTALL_ROOT="${D}" install

	dobin "src/GoldenCheetah"
}
