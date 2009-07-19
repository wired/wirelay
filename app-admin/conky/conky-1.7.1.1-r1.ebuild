# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/conky/conky-1.7.1.1.ebuild,v 1.3 2009/07/11 18:36:26 billie Exp $

EAPI="2"

inherit eutils

DESCRIPTION="An advanced, highly configurable system monitor for X"
HOMEPAGE="http://conky.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3 BSD LGPL-2.1 MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="alsa apcupsd audacious bmpx debug hddtemp imlib lua math moc mpd nano-syntax nvidia openmp +portmon rss thinkpad truetype vim-syntax wifi X"

DEPEND_COMMON="
	X? (
		x11-libs/libX11
		x11-libs/libXdamage
		x11-libs/libXext
		truetype? ( x11-libs/libXft >=media-libs/freetype-2 )
		imlib? ( media-libs/imlib2 )
		nvidia? ( media-video/nvidia-settings )
	)
	alsa? ( media-libs/alsa-lib )
	audacious? ( >=media-sound/audacious-1.5 )
	bmpx? ( media-sound/bmpx >=sys-apps/dbus-0.35 )
	portmon? ( dev-libs/glib )
	lua? ( >=dev-lang/lua-5.1 )
	openmp? ( >=sys-devel/gcc-4.3[openmp] )
	rss? ( dev-libs/libxml2 net-misc/curl dev-libs/glib )
	wifi? ( net-wireless/wireless-tools )
	"
RDEPEND="
	${DEPEND_COMMON}
	apcupsd? ( sys-power/apcupsd )
	hddtemp? ( app-admin/hddtemp )
	moc? ( media-sound/moc )
	nano-syntax? ( app-editors/nano )
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )
	"
DEPEND="
	${DEPEND_COMMON}
	dev-util/pkgconfig
	"

src_prepare() {
	cp "${FILESDIR}"/conky_no_x11.conf data/
	epatch "${FILESDIR}"/"${P}"-comment.patch
}

src_configure() {
	local myconf
	if use X; then
		myconf="--enable-x11 --enable-double-buffer --enable-xdamage"
		myconf="${myconf} --enable-own-window $(use_enable truetype xft)"
	else
		myconf="--disable-x11 --disable-own-window"
	fi

	econf \
		${myconf} \
		$(use_enable alsa) \
		$(use_enable apcupsd) \
		$(use_enable audacious) \
		$(use_enable bmpx) \
		$(use_enable debug) \
		$(use_enable hddtemp) \
		$(use_enable imlib imlib2) \
		$(use_enable lua) \
		$(use_enable thinkpad ibm) \
		$(use_enable math) \
		$(use_enable moc) \
		$(use_enable mpd) \
		$(use_enable nvidia) \
		$(use_enable openmp) \
		$(use_enable rss) \
		$(use_enable wifi wlan) \
		$(use_enable portmon)
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc ChangeLog AUTHORS TODO || die "dodoc failed"
	dohtml doc/docs.html doc/config_settings.html doc/variables.html \
		|| die "dohtml failed"

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/ftdetect
		doins "${S}"/extras/vim/ftdetect/conkyrc.vim || die "doins failed"

		insinto /usr/share/vim/vimfiles/syntax
		doins "${S}"/extras/vim/syntax/conkyrc.vim|| die "doins failed"
	fi

	if use nano-syntax; then
		insinto /usr/share/nano/
		doins "${S}"/extras/nano/conky.nanorc|| die "doins failed"
	fi
}

pkg_postinst() {
	elog "You can find a sample configuration file at"
	elog "${ROOT%/}/etc/conky/conky.conf. To customize, copy"
	elog "it to ~/.conkyrc and edit it to your liking."
	elog
	elog "For more info on Conky's new features please look at"
	elog "the Changelog in ${ROOT%/}/usr/share/doc/${PF}"
	elog "There are also pretty html docs available"
	elog "on Conky's site or in ${ROOT%/}/usr/share/doc/${PF}/html"
	elog
	elog "Also see http://www.gentoo.org/doc/en/conky-howto.xml"
	elog
	elog "Vim syntax highlighting for conkyrc now enabled with"
	elog "USE=vim-syntax, for Nano with USE=nano-syntax"
	elog
}
