# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/awesome/awesome-3.4.5.ebuild,v 1.1 2010/05/12 13:47:21 matsuu Exp $

EAPI="3"
inherit git-2 cmake-utils eutils

EGIT_REPO_URI="git://git.naquadah.org/awesome.git"

DESCRIPTION="A dynamic floating and tiling window manager"
HOMEPAGE="http://awesome.naquadah.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="dbus doc elibc_FreeBSD"

RDEPEND="
	>=dev-lang/lua-5.1
	dev-libs/libev
	>=dev-libs/libxdg-basedir-1
	dev-lua/lgi
	dev-lua/oocairo
	dev-lua/oopango
	media-libs/imlib2[png]
	x11-libs/cairo[xcb]
	|| ( >x11-libs/libX11-1.3.5 <=x11-libs/libX11-1.3.5[xcb] )
	>=x11-libs/libxcb-1.4
	>=x11-libs/pango-1.19.3[introspection]
	>=x11-libs/startup-notification-0.10
	>=x11-libs/xcb-util-0.3.6
	dbus? ( >=sys-apps/dbus-1 )
	elibc_FreeBSD? ( dev-libs/libexecinfo )"

DEPEND="${RDEPEND}
	>=app-text/asciidoc-8.4.5
	app-text/xmlto
	dev-util/gperf
	dev-util/pkgconfig
	|| ( media-gfx/imagemagick[png] media-gfx/graphicsmagick[imagemagick,png] )
	>=x11-proto/xcb-proto-1.5
	>=x11-proto/xproto-7.0.15
	doc? (
		app-doc/doxygen
		dev-lua/luadoc
		media-gfx/graphviz
	)"

RDEPEND="${RDEPEND}
	|| (
		x11-misc/gxmessage
		x11-apps/xmessage
	)"

# bug #321433: Need one of these to for awsetbg.
# imagemagick provides 'display' and is further down the default list, but
# listed here for completeness.  'display' however is only usable with
# x11-apps/xwininfo also present.
RDEPEND="${RDEPEND}
	|| (
	( x11-apps/xwininfo
		|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] )
	)
	x11-misc/habak
	media-gfx/feh
	x11-misc/hsetroot
	media-gfx/qiv
	media-gfx/xv
	x11-misc/xsri
	media-gfx/xli
	x11-apps/xsetroot
	)"

DOCS="AUTHORS BUGS PATCHES README STYLE"

src_unpack() {
	git-2_src_unpack
	# ugly way to get the git revision
	echo -n "`git --git-dir="${GIT_DIR}" describe`-gentoo" > ${S}/.version_stamp
}

src_configure() {
	mycmakeargs=(
		-DPREFIX="${EPREFIX}"/usr
		-DSYSCONFDIR="${EPREFIX}"/etc
		$(cmake-utils_use_with dbus DBUS)
		$(cmake-utils_use doc GENERATE_LUADOC)
	)

	cmake-utils_src_configure
}

src_compile() {
	local myargs="all"

	if use doc ; then
		myargs="${myargs} doc"
	fi
	cmake-utils_src_make ${myargs}
}

src_install() {
	cmake-utils_src_install

	if use doc ; then
		(
			cd "${CMAKE_BUILD_DIR}"/doc
			mv html doxygen
			dohtml -r doxygen || die
		)
		mv "${ED}"/usr/share/doc/${PN}/luadoc "${ED}"/usr/share/doc/${PF}/html/luadoc || die
	fi
	rm -rf "${ED}"/usr/share/doc/${PN} || die

	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/${PN}-session ${PN} || die
}
