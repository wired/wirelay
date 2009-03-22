# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit git cmake-utils

EGIT_REPO_URI="git://git.naquadah.org/awesome.git"

DESCRIPTION="A dynamic floating and tiling window manager"
HOMEPAGE="http://awesome.naquadah.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="dbus doc"

RDEPEND=">=dev-lang/lua-5.1
	>=dev-libs/glib-2
	dev-libs/libev
	dev-util/gperf
	sys-libs/ncurses
	x11-libs/cairo[xcb]
	x11-libs/libX11[xcb]
	>=x11-libs/libxcb-1.1
	>=x11-libs/pango-1.19.3
	>=x11-libs/xcb-util-0.3
	media-libs/imlib2
	dbus? ( >=sys-apps/dbus-1 )"

DEPEND="${RDEPEND}
	app-text/asciidoc
	app-text/xmlto
	>=dev-util/cmake-2.6
	dev-util/pkgconfig
	x11-proto/xcb-proto
	>=x11-proto/xproto-7.0.11
	doc? ( app-doc/doxygen
		dev-util/luadoc
		media-gfx/graphviz )"

RDEPEND="${RDEPEND}
	app-shells/bash
	|| ( x11-misc/gxmessage
		x11-apps/xmessage
	)
	|| ( x11-terms/eterm
		x11-misc/habak
		x11-wm/windowmaker
		media-gfx/feh
		x11-misc/hsetroot
		( media-gfx/imagemagick x11-apps/xwininfo )
		media-gfx/xv
		x11-misc/xsri
		media-gfx/xli
		x11-apps/xsetroot )"

DOCS="AUTHORS BUGS PATCHES README STYLE"

src_unpack() {
	git_src_unpack
	# ugly way to get the git revision
	echo -n "`git --git-dir="${GIT_DIR}" describe`-gentoo" > ${S}/.version_stamp
}

src_compile() {
	local myargs="all"

	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with dbus DBUS)"

	if use doc ; then
		mycmakeargs="${mycmakeargs} -DGENERATE_LUADOC=ON"
		myargs="${myargs} doc"
	else
		mycmakeargs="${mycmakeargs} -DGENERATE_LUADOC=OFF"
	fi
	cmake-utils_src_compile ${myargs}
}

src_install() {
	cmake-utils_src_install

	if use doc ; then
		(
			cd "${WORKDIR}"/${PN}_build/doc/html/ && dohtml -r * || die
			mv "${D}"/usr/share/doc/${PN}/luadoc "${D}"/usr/share/doc/${PF}/html/luadoc || die

		)
	fi
	rm -rf "${D}"/usr/share/doc/${PN} || die

	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/${PN}-session ${PN} || die
}
