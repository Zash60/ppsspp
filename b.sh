#!/bin/bash
CMAKE=1

# Check arguments
while test $# -gt 0
do
	case "$1" in

		--no-png) CMAKE_ARGS="-DUSE_SYSTEM_LIBPNG=OFF ${CMAKE_ARGS}"
			;;
		--no-sdl2) CMAKE_ARGS="-DUSE_SYSTEM_LIBSDL2=OFF ${CMAKE_ARGS}"
			;;

		--android) CMAKE_ARGS="-DCMAKE_TOOLCHAIN_FILE=android/android.toolchain.cmake ${CMAKE_ARGS}"
			TARGET_OS=Android
			PACKAGE=1
			;;
		--simulator) echo "Simulator mode enabled"
			CMAKE_ARGS="-DSIMULATOR=ON ${CMAKE_ARGS}"
			;;
		--release)
			CMAKE_ARGS="-DCMAKE_BUILD_TYPE=Release ${CMAKE_ARGS}"
			;;
		--debug)
			CMAKE_ARGS="-DCMAKE_BUILD_TYPE=Debug ${CMAKE_ARGS}"
			;;
		--reldebug)
			CMAKE_ARGS="-DCMAKE_BUILD_TYPE=RelWithDebInfo ${CMAKE_ARGS}"
			;;
		--headless) echo "Headless mode enabled"
			CMAKE_ARGS="-DHEADLESS=ON ${CMAKE_ARGS}"
			;;
		--atlas-tool) echo "Atlas tool enabled"
			CMAKE_ARGS="-DATLAS_TOOL=ON ${CMAKE_ARGS}"
			;;


		--unittest) echo "Build unittest"
			CMAKE_ARGS="-DUNITTEST=ON ${CMAKE_ARGS}"
			;;
		--no-package) echo "Packaging disabled"
			PACKAGE=0
			;;
		--clang) echo "Clang enabled"
			export CC=/usr/bin/clang
			export CXX=/usr/bin/clang++
			;;
		--sanitize) echo "Enabling address-sanitizer if available"
			CMAKE_ARGS="-DUSE_ASAN=ON ${CMAKE_ARGS}"
			;;
		--sanitizeub) echo "Enabling ub-sanitizer if available"
			CMAKE_ARGS="-DUSE_UBSAN=ON ${CMAKE_ARGS}"
			;;
		--gold) echo "Gold build enabled"
			CMAKE_ARGS="-DGOLD=ON ${CMAKE_ARGS}"
			;;
		--alderlake) echo "Alderlake opt"
			CMAKE_ARGS="-DCMAKE_C_FLAGS=\"-march=alderlake\" -DCMAKE_CPP_FLAGS=\"-march=alderlake\""
			;;
		--no_mmap) echo "Disable mmap"
			CMAKE_ARGS="-DUSE_NO_MMAP=ON ${CMAKE_ARGS}"
			;;
   		--gles) echo "Using GLES/EGL"
                	CMAKE_ARGS="-DUSING_GLES2=ON -DUSING_EGL=ON ${CMAKE_ARGS}"
                	;;
		*) MAKE_OPT="$1 ${MAKE_OPT}"
			;;
	esac
	shift
done

	echo "Building for Android"
	BUILD_DIR="build-android"
	
	CORES_COUNT=4
	# Simplified core count logic for Android build environment
	# Assuming a fixed number of cores or using a default for simplicity
	# In a real Android NDK build, this is often handled by the build system.
	# Keeping a default for this script's purpose.

# Strict errors. Any non-zero return exits this script
set -e

echo Building with $CORES_COUNT threads

mkdir -p ${BUILD_DIR}
pushd ${BUILD_DIR}

cmake $CMAKE_ARGS ..
make -j$CORES_COUNT $MAKE_OPT
popd
