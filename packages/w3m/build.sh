TERMUX_PKG_HOMEPAGE=https://w3m.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Text based Web browser and pager"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=0.5.3
_MINOR_VERSION=20230121
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.${_MINOR_VERSION}
TERMUX_PKG_REVISION=2
# The upstream w3m project is dead, but every linux distribution uses
# this maintained fork in debian:
TERMUX_PKG_SRCURL=https://github.com/tats/w3m/archive/v${_MAJOR_VERSION}+git${_MINOR_VERSION}.tar.gz
TERMUX_PKG_SHA256=fdc7d55d3c0104db26aa9759db34f37e5eee03f44c868796e3bbfb8935c96e39
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libgc, ncurses, openssl, zlib"
TERMUX_PKG_SUGGESTS="libsixel, perl"

# ac_cv_func_bcopy=yes to avoid w3m defining it's own bcopy function, which
# breaks 64-bit builds where NDK headers define bcopy as a macro:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_setpgrp_void=yes ac_cv_func_bcopy=yes"

#Overwrite the default /usr/bin/firefox with termux-open-url as default external browser. That way, pressing "M" on a URL will open a link in Androids default Browser.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-browser=termux-open-url"
#Overwrite the default editor to just vi, as the default was /usr/bin/vi.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-editor=nano"

# For Makefile.in.patch:
export TERMUX_PKG_BUILDER_DIR
