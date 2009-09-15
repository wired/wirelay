# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs subversion eutils

DESCRIPTION="Next Generation tools for configuration of Atheros based IEEE 802.11a/b/g wireless LAN cards"
HOMEPAGE="http://www.madwifi-project.org/"
ESVN_REPO_URI="http://svn.madwifi-project.org/madwifi/branches/madwifi-hal-testing"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS=""

IUSE=""
DEPEND="virtual/libc"
RDEPEND="!net-wireless/madwifi-old-tools
		!net-wireless/madwifi-ng-tools
		${DEPEND}"

src_compile() {
	cd ${S}/tools
	emake || die "emake failed"
}

src_install() {
	cd ${S}/tools
	emake ARCH="$(tc-arch-kernel)" DESTDIR="${D}" BINDIR=/usr/bin MANDIR=/usr/share/man STRIP=echo \
		install || die "emake install failed"

	dodir /sbin
	mv "${D}"/usr/bin/wlanconfig "${D}"/sbin

	# install headers for use by
	# net-wireless/wpa_supplicant and net-wireless/hostapd
	cd ${S}
	insinto /usr/include/madwifi/include/
	doins include/*.h
	insinto /usr/include/madwifi/net80211
	doins net80211/*.h
}

pkg_postinst() {
	if [ -e "${ROOT}"/etc/udev/rules.d/65-madwifi.rules ]; then
		ewarn
		ewarn "The udev rules for creating interfaces (athX) are no longer needed."
		ewarn
		ewarn "You should manually remove the /etc/udev/rules.d/65-madwifi.rules file"
		ewarn "and either run 'udevstart' or reboot for the changes to take effect."
		ewarn
	fi
	einfo
	einfo "If you use net-wireless/wpa_supplicant or net-wireless/hostapd with
madwifi"
	einfo "you should remerge them now."
	einfo
}
