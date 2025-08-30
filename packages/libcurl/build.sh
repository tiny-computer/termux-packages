TERMUX_PKG_HOMEPAGE=https://curl.se/
TERMUX_PKG_DESCRIPTION="Easy-to-use client-side URL transfer library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="8.15.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/curl/curl/releases/download/curl-${TERMUX_PKG_VERSION//./_}/curl-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=6cd0a8a5b126ddfda61c94dc2c3fc53481ba7a35461cf7c5ab66aa9d6775b609
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+.\d+.\d+"
TERMUX_PKG_DEPENDS="libnghttp2, libnghttp3, libssh2, openssl, zlib"
TERMUX_PKG_BREAKS="libcurl-dev"
TERMUX_PKG_REPLACES="libcurl-dev"
TERMUX_PKG_ESSENTIAL=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-ntlm-wb=$TERMUX_PREFIX/bin/ntlm_auth
--with-ca-bundle=$TERMUX_PREFIX/etc/tls/cert.pem
--with-ca-path=$TERMUX_PREFIX/etc/tls/certs
--with-nghttp2
--without-libidn
--without-libidn2
--without-librtmp
--without-brotli
--without-libpsl
--with-libssh2
--with-ssl
--with-openssl
--with-openssl-quic
--with-nghttp3
--disable-ares
"

# https://github.com/termux/termux-packages/issues/15889
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_getpwuid=yes"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=4

	local a
	for a in VERSIONCHANGE VERSIONDEL; do
		local _${a}=$(sed -En 's/^'"${a}"'=([0-9]+).*/\1/p' \
				lib/Makefile.soname)
	done
	local v=$(( _VERSIONCHANGE - _VERSIONDEL ))
	if [ ! "${_VERSIONCHANGE}" ] || [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	LDFLAGS+=" -Wl,-z,nodelete"
}
