EAPI=8

inherit git-r3

DESCRIPTION="Intel IPU6 camera binaries (Alder Lake)"
HOMEPAGE="https://github.com/intel/ipu6-camera-bins"
EGIT_REPO_URI="https://github.com/intel/ipu6-camera-bins.git"
LICENSE="unknown"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

BDEPEND="dev-vcs/git
		app-admin/chrpath
		dev-util/patchelf"
DEPEND="sys-libs/glibc
		media-video/ipu6-drivers"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}"

src_prepare() {
	default
}

src_install() {
	local IPULIB="/usr/lib/ipu_adl"
	local TARGET_LIB_PATH="/usr/lib"

	insinto /usr/lib
	doins -r "${S}/lib"/*

	insinto /usr/lib/pkgconfig
	doins -r "${S}/lib/ipu_adl/pkgconfig"/*

	insinto /usr/include
	doins -r "${S}/include"/*

	# Fixing paths and adding symlinks as necessary

	# dosym ${IPULIB}/libia_ccat.so /usr/lib64/libia_ccat.so
	# dosym ${IPULIB}/libia_cca.so /usr/lib64/libia_cca.so
	# dosym ${IPULIB}/libia_log.so /usr/lib64/libia_log.so
	# dosym ${IPULIB}/libgcss.so.0 /usr/lib64/libgcss.so.0

	exeinto ${TARGET_LIB_PATH}

	for lib in "${D}"/usr/lib/ipu_adl/*.so; do
		echo ${lib}
		echo ${TARGET_LIB_PATH}
		chrpath --delete "${lib}"
		patchelf --set-rpath "${TARGET_LIB_PATH}" "${lib}"
	done
}

pkg_postinst() {
	elog "Please note that some manual steps might be required to fully configure"
	elog "the Intel IPU6 camera binaries. Check the documentation and"
	elog "https://github.com/intel/ipu6-camera-bins for more information."
}

# # Copyright 1999-2024 Gentoo Authors
# # Distributed under the terms of the GNU General Public License v2

# EAPI=8

# MY_LIBDIR="/usr/lib64"

# DESCRIPTION="Binary library for Intel IPU6"
# HOMEPAGE="https://github.com/intel/ipu6-drivers"
# SRC_URI="https://github.com/intel/${PN}/archive/${MY_COMMIT}/${PN}-${MY_SHORT_COMMIT}.tar.gz"

# LICENSE="ipu6-camera-bins"
# SLOT="0"
# KEYWORDS="~amd64"

# BDEPEND="app-admin/chrpath
# 		 dev-util/patchelf"

# RDEPEND="media-video/ipu6-drivers"

# S=${WORKDIR}/${PN}-${MY_COMMIT}

# src_install() {
# 	for i in ipu6 ipu6ep; do
# 		elog "Rewriting runpath for $i libs"
# 		chrpath --delete $i/lib/*.so
# 		patchelf --set-rpath ${MY_LIBDIR}/$i $i/lib/*.so
# 		sed -i \
# 			-e "s|libdir=/usr/lib|libdir=${MY_LIBDIR}|g" \
# 			-e "s|libdir}|libdir}/$i|g" \
# 			-e "s|includedir}|includedir}/$i|g" \
# 			$i/lib/pkgconfig/*.pc
# 		# dolib.so doesn't work with custom paths
# 		insinto ${MY_LIBDIR}/$i
# 		insopts -m755
# 		doins $i/lib/*.so*

# 		insinto ${MY_LIBDIR}/$i/pkgconfig
# 		doins $i/lib/pkgconfig/*.pc

# 		# need to copy ipu6/include/ia_camera/GCSSParser.h to /usr/include/ipu6/ia_camera/GCSSParser.h
# 		insinto /usr/include/$i
# 		insopts -m644
# 		doins -r $i/include/*

# 		# do we need this?
# 		insinto ${MY_LIBDIR}/$i
# 		doins $i/lib/*.a
# 	done

# 	insinto /lib/firmware/intel/
# 	insopts -m644
# 	doins ipu6/lib/firmware/intel/ipu6_fw.bin
# 	doins ipu6ep/lib/firmware/intel/ipu6ep_fw.bin
# }
