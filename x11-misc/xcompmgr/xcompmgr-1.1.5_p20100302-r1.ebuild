# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xcompmgr/xcompmgr-1.1.5.ebuild,v 1.6 2010/01/18 20:06:37 armin76 Exp $

EAPI=2

inherit x-modular autotools

DESCRIPTION="X Compositing manager"
HOMEPAGE="http://freedesktop.org/Software/xapps"
SRC_URI="http://dev.gentooexperimental.org/~wired/distfiles/${P}.tar.bz2"
LICENSE="BSD"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
RDEPEND="x11-libs/libXrender
	x11-libs/libXdamage
	x11-libs/libXfixes
	x11-libs/libXcomposite"
DEPEND="${RDEPEND}"

src_prepare() {
	eautoreconf
	x-modular_src_prepare
}
