# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools git

EGIT_REPO_URI="git://git.webkit.org/WebKit.git"
DESCRIPTION="Open source web browser engine"
HOMEPAGE="http://www.webkit.org/"

LICENSE="LGPL-2 LGPL-2.1 BSD"
SLOT="0"
KEYWORDS=""
IUSE="coverage debug doc gnome-keyring +gstreamer pango"

RDEPEND="
	dev-libs/libxml2
	dev-libs/libxslt
	media-libs/jpeg
	media-libs/libpng
	x11-libs/cairo

	>=x11-libs/gtk+-2.10
	>=dev-libs/icu-3.8.1-r1
	>=net-libs/libsoup-2.29.3
	>=dev-db/sqlite-3
	>=app-text/enchant-0.22
	>=sys-devel/flex-2.5.33

	gnome-keyring? ( >=gnome-base/gnome-keyring-2.26.0 )

	gstreamer? (
		media-libs/gstreamer:0.10
		media-libs/gst-plugins-base:0.10
	)
	pango? ( x11-libs/pango )
	!pango? (
		media-libs/freetype:2
		media-libs/fontconfig
	)"

DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/gperf
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.10 )"

pkg_setup() {
	ewarn "This is a huge package. If you do not have at least 1.25GB of free"
	ewarn "disk space in ${PORTAGE_TMPDIR} and also in ${DISTDIR} then"
	ewarn "you should abort this installation now and free up some space."
}

src_prepare() {
	# Don't force -O2
	sed -i 's/-O2//g' "${S}"/configure.ac || die "sed failed"
	# missing in trunk
	cp "${FILESDIR}"/gtk-doc.make . || die "gtk-doc.make cp failed"
	# Prevent maintainer mode from being triggered during make
	AT_M4DIR=autotools eautoreconf
}

src_configure() {
	# It doesn't compile on alpha without this in LDFLAGS
	use alpha && append-ldflags "-Wl,--no-relax"

	local myconf

	myconf="--enable-svg-filters --with-font-backend=pango
		$(use_enable gnome-keyring gnomekeyring)
		$(use_enable gstreamer video)
		$(use_enable debug)
		$(use_enable coverage)
		--enable-filters"

	# USE-flag controlled font backend because upstream default is freetype
	# Remove USE-flag once font-backend becomes pango upstream
	if use pango; then
		ewarn "You have enabled the incomplete pango backend"
		ewarn "Please file any and all bugs *upstream*"
		myconf="${myconf} --with-font-backend=pango"
	else
		myconf="${myconf} --with-font-backend=freetype"
	fi

	econf ${myconf} || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc WebKit/gtk/{NEWS,ChangeLog} || die "dodoc failed"
}
