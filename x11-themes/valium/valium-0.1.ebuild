# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit base

MY_PN="Valium"

DESCRIPTION="dark GTK theme"
HOMEPAGE="http://gnome-look.org/content/show.php/Valium?content=128843"
SRC_URI="http://fc00.deviantart.net/fs71/f/2010/226/d/6/Valium_by_Kalushary.zip -> valium-0.1.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bright"

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/"${MY_PN}"

src_prepare() {
	use bright && epatch "${FILESDIR}"/"${PN}"-bright.patch
}

src_install() {
	dodir /usr/share/themes/
	insinto /usr/share/themes/
	doins -r gtk/"${MY_PN}" || die "theme installation failed"
}
