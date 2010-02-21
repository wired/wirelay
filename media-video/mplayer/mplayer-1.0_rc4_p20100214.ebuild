# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="2"

ESVN_REPO_URI="svn://svn.mplayerhq.hu/mplayer/trunk"
[[ ${PV} = *9999* ]] && SVN_ECLASS="subversion" || SVN_ECLASS=""

inherit eutils flag-o-matic multilib base ${SVN_ECLASS}

[[ ${PV} != *9999* ]] && MPLAYER_REVISION=SVN-r30556

IUSE="3dnow 3dnowext +a52 +aac aalib +alsa altivec +ass bidi bindist bl bs2b
+cddb +cdio cdparanoia cpudetection custom-cpuopts debug dga +dirac directfb
doc +dts +dv dvb +dvd +dvdnav dxr3 +enca +encode esd +faac +faad fbcon +ffmpeg-mt ftp
gif ggi -gmplayer +iconv ipv6 jack joystick jpeg jpeg2k kernel_linux ladspa
libcaca lirc +live lzo mad md5sum +mmx mmxext mng +mp3 nas +network nut openal
+opengl +osdmenu oss png pnm pulseaudio pvr +quicktime radio +rar +real +rtc
samba +shm +schroedinger sdl +speex sse sse2 ssse3 svga tga +theora +tremor
+truetype +toolame +twolame +unicode v4l v4l2 vdpau vidix +vorbis win32codecs
+X +x264 xanim xinerama +xscreensaver +xv +xvid xvmc zoran"
[[ ${PV} == *9999* ]] && IUSE+=" external-ffmpeg"

VIDEO_CARDS="s3virge mga tdfx nvidia vesa"
for x in ${VIDEO_CARDS}; do
	IUSE+=" video_cards_${x}"
done

BLUV="1.7"
SVGV="1.9.17"
RESTRICT="nomirror"
AMR_URI="http://www.3gpp.org/ftp/Specs/archive"
FONT_URI="
	mirror://mplayer/releases/fonts/font-arial-iso-8859-1.tar.bz2
	mirror://mplayer/releases/fonts/font-arial-iso-8859-2.tar.bz2
	mirror://mplayer/releases/fonts/font-arial-cp1250.tar.bz2
"
if [[ ${PV} == *9999* ]]; then
	RELEASE_URI=""
else
	RELEASE_URI="http://foss.math.aegean.gr/~realnc/mplayer/${P}.tar.bz2"
fi
SRC_URI="${RELEASE_URI}
	ffmpeg-mt? ( http://foss.math.aegean.gr/~realnc/mplayer/${P}-ffmpeg-mt.patch )
	!truetype? ( ${FONT_URI} )
	gmplayer? ( mirror://mplayer/skins/Blue-${BLUV}.tar.bz2 )
	svga? ( http://foss.math.aegean.gr/~realnc/mplayer/svgalib_helper-${SVGV}-mplayer.tar.gz )"
#	svga? (	http://dev.gentoo.org/~ssuominen/svgalib_helper-${SVGV}-mplayer.tar.gz )"
#	svga? ( http://mplayerhq.hu/~alex/svgalib_helper-${SVGV}-mplayer.tar.bz2 )

DESCRIPTION="Media Player for Linux"
HOMEPAGE="http://www.mplayerhq.hu/"

# Preffered font is dejavu
FONT_RDEPS="
	|| ( media-fonts/dejavu media-fonts/ttf-bitstream-vera )
	media-libs/fontconfig
	media-libs/freetype:2
"
X_RDEPS="
	x11-libs/libXext
	x11-libs/libXxf86vm
"
[[ ${PV} == *9999* ]] && RDEPEND+=" external-ffmpeg? ( media-video/ffmpeg )"
# Rar: althrought -gpl version is nice, it cant do most functions normal rars can
#	nemesi? ( net-libs/libnemesi )
RDEPEND+="
	sys-libs/ncurses
	!bindist? (
		x86? (
			win32codecs? ( media-libs/win32codecs )
		)
	)
	X? (
		${X_RDEPS}
		ass? ( ${FONT_RDEPS} )
		dga? ( x11-libs/libXxf86dga )
		ggi? (
			media-libs/libggi
			media-libs/libggiwmh
		)
		gmplayer? (
			media-libs/libpng
			x11-libs/gtk+:2
			x11-libs/libXi
		)
		opengl? ( virtual/opengl )
		truetype? ( ${FONT_RDEPS} )
		video_cards_nvidia? (
			vdpau? ( >=x11-drivers/nvidia-drivers-180.60 )
		)
		xinerama? ( x11-libs/libXinerama )
		xscreensaver? ( x11-libs/libXScrnSaver )
		xv? (
			x11-libs/libXv
			xvmc? ( x11-libs/libXvMC )
		)
	)
	aalib? ( media-libs/aalib )
	alsa? ( media-libs/alsa-lib )
	bidi? ( dev-libs/fribidi )
	cdio? ( dev-libs/libcdio )
	cdparanoia? ( media-sound/cdparanoia )
	dirac? ( media-video/dirac )
	directfb? ( dev-libs/DirectFB )
	dts? ( media-libs/libdca )
	dv? ( media-libs/libdv )
	dvb? ( media-tv/linuxtv-dvb-headers )
	encode? (
		!twolame? ( toolame? ( media-sound/toolame ) )
		twolame? ( media-sound/twolame )
		faac? ( media-libs/faac )
		mp3? ( media-sound/lame )
		x264? ( >=media-libs/x264-0.0.20091124 )
		xvid? ( media-libs/xvid )
	)
	esd? ( media-sound/esound )
	enca? ( app-i18n/enca )
	faad? ( !aac? ( media-libs/faad2 ) )
	gif? ( media-libs/giflib )
	jack? ( media-sound/jack-audio-connection-kit )
	jpeg? ( media-libs/jpeg )
	ladspa? ( media-libs/ladspa-sdk )
	libcaca? ( media-libs/libcaca )
	lirc? ( app-misc/lirc )
	live? ( media-plugins/live )
	lzo? ( >=dev-libs/lzo-2 )
	mad? ( media-libs/libmad )
	mng? ( media-libs/libmng )
	nas? ( media-libs/nas )
	nut? ( >=media-libs/libnut-661 )
	openal? ( media-libs/openal )
	jpeg2k? ( media-libs/openjpeg )
	png? ( media-libs/libpng )
	pnm? ( media-libs/netpbm )
	pulseaudio? ( media-sound/pulseaudio )
	rar? (
		|| (
			app-arch/unrar
			app-arch/rar
			app-arch/unrar-gpl
		)
	)
	samba? ( net-fs/samba )
	schroedinger? ( media-libs/schroedinger )
	sdl? ( media-libs/libsdl )
	speex? ( media-libs/speex )
	svga? ( media-libs/svgalib )
	theora? ( media-libs/libtheora )
	vorbis? ( media-libs/libvorbis )
	xanim? ( media-video/xanim )
"

X_DEPS="
	x11-proto/videoproto
	x11-proto/xf86vidmodeproto
"
ASM_DEP="dev-lang/yasm"
DEPEND="${RDEPEND}
	X? (
		${X_DEPS}
		dga? ( x11-proto/xf86dgaproto )
		dxr3? ( media-video/em8300-libraries )
		gmplayer? ( x11-proto/xextproto )
		xinerama? ( x11-proto/xineramaproto )
		xscreensaver? ( x11-proto/scrnsaverproto )
	)
	amd64? ( ${ASM_DEP} )
	doc? ( dev-libs/libxslt )
	iconv? ( virtual/libiconv )
	x86? ( ${ASM_DEP} )
	x86-fbsd? ( ${ASM_DEP} )
"

SLOT="0"
LICENSE="GPL-2"
if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
else
	KEYWORDS=""
fi

PATCHES=(
)

pkg_setup() {
	if [[ ${PV} == *9999* ]]; then
		elog ""
		elog "This is a live ebuild which installs the latest from upstream's"
		elog "subversion repository, and is unsupported by Gentoo."
		elog "Everything but bugs in the ebuild itself will be ignored."
		elog ""
	fi

	if use gmplayer; then
		ewarn ""
		ewarn "GMPlayer is no longer actively developed upstream"
		ewarn "and is not supported by Gentoo.  There are alternatives"
		ewarn "for a GUI frontend: smplayer, gnome-mplayer or kmplayer."
	fi

	if use cpudetection; then
		ewarn ""
		ewarn "You've enabled the cpudetection flag.  This feature is"
		ewarn "included mainly for people who want to use the same"
		ewarn "binary on another system with a different CPU architecture."
		ewarn "MPlayer will already detect your CPU settings by default at"
		ewarn "buildtime; this flag is used for runtime detection."
		ewarn "You won't need this turned on if you are only building"
		ewarn "mplayer for this system.  Also, if your compile fails, try"
		ewarn "disabling this use flag."
	fi

	if use custom-cpuopts; then
		ewarn ""
		ewarn "You are using the custom-cpuopts flag which will"
		ewarn "specifically allow you to enable / disable certain"
		ewarn "CPU optimizations."
		ewarn ""
		ewarn "Most desktop users won't need this functionality, but it"
		ewarn "is included for corner cases like cross-compiling and"
		ewarn "certain profiles.  If unsure, disable this flag and MPlayer"
		ewarn "will automatically detect and use your available CPU"
		ewarn "optimizations."
		ewarn ""
		ewarn "Using this flag means your build is unsupported, so"
		ewarn "please make sure your CPU optimization use flags (3dnow"
		ewarn "3dnowext mmx mmxext sse sse2 ssse3) are properly set."
	fi
}

src_unpack() {
	[[ ${PV} = *9999* ]] && subversion_src_unpack || unpack ${A}

	if ! use truetype; then
		unpack font-arial-iso-8859-1.tar.bz2 \
			font-arial-iso-8859-2.tar.bz2 \
			font-arial-cp1250.tar.bz2
	fi

	use gmplayer && unpack "Blue-${BLUV}.tar.bz2"
	use svga && unpack "svgalib_helper-${SVGV}-mplayer.tar.gz"
}

src_prepare() {
	if [[ ${PV} = *9999* ]]; then
		# Set SVN version manually
		subversion_wc_info
		sed -i s/UNKNOWN/${ESVN_WC_REVISION}/ "${S}/version.sh"
	else
		# Set version #
		sed -i s/UNKNOWN/${MPLAYER_REVISION}/ "${S}/version.sh"
	fi

	if use svga; then
		echo
		einfo "Enabling vidix non-root mode."
		einfo "(You need a proper svgalib_helper.o module for your kernel"
		einfo "to actually use this)"
		echo

		mv "${WORKDIR}/svgalib_helper" "${S}/libdha"
	fi
	
	use ffmpeg-mt && epatch "${DISTDIR}/${P}-ffmpeg-mt.patch"

	base_src_prepare
}

src_configure() {
	local myconf=""
	local uses i

	# set LINGUAS
	[[ -n $LINGUAS ]] && LINGUAS="${LINGUAS/da/dk}"

	# mplayer ebuild uses "use foo || --disable-foo" to forcibly disable
	# compilation in almost every situation.  The reason for this is
	# because if --enable is used, it will force the build of that option,
	# regardless of whether the dependency is available or not.

	###################
	#Optional features#
	###################
	myconf+="
		--disable-arts
		--disable-kai
		$(use_enable network)
		$(use_enable joystick)
	"
	uses="bl enca ftp rtc" # nemesi <- not working with in-tree ebuild
	myconf+=" --disable-nemesi" # nemesi automagic disable
	for i in ${uses}; do
		use ${i} || myconf+=" --disable-${i}"
	done
	use ass || myconf+=" --disable-ass --disable-ass-internal"
	use bidi || myconf+=" --disable-fribidi"
	use encode || myconf+=" --disable-mencoder"
	use ipv6 || myconf+=" --disable-inet6"
	use nut || myconf+=" --disable-libnut"
	use rar || myconf+=" --disable-unrarexec"
	use samba || myconf+=" --disable-smb"
	if ! use lirc; then
		myconf+="
			--disable-lirc
			--disable-lircc
			--disable-apple-ir
		"
	fi

	# libcdio support: prefer libcdio over cdparanoia
	# don't check for cddb w/cdio
	if use cdio; then
		myconf+=" --disable-cdparanoia"
	else
		myconf+=" --disable-libcdio"
		use cdparanoia || myconf+=" --disable-cdparanoia"
		use cddb || myconf+=" --disable-cddb"
	fi

	################################
	# DVD read, navigation support #
	################################
	#
	# dvdread - accessing a DVD
	# dvdnav - navigation of menus
	#
	# internal dvdread and dvdnav use flags enable internal
	# versions of the libraries, which are snapshots of the fork.
	#
	# Only check for disabled a52 use flag inside the DVD check,
	# since many users were getting confused why there was no
	# audio stream.

	if use dvd; then
		use dvdnav || myconf+=" --disable-dvdnav"
	else
		myconf+="
			--disable-dvdnav
			--disable-dvdread
			--disable-dvdread-internal
			--disable-libdvdcss-internal
		"
		use a52 || myconf+=" --disable-liba52-internal"
	fi

	#############
	# Subtitles #
	#############
	#
	# SRT/ASS/SSA (subtitles) requires freetype support
	# freetype support requires iconv
	# iconv optionally can use unicode

	if ! use ass; then
		if ! use truetype; then
			myconf+=" --disable-freetype"
			if ! use iconv; then
				myconf+="
					--disable-iconv
					--charset=noconv
				"
			fi
		fi
	fi
	use iconv && use unicode && myconf+=" --charset=UTF-8"

	#####################################
	# DVB / Video4Linux / Radio support #
	#####################################
	myconf+=" --disable-tv-bsdbt848"
	# broken upstream, won't work with recent kernels
	myconf+=" --disable-ivtv"
	if { use dvb || use v4l || use v4l2 || use pvr || use radio; }; then
		use dvb || myconf+=" --disable-dvb --disable-dvbhead"
		use pvr || myconf+=" --disable-pvr"
		use v4l	|| myconf+=" --disable-tv-v4l1"
		use v4l2 || myconf+=" --disable-tv-v4l2"
		if use radio && { use dvb || use v4l || use v4l2; }; then
			myconf+="
				--enable-radio
				$(use_enable encode radio-capture)
			"
		else
			myconf+="
				--disable-radio-v4l2
				--disable-radio-bsdbt848
			"
		fi
	else
		myconf+="
			--disable-tv
			--disable-tv-v4l1
			--disable-tv-v4l2
			--disable-radio
			--disable-radio-v4l2
			--disable-radio-bsdbt848
			--disable-dvb
			--disable-dvbhead
			--disable-v4l2
			--disable-pvr"
	fi

	##########
	# Codecs #
	##########
	# Won't work with external liba52
	myconf+=" --disable-liba52"
	# Use internal musepack codecs for SV7 and SV8 support
	myconf+=" --disable-musepack"

	use aac || myconf+=" --disable-faad-internal"
	use dirac || myconf+=" --disable-libdirac-lavc"
	use dts || myconf+=" --disable-libdca"
	use dv || myconf+=" --disable-libdv"
	use faad || myconf+=" --disable-faad"
	use lzo || myconf+=" --disable-liblzo"
	if ! use mp3; then
		myconf+="
			--disable-mp3lame
			--disable-mp3lame-lavc
			--disable-mp3lib
		"
	fi
	use bs2b || myconf+=" --disable-libbs2b"
	use schroedinger || myconf+=" --disable-libschroedinger-lavc"
	use xanim && myconf+=" --xanimcodecsdir=/usr/lib/xanim/mods"
	if ! use png && ! use gmplayer; then
		myconf+=" --disable-png"
	fi

	uses="gif jpeg live mad mng pnm speex tga theora xanim"
	for i in ${uses}; do
		use ${i} || myconf+=" --disable-${i}"
	done
	use jpeg2k || myconf+=" --disable-libopenjpeg"
	if use vorbis || use tremor; then
		use tremor || myconf+=" --disable-tremor-internal"
		use vorbis || myconf+=" --disable-libvorbis"
	else
		myconf+="
			--disable-tremor-internal
			--disable-tremor
			--disable-libvorbis
		"
	fi
	# Encoding
	if use encode; then
		uses="faac x264 xvid toolame twolame"
		for i in ${uses}; do
			use ${i} || myconf+=" --disable-${i}"
		done
		use aac || myconf+=" --disable-faac-lavc"
	else
		myconf+="
			--disable-faac-lavc
			--disable-faac
			--disable-x264
			--disable-xvid
			--disable-x264-lavc
			--disable-xvid-lavc
			--disable-twolame
			--disable-toolame
		"
		uses="aac faac x264 xvid toolame twolame"
		for i in uses; do
			use ${i} && elog "Useflag \"${i}\" require \"encode\" useflag enabled to work."
		done
	fi

	#################
	# Binary codecs #
	#################
	# bug 213836
	if ! use x86 || ! use win32codecs; then
		use quicktime || myconf+=" --disable-qtx"
	fi

	######################
	# RealPlayer support #
	######################
	# Realplayer support shows up in four places:
	# - libavcodec (internal)
	# - win32codecs
	# - realcodecs (win32codecs libs)
	# - realcodecs (realplayer libs)

	# internal
	use real || myconf+=" --disable-real"

	# Real binary codec support only available on x86, amd64
	if use real; then
		use x86 && myconf+=" --realcodecsdir=/opt/RealPlayer/codecs"
		use amd64 && myconf+=" --realcodecsdir=/usr/$(get_libdir)/codecs"
	elif ! use bindist; then
			myconf+=" $(use_enable win32codecs win32dll)"
	fi

	################
	# Video Output #
	################
	uses="directfb md5sum sdl"
	for i in ${uses}; do
		use ${i} || myconf+=" --disable-${i}"
	done
	use aalib || myconf+=" --disable-aa"
	use fbcon || myconf+=" --disable-fbdev"
	use fbcon && use video_cards_s3virge && myconf+=" --enable-s3fb"
	use libcaca || myconf+=" --disable-caca"
	use zoran || myconf+=" --disable-zr"

	if ! use kernel_linux && ! use video_cards_mga; then
		 myconf+=" --disable-mga --disable-xmga"
	fi

	if use video_cards_tdfx; then
		myconf+="
			$(use_enable video_cards_tdfx tdfxvid)
			$(use_enable fbcon tdfxfb)
		"
	else
		myconf+="
			--disable-3dfx
			--disable-tdfxvid
			--disable-tdfxfb
		"
	fi

	################
	# Audio Output #
	################
	uses="alsa esd jack ladspa nas openal"
	for i in ${uses}; do
		use ${i} || myconf+=" --disable-${i}"
	done
	use pulseaudio || myconf+=" --disable-pulse"
	if ! use radio; then
		use oss || myconf+=" --disable-ossaudio"
	fi

	####################
	# Advanced Options #
	####################
	# Platform specific flags, hardcoded on amd64 (see below)
	if use cpudetection; then
		myconf+=" --enable-runtime-cpudetection"
	fi

	# Turning off CPU optimizations usually will break the build.
	# However, this use flag, if enabled, will allow users to completely
	# specify which ones to use.  If disabled, mplayer will automatically
	# enable all CPU optimizations that the host build supports.
	if use custom-cpuopts; then
		uses="3dnow 3dnowext altivec mmx mmxext shm sse sse2 ssse3"
		for i in ${uses}; do
			myconf+=" $(use_enable ${i})"
		done
	fi

	use debug && myconf+=" --enable-debug=3"

	filter-flags -fPIC -fPIE
	append-flags -D__STDC_LIMIT_MACROS
	is-flag -O? || append-flags -O2
	if use x86 || use x86-fbsd; then
		use debug || append-flags -fomit-frame-pointer
	fi

	###########################
	# X enabled configuration #
	###########################
	if use X; then
		uses="dxr3 ggi xinerama"
		for i in ${uses}; do
			use ${i} || myconf+=" --disable-${i}"
		done
		use dga || myconf+=" --disable-dga1 --disable-dga2"
		use opengl || myconf+=" --disable-gl"
		use osdmenu && myconf+=" --enable-menu"
		use video_cards_nvidia && use vdpau || myconf+=" --disable-vdpau"
		use video_cards_vesa || myconf+=" --disable-vesa"
		use vidix || myconf+=" --disable-vidix --disable-vidix-pcidb"
		use xscreensaver || myconf+=" --disable-xss"

		# GTK gmplayer gui
		# Unsupported by Gentoo, upstream has dropped development
		myconf+=" $(use_enable gmplayer gui)"

		if use xv; then
			if use xvmc; then
				myconf+=" --enable-xvmc --with-xvmclib=XvMCW"
			else
				myconf+=" --disable-xvmc"
			fi
		else
			myconf+="
				--disable-xv
				--disable-xvmc
			"
			use xvmc && elog "Disabling xvmc because it requires \"xv\" useflag enabled."
		fi
	else
		myconf+="
		--disable-dga1
		--disable-dga2
		--disable-dxr3
		--disable-ggi
		--disable-gl
		--disable-vdpau
		--disable-vidix
		--disable-vidix-pcidb
		--disable-xinerama
		--disable-xss
		--disable-xv
		--disable-xvmc
		"
		uses="dga dxr3 ggi opengl osdmenu vdpau vidix xinerama xscreensaver xv"
		for i in uses; do
			use ${i} && elog "Useflag \"${i}\" require \"X\" useflag enabled to work."
		done
	fi

	if [[ ${PV} == *9999* ]]; then
		###################
		# External FFmpeg #
		###################
		use external-ffmpeg && myconf+=" --disable-libavutil_a --disable-libavcodec_a --disable-libavformat_a --disable-libpostproc_a --disable-libswscale_a"
	fi

	myconf="--cc=$(tc-getCC) \
		--host-cc=$(tc-getBUILD_CC) \
		--prefix=/usr \
		--confdir=/etc/mplayer \
		--datadir=/usr/share/mplayer \
		--libdir=/usr/$(get_libdir) \
		${myconf}"

	CFLAGS="${CFLAGS}" ./configure ${myconf} || die "configure died"
}

src_compile() {
	base_src_compile
	emake || die "Failed to build MPlayer!"
	use doc && make -C DOCS/xml html-chunked
}

src_install() {
	local i

	emake prefix="${D}/usr" \
		BINDIR="${D}/usr/bin" \
		LIBDIR="${D}/usr/$(get_libdir)" \
		CONFDIR="${D}/etc/mplayer" \
		DATADIR="${D}/usr/share/mplayer" \
		MANDIR="${D}/usr/share/man" \
		INSTALLSTRIP="" \
		install || die "emake install failed"

	dodoc AUTHORS Changelog Copyright README etc/codecs.conf || die

	docinto tech/
	dodoc DOCS/tech/{*.txt,MAINTAINERS,mpsub.sub,playtree,TODO,wishlist} || die
	docinto TOOLS/
	dodoc TOOLS/* || die
	if use real; then
		docinto tech/realcodecs/
		dodoc DOCS/tech/realcodecs/* || die
		docinto TOOLS/realcodecs/
		dodoc TOOLS/realcodecs/* || die
	fi
	docinto tech/mirrors/
	dodoc DOCS/tech/mirrors/* || die

	if use doc; then
		dohtml -r "${S}"/DOCS/HTML/* || die
	fi

	# Install the default Skin and Gnome menu entry
	if use gmplayer; then
		dodir /usr/share/mplayer/skins
		cp -r "${WORKDIR}/Blue" \
			"${D}/usr/share/mplayer/skins/default" || die "cp skins died"

		# Fix the symlink
		rm -rf "${D}/usr/bin/gmplayer"
		dosym mplayer /usr/bin/gmplayer
	fi

	if ! use ass && ! use truetype; then
		dodir /usr/share/mplayer/fonts
		# Do this generic, as the mplayer people like to change the structure
		# of their zips ...
		for i in $(find "${WORKDIR}/" -type d -name 'font-arial-*'); do
			cp -pPR "${i}" "${D}/usr/share/mplayer/fonts"
		done
		# Fix the font symlink ...
		rm -rf "${D}/usr/share/mplayer/font"
		dosym fonts/font-arial-14-iso-8859-1 /usr/share/mplayer/font
	fi

	insinto /etc/mplayer
	newins "${S}/etc/example.conf" mplayer.conf || die
	doins "${S}/etc/input.conf" || die
	if use osdmenu; then
		doins "${S}/etc/menu.conf" || die
	fi

	if use ass || use truetype;	then
		cat >> "${D}/etc/mplayer/mplayer.conf" << _EOF_
fontconfig=1
subfont-osd-scale=4
subfont-text-scale=3
_EOF_
	fi

	# bug 256203
	if use rar; then
		cat >> "${D}/etc/mplayer/mplayer.conf" << _EOF_
unrarexec=/usr/bin/unrar
_EOF_
	fi

	dosym ../../../etc/mplayer/mplayer.conf /usr/share/mplayer/mplayer.conf
	newbin "${S}/TOOLS/midentify.sh" midentify || die
}

pkg_preinst() {
	[[ -d ${ROOT}/usr/share/mplayer/Skin/default ]] && \
		rm -rf "${ROOT}/usr/share/mplayer/Skin/default"
}

pkg_postrm() {
	# Cleanup stale symlinks
	[ -L "${ROOT}/usr/share/mplayer/font" -a \
			! -e "${ROOT}/usr/share/mplayer/font" ] && \
		rm -f "${ROOT}/usr/share/mplayer/font"

	[ -L "${ROOT}/usr/share/mplayer/subfont.ttf" -a \
			! -e "${ROOT}/usr/share/mplayer/subfont.ttf" ] && \
		rm -f "${ROOT}/usr/share/mplayer/subfont.ttf"
}
