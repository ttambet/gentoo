# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
CMAKE_BUILD_TYPE=Release

inherit cmake-utils linux-info python-single-r1

DESCRIPTION="Record and Replay Framework"
HOMEPAGE="http://rr-project.org/"
SRC_URI="https://github.com/mozilla/${PN}/archive/${PV}.tar.gz -> mozilla-${P}.tar.gz"

LICENSE="MIT BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}
	sys-devel/gdb[xml]"
# Add all the deps needed only at build/test time.
DEPEND+="
	test? (
		dev-python/pexpect[${PYTHON_USEDEP}]
		sys-devel/gdb[xml]
	)
	${PYTHON_DEPS}"

PATCHES=(
	"${FILESDIR}"/${P}-sysmacros.patch
)

pkg_setup() {
	if use kernel_linux; then
		CONFIG_CHECK="SECCOMP"
		linux-info_pkg_setup
	fi
	python-single-r1_pkg_setup
}

src_prepare() {
	default

	sed -i 's:-Werror::' CMakeLists.txt || die #609192
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
	)

	cmake-utils_src_configure
}
