# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake

DESCRIPTION="a simple Wayland output mirror client"
HOMEPAGE="https://github.com/Ferdi265/wl-mirror"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Ferdi265/wl-mirror"
else
	SRC_URI="https://github.com/Ferdi265/wl-mirror/releases/download/v${PV}/${P}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/wayland"

DEPEND="${RDEPEND}"
