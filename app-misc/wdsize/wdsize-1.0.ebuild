# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Current directory size and file count in your prompt"
HOMEPAGE="http://cli-apps.org/content/show.php/wdsize?content=122098"
SRC_URI="http://cli-apps.org/CONTENT/content-files/122098-${P}.tar.gz"

LICENSE="gpl-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "installation failed"
	dodoc README || die "dodoc failed"
}
