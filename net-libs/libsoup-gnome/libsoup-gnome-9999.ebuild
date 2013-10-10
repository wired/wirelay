# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libsoup-gnome/libsoup-gnome-2.28.1.ebuild,v 1.1 2009/10/29 21:23:29 eva Exp $

EAPI="2"

EGIT_REPO_URI="git://git.gnome.org/libsoup"

inherit autotools eutils gnome2 git-2

MY_PN=${PN/-gnome}
MY_P=${MY_PN}-${PV}

DESCRIPTION="GNOME plugin for libsoup"
HOMEPAGE="http://www.gnome.org/"
SRC_URI=""

LICENSE="LGPL-2"
SLOT="2.4"
KEYWORDS=""
# Do NOT build with --disable-debug/--enable-debug=no - gnome2.eclass takes care of that
IUSE="debug doc"

RDEPEND="~net-libs/libsoup-${PV}
	gnome-base/gnome-keyring
	net-libs/libproxy
	>=gnome-base/gconf-2
	dev-db/sqlite:3"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1 )"

S=${WORKDIR}/${MY_P}

DOCS="AUTHORS NEWS README"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		--with-libsoup-system
		--with-gnome"
}
src_prepare() {
	gnome2_src_prepare

	# missing in trunk
	cp "${FILESDIR}"/gtk-doc.make . || die "gtk-doc.make cp failed"
	eautoreconf

	# Use lib present on the system
	epatch "${FILESDIR}"/${P}-system-lib.patch
	eautoreconf
}
