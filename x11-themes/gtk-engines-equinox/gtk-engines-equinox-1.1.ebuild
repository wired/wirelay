# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

MY_P=${P/gtk-engines-}

DESCRIPTION="A heavily modified version of the beautiful Aurora engine "
HOMEPAGE="http://gnome-look.org/content/show.php/Equinox+GTK+Engine?content=121881"
SRC_URI="http://gnome-look.org/CONTENT/content-files/121881-${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"
S="${WORKDIR}"/${MY_P}

src_unpack() {
	echo tar xjpf "${DISTDIR}"/${A} equinox-gtk-engine.tar.gz
	tar xjpf "${DISTDIR}"/${A} equinox-gtk-engine.tar.gz || die

	echo tar xzpf "${WORKDIR}"/equinox-gtk-engine.tar.gz
	tar xzpf "${WORKDIR}"/equinox-gtk-engine.tar.gz || die
	cd "${S}"
}

src_configure() {
	econf --enable-animation
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog || die "dodoc failed"
}
