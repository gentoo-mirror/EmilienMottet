EAPI=8

inherit git-r3 meson

DESCRIPTION="An ultralightweight stacking window manager"
HOMEPAGE="https://github.com/Vladimir-csp/uwsm"
EGIT_REPO_URI="https://github.com/Vladimir-csp/uwsm.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="uuctl uwsm-app"

RDEPEND="
	dev-python/pyxdg
	sys-apps/dbus-broker
"
DEPEND="${RDEPEND}"

src_configure() {
	local myemesonargs=(
		$(meson_feature uuctl uuctl)
		$(meson_feature uwsm-app uwsm-app)
	)
	meson_src_configure
}

pkg_postinst() {
	elog "To properly configure uwsm, ensure that dbus-broker is used as the D-Bus daemon."
	elog "Consider running 'uwsm finalize' with the necessary environment variables after starting your compositor."
}
