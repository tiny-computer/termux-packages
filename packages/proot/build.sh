# Contributor: @michalbednarski
TERMUX_PKG_HOMEPAGE=https://proot-me.github.io/
TERMUX_PKG_DESCRIPTION="Emulate chroot, bind mount and binfmt_misc for non-root users"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Michal Bednarski @michalbednarski"
# Just bump commit and version when needed:
_COMMIT=9fe52bafd25373f0a9f78099f530f3aff617fd79
TERMUX_PKG_VERSION=5.1.107
TERMUX_PKG_REVISION=67
TERMUX_PKG_SRCURL=https://github.com/tiny-computer/proot-termux/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=ab41f1febba393f49488ab429cde293513d70622738cc7fb3fdbe83098515f48
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="libtalloc"
TERMUX_PKG_SUGGESTS="proot-distro"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="-C src"

# Use a loader bundled with the Termux app so that it can be executed.
export PROOT_UNBUNDLE_LOADER=${TERMUX_PREFIX%/usr}/applib

termux_step_pre_configure() {
	CPPFLAGS+=" -DARG_MAX=131072"
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/share/man/man1
	install -m600 $TERMUX_PKG_SRCDIR/doc/proot/man.1 $TERMUX_PREFIX/share/man/man1/proot.1

	# sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
	# 	$TERMUX_PKG_BUILDER_DIR/termux-chroot \
	# 	> $TERMUX_PREFIX/bin/termux-chroot
	# chmod 700 $TERMUX_PREFIX/bin/termux-chroot

	# Loader is bundled with the android app itself instead so that it can be executed:
	local file
	for file in loader loader32; do
		if [ "$file" = "loader32" ] && [ "$TERMUX_ARCH" = "arm" ]; then
			continue
		fi
		mv $PROOT_UNBUNDLE_LOADER/$file \
			$TERMUX_OUTPUT_DIR/libproot-$file-$TERMUX_ARCH-$TERMUX_PKG_VERSION-$TERMUX_PKG_REVISION.so
	done
	rm -Rf $PROOT_UNBUNDLE_LOADER
}
