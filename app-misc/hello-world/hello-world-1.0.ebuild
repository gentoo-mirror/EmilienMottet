# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A classical example to use when starting on something new"
HOMEPAGE="https://wiki.gentoo.org/index.php?title=Basic_guide_to_write_Gentoo_Ebuilds"
SRC_URI="https://gitlab.com/alogim/gentoo-basic-ebuild/raw/master/update1/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
DEPEND="${RDEPEND}"

src_install() {
	dobin hello-world
}
