# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

if [[ ${PV} == *9999* ]]; then
	inherit git
	EGIT_REPO_URI=${EGIT_REPO_URI:-"git://github.com/mason-larobina/luakit.git"}
	KEYWORDS=""
	SRC_URI=""
	IUSE="develop-branch"
	use develop-branch &&
		EGIT_BRANCH="develop" &&
		EGIT_COMMIT="develop"
else
	inherit base
	KEYWORDS="~amd64 ~x86"
	SRC_URI="http://github.com/mason-larobina/${PN}/tarball/${PV} -> ${P}.tar.gz"
	IUSE=""
fi


DESCRIPTION="a webkit-gtk based, micro-browser framework in Lua"
HOMEPAGE="http://www.luakit.org"

LICENSE="GPL-3"
SLOT="0"
IUSE+=" "

DEPEND="
	>=dev-lang/lua-5.1
	dev-libs/glib:2
	dev-libs/libxdg-basedir
	dev-util/gperf
	net-libs/libsoup
	net-libs/webkit-gtk
	x11-libs/gtk+:2
"

RDEPEND="
	${DEPEND}
"

src_prepare() {
	if [[ ${PV} == *9999* ]]; then
		git_src_prepare
	else
		cd "${WORKDIR}"/mason-larobina-luakit-*
		S=$(pwd)
	fi
}

src_compile() {
	emake PREFIX="/usr"
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" DOCDIR="${D}/usr/share/doc/${PF}" install ||
		die "Installation failed"
}
