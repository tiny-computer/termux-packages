TERMUX_PKG_HOMEPAGE=https://postgis.net
TERMUX_PKG_DESCRIPTION="Spatial database extender for PostgreSQL object-relational database"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.5.2"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://download.osgeo.org/postgis/source/postgis-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=fb9f95d56e3aaef6a296473c76a3b99005ac41864d486c197cd478c9b14f791a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdal, json-c, libc++, libgeos, libprotobuf-c, libxml2, pcre2, postgresql, proj"

# both configure script and Makefile(s) look for files in current
# directory rather than srcdir, so need to build in source
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CPPFLAGS+=" -D_GNU_SOURCE" # for preadv and pwritev
	CXXFLAGS+=" -std=c++14"
}
