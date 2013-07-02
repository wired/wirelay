# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

if [[ ${PV} == *9999* ]]; then
	inherit git-2
	EGIT_REPO_URI=${EGIT_REPO_URI:-"git://github.com/taylorchu/mimi.git"}
	KEYWORDS=""
	SRC_URI=""
else
	inherit vcs-snapshot
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
	SRC_URI=""
fi

DESCRIPTION="an improved version of xdg-open for users without a DE."
HOMEPAGE="https://github.com/taylorchu/mimi"

LICENSE="as-is"
SLOT="0"
IUSE=""

DEPEND="
	x11-misc/xdg-utils
"

RDEPEND="
	${DEPEND}
"

BINARY="/usr/bin/xdg-open"

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	mv xdg-open xdg-open.mimi
	dobin xdg-open.mimi
	dodoc README.md
}

pkg_postinst() {
	ewarn "Mimi is an xdg-open replacement. Creating a selection system"
	ewarn "for xdg-open was too much work so I decided to simply replace"
	ewarn "the original xdg-open binary."
	ewarn "If you unmerge mimi, the original xdg-open will be restored"
	ewarn "automatically. Note that rebuilding xdg-utils will destroy the"
	ewarn "mimi link and you will have to re-emerge mimi to fix it."
	if [[ ! -L ${BINARY} ]]; then
		if [[ -f ${BINARY} ]]; then
			elog "Renaming ${BINARY} to ${BINARY}.utils"
			mv ${BINARY} ${BINARY}.utils ||
				die "mv failed"
		fi
		elog "Linking ${BINARY}.mimi to ${BINARY}"
		ln -s ${BINARY}.mimi ${BINARY} ||
			die "ln failed"
	else
		elog "xdg-open already pointing to xdg-open.mimi,"
		elog "nothing to do here :)"
	fi
}

pkg_postrm() {
	if [[ -L ${BINARY} ]]; then
		elog "Removing the ${BINARY}.mimi -> ${BINARY} link";
		rm ${BINARY} ||
			die "removal of the xdg-open link failed"
		elog "Restoring the original xdg-open binary"
		mv ${BINARY}.utils ${BINARY} ||
			die "restoration of the original xdg-open binary failed"
	fi
}
