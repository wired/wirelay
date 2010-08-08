# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit git

EGIT_REPO_URI="http://github.com/mason-larobina/luakit.git"

DESCRIPTION="a webkit-gtk based, micro-browser framework in Lua"
HOMEPAGE="http://www.luakit.org"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=dev-lang/lua-5.1
	dev-util/gperf
	>=net-libs/webkit-gtk-1.1.15
	x11-libs/gtk+
"

RDEPEND="
	dev-libs/libxdg-basedir
	${DEPEND}
"

src_compile() {
	emake PREFIX="/usr"
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" DOCDIR="${D}/usr/share/doc/${PF}" install ||
		die "Installation failed"
}
