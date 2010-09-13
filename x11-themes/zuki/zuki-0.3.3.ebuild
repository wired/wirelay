# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit base

DESCRIPTION="GTK style is inspired by eGTK by danrabbit"
HOMEPAGE="http://gnome-look.org/content/show.php/Zuki?content=126043"
SRC_URI="http://gnome-look.org/CONTENT/content-files/126043-Zuki.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	x11-libs/gtk+:2
	x11-themes/gtk-engines
	x11-themes/gtk-engines-equinox
	x11-themes/gtk-engines-murrine
"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
	dodir /usr/share/themes/
	insinto /usr/share/themes/
	rm Zuki.emerald
	doins -r Zuki* || die "theme installation failed"

	dodoc AUTHORS CONTRIBUTORS || die "dodoc failed"
}
