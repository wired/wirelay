# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pam_mysql/pam_mysql-0.7_rc1-r3.ebuild,v 1.1 2011/09/13 07:29:13 hanno Exp $

EAPI=4

inherit mercurial pam

DESCRIPTION="2-step authentication for pam using google-authenticator"
HOMEPAGE="http://code.google.com/p/google-authenticator"

SRC_URI=""
EHG_REPO_URI="https://code.google.com/p/google-authenticator/"

DEPEND="
	sys-libs/pam
"
RDEPEND="${DEPEND}
	qr? ( media-gfx/qrencode )
"

LICENSE="Apache-2.0"

SLOT="0"
KEYWORDS=""

IUSE="+qr"

pkg_postinst() {
	elog	"To enable the pam module, add the following line to your"
	elog	"PAM configuration file, i.e. /etc/pam.d/login:"
	ewarn	"	auth required pam_google_authenticator.so"
	elog	"For more info, consult the README file."
}

src_prepare() {
	epatch "${FILESDIR}/pam_googleauthenticator-makefile.patch"
}

src_compile() {
	cd libpam
	emake pam_google_authenticator.so
	use tools && emake google-authenticator
}

src_install() {
	cd libpam
	insinto $(getpam_mod_dir)
	doins pam_google_authenticator.so
	if use tools; then
		dobin google-authenticator
	fi
	dodoc FILEFORMAT README
}
