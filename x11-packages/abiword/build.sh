TERMUX_PKG_HOMEPAGE=https://www.abisource.com/
TERMUX_PKG_DESCRIPTION="A free word processing program"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.6"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/World/AbiWord/-/archive/release-${TERMUX_PKG_VERSION}/AbiWord-release-${TERMUX_PKG_VERSION}.tar.gz
#TERMUX_PKG_SRCURL=https://dev.alpinelinux.org/archive/abiword/abiword-${TERMUX_PKG_VERSION}.tar.gz
#TERMUX_PKG_SRCURL=https://ftp-osl.osuosl.org/pub/gentoo/distfiles/abiword-${TERMUX_PKG_VERSION}.tar.gz
#TERMUX_PKG_SRCURL=http://www.abisource.com/downloads/abiword/${TERMUX_PKG_VERSION}/source/abiword-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=571b8db0f7aac6f2a607b489eedd71260b449cc733d704cf4d9551e6df35d1a4
TERMUX_PKG_DEPENDS="atk, enchant, fontconfig, fribidi, gdk-pixbuf, glib, goffice, gtk3, libc++, libcairo, libgsf, libical, libjpeg-turbo, libpng, librsvg, libwv, libx11, libxml2, libxslt, pango, readline, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers, g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-default-plugins
--enable-plugins=applix,babelfish,bmp,clarisworks,command,docbook,eml,epub,freetranslation,garble,gdict,gimp,goffice,google,hancom,hrtext,iscii,kword,latex,loadbindings,mif,mswrite,openwriter,openxml,opml,passepartout,pdb,pdf,presentation,s5,sdw,t602,urldict,wikipedia,wml,xslfo
--disable-builtin-plugins
--disable-print
--enable-spell
--enable-statusbar
--enable-clipart
--enable-templates
--disable-collab-backend-telepathy
--disable-collab-backend-xmpp
--disable-collab-backend-tcp
--disable-collab-backend-sugar
--disable-collab-backend-service
--disable-introspection
--without-gtk2
--with-goffice
--without-redland
--without-evolution-data-server
--without-champlain
--without-inter7eps
--without-libtidy
"

termux_step_pre_configure() {
	termux_setup_gir

	./autogen-common.sh
	autoreconf -fi

	LDFLAGS+=" $($CC -print-libgcc-file-name) -lm"
}

termux_step_post_configure() {
	touch ./src/g-ir-scanner

	# Avoid overlinking
	sed -i 's/ -shared / -Wl,--as-needed\0/g' ./libtool
}
