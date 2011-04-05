# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit linux-mod

DESCRIPTION="Kernel module for the Avermedia A828 USB Adapter"
HOMEPAGE="http://www.avermedia.com/"
SRC_URI="
	amd64? (
		http://www.avermedia.com/avertv/Support/DownloadCount.aspx?FDFId=3204 ->
			A828_Installer_x64_0.28-Beta_091125.zip
		)
	"

LICENSE="AVerMediaLinuxDriver"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="mirror strip"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/"A828_Installer_x64_0.28-Beta"

pkg_setup() {
	MODULE_NAMES="
		averusba828(video:${S}/drv/installer/src:${S}/drv/installer/src)
		a828(video:${S}/drv/installer/src:${S}/drv/installer/src) 
	"
	BUILD_TARGETS="default"
	linux-mod_pkg_setup
}

src_prepare() {
	# fix the installer
	epatch "${FILESDIR}"/"${PN}".installer.patch

	# extract the thing
	./AVERMEDIA-Linux-x64-A828-0.28-beta.sh "${S}"/drv

	cd drv/installer
	# fix driver
	# http://www.linuxtv.org/wiki/index.php/AVerMedia_A828
	kernel_is ge 2 6 37 && epatch "${FILESDIR}"/"${PN}"-2.6.37.patch

	cp "${FILESDIR}"/install_prebuilt.sh .
	# moving prebuilt stuff to place
	./install_prebuilt.sh "${S}"/drv/installer $KV_DIR $KV_OUT_DIR

	BUILD_PARAMS="KERNELDIR=\"${KV_DIR}\""
}
