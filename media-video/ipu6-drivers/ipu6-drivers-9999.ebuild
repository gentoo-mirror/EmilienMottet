# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod toolchain-funcs

inherit git-r3
# EGIT_REPO_URI="https://git.launchpad.net/~vicamo/+git/intel-ipu6-dkms"
# EGIT_BRANCH="ubuntu/devel"

EGIT_REPO_URI="https://github.com/intel/ipu6-drivers.git"
IVSC_REPO_URI="https://github.com/intel/ivsc-driver.git"

DESCRIPTION="Drivers for MIPI cameras through the IPU6 on Intel Tiger Lake and Alder Lake platforms."
# HOMEPAGE="https://github.com/intel/ipu6-drivers"
HOMEPAGE="https://github.com/jwrdegoede/ipu6-drivers"

SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="
	virtual/linux-sources
	sys-kernel/linux-headers
"
RDEPEND=""

MODULE_NAMES="  intel-ipu6(drivers/media/pci/intel/ipu6:${S}:drivers/media/pci/intel/ipu6) \
				intel-ipu6-isys(drivers/media/pci/intel/ipu6:${S}:drivers/media/pci/intel/ipu6) \
				intel-ipu6-psys(drivers/media/pci/intel/ipu6:${S}:drivers/media/pci/intel/ipu6) \
				"

src_unpack() {
	git-r3_src_unpack
	pushd "${P}" >/dev/null || die
	git-r3_fetch "${IVSC_REPO_URI}"
	git-r3_checkout "${IVSC_REPO_URI}" ivsc-driver

	cp -vr ivsc-driver/backport-include ivsc-driver/drivers ivsc-driver/include .
	rm -rf ivsc-driver
	popd >/dev/null || die
}

pkg_setup() {
	linux-mod_pkg_setup

	BUILD_TARGETS="clean all"
}

src_compile() {
	KBUILD_MODPOST_WARN=1 linux-mod_src_compile
}

src_install() {
	linux-mod_src_install
}
