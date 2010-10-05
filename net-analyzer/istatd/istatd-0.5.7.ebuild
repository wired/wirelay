# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils autotools

DESCRIPTION="Daemon that serves statistics to the iStat iPhone application"
HOMEPAGE="http://bjango.com/help/istat/istatserverlinux/"
SRC_URI="http://github.com/downloads/tiwilliam/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-libs/libxml2
"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup istatd
	enewuser istatd -1 -1 /dev/null istatd
}

src_prepare() {
	# istat -> istatd for consistency
	epatch "${FILESDIR}/${PN}-gentoo-config.patch"

	eautoreconf

	mv resource/istat.conf resource/istatd.conf || die "rename failed"
	mv resource/istat.conf.5 resource/istatd.conf.5 || die "rename failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "installation failed"

	newinitd "${FILESDIR}"/istatd.initd istatd || die "newinitd failed"
	newconfd "${FILESDIR}"/istatd.confd istatd || die "newconfd failed"

	keepdir /var/run/istatd
	fowners istatd:istatd /var/run/istatd
	keepdir /var/cache/istatd
	fowners istatd:istatd /var/cache/istatd
}

pkg_postinst() {
	elog
	elog "Don't forget to edit /etc/istatd.conf and change the server access code!"
	elog
}
