# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10,11,12} )

inherit git-r3 distutils-r1

DESCRIPTION="A tool to remotely control LG Web OS TVs"
HOMEPAGE="https://github.com/klattimer/LGWebOSRemote"
EGIT_REPO_URI="https://github.com/klattimer/LGWebOSRemote.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/ws4py
	dev-python/pycryptodomex
	dev-python/websocket-client
"
BDEPEND="dev-python/setuptools"
DEPEND="${RDEPEND}"
