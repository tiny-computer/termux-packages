#!/bin/bash
# shellcheck disable=SC1117

# Setting the TMPDIR variable
: "${TMPDIR:=/tmp}"
export TMPDIR

set -e -o pipefail -u

cd "$(realpath "$(dirname "$0")")"
TERMUX_SCRIPTDIR=$(pwd)
export TERMUX_SCRIPTDIR

# Store pid of current process in a file for docker__run_docker_exec_trap
source "$TERMUX_SCRIPTDIR/scripts/utils/docker/docker.sh"; docker__create_docker_exec_pid_file

# Source the `termux_package` library.
source "$TERMUX_SCRIPTDIR/scripts/utils/termux/package/termux_package.sh"

export SOURCE_DATE_EPOCH=${SOURCE_DATE_EPOCH:-$(git -c log.showSignature=false log -1 --pretty=%ct 2>/dev/null || date "+%s")}

if [ "$(uname -o)" = "Android" ] || [ -e "/system/bin/app_process" ]; then
	if [ "$(id -u)" = "0" ]; then
		echo "On-device execution of this script as root is disabled."
		exit 1
	fi

	# This variable tells all parts of build system that build
	# is performed on device.
	export TERMUX_ON_DEVICE_BUILD=true
else
	export TERMUX_ON_DEVICE_BUILD=false
fi

# Automatically enable offline set of sources and build tools.
# Offline termux-packages bundle can be created by executing
# script ./scripts/setup-offline-bundle.sh.
if [ -f "${TERMUX_SCRIPTDIR}/build-tools/.installed" ]; then
	export TERMUX_PACKAGES_OFFLINE=true
fi

# Lock file to prevent parallel running in the same environment.
TERMUX_BUILD_LOCK_FILE="${TMPDIR}/.termux-build.lck"
if [ ! -e "$TERMUX_BUILD_LOCK_FILE" ]; then
	touch "$TERMUX_BUILD_LOCK_FILE"
fi

export TERMUX_REPO_PKG_FORMAT=$(jq --raw-output '.pkg_format // "debian"' ${TERMUX_SCRIPTDIR}/repo.json)

# Special variable for internal use. It forces script to ignore
# lock file.
: "${TERMUX_BUILD_IGNORE_LOCK:=false}"

# Utility function to log an error message and exit with an error code.
# shellcheck source=scripts/build/termux_error_exit.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_error_exit.sh"

# Utility function to download a resource with an expected checksum.
# shellcheck source=scripts/build/termux_download.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_download.sh"

# Utility function to run binaries under termux environment via proot.
# shellcheck source=scripts/build/setup/termux_setup_proot.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_proot.sh"

# Utility function for setting up Cargo C-ABI helpers.
# shellcheck source=scripts/build/setup/termux_setup_cargo_c.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_cargo_c.sh"

# Utility function for setting up pkg-config wrapper.
# shellcheck source=scripts/build/setup/termux_setup_pkg_config_wrapper.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_pkg_config_wrapper.sh"

# Utility function for setting up Crystal toolchain.
# shellcheck source=scripts/build/setup/termux_setup_crystal.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_crystal.sh"

# Utility function for setting up DotNet toolchain.
# shellcheck source=scripts/build/setup/termux_setup_dotnet.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_dotnet.sh"

# Utility function for setting up Flang toolchain.
# shellcheck source=scripts/build/setup/termux_setup_flang.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_flang.sh"

# Utility function to setup a GHC cross-compiler toolchain targeting Android.
# shellcheck source=scripts/build/setup/termux_setup_ghc.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_ghc.sh"

# Utility function to setup GHC iserv to cross-compile haskell-template.
# shellcheck source=scripts/build/setup/termux_setup_ghc_iserv.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_ghc_iserv.sh"

# Utility function to setup cabal-install (may be used by ghc toolchain).
# shellcheck source=scripts/build/setup/termux_setup_cabal.sh.
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_cabal.sh"

# Utility function to setup jailbreak-cabal. It is used to remove version constraints
# from Cabal packages.
# shellcheck source=scripts/build/setup/termux_setup_jailbreak_cabal.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_jailbreak_cabal.sh"

# Utility function for setting up GObject Introspection cross environment.
# shellcheck source=scripts/build/setup/termux_setup_gir.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_gir.sh"

# Utility function for setting up GN toolchain.
# shellcheck source=scripts/build/setup/termux_setup_gn.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_gn.sh"

# Utility function for golang-using packages to setup a go toolchain.
# shellcheck source=scripts/build/setup/termux_setup_golang.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_golang.sh"

# Utility function for setting up LDC cross environment.
# shellcheck source=scripts/build/setup/termux_setup_ldc.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_ldc.sh"

# Utility function for python packages to setup a python.
# shellcheck source=scripts/build/setup/termux_setup_python_pip.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_python_pip.sh"

# Utility function for rust-using packages to setup a rust toolchain.
# shellcheck source=scripts/build/setup/termux_setup_rust.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_rust.sh"

# Utility function for swift-using packages to setup a swift toolchain
# shellcheck source=scripts/build/setup/termux_setup_swift.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_swift.sh"

# Utility function to setup a current xmake build system.
# shellcheck source=scripts/build/setup/termux_setup_xmake.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_xmake.sh"

# Utility function to setup a current ninja build system.
# shellcheck source=scripts/build/setup/termux_setup_ninja.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_ninja.sh"

# Utility function to setup Node.js JavaScript Runtime
# shellcheck source=scripts/build/setup/termux_setup_nodejs.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_nodejs.sh"

# Utility function to setup a current meson build system.
# shellcheck source=scripts/build/setup/termux_setup_meson.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_meson.sh"

# Utility function to setup a current cmake build system
# shellcheck source=scripts/build/setup/termux_setup_cmake.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_cmake.sh"

# Utility function to setup protobuf:
# shellcheck source=scripts/build/setup/termux_setup_protobuf.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_protobuf.sh"

# Utility function to setup the current version of the tree-sitter CLI
# shellcheck source=scripts/build/setup/termux_setup_treesitter.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_treesitter.sh"

# Setup variables used by the build. Not to be overridden by packages.
# shellcheck source=scripts/build/termux_step_setup_variables.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_setup_variables.sh"

# Save away and restore build setups which may change between builds.
# shellcheck source=scripts/build/termux_step_handle_buildarch.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_handle_buildarch.sh"

# Function to get TERMUX_PKG_VERSION from build.sh
# shellcheck source=scripts/build/termux_extract_dep_info.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_extract_dep_info.sh"

# Function that downloads a .deb (using the termux_download function)
# shellcheck source=scripts/build/termux_download_deb_pac.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_download_deb_pac.sh"

# Script to download InRelease, verify it's signature and then download Packages.xz by hash
# shellcheck source=scripts/build/termux_get_repo_files.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_get_repo_files.sh"

# Download or build dependencies. Not to be overridden by packages.
# shellcheck source=scripts/build/termux_step_get_dependencies.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_get_dependencies.sh"

# Download python dependency modules for compilation.
# shellcheck source=scripts/build/termux_step_get_dependencies_python.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_get_dependencies_python.sh"

# Handle config scripts that needs to be run during build. Not to be overridden by packages.
# shellcheck source=scripts/build/termux_step_override_config_scripts.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_override_config_scripts.sh"

# Remove old src and build folders and create new ones
# shellcheck source=scripts/build/termux_step_setup_build_folders.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_setup_build_folders.sh"

# Source the package build script and start building. Not to be overridden by packages.
# shellcheck source=scripts/build/termux_step_start_build.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_start_build.sh"

# Cleans up files from already built packages. Not to be overridden by packages.
# shellcheck source=scripts/build/termux_step_start_build.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_cleanup_packages.sh"

# Download or build dependencies. Not to be overridden by packages.
# shellcheck source=scripts/build/termux_step_create_timestamp_file.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_create_timestamp_file.sh"

# Run just after sourcing $TERMUX_PKG_BUILDER_SCRIPT. Can be overridden by packages.
# shellcheck source=scripts/build/get_source/termux_step_get_source.sh
source "$TERMUX_SCRIPTDIR/scripts/build/get_source/termux_step_get_source.sh"

# Run from termux_step_get_source if TERMUX_PKG_SRCURL begins with "git+".
# shellcheck source=scripts/build/get_source/termux_step_get_source.sh
source "$TERMUX_SCRIPTDIR/scripts/build/get_source/termux_git_clone_src.sh"

# Run from termux_step_get_source if TERMUX_PKG_SRCURL does not begin with "git+".
# shellcheck source=scripts/build/get_source/termux_download_src_archive.sh
source "$TERMUX_SCRIPTDIR/scripts/build/get_source/termux_download_src_archive.sh"

# Run from termux_step_get_source after termux_download_src_archive.
# shellcheck source=scripts/build/get_source/termux_unpack_src_archive.sh
source "$TERMUX_SCRIPTDIR/scripts/build/get_source/termux_unpack_src_archive.sh"

# Hook for packages to act just after the package sources have been obtained.
# Invoked from $TERMUX_PKG_SRCDIR.
termux_step_post_get_source() {
	return
}

# Optional host build. Not to be overridden by packages.
# shellcheck source=scripts/build/termux_step_handle_host_build.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_handle_host_build.sh"

# Perform a host build. Will be called in $TERMUX_PKG_HOSTBUILD_DIR.
# After termux_step_post_get_source() and before termux_step_patch_package()
# shellcheck source=scripts/build/termux_step_host_build.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_host_build.sh"

# Setup a standalone Android NDK toolchain. Called from termux_step_setup_toolchain.
# shellcheck source=scripts/build/toolchain/termux_setup_toolchain_27c.sh
source "$TERMUX_SCRIPTDIR/scripts/build/toolchain/termux_setup_toolchain_27c.sh"

# Runs termux_step_setup_toolchain_${TERMUX_NDK_VERSION}. Not to be overridden by packages.
# shellcheck source=scripts/build/termux_step_setup_toolchain.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_setup_toolchain.sh"

# Apply all *.patch files for the package. Not to be overridden by packages.
# shellcheck source=scripts/build/termux_step_patch_package.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_patch_package.sh"

# Replace autotools build-aux/config.{sub,guess} with ours to add android targets.
# shellcheck source=scripts/build/termux_step_replace_guess_scripts.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_replace_guess_scripts.sh"

# For package scripts to override. Called in $TERMUX_PKG_BUILDDIR.
termux_step_pre_configure() {
	return
}

# Setup configure args and run $TERMUX_PKG_SRCDIR/configure. This function is called from termux_step_configure
# shellcheck source=scripts/build/configure/termux_step_configure_autotools.sh
source "$TERMUX_SCRIPTDIR/scripts/build/configure/termux_step_configure_autotools.sh"

# Setup configure args and run cmake. This function is called from termux_step_configure
# shellcheck source=scripts/build/configure/termux_step_configure_cmake.sh
source "$TERMUX_SCRIPTDIR/scripts/build/configure/termux_step_configure_cmake.sh"

# Setup configure args and run meson. This function is called from termux_step_configure
# shellcheck source=scripts/build/configure/termux_step_configure_meson.sh
source "$TERMUX_SCRIPTDIR/scripts/build/configure/termux_step_configure_meson.sh"

# Setup configure args and run cabal. This function is called from termux_step_configure
# shellcheck source=scripts/build/configure/termux_step_configure_cabal.sh
source "$TERMUX_SCRIPTDIR/scripts/build/configure/termux_step_configure_cabal.sh"

# Configure the package
# shellcheck source=scripts/build/configure/termux_step_configure.sh
source "$TERMUX_SCRIPTDIR/scripts/build/configure/termux_step_configure.sh"

# Hook for packages after configure step
termux_step_post_configure() {
	return
}

# Make package, either with ninja or make
# shellcheck source=scripts/build/termux_step_make.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_make.sh"

# Make install, either with ninja, make of cargo
# shellcheck source=scripts/build/termux_step_make_install.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_make_install.sh"

# Hook function for package scripts to override.
termux_step_post_make_install() {
	return
}

# Install hooks (alpm-hooks) and hook-scripts into the pacman package
# shellcheck source=scripts/build/termux_step_install_pacman_hooks.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_install_pacman_hooks.sh"

# Add service scripts from array TERMUX_PKG_SERVICE_SCRIPT, if it is set
# shellcheck source=scripts/build/termux_step_install_service_scripts.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_install_service_scripts.sh"

# Link/copy the LICENSE for the package to $TERMUX_PREFIX/share/$TERMUX_PKG_NAME/
# shellcheck source=scripts/build/termux_step_install_license.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_install_license.sh"

# Function to cp (through tar) installed files to massage dir
# shellcheck source=scripts/build/termux_step_copy_into_massagedir.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_copy_into_massagedir.sh"

# Hook function to create {pre,post}install, {pre,post}rm-scripts for subpkgs
# shellcheck source=scripts/build/termux_step_create_subpkg_debscripts.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_create_subpkg_debscripts.sh"

# Create all subpackages. Run from termux_step_massage
# shellcheck source=scripts/build/termux_create_debian_subpackages.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_create_debian_subpackages.sh"

# Function to run various cleanup/fixes
# shellcheck source=scripts/build/termux_step_massage.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_massage.sh"

# Function to run strip symbols during termux_step_massage
# shellcheck source=scripts/build/termux_step_strip_elf_symbols.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_strip_elf_symbols.sh"

# Function to run termux-elf-cleaner during termux_step_massage
# shellcheck source=scripts/build/termux_step_elf_cleaner.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_elf_cleaner.sh"

# Hook for packages before massage step
termux_step_pre_massage() {
	return
}

# Hook for packages after massage step
termux_step_post_massage() {
	return
}

# Function to create {pre,post}install, {pre,post}rm-scripts and similar
# shellcheck source=scripts/build/termux_step_create_debscripts.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_create_debscripts.sh"

# Create the build deb file. Not to be overridden by package scripts.
# shellcheck source=scripts/build/termux_step_create_debian_package.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_create_debian_package.sh"

# Finish the build. Not to be overridden by package scripts.
# shellcheck source=scripts/build/termux_step_finish_build.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_finish_build.sh"

################################################################################

# shellcheck source=scripts/properties.sh
. "$TERMUX_SCRIPTDIR/scripts/properties.sh"

if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
	# For on device builds cross compiling is not supported.
	# Target architecture must be same as for environment used currently.
	TERMUX_ARCH=$(dpkg --print-architecture)
	export TERMUX_ARCH
fi

# Configure variables (TERMUX_ARCH, TERMUX__PREFIX__INCLUDE_DIR, TERMUX__PREFIX__LIB_DIR) for multilib-compilation
termux_conf_multilib_vars() {
	# Change the 64-bit architecture type to its 32-bit counterpart in the `TERMUX_ARCH` variable
	case $TERMUX_ARCH in
		"aarch64") TERMUX_ARCH="arm";;
		"x86_64") TERMUX_ARCH="i686";;
		*) termux_error_exit "It is impossible to set multilib arch for ${TERMUX_ARCH} arch."
	esac
	TERMUX__PREFIX__INCLUDE_DIR="$TERMUX__PREFIX__MULTI_INCLUDE_DIR"
	TERMUX__PREFIX__LIB_DIR="$TERMUX__PREFIX__MULTI_LIB_DIR"
}

# Run functions for normal compilation and multilib-compilation
termux_run_base_and_multilib_build_step() {
	case "${1}" in
		termux_step_configure|termux_step_make|termux_step_make_install) local func="${1}";;
		*) termux_error_exit "Unsupported function '${1}'."
	esac
	cd "$TERMUX_PKG_BUILDDIR"
	if [ "$TERMUX_PKG_BUILD_ONLY_MULTILIB" = "false" ]; then
		"${func}"
	fi
	if [ "$TERMUX_PKG_BUILD_MULTILIB" = "true" ]; then
		(
			termux_step_setup_multilib_environment
			"${func}_multilib"
		)
	fi
}

# Special hook to prevent use of "sudo" inside package build scripts.
# build-package.sh shouldn't perform any privileged operations.
sudo() {
	termux_error_exit "Do not use 'sudo' inside build scripts. Build environment should be configured through ./scripts/setup-ubuntu.sh."
}

_show_usage() {
	echo "Usage: ./build-package.sh [options] PACKAGE_1 PACKAGE_2 ..."
	echo
	echo "Build a package by creating a .deb file in the debs/ folder."
	echo
	echo "Available options:"
	[ "$TERMUX_ON_DEVICE_BUILD" = "false" ] && echo "  -a The architecture to build for: aarch64(default), arm, x86_64 or all."
	echo "  -d Build with debug symbols."
	echo "  -F Force build even if package and its dependencies have already been built."
	[ "$TERMUX_ON_DEVICE_BUILD" = "false" ] && echo "  -i Download dependencies instead of building them."
	echo "  -q Quiet build."
	echo "  -Q Loud build -- set -x debug output."
	echo "  -o Specify directory where to put built packages. Default: output/."
	exit 1
}

declare -a PACKAGE_LIST=()

if [ "$#" -lt 1 ]; then _show_usage; fi
while (($# >= 1)); do
	case "$1" in
		--) shift 1; break;;
		-h|--help) _show_usage;;
		-a)
			if [ $# -ge 2 ]; then
				shift 1
				if [ -z "$1" ]; then
					termux_error_exit "Argument to '-a' should not be empty."
				fi
				if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
					termux_error_exit "./build-package.sh: option '-a' is not available for on-device builds"
				else
					export TERMUX_ARCH="$1"
				fi
			else
				termux_error_exit "./build-package.sh: option '-a' requires an argument"
			fi
			;;
		-d) export TERMUX_DEBUG_BUILD=true;;
		-i)
			if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
				termux_error_exit "./build-package.sh: option '-i' is not available for on-device builds"
			fi
			export TERMUX_INSTALL_DEPS=true
			;;
		-q) export TERMUX_QUIET_BUILD=true;;
		-Q) set -x;;
		-o)
			if [ $# -ge 2 ]; then
				shift 1
				if [ -z "$1" ]; then
					termux_error_exit "./build-package.sh: argument to '-o' should not be empty"
				fi
				TERMUX_OUTPUT_DIR=$(realpath -m "$1")
			else
				termux_error_exit "./build-package.sh: option '-o' requires an argument"
			fi
			;;
		-c) TERMUX_CONTINUE_BUILD=true;;
		-C) TERMUX_CLEANUP_BUILT_PACKAGES_ON_LOW_DISK_SPACE=true;;
		-*) termux_error_exit "./build-package.sh: illegal option '$1'";;
		*) PACKAGE_LIST+=("$1");;
	esac
	shift 1
done
unset -f _show_usage

# Dependencies should be used from repo only if they are built for
# same package name.
if [ "$TERMUX_REPO_APP__PACKAGE_NAME" != "$TERMUX_APP_PACKAGE" ]; then
	echo "Ignoring -i option to download dependencies since repo package name ($TERMUX_REPO_APP__PACKAGE_NAME) does not equal app package name ($TERMUX_APP_PACKAGE)"
	TERMUX_INSTALL_DEPS=false
fi

if [ "${TERMUX_INSTALL_DEPS-false}" = "true" ]; then
	# Setup PGP keys for verifying integrity of dependencies.
	# Keys are obtained from our keyring package.
	FINGERPRINT=$(gpg --with-colons --show-keys $TERMUX_SCRIPTDIR/packages/termux-keyring/termux-packages.gpg | awk -F':' '$1=="fpr"{print $10}')
	gpg --list-keys $FINGERPRINT > /dev/null 2>&1 || {
		gpg --import "$TERMUX_SCRIPTDIR/packages/termux-keyring/termux-packages.gpg"
		gpg --no-tty --command-file <(echo -e "trust\n5\ny")  --edit-key $FINGERPRINT
	}
fi

for ((i=0; i<${#PACKAGE_LIST[@]}; i++)); do
	# Following commands must be executed under lock to prevent running
	# multiple instances of "./build-package.sh".
	#
	# To provide sane environment for each package, builds are done
	# in subshell.
	(
		if ! $TERMUX_BUILD_IGNORE_LOCK; then
			flock -n 5 || termux_error_exit "Another build is already running within same environment."
		fi

		# Handle 'all' arch:
		if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ] && [ -n "${TERMUX_ARCH+x}" ] && [ "${TERMUX_ARCH}" = 'all' ]; then
			for arch in 'aarch64' 'x86_64' 'arm'; do
				env TERMUX_ARCH="$arch" TERMUX_BUILD_IGNORE_LOCK=true ./build-package.sh \
					${TERMUX_INSTALL_DEPS+-i} \
					${TERMUX_DEBUG_BUILD+-d} ${TERMUX_OUTPUT_DIR+-o $TERMUX_OUTPUT_DIR} \
					"${PACKAGE_LIST[i]}"
			done
			exit
		fi

		# Check the package to build:
		TERMUX_PKG_NAME=$(basename "${PACKAGE_LIST[i]}")
		export TERMUX_PKG_BUILDER_DIR=
		if [[ ${PACKAGE_LIST[i]} == *"/"* ]]; then
			# Path to directory which may be outside this repo:
			if [ ! -d "${PACKAGE_LIST[i]}" ]; then termux_error_exit "'${PACKAGE_LIST[i]}' seems to be a path but is not a directory"; fi
			export TERMUX_PKG_BUILDER_DIR=$(realpath "${PACKAGE_LIST[i]}")
		else
			# Package name:
			for package_directory in $TERMUX_PACKAGES_DIRECTORIES; do
				if [ -d "${TERMUX_SCRIPTDIR}/${package_directory}/${TERMUX_PKG_NAME}" ]; then
					export TERMUX_PKG_BUILDER_DIR=${TERMUX_SCRIPTDIR}/$package_directory/$TERMUX_PKG_NAME
					break
				fi
			done
			if [ -z "${TERMUX_PKG_BUILDER_DIR}" ]; then
				termux_error_exit "No package $TERMUX_PKG_NAME found in any of the enabled repositories. Are you trying to set up a custom repository?"
			fi
		fi
		TERMUX_PKG_BUILDER_SCRIPT=$TERMUX_PKG_BUILDER_DIR/build.sh
		if test ! -f "$TERMUX_PKG_BUILDER_SCRIPT"; then
			termux_error_exit "No build.sh script at package dir $TERMUX_PKG_BUILDER_DIR!"
		fi

		TERMUX_PKG_BUILDER_ENCLOSING_DIR=$(dirname "$TERMUX_PKG_BUILDER_DIR")
		TERMUX_PKG_BUILDER_ENCLOSING_DIR=${TERMUX_PKG_BUILDER_ENCLOSING_DIR##*/}
		TERMUX_PKG_REPO_METADATA=""
		if [ "$TERMUX_PKG_BUILDER_ENCLOSING_DIR" != "packages" ]; then
			TERMUX_PKG_REPO_METADATA="$TERMUX_PKG_BUILDER_ENCLOSING_DIR"
		fi

		termux_step_setup_variables
		termux_step_handle_buildarch

		termux_step_cleanup_packages
		termux_step_start_build

		if [ "$TERMUX_CONTINUE_BUILD" == "false" ]; then
			termux_step_get_dependencies
			termux_step_override_config_scripts
		fi

		termux_step_create_timestamp_file

		if [ "$TERMUX_CONTINUE_BUILD" == "false" ]; then
			cd "$TERMUX_PKG_CACHEDIR"
			termux_step_get_source
			cd "$TERMUX_PKG_SRCDIR"
			termux_step_post_get_source
			termux_step_handle_host_build
		fi

		termux_step_setup_toolchain

		if [ "$TERMUX_CONTINUE_BUILD" == "false" ]; then
			termux_step_get_dependencies_python
			termux_step_patch_package
			termux_step_replace_guess_scripts
			cd "$TERMUX_PKG_SRCDIR"
			termux_step_pre_configure
		fi

		# Even on continued build we might need to setup paths
		# to tools so need to run part of configure step
		termux_run_base_and_multilib_build_step termux_step_configure

		if [ "$TERMUX_CONTINUE_BUILD" == "false" ]; then
			cd "$TERMUX_PKG_BUILDDIR"
			termux_step_post_configure
		fi
		termux_run_base_and_multilib_build_step termux_step_make
		termux_run_base_and_multilib_build_step termux_step_make_install
		cd "$TERMUX_PKG_BUILDDIR"
		termux_step_post_make_install
		termux_step_install_pacman_hooks
		termux_step_install_service_scripts
		termux_step_install_license
		cd "$TERMUX_PKG_MASSAGEDIR"
		termux_step_copy_into_massagedir
		cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX_CLASSICAL"
		termux_step_pre_massage
		cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX_CLASSICAL"
		termux_step_massage
		cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"
		termux_step_post_massage
		# At the final stage (when the package is archiving) it is better to use commands from the system
		if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
			export PATH="/usr/bin:$PATH"
		fi
		cd "$TERMUX_PKG_MASSAGEDIR"
		termux_step_create_debian_package
		termux_step_finish_build
	) 5< "$TERMUX_BUILD_LOCK_FILE"
done
