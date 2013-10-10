# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libsoup/libsoup-2.28.1.ebuild,v 1.2 2009/11/16 21:41:12 eva Exp $

EAPI="2"

EGIT_REPO_URI="git://git.gnome.org/libsoup"
inherit autotools eutils gnome2 git-2

DESCRIPTION="An HTTP library implementation in C"
HOMEPAGE="http://www.gnome.org/"
SRC_URI=""

LICENSE="LGPL-2"
SLOT="2.4"
KEYWORDS=""
# Do NOT build with --disable-debug/--enable-debug=no - gnome2.eclass takes care of that
IUSE="debug doc gnome ssl"

RDEPEND=">=dev-libs/glib-2.21.3
	>=dev-libs/libxml2-2
	ssl? ( >=net-libs/gnutls-2.1.7 )"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1 )"
#	test? (
#		www-servers/apache
#		dev-lang/php
#		net-misc/curl )
PDEPEND="gnome? ( ~net-libs/${PN}-gnome-${PV} )"

DOCS="AUTHORS NEWS README"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		--without-gnome
		$(use_enable ssl)"
}

src_prepare() {
	gnome2_src_prepare

	# missing in trunk
	cp "${FILESDIR}"/gtk-doc.make . || die "gtk-doc.make cp failed"
	eautoreconf
}
