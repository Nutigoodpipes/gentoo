# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit python-r1

MY_P=cfe-${PV/_/}.src
DESCRIPTION="Python bindings for sys-devel/clang"
HOMEPAGE="https://llvm.org/"
SRC_URI="http://prereleases.llvm.org/${PV/_//}/${MY_P}.tar.xz"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# The module is opening libclang.so directly, and doing some blasphemy
# on top of it.
RDEPEND="
	>=sys-devel/clang-${PV}:*
	!sys-devel/llvm:0[clang(-),python(-)]
	!sys-devel/clang:0[python(-)]
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S=${WORKDIR}/${MY_P}/bindings/python

src_unpack() {
	einfo "Unpacking parts of ${MY_P}.tar.xz ..."
	tar -xJf "${DISTDIR}/${MY_P}.tar.xz" "${MY_P}/bindings/python" || die
}

src_test() {
	python_foreach_impl nosetests -v || die
}

src_install() {
	python_foreach_impl python_domodule clang
}
