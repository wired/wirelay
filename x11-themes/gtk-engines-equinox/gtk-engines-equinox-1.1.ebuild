# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

MY_P=${P/gtk-engines-}

DESCRIPTION="A heavily modified version of the beautiful Aurora engine"
HOMEPAGE="http://gnome-look.org/content/show.php/Equinox+GTK+Engine?content=121881"
SRC_URI="http://gnome-look.org/CONTENT/content-files/121881-${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+animation themes"

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"
S="${WORKDIR}"/${MY_P}

src_unpack() {
	unpack "${A}"
	# extract engine
	echo tar xzpf "${WORKDIR}"/equinox-gtk-engine.tar.gz
	tar xzpf "${WORKDIR}"/equinox-gtk-engine.tar.gz || die
	cd "${S}"

	if use themes; then # extract themes
		mkdir themes
		cd themes
		echo tar xzpf "${WORKDIR}"/equinox-themes.tar.gz
		tar xzpf "${WORKDIR}"/equinox-themes.tar.gz || die
	fi
}

src_configure() {
	econf $(use_enable animation) || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	if use themes; then
		dodir /usr/share/themes/
		insinto /usr/share/themes/
		doins -r themes/* || die "themes installation failed"
	fi

	dodoc AUTHORS ChangeLog || die "dodoc failed"
}
