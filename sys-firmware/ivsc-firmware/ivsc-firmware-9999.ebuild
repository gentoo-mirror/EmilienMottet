# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="This provides the necessary firmware for Intel iVSC"
HOMEPAGE="https://github.com/intel/ivsc-firmware"
EGIT_REPO_URI="https://github.com/intel/ivsc-firmware.git"

LICENSE="ivsc-firmware"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="media-video/ipu6-drivers"

S=${WORKDIR}/${P}/firmware

src_install() {
	for i in *.bin; do
		insinto /lib/firmware/vsc/soc_a1
		insopts -m644
		newins "${i}" $(echo "${i}" | sed 's|\.bin|_a1\.bin|')
		insinto /lib/firmware/vsc/soc_a1_prod
		insopts -m644
		newins "${i}" $(echo "${i}" | sed 's|\.bin|_a1_prod\.bin|')
	done
}
