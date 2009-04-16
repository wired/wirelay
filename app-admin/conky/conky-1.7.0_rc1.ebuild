# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/conky/conky-1.7.0_rc1.ebuild,v 1.1 2009/03/17 01:22:09 omp Exp $

EAPI="2"

inherit eutils
# used for epause

DESCRIPTION="An advanced, highly configurable system monitor for X"
HOMEPAGE="http://conky.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3 BSD LGPL-2.1 MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="audacious awesome bmpx debug hddtemp ibm ipv6 moc mpd nano-syntax nvidia rss truetype vim-syntax wifi X"

DEPEND_COMMON="
	X? (
		x11-libs/libICE
		x11-libs/libXext
		x11-libs/libX11
		x11-libs/libSM
		x11-libs/libXrender
		x11-libs/libXdamage
		x11-libs/libXft
		truetype? ( >=media-libs/freetype-2 )
		audacious? ( >=media-sound/audacious-1.5 )
		bmpx? ( media-sound/bmpx
				>=sys-apps/dbus-0.35
			)
	)
	rss? ( dev-libs/libxml2
			net-misc/curl
			)
	wifi? ( net-wireless/wireless-tools )
	nvidia? ( media-video/nvidia-settings )
	!ipv6? ( >=dev-libs/glib-2.0 )"
RDEPEND="${DEPEND_COMMON}
	hddtemp? ( app-admin/hddtemp )
	vim-syntax? ( || ( app-editors/vim
	app-editors/gvim ) )
	nano-syntax? ( app-editors/nano )"
DEPEND="
	${DEPEND_COMMON}
	dev-util/pkgconfig
	X? (
		x11-libs/libXt
		x11-proto/xextproto
		x11-proto/xproto
	)"

src_prepare() {
	if use awesome; then
		epatch "${FILESDIR}/${PN}-awesome.patch" || die "patching for awesome failed"
	fi
}

src_configure() {
	local myconf
	myconf="--enable-proc-uptime"
	if useq X; then
		myconf="${myconf} --enable-x11 --enable-double-buffer --enable-xdamage --enable-own-window"
		myconf="${myconf} $(use_enable truetype xft)"
	else
		myconf="${myconf} --disable-x11 --disable-double-buffer --disable-xdamage --disable-own-window"
		myconf="${myconf} --disable-xft"
	fi
	econf \
		${myconf} \
		$(use_enable audacious) \
		$(use_enable bmpx) \
		$(use_enable debug) \
		$(use_enable hddtemp ) \
		$(use_enable ibm) \
		$(use_enable moc) \
		$(use_enable mpd) \
		$(use_enable nvidia) \
		$(use_enable rss) \
		$(use_enable wifi wlan) \
		$(use_enable !ipv6 portmon) || die "econf failed"
}

src_compile() {
	local mymake
	if useq ipv6 ; then
		ewarn "You have the ipv6 USE flag enabled.  Please note that using"
		ewarn "the ipv6 USE flag with Conky disables the port monitor."
		epause
	else
		mymake="MPD_NO_IPV6=noipv6"
	fi

	emake ${mymake} || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc ChangeLog AUTHORS README || die
	dohtml doc/docs.html doc/config_settings.html doc/variables.html || die

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/ftdetect
		doins "${S}"/extras/vim/ftdetect/conkyrc.vim

		insinto /usr/share/vim/vimfiles/syntax
		doins "${S}"/extras/vim/syntax/conkyrc.vim
	fi

	if use nano-syntax; then
		insinto /usr/share/nano/
		doins "${S}"/extras/nano/conky.nanorc
	fi
}

pkg_postinst() {
	elog "You can find the sample configuration file at"
	elog "/etc/conky/conky.conf.  To customize it, copy"
	elog "/etc/conky/conky.conf to ~/.conkyrc and edit"
	elog "it to your liking."
	elog
	elog "For more info on Conky's new features,"
	elog "please look at the README and ChangeLog:"
	elog "/usr/share/doc/${PF}/README.bz2"
	elog "/usr/share/doc/${PF}/ChangeLog.bz2"
	elog "There are also pretty html docs available"
	elog "on Conky's site or in /usr/share/doc/${PF}"
	elog
	elog "Also see http://www.gentoo.org/doc/en/conky-howto.xml"
	elog
	elog "Vim syntax highlighting for conkyrc now enabled with"
	elog "USE=vim-syntax, for Nano with USE=nano-syntax"
	elog
}
