# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/awesome/awesome-3.4.5.ebuild,v 1.1 2010/05/12 13:47:21 matsuu Exp $

EAPI="2"
inherit cmake-utils eutils

DESCRIPTION="A dynamic floating and tiling window manager"
HOMEPAGE="http://awesome.naquadah.org/"
SRC_URI="http://awesome.naquadah.org/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="dbus doc elibc_FreeBSD bash-completion"

RDEPEND=">=dev-lang/lua-5.1[deprecated]
	dev-libs/libev
	>=dev-libs/libxdg-basedir-1
	media-libs/imlib2[png]
	x11-libs/cairo[xcb]
	x11-libs/libX11[xcb]
	>=x11-libs/libxcb-1.4
	>=x11-libs/pango-1.19.3
	>=x11-libs/startup-notification-0.10
	>=x11-libs/xcb-util-0.3.6
	dbus? ( >=sys-apps/dbus-1 )
	elibc_FreeBSD? ( dev-libs/libexecinfo )"

DEPEND="${RDEPEND}
	>=app-text/asciidoc-8.4.5
	app-text/xmlto
	>=dev-util/cmake-2.6
	dev-util/gperf
	dev-util/pkgconfig
	media-gfx/imagemagick[png]
	>=x11-proto/xcb-proto-1.5
	>=x11-proto/xproto-7.0.15
	doc? (
		app-doc/doxygen
		dev-util/luadoc
		media-gfx/graphviz
	)"

RDEPEND="${RDEPEND}
	app-shells/bash
	bash-completion? ( app-shells/bash-completion )
	|| (
		x11-misc/gxmessage
		x11-apps/xmessage
	)"

DOCS="AUTHORS BUGS PATCHES README STYLE"

mycmakeargs="-DPREFIX=/usr
	-DSYSCONFDIR=/etc
	$(cmake-utils_use_with dbus DBUS)
	$(cmake-utils_use doc GENERATE_LUADOC)"

src_prepare() {
	epatch "${FILESDIR}/${PN}-3.4.2-backtrace.patch"

	# kill handling of NET_CURRENT_DESKTOP
	# temp fix for openoffice bug #109550
	# doesn't seem to break anything else
	epatch "${FILESDIR}/${PN}-3.4.3-net-current-desktop-ooo.patch"
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
		mv "${D}"/usr/share/doc/${PN}/luadoc "${D}"/usr/share/doc/${PF}/html/luadoc || die
	fi
	rm -rf "${D}"/usr/share/doc/${PN} || die

	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/${PN}-session ${PN} || die
}
