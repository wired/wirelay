# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/kbuild/kbuild-0.1.5-r1.ebuild,v 1.2 2009/04/24 07:59:21 patrick Exp $

EAPI=2

WANT_AUTOMAKE=1.9

inherit eutils autotools

MY_P=kBuild-${PV}-src-20090221
DESCRIPTION="A makefile framework for writing simple makefiles for complex tasks"
HOMEPAGE="http://svn.netlabs.org/kbuild/wiki"
SRC_URI="http://gentoo.zerodev.it/files/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-util/cvs
	dev-util/subversion
	sys-devel/gettext"
RDEPEND=""

S=${WORKDIR}/${MY_P/-src-20090221}

src_prepare() {
		rm -rf "${S}/kBuild/bin"

		cd "${S}/src/kmk"
		eautoreconf
		cd "${S}/src/sed"
		eautoreconf
		cd "${S}"
		epatch "${FILESDIR}/${PN}-unknown-configure-opt.patch"
		epatch "${FILESDIR}/kbuild-dprintf-posix2008.patch"
}

src_compile() {
		kBuild/env.sh --full \
		make -f bootstrap.gmk AUTORECONF=true \
		|| die "bootstrap failed"
}

src_install() {
		kBuild/env.sh kmk \
		NIX_INSTALL_DIR=/usr \
		PATH_INS="${D}" \
		install || die "install failed"
}
