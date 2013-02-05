# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2 python

DESCRIPTION="A python sync daemon for ownCloud depending on csync."
HOMEPAGE="https://github.com/visit1985/oc-ocpy"

EGIT_REPO_URI=${EGIT_REPO_URI:-"git://github.com/visit1985/oc-ocpy.git"}
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="
	dev-python/pyinotify
	net-misc/csync[webdav]
	${DEPEND}
"

src_install() {
	newinitd "${FILESDIR}"/"${PN}".initd "${PN}"
	newconfd "${FILESDIR}"/"${PN}".confd "${PN}"

	dobin ${PN}.py
	dodoc README
}
