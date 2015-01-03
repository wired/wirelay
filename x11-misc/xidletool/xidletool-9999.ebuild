# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils autotools git-2

DESCRIPTION="Use the X Screensaver extension to get and use the user's idle time."
HOMEPAGE="https://github.com/wired/xidletool"
RESTRICT="mirror"
EGIT_REPO_URI="https://github.com/wired/xidletool.git"
EGIT_BRANCH="master"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-base/xorg-server
	|| ( app-arch/lzma-utils app-arch/xz-utils )"
RDEPEND="x11-base/xorg-server"

#pre_src_configure() {
src_prepare() {
	sed -i "s/ dist-lzma//" configure.ac ||
		die "sed failed"
	sed -i "/^LDADD/ s/ -lX11/ -lX11 -lXext/" Makefile.am ||
		die "sed failed"
	eautoreconf
}

src_configure() {
	econf \
		--x-libraries=/usr/lib/X11 \
		--x-includes=/usr/include/X11
}

src_install() {
	einstall
}
