TERMUX_PKG_HOMEPAGE=https://www.wireshark.org/
TERMUX_PKG_DESCRIPTION="Network protocol analyzer and sniffer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.4.6"
TERMUX_PKG_SRCURL=https://www.wireshark.org/download/src/all-versions/wireshark-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=4fffcee3d18d1daac12f780c2e8da511824dffb3b0fd6446b53ab7516538edcd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="brotli, c-ares, glib, libcap, libgcrypt, libgmp, libgnutls, libgpg-error, libidn2, liblz4, liblzma, libminizip, libnettle, libnghttp2, libnl, libopus, libpcap, libsnappy, libssh, libunistring, libxml2, openssl, pcre2, speexdsp, zlib, zstd"
TERMUX_PKG_BREAKS="tshark-dev"
TERMUX_PKG_REPLACES="tshark-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_wireshark=OFF
-DENABLE_LUA=OFF
-DHAVE_LINUX_IF_BONDING_H=1
"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	gcc $TERMUX_PKG_SRCDIR/tools/lemon/lemon.c -o lemon
}

termux_step_pre_configure() {
	export PATH=$TERMUX_PKG_HOSTBUILD_DIR:$PATH
	LDFLAGS+=" -lm"
	sed -i "s#-T/usr/share/lemon/lempar.c#-T$TERMUX_PKG_SRCDIR/tools/lemon/lempar.c#" $TERMUX_PKG_SRCDIR/cmake/modules/UseLemon.cmake
}
