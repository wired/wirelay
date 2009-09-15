# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-mod subversion eutils

DESCRIPTION="Next Generation driver for Atheros based IEEE 802.11a/b/g wireless LAN cards"
HOMEPAGE="http://www.madwifi-project.org/"
ESVN_REPO_URI="http://svn.madwifi-project.org/madwifi/branches/madwifi-hal-testing"

LICENSE="atheros-hal
	|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS=""
IUSE="injection"

DEPEND="app-arch/sharutils"
RDEPEND="!net-wireless/madwifi-old
		!net-wireless/madwifi-ng
		net-wireless/wireless-tools
		~net-wireless/madwifi-ng-tools-hal-${PV}"

CONFIG_CHECK="CRYPTO WIRELESS_EXT SYSCTL"
ERROR_CRYPTO="${P} requires Cryptographic API support (CONFIG_CRYPTO)."
ERROR_WIRELESS_EXT="${P} requires CONFIG_WIRELESS_EXT selected by Wireless LAN drivers (non-hamradio) & Wireless Extensions"
ERROR_SYSCTL="${P} requires Sysctl support (CONFIG_SYSCTL)."
BUILD_TARGETS="all"
MODULESD_ATH_PCI_DOCS="README"

pkg_setup() {
	linux-mod_pkg_setup

	MODULE_NAMES='ath_hal(net:"${S}"/ath_hal)
				wlan(net:"${S}"/net80211)
				wlan_acl(net:"${S}"/net80211)
				wlan_ccmp(net:"${S}"/net80211)
				wlan_tkip(net:"${S}"/net80211)
				wlan_wep(net:"${S}"/net80211)
				wlan_xauth(net:"${S}"/net80211)
				wlan_scan_sta(net:"${S}"/net80211)
				wlan_scan_ap(net:"${S}"/net80211)
				ath_rate_amrr(net:"${S}"/ath_rate/amrr)
				ath_rate_onoe(net:"${S}"/ath_rate/onoe)
				ath_rate_sample(net:"${S}"/ath_rate/sample)
				ath_rate_minstrel(net:"${S}"/ath_rate/minstrel)
				ath_pci(net:"${S}"/ath)'

	BUILD_PARAMS="KERNELPATH=${KV_OUT_DIR}"

}

src_unpack() {
	subversion_src_unpack

	einfo "fixing svnversion.h quirk [sed '/#include "svnversion.h"/d' -i release.h]"
	sed '/#include "svnversion.h"/d' -i release.h

	if use injection; then epatch ${FILESDIR}/${PN}-injection.patch; fi
	for dir in ath ath_hal net80211 ath_rate ath_rate/amrr ath_rate/onoe ath_rate/sample ath_rate/minstrel; do
		convert_to_m ${dir}/Makefile
	done
}

src_install() {

	linux-mod_src_install

	dodoc README THANKS docs/users-guide.pdf docs/WEP-HOWTO.txt
}

pkg_postinst() {
	local moddir="${ROOT}/lib/modules/${KV_FULL}/net/"

	linux-mod_pkg_postinst

	einfo
	einfo "Interfaces (athX) are now automatically created upon loading the ath_pci"
	einfo "module."
	einfo
	einfo "The type of the created interface can be controlled through the 'autocreate'"
	einfo "module parameter."
	einfo
	einfo "As of net-wireless/madwifi-ng-0.9.3 rate control module selection is done at"
	einfo "module load time via the 'ratectl' module parameter. USE flags amrr and onoe"
	einfo "no longer serve any purpose."
}
