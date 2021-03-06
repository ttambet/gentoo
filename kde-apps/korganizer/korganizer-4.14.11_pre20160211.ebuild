# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
KMNAME="kdepim"
EGIT_BRANCH="KDE/4.14"
inherit kde4-meta

DESCRIPTION="Personal Organizer by KDE"
HOMEPAGE="https://www.kde.org/applications/office/korganizer/"
COMMIT_ID="2aec255c6465676404e4694405c153e485e477d9"
SRC_URI="https://quickgit.kde.org/?p=kdepim.git&a=snapshot&h=${COMMIT_ID}&fmt=tgz -> ${KMNAME}-${PV}.tar.gz"

KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepimlibs 'akonadi(+)')
	$(add_kdeapps_dep kdepim-common-libs)
	sys-libs/zlib
"
RDEPEND="${DEPEND}
	$(add_kdeapps_dep ktimezoned '' 4.14.3)
"

RESTRICT="test"
# bug 393135

KMLOADLIBS="kdepim-common-libs"

KMEXTRA="
	korgac/
"
KMEXTRACTONLY="
	agents/mailfilteragent/org.freedesktop.Akonadi.MailFilterAgent.xml
	akonadi_next/
	calendarviews/
	kdgantt2/
	kmail/
	knode/org.kde.knode.xml
	libkdepimdbusinterfaces/
	libkleo/
	libkpgp/
	mailimporter/
	messagecomposer/
"
KMCOMPILEONLY="
	calendarsupport/
	grantleetheme/
	incidenceeditor-ng/
	kaddressbookgrantlee/
	mailcommon/
	messagecore/
	messageviewer/
	pimcommon/
	templateparser/
"

src_unpack() {
	if use kontact; then
		KMEXTRA="${KMEXTRA}
			kontact/plugins/planner/
			kontact/plugins/specialdates/
		"
	fi

	kde4-meta_src_unpack
}

src_prepare() {
	use handbook && epatch "${FILESDIR}/${PN}-4.14.10-handbook.patch"

	kde4-meta_src_prepare
}

src_install() {
	kde4-meta_src_install
	# colliding with kdepim-common-libs
	rm -rf "${ED}"usr/share/kde4/servicetypes/calendarplugin.desktop || die
	rm -rf "${ED}"usr/share/kde4/servicetypes/calendardecoration.desktop || die
}

pkg_postinst() {
	kde4-meta_pkg_postinst

	if ! has_version kde-apps/kdepim-kresources:${SLOT}; then
		echo
		elog "For groupware functionality, please install kde-apps/kdepim-kresources:${SLOT}"
		echo
	fi
}
