%define debug_package %{nil}
%global DATE 20140120
%global SVNREV 206854
%global gcc_version 4.8.3
# Note, gcc_release must be integer, if you want to add suffixes to
# %{release}, append them after %{gcc_release} on Release: line.
%global gcc_release 16
%global _unpackaged_files_terminate_build 0
%global _performance_build 1
%global multilib_64_archs sparc64 ppc64 ppc64p7 s390x x86_64
%ifarch %{ix86} x86_64 ia64 ppc ppc64 ppc64p7 alpha
%global build_ada 1
%else
%global build_ada 0
%endif
%if 0%{?rhel} >= 7
%global build_java 0
%else
%global build_java 0
%endif
%ifarch %{ix86} x86_64 ppc ppc64 ppc64p7 s390 s390x %{arm}
%global build_go 1
%else
%global build_go 0
%endif
%ifarch %{ix86} x86_64 ia64
%global build_libquadmath 1
%else
%global build_libquadmath 0
%endif
%ifarch %{ix86} x86_64 ppc ppc64 ppc64p7
%global build_libasan 1
%else
%global build_libasan 0
%endif
%ifarch x86_64
%global build_libtsan 1
%else
%global build_libtsan 0
%endif
%ifarch %{ix86} x86_64 ppc ppc64 ppc64p7 s390 s390x %{arm}
%global build_libatomic 1
%else
%global build_libatomic 0
%endif
%ifarch %{ix86} x86_64 %{arm} alpha ppc ppc64 ppc64p7 s390 s390x
%global build_libitm 1
%else
%global build_libitm 0
%endif
%global build_cloog 1
%ifarch %{ix86} x86_64 ppc ppc64 ppc64p7 s390 s390x %{arm} aarch64
%global attr_ifunc 1
%else
%global attr_ifunc 0
%endif
%ifarch s390x
%global multilib_32_arch s390
%endif
%ifarch sparc64
%global multilib_32_arch sparcv9
%endif
%ifarch ppc64 ppc64p7
%global multilib_32_arch ppc
%endif
%ifarch x86_64
%global multilib_32_arch i686
%endif
Summary: GNU Compiler Collection 4.8
Name: gcc48
Version: 4.8.2
Release: %{gcc_release}.el6
# libgcc, libgfortran, libmudflap, libgomp, libstdc++ and crtstuff have
# GCC Runtime Exception.
License: GPLv3+ and GPLv3+ with exceptions and GPLv2+ with exceptions and LGPLv2+ and BSD
Group: Development/Languages
# The source for this package was pulled from upstream's vcs.  Use the
# following commands to generate the tarball:
# svn export svn://gcc.gnu.org/svn/gcc/branches/redhat/gcc-4_7-branch@%{SVNREV} gcc-%{version}-%{DATE}
# tar cf - gcc-%{version}-%{DATE} | bzip2 -9 > gcc-%{version}-%{DATE}.tar.bz2
Source0: gcc-%{version}-%{DATE}.tar.bz2
%global isl_version 0.11.1
Source1: ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-%{isl_version}.tar.bz2
%global cloog_version 0.18.0
Source2: ftp://gcc.gnu.org/pub/gcc/infrastructure/cloog-%{cloog_version}.tar.gz
URL: http://gcc.gnu.org
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
# Need binutils with -pie support >= 2.14.90.0.4-4
# Need binutils which can omit dot symbols and overlap .opd on ppc64 >= 2.15.91.0.2-4
# Need binutils which handle -msecure-plt on ppc >= 2.16.91.0.2-2
# Need binutils which support .weakref >= 2.16.91.0.3-1
# Need binutils which support --hash-style=gnu >= 2.17.50.0.2-7
# Need binutils which support mffgpr and mftgpr >= 2.17.50.0.2-8
# Need binutils which support --build-id >= 2.17.50.0.17-3
# Need binutils which support %gnu_unique_object >= 2.19.51.0.14
# Need binutils which support .cfi_sections >= 2.19.51.0.14-33
# Need binutils which support --no-add-needed >= 2.20.51.0.2-12
BuildRequires: binutils >= 2.20.51.0.2-12
# While gcc doesn't include statically linked binaries, during testing
# -static is used several times.
BuildRequires: glibc-static
BuildRequires: zlib-devel, gettext, dejagnu, bison, flex, sharutils
BuildRequires: texinfo, texinfo-tex, /usr/bin/pod2man
BuildRequires: systemtap-sdt-devel >= 1.3
%if %{build_go}
#Cannot find this amongst the official gcc-go or libgo deps
#BuildRequires: hostname
%endif
# For VTA guality testing
BuildRequires: gdb
# Make sure pthread.h doesn't contain __thread tokens
# Make sure glibc supports stack protector
# Make sure glibc supports DT_GNU_HASH
BuildRequires: glibc-devel >= 2.4.90-13
BuildRequires: elfutils-devel >= 0.147
BuildRequires: elfutils-libelf-devel >= 0.147
%ifarch ppc ppc64 ppc64p7 s390 s390x sparc sparcv9 alpha
# Make sure glibc supports TFmode long double
BuildRequires: glibc >= 2.3.90-35
%endif
%ifarch %{multilib_64_archs} sparcv9 ppc
# Ensure glibc{,-devel} is installed for both multilib arches
BuildRequires: /lib/libc.so.6 /usr/lib/libc.so /lib64/libc.so.6 /usr/lib64/libc.so
%endif
%if %{build_ada}
# Ada requires Ada to build
BuildRequires: gcc-gnat >= 3.1, libgnat >= 3.1
%endif
%ifarch ia64
BuildRequires: libunwind >= 0.98
%endif
Requires: cpp >= 4.4.7
# Need .eh_frame ld optimizations
# Need proper visibility support
# Need -pie support
# Need --as-needed/--no-as-needed support
# On ppc64, need omit dot symbols support and --non-overlapping-opd
# Need binutils that owns /usr/bin/c++filt
# Need binutils that support .weakref
# Need binutils that supports --hash-style=gnu
# Need binutils that support mffgpr/mftgpr
# Need binutils that support --build-id
# Need binutils that support %gnu_unique_object
# Need binutils that support .cfi_sections
# Need binutils that support --no-add-needed
Requires: binutils >= 2.20.51.0.2-12
# Make sure gdb will understand DW_FORM_strp
Conflicts: gdb < 5.1-2
Requires: glibc-devel >= 2.2.90-12
%ifarch ppc ppc64 ppc64p7 s390 s390x sparc sparcv9 alpha
# Make sure glibc supports TFmode long double
Requires: glibc >= 2.3.90-35
%endif
%if 0%{?fedora} >= 18 || 0%{?rhel} >= 7
%ifarch %{arm}
Requires: glibc >= 2.16
%endif
%endif
Requires: libgcc >= 4.4.7
Requires: libgomp >= 4.4.7
%if !%{build_ada}
Obsoletes: gcc48-gnat < %{version}-%{release}
Obsoletes: libgnat48 < %{version}-%{release}
%endif
Requires(post): /sbin/install-info
Requires(preun): /sbin/install-info
AutoReq: true
AutoProv: false
Provides: bundled(libiberty)
Obsoletes: gcc47

Patch0: gcc48-hack.patch
Patch1: gcc48-java-nomulti.patch
Patch2: gcc48-ppc32-retaddr.patch
Patch3: gcc48-rh330771.patch
Patch4: gcc48-i386-libgomp.patch
Patch5: gcc48-sparc-config-detection.patch
Patch6: gcc48-libgomp-omp_h-multilib.patch
Patch7: gcc48-libtool-no-rpath.patch
Patch8: gcc48-cloog-dl.patch
Patch9: gcc48-cloog-dl2.patch
Patch10: gcc48-pr38757.patch
Patch11: gcc48-libstdc++-docs.patch
Patch12: gcc48-no-add-needed.patch
Patch13: gcc48-pr56564.patch
Patch14: gcc48-pr56493.patch
Patch15: gcc48-color-auto.patch
Patch16: gcc48-pr28865.patch
Patch17: gcc48-libgo-p224.patch
Patch18: gcc48-pr60137.patch
Patch19: gcc48-pr60010.patch
Patch20: gcc48-pr60046.patch
Patch21: gcc48-pr57896.patch
Patch22: gcc48-pr60272.patch
Patch23: gcc48-pr60233.patch
Patch24: gcc48-pr60274.patch

Patch1000: fastjar-0.97-segfault.patch
Patch1001: fastjar-0.97-len1.patch
Patch1002: fastjar-0.97-filename0.patch
Patch1003: fastjar-CVE-2010-0831.patch
Patch1004: fastjar-man.patch
Patch1005: fastjar-0.97-aarch64-config.patch

Patch1100: isl-%{isl_version}-aarch64-config.patch

# On ARM EABI systems, we do want -gnueabi to be part of the
# target triple.
%ifnarch %{arm}
%global _gnu 7E
%endif
%ifarch sparcv9
%global gcc_target_platform sparc64-%{_vendor}-%{_target_os}%{?_gnu}
%endif
%ifarch ppc ppc64p7
%global gcc_target_platform ppc64-%{_vendor}-%{_target_os}%{?_gnu}
%endif
%ifnarch sparcv9 ppc ppc64p7
%global gcc_target_platform %{_target_platform}
%endif

%description
The gcc48 package contains the GNU Compiler Collection version 4.8.

%package c++
Summary: C++ support for GCC version 4.8
Group: Development/Languages
Requires: gcc48 = %{version}-%{release}
Requires: libstdc++48 = %{version}-%{release}
Requires: libstdc++48-devel = %{version}-%{release}
Obsoletes: gcc47-c++
Autoreq: true
AutoProv: true

%description c++
This package adds C++ support to the GNU Compiler Collection
version 4.8.   It includes support for most of the current C++ specification
and a lot of support for the upcoming C++ specification.

%package -n libstdc++48
Summary: GNU Standard C++ Library
Group: System Environment/Libraries
Requires: glibc >= 2.10.90-7
Obsoletes: libstdc++47
Autoreq: true
AutoProv: true

%description -n libstdc++48
The libstdc++48 package contains a rewritten standard compliant GCC Standard
C++ Library.

%package -n libstdc++48-devel
Summary: Header files and libraries for C++ development
Group: Development/Libraries
Requires: libstdc++48 = %{version}-%{release}, %{_prefix}/%{_lib}/libstdc++.so.6
Obsoletes: libstdc++47-devel
Autoreq: true
Autoprov: true

%description -n libstdc++48-devel
This is the GNU implementation of the standard C++ libraries.  This
package includes the header files and libraries needed for C++
development. This includes rewritten implementation of STL.

%package objc
Summary: Objective-C support for GCC
Group: Development/Languages
Requires: gcc48 = %{version}-%{release}
Requires: libobjc48 = %{version}-%{release}
Obsoletes: gcc47-objc
Autoreq: true
AutoProv: true

%description objc
gcc48-objc provides Objective-C support for the GCC.
Mainly used on systems running NeXTSTEP, Objective-C is an
object-oriented derivative of the C language.

%package objc++
Summary: Objective-C++ support for GCC
Group: Development/Languages
Requires: gcc48-c++ = %{version}-%{release}, gcc48-objc = %{version}-%{release}
Obsoletes: gcc47-objc++
Autoreq: true
AutoProv: true

%description objc++
gcc48-objc++ package provides Objective-C++ support for the GCC.

%package -n libobjc48
Summary: Objective-C runtime
Group: System Environment/Libraries
Obsoletes: libobjc47
Autoreq: true
AutoProv: true

%description -n libobjc48
This package contains Objective-C shared library which is needed to run
Objective-C dynamically linked programs.

%package gfortran
Summary: Fortran support for GCC 4.8
Group: Development/Languages
Requires: gcc48 = %{version}-%{release}
Requires: libgfortran48 = %{version}-%{release}
%if %{build_libquadmath}
Requires: libquadmath = %{version}-%{release}
Requires: libquadmath-devel = %{version}-%{release}
%endif
BuildRequires: gmp-devel >= 4.1.2-8, mpfr-devel >= 2.2.1, libmpc-devel >= 0.8.1
Obsoletes: gcc47-gfortran
Requires(post): /sbin/install-info
Requires(preun): /sbin/install-info
Autoreq: true
AutoProv: true

%description gfortran
The gcc48-gfortran package provides support for compiling Fortran
programs with the GNU Compiler Collection.

%package -n libgfortran48
Summary: Fortran runtime for GCC 4.8
Group: System Environment/Libraries
Obsoletes: libgfortran47
Autoreq: true
Autoprov: true
%if %{build_libquadmath}
Requires: libquadmath = %{version}-%{release}
%endif

%description -n libgfortran48
This package contains Fortran shared library which is needed to run
Fortran dynamically linked programs.

%package -n libgomp48
Summary: GCC 4.8 OpenMP v3.0 shared support library
Group: System Environment/Libraries
Obsoletes: libgomp47
Requires(post): /sbin/install-info
Requires(preun): /sbin/install-info

%description -n libgomp48
This package contains GCC 4.8 shared support library which is needed
for OpenMP v3.0 support.

%package -n libmudflap48
Summary: GCC 4.8 mudflap shared support library
Group: System Environment/Libraries
Obsoletes: libmudflap47

%description -n libmudflap48
This package contains GCC 4.8 shared support library which is needed
for mudflap support.

%package -n libmudflap48-devel
Summary: GCC 4.8 mudflap support
Group: Development/Libraries
Requires: libmudflap48 = %{version}-%{release}
Requires: gcc48 = %{version}-%{release}
Obsoletes: libmudflap47-devel

%description -n libmudflap48-devel
This package contains headers for building mudflap-instrumented programs.

To instrument a non-threaded program, add -fmudflap
option to GCC 4.8 and when linking add -lmudflap, for threaded programs
also add -fmudflapth and -lmudflapth.

%package -n libquadmath
Summary: GCC 4.8 __float128 shared support library
Group: System Environment/Libraries
Requires(post): /sbin/install-info
Requires(preun): /sbin/install-info

%description -n libquadmath
This package contains GCC 4.8 shared support library which is needed
for __float128 math support and for Fortran REAL*16 support.

%package -n libquadmath-devel
Summary: GCC 4.8 __float128 support
Group: Development/Libraries
Requires: libquadmath = %{version}-%{release}
Requires: gcc48 = %{version}-%{release}

%description -n libquadmath-devel
This package contains headers for building Fortran programs using
REAL*16 and programs using __float128 math.

%package -n libitm
Summary: The GNU Transactional Memory library
Group: System Environment/Libraries
Requires(post): /sbin/install-info
Requires(preun): /sbin/install-info

%description -n libitm
This package contains the GNU Transactional Memory library
which is a GCC transactional memory support runtime library.

%package -n libitm-devel
Summary: The GNU Transactional Memory support
Group: Development/Libraries
Requires: libitm = %{version}-%{release}
Requires: gcc48 = %{version}-%{release}

%description -n libitm-devel
This package contains headers and support files for the
GNU Transactional Memory library.

%package -n libatomic
Summary: The GNU Atomic library
Group: System Environment/Libraries
Requires(post): /sbin/install-info
Requires(preun): /sbin/install-info

%description -n libatomic
This package contains the GNU Atomic library
which is a GCC support runtime library for atomic operations not supported
by hardware.

%package -n libasan
Summary: The Address Sanitizer runtime library
Group: System Environment/Libraries
Requires(post): /sbin/install-info
Requires(preun): /sbin/install-info

%description -n libasan
This package contains the Address Sanitizer library
which is used for -fsanitize=address instrumented programs.

%package -n libtsan
Summary: The Thread Sanitizer runtime library
Group: System Environment/Libraries
Requires(post): /sbin/install-info
Requires(preun): /sbin/install-info

%description -n libtsan
This package contains the Thread Sanitizer library
which is used for -fsanitize=thread instrumented programs.

%package gnat
Summary: Ada 95 support for GCC 4.8
Group: Development/Languages
Requires: gcc48 = %{version}-%{release}
Requires: libgnat48 = %{version}-%{release}, libgnat48-devel = %{version}-%{release}
Obsoletes: gcc47-gnat
Requires(post): /sbin/install-info
Requires(preun): /sbin/install-info
Autoreq: true
AutoProv: true

%description gnat
GNAT is a GNU Ada 95 front-end to GCC 4.8. This package includes development tools,
the documents and Ada 95 compiler.

%package -n libgnat48
Summary: GNU Ada 95 runtime shared libraries
Group: System Environment/Libraries
Obsoletes: libgnat47
Autoreq: true
AutoProv: true

%description -n libgnat48
GNAT is a GNU Ada 95 front-end to GCC 4.8. This package includes shared libraries,
which are required to run programs compiled with the GNAT.

%package -n libgnat48-devel
Summary: GNU Ada 95 libraries
Group: Development/Languages
Obsoletes: libgnat47-devel
Autoreq: true
AutoProv: true

%description -n libgnat48-devel
GNAT is a GNU Ada 95 front-end to GCC 4.8. This package includes libraries,
which are required to compile with the GNAT.

%package go
Summary: Go support
Group: Development/Languages
Requires: gcc48 = %{version}-%{release}
Requires: libgo48 = %{version}-%{release}
Requires: libgo48-devel = %{version}-%{release}
Obsoletes: gcc47-go
Requires(post): /sbin/install-info
Requires(preun): /sbin/install-info
Autoreq: true
AutoProv: true

%description go
The gcc48-go package provides support for compiling Go programs
with the GNU Compiler Collection.

%package -n libgo48
Summary: Go runtime
Group: System Environment/Libraries
Obsoletes: libgo47
Autoreq: true
AutoProv: true

%description -n libgo48
This package contains Go shared library which is needed to run
Go dynamically linked programs.

%package -n libgo48-devel
Summary: Go development libraries
Group: Development/Languages
Requires: libgo48 = %{version}-%{release}
Obsoletes: libgo47-devel
Autoreq: true
AutoProv: true

%description -n libgo48-devel
This package includes libraries and support files for compiling
Go programs.

%package plugin-devel
Summary: Support for compiling GCC 4.8 plugins
Group: Development/Languages
Requires: gcc48 = %{version}-%{release}
Requires: gmp-devel >= 4.1.2-8, mpfr-devel >= 2.2.1, libmpc-devel >= 0.8.1
Obsoletes: gcc47-plugin-devel

%description plugin-devel
This package contains header files and other support files
for compiling GCC 4.8 plugins.  The GCC 4.8 plugin ABI is currently
not stable, so plugins must be rebuilt any time GCC is updated.

%prep
%setup -q -n gcc-%{version}-%{DATE} -a 1 -a 2
%patch0 -p0 -b .hack~
%patch1 -p0 -b .java-nomulti~
%patch2 -p0 -b .ppc32-retaddr~
%patch3 -p0 -b .rh330771~
%patch4 -p0 -b .i386-libgomp~
%patch5 -p0 -b .sparc-config-detection~
%patch6 -p0 -b .libgomp-omp_h-multilib~
%patch7 -p0 -b .libtool-no-rpath~
%if %{build_cloog}
%patch8 -p0 -b .cloog-dl~
%patch9 -p0 -b .cloog-dl2~
%endif
%patch10 -p0 -b .pr38757~
#%patch11 -p0 -b .libstdc++-docs~
%patch12 -p0 -b .no-add-needed~
%patch13 -p0 -b .pr56564~
%patch14 -p0 -b .pr56493~
%if 0%{?fedora} >= 20 || 0%{?rhel} >= 7
%patch15 -p0 -b .color-auto~
%endif
%patch16 -p0 -b .pr28865~
%patch17 -p0 -b .libgo-p224~
rm -f libgo/go/crypto/elliptic/p224{,_test}.go
%patch18 -p0 -b .pr60137~
%patch19 -p0 -b .pr60010~
%patch20 -p0 -b .pr60046~
%patch21 -p0 -b .pr57896~
%patch22 -p0 -b .pr60272~
%patch23 -p0 -b .pr60233~
%patch24 -p0 -b .pr60274~

# This testcase doesn't compile.
rm libjava/testsuite/libjava.lang/PR35020*

#%patch1000 -p0 -b .fastjar-0.97-segfault~
#%patch1001 -p0 -b .fastjar-0.97-len1~
#%patch1002 -p0 -b .fastjar-0.97-filename0~
#%patch1003 -p0 -b .fastjar-CVE-2010-0831~
#%patch1004 -p0 -b .fastjar-man~
#%patch1005 -p0 -b .fastjar-0.97-aarch64-config~

%patch1100 -p0 -b .isl-aarch64~

#sed -i -e 's/4\.8\.3/4.8.2/' gcc/BASE-VER
echo 'Red Hat %{version}-%{gcc_release}' > gcc/DEV-PHASE

%if 0%{?fedora} >= 16 || 0%{?rhel} >= 7
# Default to -gdwarf-4 -fno-debug-types-section rather than -gdwarf-2
sed -i '/UInteger Var(dwarf_version)/s/Init(2)/Init(4)/' gcc/common.opt
sed -i '/flag_debug_types_section/s/Init(1)/Init(0)/' gcc/common.opt
sed -i '/dwarf_record_gcc_switches/s/Init(0)/Init(1)/' gcc/common.opt
sed -i 's/\(may be either 2, 3 or 4; the default version is \)2\./\14./' gcc/doc/invoke.texi
%else
# Default to -gdwarf-3 rather than -gdwarf-2
sed -i '/UInteger Var(dwarf_version)/s/Init(2)/Init(3)/' gcc/common.opt
sed -i 's/\(may be either 2, 3 or 4; the default version is \)2\./\13./' gcc/doc/invoke.texi
sed -i 's/#define[[:blank:]]*EMIT_ENTRY_VALUE[[:blank:]].*$/#define EMIT_ENTRY_VALUE 0/' gcc/{var-tracking,dwarf2out}.c
sed -i 's/#define[[:blank:]]*EMIT_TYPED_DWARF_STACK[[:blank:]].*$/#define EMIT_TYPED_DWARF_STACK 0/' gcc/dwarf2out.c
sed -i 's/#define[[:blank:]]*EMIT_DEBUG_MACRO[[:blank:]].*$/#define EMIT_DEBUG_MACRO 0/' gcc/dwarf2out.c
%endif

cp -a libstdc++-v3/config/cpu/i{4,3}86/atomicity.h

./contrib/gcc_update --touch

LC_ALL=C sed -i -e 's/\xa0/ /' gcc/doc/options.texi

%ifarch ppc
if [ -d libstdc++-v3/config/abi/post/powerpc64-linux-gnu ]; then
  mkdir -p libstdc++-v3/config/abi/post/powerpc64-linux-gnu/64
  mv libstdc++-v3/config/abi/post/powerpc64-linux-gnu/{,64/}baseline_symbols.txt
  mv libstdc++-v3/config/abi/post/powerpc64-linux-gnu/{32/,}baseline_symbols.txt
  rm -rf libstdc++-v3/config/abi/post/powerpc64-linux-gnu/32
fi
%endif
%ifarch sparc
if [ -d libstdc++-v3/config/abi/post/sparc64-linux-gnu ]; then
  mkdir -p libstdc++-v3/config/abi/post/sparc64-linux-gnu/64
  mv libstdc++-v3/config/abi/post/sparc64-linux-gnu/{,64/}baseline_symbols.txt
  mv libstdc++-v3/config/abi/post/sparc64-linux-gnu/{32/,}baseline_symbols.txt
  rm -rf libstdc++-v3/config/abi/post/sparc64-linux-gnu/32
fi
%endif

# This test causes fork failures, because it spawns way too many threads
rm -f gcc/testsuite/go.test/test/chan/goroutines.go

%build

# Undo the broken autoconf change in recent Fedora versions
export CONFIG_SITE=NONE

rm -fr obj-%{gcc_target_platform}
mkdir obj-%{gcc_target_platform}
cd obj-%{gcc_target_platform}

%if %{build_cloog}
mkdir isl-build isl-install
%ifarch s390 s390x
ISL_FLAG_PIC=-fPIC
%else
ISL_FLAG_PIC=-fpic
%endif
cd isl-build
../../isl-%{isl_version}/configure --disable-shared \
  CC=/usr/bin/gcc CXX=/usr/bin/g++ \
  CFLAGS="${CFLAGS:-%optflags} $ISL_FLAG_PIC" --prefix=`cd ..; pwd`/isl-install
make %{?_smp_mflags}
make install
cd ..

mkdir cloog-build cloog-install
cd cloog-build
cat >> ../../cloog-%{cloog_version}/source/isl/constraints.c << \EOF
#include <isl/flow.h>
static void __attribute__((used)) *s1 = (void *) isl_union_map_compute_flow;
static void __attribute__((used)) *s2 = (void *) isl_map_dump;
EOF
sed -i 's|libcloog|libgcc48privatecloog|g' \
  ../../cloog-%{cloog_version}/{,test/}Makefile.{am,in}
isl_prefix=`cd ../isl-install; pwd` \
../../cloog-%{cloog_version}/configure --with-isl=system \
  --with-isl-prefix=`cd ../isl-install; pwd` \
  CC=/usr/bin/gcc CXX=/usr/bin/g++ \
  CFLAGS="${CFLAGS:-%optflags}" CXXFLAGS="${CXXFLAGS:-%optflags}" \
   --prefix=`cd ..; pwd`/cloog-install
sed -i 's|^hardcode_libdir_flag_spec=.*|hardcode_libdir_flag_spec=""|g' libtool
sed -i 's|^runpath_var=LD_RUN_PATH|runpath_var=DIE_RPATH_DIE|g' libtool
make %{?_smp_mflags}
make %{?_smp_mflags} install
cd ../cloog-install/lib
rm libgcc48privatecloog-isl.so{,.4}
mv libgcc48privatecloog-isl.so.4.0.0 libcloog-isl.so.4
ln -sf libcloog-isl.so.4 libcloog-isl.so
ln -sf libcloog-isl.so.4 libcloog.so
cd ../..
%endif

CC=gcc
OPT_FLAGS=`echo %{optflags}|sed -e 's/\(-Wp,\)\?-D_FORTIFY_SOURCE=[12]//g'`
OPT_FLAGS=`echo $OPT_FLAGS|sed -e 's/-m64//g;s/-m32//g;s/-m31//g'`
OPT_FLAGS=`echo $OPT_FLAGS|sed -e 's/-mfpmath=sse/-mfpmath=sse -msse2/g'`
OPT_FLAGS=`echo $OPT_FLAGS|sed -e 's/ -pipe / /g'`
%ifarch sparc
OPT_FLAGS=`echo $OPT_FLAGS|sed -e 's/-mcpu=ultrasparc/-mtune=ultrasparc/g;s/-mcpu=v[78]//g'`
%endif
%ifarch %{ix86}
OPT_FLAGS=`echo $OPT_FLAGS|sed -e 's/-march=i.86//g'`
%endif
%ifarch sparc64
cat > gcc64 <<"EOF"
#!/bin/sh
exec /usr/bin/gcc -m64 "$@"
EOF
chmod +x gcc64
CC=`pwd`/gcc64
%endif
%ifarch ppc64 ppc64p7
if gcc -m64 -xc -S /dev/null -o - > /dev/null 2>&1; then
  cat > gcc64 <<"EOF"
#!/bin/sh
exec /usr/bin/gcc -m64 "$@"
EOF
  chmod +x gcc64
  CC=`pwd`/gcc64
fi
%endif
OPT_FLAGS=`echo "$OPT_FLAGS" | sed -e 's/[[:blank:]]\+/ /g'`
case "$OPT_FLAGS" in
  *-fasynchronous-unwind-tables*)
    sed -i -e 's/-fno-exceptions /-fno-exceptions -fno-asynchronous-unwind-tables/' \
      ../gcc/Makefile.in
    ;;
esac
enablelgo=
enablelada=
%if %{build_ada}
enablelada=,ada
%endif
%if %{build_go}
enablelgo=,go
%endif
CC="$CC" CFLAGS="$OPT_FLAGS" \
	CXXFLAGS="`echo " $OPT_FLAGS " | sed 's/ -Wall / /g;s/ -fexceptions / /g' \
		  | sed 's/ -Werror=format-security / -Wformat -Werror=format-security /'`" \
	XCFLAGS="$OPT_FLAGS" TCFLAGS="$OPT_FLAGS" GCJFLAGS="$OPT_FLAGS" \
	../configure --prefix=%{_prefix} --mandir=%{_mandir} --infodir=%{_infodir} \
	--with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap \
	--enable-shared --enable-threads=posix --enable-checking=release \
	--with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions \
	--enable-gnu-unique-object --enable-linker-build-id --with-linker-hash-style=gnu \
	--enable-languages=c,c++,objc,obj-c++,fortran${enablelada}${enablelgo} \
	--enable-plugin --enable-initfini-array \
	--disable-libgcj \
%if %{build_cloog}
	--with-isl=`pwd`/isl-install --with-cloog=`pwd`/cloog-install \
%else
	--without-isl --without-cloog \
%endif
%if 0%{?fedora} >= 21 || 0%{?rhel} >= 7
%if %{attr_ifunc}
	--enable-gnu-indirect-function \
%endif
%endif
%ifarch %{arm}
	--disable-sjlj-exceptions \
%endif
%ifarch ppc ppc64 ppc64p7
	--enable-secureplt \
%endif
%ifarch sparc sparcv9 sparc64 ppc ppc64 ppc64p7 s390 s390x alpha
	--with-long-double-128 \
%endif
%ifarch sparc
	--disable-linux-futex \
%endif
%ifarch sparc64
	--with-cpu=ultrasparc \
%endif
%ifarch sparc sparcv9
	--host=%{gcc_target_platform} --build=%{gcc_target_platform} --target=%{gcc_target_platform} --with-cpu=v7
%endif
%ifarch ppc ppc64 ppc64p7
%if 0%{?rhel} >= 7
	--with-cpu-32=power7 --with-tune-32=power7 --with-cpu-64=power7 --with-tune-64=power7 \
%endif
%if 0%{?rhel} == 6
	--with-cpu-32=power4 --with-tune-32=power6 --with-cpu-64=power4 --with-tune-64=power6 \
%endif
%endif
%ifarch ppc
	--build=%{gcc_target_platform} --target=%{gcc_target_platform} --with-cpu=default32
%endif
%ifarch %{ix86} x86_64
	--with-tune=generic \
%endif
%if 0%{?rhel} >= 7
%ifarch %{ix86}
	--with-arch=x86-64 \
%endif
%ifarch x86_64
	--with-arch_32=x86-64 \
%endif
%else
%ifarch %{ix86}
	--with-arch=i686 \
%endif
%ifarch x86_64
	--with-arch_32=i686 \
%endif
%endif
%ifarch s390 s390x
%if 0%{?rhel} >= 7
	--with-arch=z196 --with-tune=zEC12 --enable-decimal-float \
%else
	--with-arch=z9-109 --with-tune=z10 --enable-decimal-float \
%endif
%endif
%ifarch armv7hl
	--with-cpu=cortex-a8 --with-tune=cortex-a8 --with-arch=armv7-a \
	--with-float=hard --with-fpu=vfpv3-d16 --with-abi=aapcs-linux \
%endif
%ifnarch sparc sparcv9 ppc
	--build=%{gcc_target_platform}
%endif

%ifarch %{arm} sparc sparcv9 sparc64
GCJFLAGS="$OPT_FLAGS" make %{?_smp_mflags} BOOT_CFLAGS="$OPT_FLAGS" bootstrap
%else
GCJFLAGS="$OPT_FLAGS" make %{?_smp_mflags} BOOT_CFLAGS="$OPT_FLAGS" profiledbootstrap
%endif

%if %{build_cloog}
cp -a cloog-install/lib/libcloog-isl.so.4 gcc/
%endif

# Make generated man pages even if Pod::Man is not new enough
perl -pi -e 's/head3/head2/' ../contrib/texi2pod.pl
for i in ../gcc/doc/*.texi; do
  cp -a $i $i.orig; sed 's/ftable/table/' $i.orig > $i
done
make -C gcc generated-manpages
for i in ../gcc/doc/*.texi; do mv -f $i.orig $i; done

# Copy various doc files here and there
cd ..
mkdir -p rpm.doc/gfortran rpm.doc/objc
mkdir -p rpm.doc/go rpm.doc/libgo rpm.doc/libquadmath rpm.doc/libitm
mkdir -p rpm.doc/changelogs/{gcc/cp,gcc/ada,libstdc++-v3,libobjc,libmudflap,libgomp,libatomic,libsanitizer}

for i in {gcc,gcc/cp,gcc/ada,libstdc++-v3,libobjc,libmudflap,libgomp,libatomic,libsanitizer}/ChangeLog*; do
	cp -p $i rpm.doc/changelogs/$i
done

(cd gcc/fortran; for i in ChangeLog*; do
	cp -p $i ../../rpm.doc/gfortran/$i
done)
(cd libgfortran; for i in ChangeLog*; do
	cp -p $i ../rpm.doc/gfortran/$i.libgfortran
done)
(cd libobjc; for i in README*; do
	cp -p $i ../rpm.doc/objc/$i.libobjc
done)
%if %{build_libquadmath}
(cd libquadmath; for i in ChangeLog* COPYING.LIB; do
	cp -p $i ../rpm.doc/libquadmath/$i.libquadmath
done)
%endif
%if %{build_libitm}
(cd libitm; for i in ChangeLog*; do
	cp -p $i ../rpm.doc/libitm/$i.libitm
done)
%endif
%if %{build_go}
(cd gcc/go; for i in README* ChangeLog*; do
	cp -p $i ../../rpm.doc/go/$i
done)
(cd libgo; for i in LICENSE* PATENTS* README; do
	cp -p $i ../rpm.doc/libgo/$i.libgo
done)
%endif

rm -f rpm.doc/changelogs/gcc/ChangeLog.[1-9]
find rpm.doc -name \*ChangeLog\* | xargs bzip2 -9

%install
rm -fr %{buildroot}

perl -pi -e \
  's~href="l(ibstdc|atest)~href="http://gcc.gnu.org/onlinedocs/libstdc++/l\1~' \
  libstdc++-v3/doc/html/api.html

cd obj-%{gcc_target_platform}

TARGET_PLATFORM=%{gcc_target_platform}

# There are some MP bugs in libstdc++ Makefiles
make -C %{gcc_target_platform}/libstdc++-v3

make prefix=%{buildroot}%{_prefix} mandir=%{buildroot}%{_mandir} \
  infodir=%{buildroot}%{_infodir} install
%if %{build_ada}
chmod 644 %{buildroot}%{_infodir}/gnat*
%endif

FULLPATH=%{buildroot}%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
FULLEPATH=%{buildroot}%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}

%if %{build_cloog}
cp -a cloog-install/lib/libcloog-isl.so.4 $FULLPATH/
%endif

# fix some things
ln -sf gcc %{buildroot}%{_prefix}/bin/cc
rm -f %{buildroot}%{_prefix}/lib/cpp
ln -sf ../bin/cpp %{buildroot}/%{_prefix}/lib/cpp
ln -sf gfortran %{buildroot}%{_prefix}/bin/f95
rm -f %{buildroot}%{_infodir}/dir
gzip -9 %{buildroot}%{_infodir}/*.info*
#in anticipation of the rename of gnatgcc to gnatgcc48 this symlink needs to resolve NOW
ln -sf gcc48 %{buildroot}%{_prefix}/bin/gnatgcc

cxxconfig="`find %{gcc_target_platform}/libstdc++-v3/include -name c++config.h`"
for i in `find %{gcc_target_platform}/[36]*/libstdc++-v3/include -name c++config.h 2>/dev/null`; do
  if ! diff -up $cxxconfig $i; then
    cat > %{buildroot}%{_prefix}/include/c++/%{gcc_version}/%{gcc_target_platform}/bits/c++config.h <<EOF
#ifndef _CPP_CPPCONFIG_WRAPPER
#define _CPP_CPPCONFIG_WRAPPER 1
#include <bits/wordsize.h>
#if __WORDSIZE == 32
%ifarch %{multilib_64_archs}
`cat $(find %{gcc_target_platform}/32/libstdc++-v3/include -name c++config.h)`
%else
`cat $(find %{gcc_target_platform}/libstdc++-v3/include -name c++config.h)`
%endif
#else
%ifarch %{multilib_64_archs}
`cat $(find %{gcc_target_platform}/libstdc++-v3/include -name c++config.h)`
%else
`cat $(find %{gcc_target_platform}/64/libstdc++-v3/include -name c++config.h)`
%endif
#endif
#endif
EOF
    break
  fi
done

for f in `find %{buildroot}%{_prefix}/include/c++/%{gcc_version}/%{gcc_target_platform}/ -name c++config.h`; do
  for i in 1 2 4 8; do
    sed -i -e 's/#define _GLIBCXX_ATOMIC_BUILTINS_'$i' 1/#ifdef __GCC_HAVE_SYNC_COMPARE_AND_SWAP_'$i'\
&\
#endif/' $f
  done
done

# Nuke bits/*.h.gch dirs
# 1) there is no bits/*.h header installed, so when gch file can't be
#    used, compilation fails
# 2) sometimes it is hard to match the exact options used for building
#    libstdc++-v3 or they aren't desirable
# 3) there are multilib issues, conflicts etc. with this
# 4) it is huge
# People can always precompile on their own whatever they want, but
# shipping this for everybody is unnecessary.
rm -rf %{buildroot}%{_prefix}/include/c++/%{gcc_version}/%{gcc_target_platform}/bits/*.h.gch

%ifarch sparcv9 sparc64
ln -f %{buildroot}%{_prefix}/bin/%{gcc_target_platform}-gcc \
  %{buildroot}%{_prefix}/bin/sparc-%{_vendor}-%{_target_os}%{?_gnu}-gcc
%endif
%ifarch ppc ppc64 ppc64p7
ln -f %{buildroot}%{_prefix}/bin/%{gcc_target_platform}-gcc \
  %{buildroot}%{_prefix}/bin/ppc-%{_vendor}-%{_target_os}%{?_gnu}-gcc
%endif

%ifarch sparcv9 ppc
FULLLPATH=$FULLPATH/lib32
%endif
%ifarch sparc64 ppc64 ppc64p7
FULLLPATH=$FULLPATH/lib64
%endif
if [ -n "$FULLLPATH" ]; then
  mkdir -p $FULLLPATH
else
  FULLLPATH=$FULLPATH
fi

find %{buildroot} -name \*.la | xargs rm -f

mv %{buildroot}%{_prefix}/%{_lib}/libgfortran.spec $FULLPATH/
%if %{build_libitm}
mv %{buildroot}%{_prefix}/%{_lib}/libitm.spec $FULLPATH/
%endif

mkdir -p %{buildroot}/%{_lib}
mv -f %{buildroot}%{_prefix}/%{_lib}/libgcc_s.so.1 %{buildroot}/%{_lib}/libgcc_s-%{gcc_version}-%{DATE}.so.1
chmod 755 %{buildroot}/%{_lib}/libgcc_s-%{gcc_version}-%{DATE}.so.1
ln -sf libgcc_s-%{gcc_version}-%{DATE}.so.1 %{buildroot}/%{_lib}/libgcc_s.so.1
ln -sf /%{_lib}/libgcc_s.so.1 $FULLPATH/libgcc_s.so
%ifarch sparcv9 ppc
ln -sf /lib64/libgcc_s.so.1 $FULLPATH/64/libgcc_s.so
%endif
%ifarch %{multilib_64_archs}
ln -sf /lib/libgcc_s.so.1 $FULLPATH/32/libgcc_s.so
%endif
%ifarch ppc
rm -f $FULLPATH/libgcc_s.so
echo '/* GNU ld script
   Use the shared library, but some functions are only in
   the static library, so try that secondarily.  */
OUTPUT_FORMAT(elf32-powerpc)
GROUP ( /lib/libgcc_s.so.1 libgcc.a )' > $FULLPATH/libgcc_s.so
%endif
%ifarch ppc64 ppc64p7
rm -f $FULLPATH/32/libgcc_s.so
echo '/* GNU ld script
   Use the shared library, but some functions are only in
   the static library, so try that secondarily.  */
OUTPUT_FORMAT(elf32-powerpc)
GROUP ( /lib/libgcc_s.so.1 libgcc.a )' > $FULLPATH/32/libgcc_s.so
%endif
%ifarch %{arm}
rm -f $FULLPATH/libgcc_s.so
echo '/* GNU ld script
   Use the shared library, but some functions are only in
   the static library, so try that secondarily.  */
OUTPUT_FORMAT(elf32-littlearm)
GROUP ( /lib/libgcc_s.so.1 libgcc.a )' > $FULLPATH/libgcc_s.so
%endif

mv -f %{buildroot}%{_prefix}/%{_lib}/libgomp.spec $FULLPATH/

%if %{build_ada}
mv -f $FULLPATH/adalib/libgnarl-*.so %{buildroot}%{_prefix}/%{_lib}/
mv -f $FULLPATH/adalib/libgnat-*.so %{buildroot}%{_prefix}/%{_lib}/
rm -f $FULLPATH/adalib/libgnarl.so* $FULLPATH/adalib/libgnat.so*
%endif

mkdir -p %{buildroot}%{_prefix}/libexec/getconf
if gcc/xgcc -B gcc/ -E -dD -xc /dev/null | grep __LONG_MAX__.*2147483647; then
  ln -sf POSIX_V6_ILP32_OFF32 %{buildroot}%{_prefix}/libexec/getconf/default
else
  ln -sf POSIX_V6_LP64_OFF64 %{buildroot}%{_prefix}/libexec/getconf/default
fi

mkdir -p %{buildroot}%{_datadir}/gdb/auto-load/%{_prefix}/%{_lib}
mv -f %{buildroot}%{_prefix}/%{_lib}/libstdc++*gdb.py* \
      %{buildroot}%{_datadir}/gdb/auto-load/%{_prefix}/%{_lib}/
pushd ../libstdc++-v3/python
for i in `find . -name \*.py`; do
  touch -r $i %{buildroot}%{_prefix}/share/gcc-%{gcc_version}/python/$i
done
touch -r hook.in %{buildroot}%{_datadir}/gdb/auto-load/%{_prefix}/%{_lib}/libstdc++*gdb.py
popd

pushd $FULLPATH
if [ "%{_lib}" = "lib" ]; then
ln -sf ../../../libobjc.so.4 libobjc.so
ln -sf ../../../libstdc++.so.6.*[0-9] libstdc++.so
#even though libgfortran has an updated A(P/B)I for gcc48 the .so versioning did not increment; idiots
mv ../../../libgfortran.so.3.0.0 ../../../libgfortran.so.4.0.0
ln -sf ../../../libgfortran.so.4.* ln -sf ../../../libgfortran.so.4
ln -sf ../../../libgfortran.so.3.* libgfortran.so
ln -sf ../../../libgomp.so.1.* libgomp.so
ln -sf ../../../libmudflap.so.0.* libmudflap.so
ln -sf ../../../libmudflapth.so.0.* libmudflapth.so
%if %{build_go}
ln -sf ../../../libgo.so.4.* libgo.so
%endif
%if %{build_libquadmath}
ln -sf ../../../libquadmath.so.0.* libquadmath.so
%endif
%if %{build_libitm}
ln -sf ../../../libitm.so.1.* libitm.so
%endif
%if %{build_libatomic}
ln -sf ../../../libatomic.so.1.* libatomic.so
%endif
%if %{build_libasan}
ln -sf ../../../libasan.so.0.* libasan.so
mv ../../../libasan_preinit.o libasan_preinit.o
%endif
else
ln -sf ../../../../%{_lib}/libobjc.so.4 libobjc.so
ln -sf ../../../../%{_lib}/libstdc++.so.6.*[0-9] libstdc++.so
#even though libgfortran has an updated A(P/B)I for gcc48 the .so versioning did not increment; idiots
mv ../../../../%{_lib}/libgfortran.so.3.0.0 ../../../../%{_lib}/libgfortran.so.4.0.0
ln -sf ../../../../%{_lib}/libgfortran.so.4.* ../../../../%{_lib}/libgfortran.so.4
ln -sf ../../../../%{_lib}/libgfortran.so.4.* libgfortran.so
ln -sf ../../../../%{_lib}/libgomp.so.1.* libgomp.so
ln -sf ../../../../%{_lib}/libmudflap.so.0.* libmudflap.so
ln -sf ../../../../%{_lib}/libmudflapth.so.0.* libmudflapth.so
%if %{build_go}
ln -sf ../../../../%{_lib}/libgo.so.4.* libgo.so
%endif
%if %{build_libquadmath}
ln -sf ../../../../%{_lib}/libquadmath.so.0.* libquadmath.so
%endif
%if %{build_libitm}
ln -sf ../../../../%{_lib}/libitm.so.1.* libitm.so
%endif
%if %{build_libatomic}
ln -sf ../../../../%{_lib}/libatomic.so.1.* libatomic.so
%endif
%if %{build_libasan}
ln -sf ../../../../%{_lib}/libasan.so.0.* libasan.so
mv ../../../../%{_lib}/libasan_preinit.o libasan_preinit.o
%endif
%if %{build_libtsan}
rm -f libtsan.so
echo 'INPUT ( %{_prefix}/%{_lib}/'`echo ../../../../%{_lib}/libtsan.so.0.* | sed 's,^.*libt,libt,'`' )' > libtsan.so
%endif
fi
mv -f %{buildroot}%{_prefix}/%{_lib}/libstdc++.*a $FULLLPATH/
mv -f %{buildroot}%{_prefix}/%{_lib}/libsupc++.*a $FULLLPATH/
mv -f %{buildroot}%{_prefix}/%{_lib}/libgfortran.*a $FULLLPATH/
mv -f %{buildroot}%{_prefix}/%{_lib}/libobjc.*a .
mv -f %{buildroot}%{_prefix}/%{_lib}/libgomp.*a .
mv -f %{buildroot}%{_prefix}/%{_lib}/libmudflap{,th}.*a $FULLLPATH/
%if %{build_libquadmath}
mv -f %{buildroot}%{_prefix}/%{_lib}/libquadmath.*a $FULLLPATH/
%endif
%if %{build_libitm}
mv -f %{buildroot}%{_prefix}/%{_lib}/libitm.*a $FULLLPATH/
%endif
%if %{build_libatomic}
mv -f %{buildroot}%{_prefix}/%{_lib}/libatomic.*a $FULLLPATH/
%endif
%if %{build_libasan}
mv -f %{buildroot}%{_prefix}/%{_lib}/libasan.*a $FULLLPATH/
%endif
%if %{build_libtsan}
mv -f %{buildroot}%{_prefix}/%{_lib}/libtsan.*a $FULLLPATH/
%endif
%if %{build_go}
mv -f %{buildroot}%{_prefix}/%{_lib}/libgo.*a $FULLLPATH/
mv -f %{buildroot}%{_prefix}/%{_lib}/libgobegin.*a $FULLLPATH/
%endif

%if %{build_ada}
%ifarch sparcv9 ppc
rm -rf $FULLPATH/64/ada{include,lib}
%endif
%ifarch %{multilib_64_archs}
rm -rf $FULLPATH/32/ada{include,lib}
%endif
if [ "$FULLPATH" != "$FULLLPATH" ]; then
mv -f $FULLPATH/ada{include,lib} $FULLLPATH/
pushd $FULLLPATH/adalib
if [ "%{_lib}" = "lib" ]; then
ln -sf ../../../../../libgnarl-*.so libgnarl.so
ln -sf ../../../../../libgnarl-*.so libgnarl-4.8.so
ln -sf ../../../../../libgnat-*.so libgnat.so
ln -sf ../../../../../libgnat-*.so libgnat-4.8.so
else
ln -sf ../../../../../../%{_lib}/libgnarl-*.so libgnarl.so
ln -sf ../../../../../../%{_lib}/libgnarl-*.so libgnarl-4.8.so
ln -sf ../../../../../../%{_lib}/libgnat-*.so libgnat.so
ln -sf ../../../../../../%{_lib}/libgnat-*.so libgnat-4.8.so
fi
popd
else
pushd $FULLPATH/adalib
if [ "%{_lib}" = "lib" ]; then
ln -sf ../../../../libgnarl-*.so libgnarl.so
ln -sf ../../../../libgnarl-*.so libgnarl-4.8.so
ln -sf ../../../../libgnat-*.so libgnat.so
ln -sf ../../../../libgnat-*.so libgnat-4.8.so
else
ln -sf ../../../../../%{_lib}/libgnarl-*.so libgnarl.so
ln -sf ../../../../../%{_lib}/libgnarl-*.so libgnarl-4.8.so
ln -sf ../../../../../%{_lib}/libgnat-*.so libgnat.so
ln -sf ../../../../../%{_lib}/libgnat-*.so libgnat-4.8.so
fi
popd
fi
%endif

%ifarch sparcv9 ppc
ln -sf ../../../../../lib64/libobjc.so.4 64/libobjc.so
ln -sf ../`echo ../../../../lib/libstdc++.so.6.*[0-9] | sed s~/lib/~/lib64/~` 64/libstdc++.so
ln -sf ../`echo ../../../../lib/libgfortran.so.4.* | sed s~/lib/~/lib64/~` 64/libgfortran.so
ln -sf ../`echo ../../../../lib/libgomp.so.1.* | sed s~/lib/~/lib64/~` 64/libgomp.so
rm -f libmudflap.so libmudflapth.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib/libmudflap.so.0.* | sed 's,^.*libm,libm,'`' )' > libmudflap.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib/libmudflapth.so.0.* | sed 's,^.*libm,libm,'`' )' > libmudflapth.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib/libmudflap.so.0.* | sed 's,^.*libm,libm,'`' )' > 64/libmudflap.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib/libmudflapth.so.0.* | sed 's,^.*libm,libm,'`' )' > 64/libmudflapth.so
%if %{build_go}
rm -f libgo.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib/libgo.so.4.* | sed 's,^.*libg,libg,'`' )' > libgo.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib/libgo.so.4.* | sed 's,^.*libg,libg,'`' )' > 64/libgo.so
%endif
%if %{build_libquadmath}
rm -f libquadmath.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib/libquadmath.so.0.* | sed 's,^.*libq,libq,'`' )' > libquadmath.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib/libquadmath.so.0.* | sed 's,^.*libq,libq,'`' )' > 64/libquadmath.so
%endif
%if %{build_libitm}
rm -f libitm.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib/libitm.so.1.* | sed 's,^.*libi,libi,'`' )' > libitm.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib/libitm.so.1.* | sed 's,^.*libi,libi,'`' )' > 64/libitm.so
%endif
%if %{build_libatomic}
rm -f libatomic.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib/libatomic.so.1.* | sed 's,^.*liba,liba,'`' )' > libatomic.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib/libatomic.so.1.* | sed 's,^.*liba,liba,'`' )' > 64/libatomic.so
%endif
%if %{build_libasan}
rm -f libasan.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib/libasan.so.0.* | sed 's,^.*liba,liba,'`' )' > libasan.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib/libasan.so.0.* | sed 's,^.*liba,liba,'`' )' > 64/libasan.so
mv ../../../../lib64/libasan_preinit.o 64/libasan_preinit.o
%endif
ln -sf lib32/libgfortran.a libgfortran.a
ln -sf ../lib64/libgfortran.a 64/libgfortran.a
mv -f %{buildroot}%{_prefix}/lib64/libobjc.*a 64/
mv -f %{buildroot}%{_prefix}/lib64/libgomp.*a 64/
ln -sf lib32/libstdc++.a libstdc++.a
ln -sf ../lib64/libstdc++.a 64/libstdc++.a
ln -sf lib32/libsupc++.a libsupc++.a
ln -sf ../lib64/libsupc++.a 64/libsupc++.a
ln -sf lib32/libmudflap.a libmudflap.a
ln -sf ../lib64/libmudflap.a 64/libmudflap.a
ln -sf lib32/libmudflapth.a libmudflapth.a
ln -sf ../lib64/libmudflapth.a 64/libmudflapth.a
%if %{build_libquadmath}
ln -sf lib32/libquadmath.a libquadmath.a
ln -sf ../lib64/libquadmath.a 64/libquadmath.a
%endif
%if %{build_libitm}
ln -sf lib32/libitm.a libitm.a
ln -sf ../lib64/libitm.a 64/libitm.a
%endif
%if %{build_libatomic}
ln -sf lib32/libatomic.a libatomic.a
ln -sf ../lib64/libatomic.a 64/libatomic.a
%endif
%if %{build_libasan}
ln -sf lib32/libasan.a libasan.a
ln -sf ../lib64/libasan.a 64/libasan.a
%endif
%if %{build_go}
ln -sf lib32/libgo.a libgo.a
ln -sf ../lib64/libgo.a 64/libgo.a
ln -sf lib32/libgobegin.a libgobegin.a
ln -sf ../lib64/libgobegin.a 64/libgobegin.a
%endif
%if %{build_ada}
ln -sf lib32/adainclude adainclude
ln -sf ../lib64/adainclude 64/adainclude
ln -sf lib32/adalib adalib
ln -sf ../lib64/adalib 64/adalib
%endif
%endif
%ifarch %{multilib_64_archs}
mkdir -p 32
ln -sf ../../../../libobjc.so.4 32/libobjc.so
ln -sf ../`echo ../../../../lib64/libstdc++.so.6.*[0-9] | sed s~/../lib64/~/~` 32/libstdc++.so
ln -sf ../`echo ../../../../lib64/libgfortran.so.4.* | sed s~/../lib64/~/~` 32/libgfortran.so
ln -sf ../`echo ../../../../lib64/libgomp.so.1.* | sed s~/../lib64/~/~` 32/libgomp.so
rm -f libmudflap.so libmudflapth.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib64/libmudflap.so.0.* | sed 's,^.*libm,libm,'`' )' > libmudflap.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib64/libmudflapth.so.0.* | sed 's,^.*libm,libm,'`' )' > libmudflapth.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib64/libmudflap.so.0.* | sed 's,^.*libm,libm,'`' )' > 32/libmudflap.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib64/libmudflapth.so.0.* | sed 's,^.*libm,libm,'`' )' > 32/libmudflapth.so
%if %{build_go}
rm -f libgo.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib64/libgo.so.4.* | sed 's,^.*libg,libg,'`' )' > libgo.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib64/libgo.so.4.* | sed 's,^.*libg,libg,'`' )' > 32/libgo.so
%endif
%if %{build_libquadmath}
rm -f libquadmath.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib64/libquadmath.so.0.* | sed 's,^.*libq,libq,'`' )' > libquadmath.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib64/libquadmath.so.0.* | sed 's,^.*libq,libq,'`' )' > 32/libquadmath.so
%endif
%if %{build_libitm}
rm -f libitm.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib64/libitm.so.1.* | sed 's,^.*libi,libi,'`' )' > libitm.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib64/libitm.so.1.* | sed 's,^.*libi,libi,'`' )' > 32/libitm.so
%endif
%if %{build_libatomic}
rm -f libatomic.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib64/libatomic.so.1.* | sed 's,^.*liba,liba,'`' )' > libatomic.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib64/libatomic.so.1.* | sed 's,^.*liba,liba,'`' )' > 32/libatomic.so
%endif
%if %{build_libasan}
rm -f libasan.so
echo 'INPUT ( %{_prefix}/lib64/'`echo ../../../../lib64/libasan.so.0.* | sed 's,^.*liba,liba,'`' )' > libasan.so
echo 'INPUT ( %{_prefix}/lib/'`echo ../../../../lib64/libasan.so.0.* | sed 's,^.*liba,liba,'`' )' > 32/libasan.so
mv ../../../../lib/libasan_preinit.o 32/libasan_preinit.o
%endif
mv -f %{buildroot}%{_prefix}/lib/libobjc.*a 32/
mv -f %{buildroot}%{_prefix}/lib/libgomp.*a 32/
%endif
%ifarch sparc64 ppc64 ppc64p7
ln -sf ../lib32/libgfortran.a 32/libgfortran.a
ln -sf lib64/libgfortran.a libgfortran.a
ln -sf ../lib32/libstdc++.a 32/libstdc++.a
ln -sf lib64/libstdc++.a libstdc++.a
ln -sf ../lib32/libsupc++.a 32/libsupc++.a
ln -sf lib64/libsupc++.a libsupc++.a
ln -sf ../lib32/libmudflap.a 32/libmudflap.a
ln -sf lib64/libmudflap.a libmudflap.a
ln -sf ../lib32/libmudflapth.a 32/libmudflapth.a
ln -sf lib64/libmudflapth.a libmudflapth.a
%if %{build_libquadmath}
ln -sf ../lib32/libquadmath.a 32/libquadmath.a
ln -sf lib64/libquadmath.a libquadmath.a
%endif
%if %{build_libitm}
ln -sf ../lib32/libitm.a 32/libitm.a
ln -sf lib64/libitm.a libitm.a
%endif
%if %{build_libatomic}
ln -sf ../lib32/libatomic.a 32/libatomic.a
ln -sf lib64/libatomic.a libatomic.a
%endif
%if %{build_libasan}
ln -sf ../lib32/libasan.a 32/libasan.a
ln -sf lib64/libasan.a libasan.a
%endif
%if %{build_go}
ln -sf ../lib32/libgo.a 32/libgo.a
ln -sf lib64/libgo.a libgo.a
ln -sf ../lib32/libgobegin.a 32/libgobegin.a
ln -sf lib64/libgobegin.a libgobegin.a
%endif
%if %{build_ada}
ln -sf ../lib32/adainclude 32/adainclude
ln -sf lib64/adainclude adainclude
ln -sf ../lib32/adalib 32/adalib
ln -sf lib64/adalib adalib
%endif
%else
%ifarch %{multilib_64_archs}
ln -sf ../../../%{multilib_32_arch}-%{_vendor}-%{_target_os}%{?_gnu}/%{gcc_version}/libgfortran.a 32/libgfortran.a
ln -sf ../../../%{multilib_32_arch}-%{_vendor}-%{_target_os}%{?_gnu}/%{gcc_version}/libstdc++.a 32/libstdc++.a
ln -sf ../../../%{multilib_32_arch}-%{_vendor}-%{_target_os}%{?_gnu}/%{gcc_version}/libsupc++.a 32/libsupc++.a
ln -sf ../../../%{multilib_32_arch}-%{_vendor}-%{_target_os}%{?_gnu}/%{gcc_version}/libmudflap.a 32/libmudflap.a
ln -sf ../../../%{multilib_32_arch}-%{_vendor}-%{_target_os}%{?_gnu}/%{gcc_version}/libmudflapth.a 32/libmudflapth.a
%if %{build_libquadmath}
ln -sf ../../../%{multilib_32_arch}-%{_vendor}-%{_target_os}%{?_gnu}/%{gcc_version}/libquadmath.a 32/libquadmath.a
%endif
%if %{build_libitm}
ln -sf ../../../%{multilib_32_arch}-%{_vendor}-%{_target_os}%{?_gnu}/%{gcc_version}/libitm.a 32/libitm.a
%endif
%if %{build_libatomic}
ln -sf ../../../%{multilib_32_arch}-%{_vendor}-%{_target_os}%{?_gnu}/%{gcc_version}/libatomic.a 32/libatomic.a
%endif
%if %{build_libasan}
ln -sf ../../../%{multilib_32_arch}-%{_vendor}-%{_target_os}%{?_gnu}/%{gcc_version}/libasan.a 32/libasan.a
%endif
%if %{build_go}
ln -sf ../../../%{multilib_32_arch}-%{_vendor}-%{_target_os}%{?_gnu}/%{gcc_version}/libgo.a 32/libgo.a
ln -sf ../../../%{multilib_32_arch}-%{_vendor}-%{_target_os}%{?_gnu}/%{gcc_version}/libgobegin.a 32/libgobegin.a
%endif
%if %{build_ada}
ln -sf ../../../%{multilib_32_arch}-%{_vendor}-%{_target_os}%{?_gnu}/%{gcc_version}/adainclude 32/adainclude
ln -sf ../../../%{multilib_32_arch}-%{_vendor}-%{_target_os}%{?_gnu}/%{gcc_version}/adalib 32/adalib
%endif
%endif
%endif

# Strip debug info from Fortran/ObjC/Java static libraries
strip -g `find . \( -name libgfortran.a -o -name libobjc.a -o -name libgomp.a \
		    -o -name libmudflap.a -o -name libmudflapth.a \
		    -o -name libgcc.a -o -name libgcov.a -o -name libquadmath.a \
		    -o -name libitm.a -o -name libgo.a -o -name libcaf\*.a \
		    -o -name libatomic.a -o -name libasan.a -o -name libtsan.a \) \
		 -a -type f`
popd
chmod 755 %{buildroot}%{_prefix}/%{_lib}/libgfortran.so.4.*
chmod 755 %{buildroot}%{_prefix}/%{_lib}/libgomp.so.1.*
chmod 755 %{buildroot}%{_prefix}/%{_lib}/libmudflap{,th}.so.0.*
%if %{build_libquadmath}
chmod 755 %{buildroot}%{_prefix}/%{_lib}/libquadmath.so.0.*
%endif
%if %{build_libitm}
chmod 755 %{buildroot}%{_prefix}/%{_lib}/libitm.so.1.*
%endif
%if %{build_libatomic}
chmod 755 %{buildroot}%{_prefix}/%{_lib}/libatomic.so.1.*
%endif
%if %{build_libasan}
chmod 755 %{buildroot}%{_prefix}/%{_lib}/libasan.so.0.*
%endif
%if %{build_libtsan}
chmod 755 %{buildroot}%{_prefix}/%{_lib}/libtsan.so.0.*
%endif
%if %{build_go}
chmod 755 %{buildroot}%{_prefix}/%{_lib}/libgo.so.4.*
%endif
chmod 755 %{buildroot}%{_prefix}/%{_lib}/libobjc.so.4.*

%if %{build_ada}
chmod 755 %{buildroot}%{_prefix}/%{_lib}/libgnarl*so*
chmod 755 %{buildroot}%{_prefix}/%{_lib}/libgnat*so*
%endif

mv $FULLPATH/include-fixed/syslimits.h $FULLPATH/include/syslimits.h
mv $FULLPATH/include-fixed/limits.h $FULLPATH/include/limits.h
for h in `find $FULLPATH/include -name \*.h`; do
  if grep -q 'It has been auto-edited by fixincludes from' $h; then
    rh=`grep -A2 'It has been auto-edited by fixincludes from' $h | tail -1 | sed 's|^.*"\(.*\)".*$|\1|'`
    diff -up $rh $h || :
    rm -f $h
  fi
done

cd ..
for i in %{buildroot}%{_prefix}/bin/{gcc,gccgo,g++,gcov,gfortran,gnat*}; do
  mv -f $i ${i}48
done

#this introduces conflicts with gcc and the files discovered here are semi-pointless
#%find_lang gcc
#%files -f gcc.lang to package this back with gcc48

# Remove binaries we will not be including, so that they don't end up in
# gcc48-debuginfo
rm -f %{buildroot}%{_prefix}/%{_lib}/{libffi*,libiberty.a}
rm -f $FULLEPATH/install-tools/{mkheaders,fixincl}
rm -f %{buildroot}%{_prefix}/lib/{32,64}/libiberty.a
rm -f %{buildroot}%{_prefix}/%{_lib}/libssp*
rm -f %{buildroot}/lib/cpp
rm -f %{buildroot}/%{_lib}/libgcc_s*
rm -f %{buildroot}%{_prefix}/bin/{*c++*,cc,cpp,f95}
rm -f %{buildroot}%{_prefix}/bin/%{gcc_target_platform}-{gcc-*,gfortran}
rm -f %{buildroot}%{_prefix}/bin/gappletviewer || :
rm -f %{buildroot}%{_prefix}/bin/%{_target_platform}-gcc-%{version} || :
rm -f %{buildroot}%{_prefix}/bin/%{_target_platform}-gfortran || :
rm -f %{buildroot}%{_prefix}/bin/%{_target_platform}-gccgo || :
rm -f %{buildroot}%{_prefix}/bin/%{_target_platform}-gcc-ar || :
rm -f %{buildroot}%{_prefix}/bin/%{_target_platform}-gcc-nm || :
rm -f %{buildroot}%{_prefix}/bin/%{_target_platform}-gcc-ranlib || :

%ifarch %{multilib_64_archs}
# Remove libraries for the other arch on multilib arches
rm -f %{buildroot}%{_prefix}/lib/lib*.so*
rm -f %{buildroot}%{_prefix}/lib/lib*.a
%if %{build_go}
rm -rf %{buildroot}%{_prefix}/lib/go/%{gcc_version}/%{gcc_target_platform}
%ifnarch sparc64 ppc64 ppc64p7
ln -sf %{multilib_32_arch}-%{_vendor}-%{_target_os} %{buildroot}%{_prefix}/lib/go/%{gcc_version}/%{gcc_target_platform}
%endif
%endif
%else
%ifarch sparcv9 ppc
rm -f %{buildroot}%{_prefix}/lib64/lib*.so*
rm -f %{buildroot}%{_prefix}/lib64/lib*.a
%if %{build_go}
rm -rf %{buildroot}%{_prefix}/lib64/go/%{gcc_version}/%{gcc_target_platform}
%endif
%endif
%endif

rm -f %{buildroot}%{mandir}/man3/ffi*

# Help plugins find out nvra.
echo gcc-%{version}-%{release}.%{_arch} > $FULLPATH/rpmver

%check
cd obj-%{gcc_target_platform}

# run the tests.
make %{?_smp_mflags} -k check ALT_CC_UNDER_TEST=gcc ALT_CXX_UNDER_TEST=g++ \
%if 0%{?fedora} >= 20
     RUNTESTFLAGS="--target_board=unix/'{,-fstack-protector-strong}'" || :
%else
     RUNTESTFLAGS="--target_board=unix/'{,-fstack-protector}'" || :
%endif
echo ====================TESTING=========================
( LC_ALL=C ../contrib/test_summary || : ) 2>&1 | sed -n '/^cat.*EOF/,/^EOF/{/^cat.*EOF/d;/^EOF/d;/^LAST_UPDATED:/d;p;}'
echo ====================TESTING END=====================
mkdir testlogs-%{_target_platform}-%{version}-%{release}
for i in `find . -name \*.log | grep -F testsuite/ | grep -v 'config.log\|acats.*/tests/'`; do
  ln $i testlogs-%{_target_platform}-%{version}-%{release}/ || :
done
tar cf - testlogs-%{_target_platform}-%{version}-%{release} | bzip2 -9c \
  | uuencode testlogs-%{_target_platform}.tar.bz2 || :
rm -rf testlogs-%{_target_platform}-%{version}-%{release}

%clean
rm -rf %{buildroot}

%post -n libstdc++48 -p /sbin/ldconfig

%postun -n libstdc++48 -p /sbin/ldconfig

%post -n libobjc48 -p /sbin/ldconfig

%postun -n libobjc48 -p /sbin/ldconfig

%post -n libgfortran48 -p /sbin/ldconfig

%postun -n libgfortran48 -p /sbin/ldconfig

%post -n libgnat48 -p /sbin/ldconfig

%postun -n libgnat48 -p /sbin/ldconfig

%post -n libgomp48 -p /sbin/ldconfig

%postun -n libgomp48 -p /sbin/ldconfig

%post -n libmudflap48 -p /sbin/ldconfig

%postun -n libmudflap48 -p /sbin/ldconfig

%post -n libquadmath
/sbin/ldconfig
/sbin/install-info \
  --info-dir=%{_infodir} %{_infodir}/libquadmath.info.gz || :

%preun -n libquadmath
if [ $1 = 0 ]; then
  /sbin/install-info --delete \
    --info-dir=%{_infodir} %{_infodir}/libquadmath.info.gz || :
fi

%postun -n libquadmath -p /sbin/ldconfig

%post -n libitm
/sbin/ldconfig
/sbin/install-info \
  --info-dir=%{_infodir} %{_infodir}/libitm.info.gz || :

%preun -n libitm
if [ $1 = 0 ]; then
  /sbin/install-info --delete \
    --info-dir=%{_infodir} %{_infodir}/libitm.info.gz || :
fi

%postun -n libitm -p /sbin/ldconfig

%post -n libatomic -p /sbin/ldconfig

%postun -n libatomic -p /sbin/ldconfig

%post -n libasan -p /sbin/ldconfig

%postun -n libasan -p /sbin/ldconfig

%post -n libtsan -p /sbin/ldconfig

%postun -n libtsan -p /sbin/ldconfig

%post -n libgo48 -p /sbin/ldconfig

%postun -n libgo48 -p /sbin/ldconfig

%files
%defattr(-,root,root,-)
%{_prefix}/bin/gcc48
%{_prefix}/bin/gcov48
%ifarch ppc
%{_prefix}/bin/%{_target_platform}-gcc48
%endif
%ifarch sparc64 sparcv9
%{_prefix}/bin/sparc-%{_vendor}-%{_target_os}%{?_gnu}-gcc48
%endif
%ifarch ppc64 ppc64p7
%{_prefix}/bin/ppc-%{_vendor}-%{_target_os}%{?_gnu}-gcc48
%endif
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%dir %{_prefix}/libexec/gcc
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}/lto1
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}/lto-wrapper
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}/liblto_plugin.so*
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/rpmver
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/stddef.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/stdarg.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/stdfix.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/varargs.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/float.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/limits.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/stdbool.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/iso646.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/syslimits.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/unwind.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/omp.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/stdint.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/stdint-gcc.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/stdalign.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/stdnoreturn.h
%ifarch %{ix86} x86_64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/mmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/xmmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/emmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/pmmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/tmmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/ammintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/smmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/nmmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/bmmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/wmmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/immintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/avxintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/x86intrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/fma4intrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/xopintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/lwpintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/popcntintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/bmiintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/tbmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/ia32intrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/avx2intrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/bmi2intrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/f16cintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/fmaintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/lzcntintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/rtmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/xtestintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/adxintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/prfchwintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/rdseedintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/fxsrintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/xsaveintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/xsaveoptintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/mm_malloc.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/mm3dnow.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/cpuid.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/cross-stdarg.h
%endif
%ifarch ia64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/ia64intrin.h
%endif
%ifarch ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/ppc-asm.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/altivec.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/spe.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/paired.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/ppu_intrinsics.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/si2vmx.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/spu2vmx.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/vec_types.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/htmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/htmxlintrin.h
%endif
%ifarch %{arm}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/unwind-arm-common.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/mmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/arm_neon.h
%endif
%ifarch aarch64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/arm_neon.h
%endif
%ifarch sparc sparcv9 sparc64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/visintrin.h
%endif
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}/cc1
%ifarch s390 s390x
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/s390intrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/htmintrin.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/htmxlintrin.h
%endif
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}/collect2
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/crt*.o
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgcc.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgcov.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgcc_eh.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgcc_s.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgomp.spec
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgomp.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgomp.so
%if %{build_libitm}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libitm.spec
%endif
%if %{build_cloog}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libcloog-isl.so.*
%endif
%ifarch sparcv9 ppc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/crt*.o
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgcc.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgcov.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgcc_eh.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgcc_s.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgomp.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgomp.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libmudflap.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libmudflapth.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libmudflap.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libmudflapth.so
%if %{build_libquadmath}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libquadmath.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libquadmath.so
%endif
%if %{build_libitm}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libitm.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libitm.so
%endif
%if %{build_libatomic}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libatomic.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libatomic.so
%endif
%if %{build_libasan}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libasan.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libasan.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libasan_preinit.o
%endif
%endif
%ifarch %{multilib_64_archs}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/crt*.o
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgcc.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgcov.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgcc_eh.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgcc_s.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgomp.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgomp.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libmudflap.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libmudflapth.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libmudflap.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libmudflapth.so
%if %{build_libquadmath}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libquadmath.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libquadmath.so
%endif
%if %{build_libitm}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libitm.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libitm.so
%endif
%if %{build_libatomic}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libatomic.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libatomic.so
%endif
%if %{build_libasan}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libasan.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libasan.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libasan_preinit.o
%endif
%endif
%ifarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libmudflap.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libmudflapth.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libmudflap.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libmudflapth.so
%if %{build_libquadmath}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libquadmath.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libquadmath.so
%endif
%if %{build_libitm}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libitm.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libitm.so
%endif
%if %{build_libatomic}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libatomic.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libatomic.so
%endif
%if %{build_libasan}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libasan.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libasan.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libasan_preinit.o
%endif
%if %{build_libtsan}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libtsan.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libtsan.so
%endif
%else
%if %{build_libatomic}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libatomic.so
%endif
%if %{build_libasan}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libasan.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libasan_preinit.o
%endif
%if %{build_libtsan}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libtsan.so
%endif
%endif
%dir %{_prefix}/libexec/getconf
%{_prefix}/libexec/getconf/default
%doc gcc/README* rpm.doc/changelogs/gcc/ChangeLog* gcc/COPYING* COPYING.RUNTIME

%files c++
%defattr(-,root,root,-)
%{_prefix}/bin/g++48
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%dir %{_prefix}/libexec/gcc
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}/cc1plus
%ifarch sparcv9 ppc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libstdc++.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libstdc++.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libsupc++.a
%endif
%ifarch %{multilib_64_archs}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libstdc++.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libstdc++.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libsupc++.a
%endif
%ifarch sparcv9 ppc %{multilib_64_archs}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libstdc++.so
%endif
%ifarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libstdc++.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libsupc++.a
%endif
%doc rpm.doc/changelogs/gcc/cp/ChangeLog*

%files -n libstdc++48
%defattr(-,root,root,-)
%{_prefix}/%{_lib}/libstdc++.so.6.*
%dir %{_datadir}/gdb
%dir %{_datadir}/gdb/auto-load
%dir %{_datadir}/gdb/auto-load/%{_prefix}
%dir %{_datadir}/gdb/auto-load/%{_prefix}/%{_lib}/
%{_datadir}/gdb/auto-load/%{_prefix}/%{_lib}/libstdc*gdb.py*
%dir %{_prefix}/share/gcc-%{gcc_version}
%dir %{_prefix}/share/gcc-%{gcc_version}/python
%{_prefix}/share/gcc-%{gcc_version}/python/libstdcxx

%files -n libstdc++48-devel
%defattr(-,root,root,-)
%dir %{_prefix}/include/c++
%dir %{_prefix}/include/c++/%{gcc_version}
%{_prefix}/include/c++/%{gcc_version}/[^gjos]*
%{_prefix}/include/c++/%{gcc_version}/os*
%{_prefix}/include/c++/%{gcc_version}/s[^u]*
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%ifnarch sparcv9 ppc %{multilib_64_archs}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libstdc++.so
%endif
%doc rpm.doc/changelogs/libstdc++-v3/ChangeLog* libstdc++-v3/README*

%files objc
%defattr(-,root,root,-)
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%dir %{_prefix}/libexec/gcc
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/objc
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}/cc1obj
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libobjc.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libobjc.so
%ifarch sparcv9 ppc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libobjc.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libobjc.so
%endif
%ifarch %{multilib_64_archs}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libobjc.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libobjc.so
%endif
%doc rpm.doc/objc/*
%doc libobjc/THREADS* rpm.doc/changelogs/libobjc/ChangeLog*

%files objc++
%defattr(-,root,root,-)
%dir %{_prefix}/libexec/gcc
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}/cc1objplus

%files -n libobjc48
%defattr(-,root,root,-)
%{_prefix}/%{_lib}/libobjc.so.4*

%files gfortran
%defattr(-,root,root,-)
%{_prefix}/bin/gfortran48
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%dir %{_prefix}/libexec/gcc
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/finclude
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/finclude/omp_lib.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/finclude/omp_lib.f90
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/finclude/omp_lib.mod
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/finclude/omp_lib_kinds.mod
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}/f951
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgfortran.spec
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgfortranbegin.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libcaf_single.a
%ifarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgfortran.a
%endif
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgfortran.so
%ifarch sparcv9 ppc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgfortranbegin.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libcaf_single.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgfortran.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgfortran.so
%endif
%ifarch %{multilib_64_archs}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgfortranbegin.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libcaf_single.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgfortran.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgfortran.so
%endif
%doc rpm.doc/gfortran/*

%files -n libgfortran48
%defattr(-,root,root,-)
%{_prefix}/%{_lib}/libgfortran.so.4*

%if %{build_ada}
%files gnat
%defattr(-,root,root,-)
%{_prefix}/bin/gnat48
%{_prefix}/bin/gnat[^i]*48
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%dir %{_prefix}/libexec/gcc
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}
%ifarch sparcv9 ppc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/adainclude
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/adalib
%endif
%ifarch %{multilib_64_archs}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/adainclude
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/adalib
%endif
%ifarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/adainclude
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/adalib
%endif
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}/gnat1
%doc rpm.doc/changelogs/gcc/ada/ChangeLog*

%files -n libgnat48
%defattr(-,root,root,-)
%{_prefix}/%{_lib}/libgnat-*.so
%{_prefix}/%{_lib}/libgnarl-*.so

%files -n libgnat48-devel
%defattr(-,root,root,-)
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%ifarch sparcv9 ppc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32/adainclude
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32/adalib
%exclude %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32/adalib/libgnat.a
%exclude %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32/adalib/libgnarl.a
%endif
%ifarch sparc64 ppc64 ppc64p7
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64/adainclude
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64/adalib
%exclude %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64/adalib/libgnat.a
%exclude %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64/adalib/libgnarl.a
%endif
%ifnarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/adainclude
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/adalib
%exclude %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/adalib/libgnat.a
%exclude %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/adalib/libgnarl.a
%endif
%endif

#libgomp for GCC 4.8.2 is identical to libgomp for 4.4.7 so lets avoid a conlict here
#%files -n libgomp48
#%defattr(-,root,root,-)
#%{_prefix}/%{_lib}/libgomp.so.1*
#%doc rpm.doc/changelogs/libgomp/ChangeLog*

%files -n libmudflap48
%defattr(-,root,root,-)
%{_prefix}/%{_lib}/libmudflap.so.0*
%{_prefix}/%{_lib}/libmudflapth.so.0*

%files -n libmudflap48-devel
%defattr(-,root,root,-)
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/mf-runtime.h
%ifnarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libmudflap.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libmudflapth.so
%endif
%doc rpm.doc/changelogs/libmudflap/ChangeLog*

%if %{build_libquadmath}
%files -n libquadmath
%defattr(-,root,root,-)
%{_prefix}/%{_lib}/libquadmath.so.0*
%{_infodir}/libquadmath.info*
%doc rpm.doc/libquadmath/COPYING*

%files -n libquadmath-devel
%defattr(-,root,root,-)
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/quadmath.h
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/quadmath_weak.h
%ifnarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libquadmath.so
%endif
%doc rpm.doc/libquadmath/ChangeLog*
%endif

%if %{build_libitm}
%files -n libitm
%defattr(-,root,root,-)
%{_prefix}/%{_lib}/libitm.so.1*
%{_infodir}/libitm.info*

%files -n libitm-devel
%defattr(-,root,root,-)
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include
#%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/itm.h
#%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/include/itm_weak.h
%ifnarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libitm.so
%endif
%doc rpm.doc/libitm/ChangeLog*
%endif

%if %{build_libatomic}
%files -n libatomic
%defattr(-,root,root,-)
%{_prefix}/%{_lib}/libatomic.so.1*
%endif

%if %{build_libasan}
%files -n libasan
%defattr(-,root,root,-)
%{_prefix}/%{_lib}/libasan.so.0*
%endif

%if %{build_libtsan}
%files -n libtsan
%defattr(-,root,root,-)
%{_prefix}/%{_lib}/libtsan.so.0*
%endif

%if %{build_go}
%files go
%defattr(-,root,root,-)
%{_prefix}/bin/gccgo48
%{_mandir}/man1/gccgo.1*
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%dir %{_prefix}/libexec/gcc
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}/go1
%ifarch sparcv9 ppc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgo.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgo.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/64/libgobegin.a
%endif
%ifarch %{multilib_64_archs}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgo.so
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgo.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/32/libgobegin.a
%endif
%ifarch sparcv9 ppc %{multilib_64_archs}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgo.so
%endif
%ifarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgo.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgobegin.a
%endif
%doc rpm.doc/go/*

%files -n libgo48
%defattr(-,root,root,-)
%{_prefix}/%{_lib}/libgo.so.4*
%doc rpm.doc/libgo/*

%files -n libgo48-devel
%defattr(-,root,root,-)
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%dir %{_prefix}/%{_lib}/go
%dir %{_prefix}/%{_lib}/go/%{gcc_version}
%{_prefix}/%{_lib}/go/%{gcc_version}/%{gcc_target_platform}
%ifarch %{multilib_64_archs}
%ifnarch sparc64 ppc64 ppc64p7
%dir %{_prefix}/lib/go
%dir %{_prefix}/lib/go/%{gcc_version}
%{_prefix}/lib/go/%{gcc_version}/%{gcc_target_platform}
%endif
%endif
%ifarch sparcv9 ppc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib32/libgobegin.a
%endif
%ifarch sparc64 ppc64 ppc64p7
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/lib64/libgobegin.a
%endif
%ifnarch sparcv9 sparc64 ppc ppc64 ppc64p7
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgobegin.a
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/libgo.so
%endif
%endif

%files plugin-devel
%defattr(-,root,root,-)
%dir %{_prefix}/lib/gcc
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}
%dir %{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}
%{_prefix}/lib/gcc/%{gcc_target_platform}/%{gcc_version}/plugin
%dir %{_prefix}/libexec/gcc
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}
%dir %{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}
%{_prefix}/libexec/gcc/%{gcc_target_platform}/%{gcc_version}/plugin

%changelog
* Thu Jul 31 2014 4.8.2-16.el6
- First attempt at a full GNU 4.8 toolchain side-install for EL6 (minus java, libgcc, and cpp)

* Mon Mar  3 2014 Jakub Jelinek <jakub@redhat.com> 4.8.2-16
- fix up compare_exchange_* in libatomic too (PR c++/60272)

* Thu Feb 20 2014 Jakub Jelinek <jakub@redhat.com> 4.8.2-15
- fix exception spec instantiation ICE (#1067398, PR c++/60046)
- fix pch on aarch64 (#1058991, PR pch/60010)
- configure with --enable-gnu-indirect-function on architectures
  and distros that support it and don't support it by default
  yet (#1067245)
- fix vector permutation handling on i?86/x86_64 (PR target/57896)
- fix __atomic_compare_exchange_* not to store into *expected
  on success (PR c++/60272)
- fix -march=native on VMs where saving/restoring of YMM state
  is not supported, yet CPU supports f16c (PR driver/60233)
- add ref7.C testcase (PR c++/60274)

* Wed Feb 19 2014 Jakub Jelinek <jakub@redhat.com> 4.8.2-14
- remove libgo P.224 elliptic curve (#1066539)
- fix -mcpu=power8 ICE (#1064242, PR target/60137)

* Tue Jan 21 2014 Jakub Jelinek <jakub@redhat.com> 4.8.2-13
- when removing -Wall from CXXFLAGS, if -Werror=format-security
  is present, add -Wformat to it, so that GCC builds on F21

* Mon Jan 20 2014 Jakub Jelinek <jakub@redhat.com> 4.8.2-12
- update from the 4.8 branch (#1052892)
  - PRs c++/59838, debug/54694, fortran/34547, fortran/58410,
	middle-end/59827, middle-end/59860, target/58139, target/59142,
	target/59695, target/59794, target/59826, target/59839
- fix handling of initialized vars with flexible array members
  (#1035413, PR middle-end/28865)

* Wed Jan 15 2014 Jakub Jelinek <jakub@redhat.com> 4.8.2-11
- update from the 4.8 branch
  - fix s390x reload bug (#1052372, PR target/59803)

* Tue Jan 14 2014 Jakub Jelinek <jakub@redhat.com> 4.8.2-10
- update from the 4.8 branch (#1052892)
  - PRs ada/55946, ada/59772, c++/56060, c++/58954, c++/59255, c++/59730,
	fortran/57042, fortran/58998, fortran/59493, fortran/59612,
	fortran/59654, ipa/59610, middle-end/59584, pch/59436,
	rtl-optimization/54300, rtl-optimization/58668,
	rtl-optimization/59137, rtl-optimization/59647,
	rtl-optimization/59724, target/57386, target/59587, target/59625,
	target/59652, testsuite/58630, tree-optimization/54570,
	tree-optimization/59125, tree-optimization/59362,
	tree-optimization/59715, tree-optimization/59745
- default to -march=z196 instead of -march=z10 on s390/s390x (#1052890)

* Fri Jan 10 2014 Jakub Jelinek <jakub@redhat.com> 4.8.2-9
- define %%global _performance_build 1 (#1051064)

* Tue Jan  7 2014 Jakub Jelinek <jakub@redhat.com> 4.8.2-8
- treat ppc64p7 as ppc64 (#1048859)

* Thu Dec 12 2013 Jakub Jelinek <jakub@redhat.com> 4.8.2-7
- update from the 4.8 branch
  - PRs libgomp/59467, rtl-optimization/58295, target/56807,
	testsuite/59442
  - fix LRA coalescing for real (PR middle-end/59470)

* Wed Dec 11 2013 Jakub Jelinek <jakub@redhat.com> 4.8.2-6
- temporarily revert PR middle-end/58956 to avoid libstdc++
  miscompilation on i?86 (PR middle-end/59470)

* Mon Dec  9 2013 Jakub Jelinek <jakub@redhat.com> 4.8.2-5
- update from the 4.8 branch
  - PRs ada/59382, bootstrap/57683, c++/58162, c++/59031, c++/59032,
	c++/59044, c++/59052, c++/59268, c++/59297, c/59280, c/59351,
	fortran/57445, fortran/58099, fortran/58471, fortran/58771,
	middle-end/58742, middle-end/58941, middle-end/58956,
	middle-end/59011, middle-end/59037, middle-end/59138,
	rtl-optimization/58726, target/50751, target/51244, target/56788,
	target/58854, target/58864, target/59021, target/59088,
	target/59101, target/59153, target/59163, target/59207,
	target/59343, target/59405, tree-optimization/57517,
	tree-optimization/58137, tree-optimization/58143,
	tree-optimization/58653, tree-optimization/58794,
	tree-optimization/59014, tree-optimization/59047,
	tree-optimization/59139, tree-optimization/59164,
	tree-optimization/59288, tree-optimization/59330,
	tree-optimization/59334, tree-optimization/59358,
	tree-optimization/59388
- aarch64 gcj enablement (#1023789)
- look for libgfortran.spec and libitm.spec in %%{_lib} rather than lib
  subdirs (#1023789)

* Mon Nov 11 2013 Jakub Jelinek <jakub@redhat.com> 4.8.2-4
- update from the 4.8 branch
  - PRs plugins/52872, regression/58985, target/59034

* Wed Nov  6 2013 Jakub Jelinek <jakub@redhat.com> 4.8.2-3
- update from the 4.8 branch
  - PRs c++/58282, c++/58979, fortran/58355, fortran/58989, libstdc++/58839,
	libstdc++/58912, libstdc++/58952, lto/57084, middle-end/58789,
	rtl-optimization/58079, rtl-optimization/58831, rtl/58542,
	target/58690, target/58779, target/58792, target/58838,
	tree-optimization/57488, tree-optimization/58805,
	tree-optimization/58984
- fix ICEs in get_bit_range (PR middle-end/58970)
- fix ICEs in RTL loop unswitching (PR rtl-optimization/58997)

* Sun Oct 20 2013 Jakub Jelinek <jakub@redhat.com> 4.8.2-2
- update from the 4.8 branch
  - PRs c++/58596, libstdc++/58800
- power8 TImode fix (#1014053, PR target/58673)

* Thu Oct 17 2013 Jakub Jelinek <jakub@redhat.com> 4.8.2-1
- update from the 4.8 branch
  - GCC 4.8.2 release
  - PRs c++/57850, c++/58633, libstdc++/58191

* Thu Oct 10 2013 Jakub Jelinek <jakub@redhat.com> 4.8.1-12
- update from the 4.8 branch
  - PRs c++/58568, fortran/55469, fortran/57697, fortran/58469,
	libstdc++/57465, libstdc++/57641, libstdc++/58659, target/58460,
	tree-optimization/58539
  - fix asm goto handling (#1017704, PR middle-end/58670)

* Wed Oct  2 2013 Jakub Jelinek <jakub@redhat.com> 4.8.1-11
- update from the 4.8 branch
  - PRs c++/58535, libstdc++/58437, libstdc++/58569, middle-end/56791,
	middle-end/58463, middle-end/58564, target/58330,
	tree-optimization/56716
  - fix s390x z10+ chunkification (#1012870, PR target/58574)
- disable ppc{,64} -mvsx-timode by default (#1014053, PR target/58587)

* Fri Sep 20 2013 Jakub Jelinek <jakub@redhat.com> 4.8.1-10
- update from the 4.8 branch
  - PRs ada/58264, c++/58457, c++/58458, libstdc++/58358,
	tree-optimization/58088
- on RHEL7, configure on ppc/ppc64 with default -mcpu=power7,
  on s390/s390x with default -march=z10 -mtune=zEC12 and
  on i?86 default to -march=x86-64 -mtune=generic (#805157)
- on Fedora 20+ and RHEL7 default to -fdiagnostics-color=auto
  rather than -fdiagnostics-color=never, if GCC_COLORS isn't
  in the environment; to turn it off by default, set GCC_COLORS=
  in the environment

* Sun Sep 15 2013 Jakub Jelinek <jakub@redhat.com> 4.8.1-9
- update from the 4.8 branch
  - PRs c++/58273, libstdc++/58415, middle-end/58377, rtl-optimization/58365,
	target/58314, target/58361, target/58382, tree-optimization/58385
- add arm_neon.h on aarch64 (#1007490)

* Mon Sep  9 2013 Jakub Jelinek <jakub@redhat.com> 4.8.1-8
- update from the 4.8 branch
  - PRs c++/58325, libstdc++/58302, libstdc++/58341, middle-end/57656,
	other/12081, target/57735, tree-optimization/57521,
	tree-optimization/57685, tree-optimization/58010,
	tree-optimization/58223, tree-optimization/58228,
	tree-optimization/58246, tree-optimization/58277,
	tree-optimization/58364

* Thu Aug 29 2013 Jakub Jelinek <jakub@redhat.com> 4.8.1-7
- update from the 4.8 branch
  - PRs c++/58083, c++/58119, c++/58190, fortran/57798, fortran/58185,
	middle-end/56977, middle-end/57381, middle-end/58257, target/56979,
	target/57865, target/57927, target/58218, tree-optimization/57343,
	tree-optimization/57396, tree-optimization/57417,
	tree-optimization/58006, tree-optimization/58164,
	tree-optimization/58165, tree-optimization/58209
- fix up x86-64 -mcmodel=large -fpic TLS GD and LD model
  (#994244, PR target/58067)
- power8 fusion support fixes (#731884, PR target/58160)

* Wed Aug 14 2013 Jakub Jelinek <jakub@redhat.com> 4.8.1-6
- update from the 4.8 branch
  - PRs c++/57825, c++/57901, c++/57981, c++/58022, fortran/57435,
	fortran/58058, libstdc++/56627, libstdc++/57914, libstdc++/58098,
	middle-end/58041, rtl-optimization/57459, rtl-optimization/57708,
	rtl-optimization/57878, sanitizer/56417, target/51784, target/57516,
	target/58067, target/58132, tree-optimization/57980
- power8 fusion support (#731884)
- fix up ABI alignment patch (#947197)
- fix up SRA with volatile struct accesses (PR tree-optimization/58145)

* Wed Jul 17 2013 Jakub Jelinek <jakub@redhat.com> 4.8.1-5
- update from the 4.8 branch
  - PRs target/55656, target/55657
  - update to Go 1.1.1
- backport power8 HTM support from trunk (#731884)
- backport s390 zEC12 HTM support from trunk

* Mon Jul 15 2013 Jakub Jelinek <jakub@redhat.com> 4.8.1-4
- update from the 4.8 branch
  - PRs c++/57437, c++/57526, c++/57532, c++/57545, c++/57550, c++/57551,
	c++/57645, c++/57771, c++/57831, fortran/57785,
	rtl-optimization/57829, target/56102, target/56892, target/56987,
	target/57506, target/57631, target/57736, target/57744,
	target/57777, target/57792, target/57844
- backport some raw-string literal handling fixes (#981029,
  PRs preprocessor/57757, preprocessor/57824)
- improve convert_to_* (PR c++/56493)
- tune for power7 on RHEL7

* Fri Jun 28 2013 Jakub Jelinek <jakub@redhat.com> 4.8.1-3
- update from the 4.8 branch
  - PRs c++/53211, c++/56544, driver/57652, libstdc++/57619, libstdc++/57666,
	libstdc++/57674, rtl-optimization/57518, target/57623, target/57655,
	tree-optimization/57358, tree-optimization/57537
  - fix up gcc-{ar,nm,ranlib} (#974853, PR driver/57651)
- fix two libitm HTM handling bugs (PR libitm/57643)
- speed up __popcount[sdt]i2 library function (PR middle-end/36041)
- backport power8 support from trunk (#731884, PR target/57615)
- for Fedora 20+ test -fstack-protector-strong during %%check instead
  of -fstack-protector

* Wed Jun 12 2013 Jakub Jelinek <jakub@redhat.com> 4.8.1-2
- update from the 4.8 branch
  - PRs fortran/57364, fortran/57508, target/56547, target/57379, target/57568
- backport backwards compatible alignment ABI fixes (#947197, PR target/56564)
- fix up widening multiplication vectorization on big-endian
  (PR tree-optimization/57537)

* Mon Jun  3 2013 Jakub Jelinek <jakub@redhat.com> 4.8.1-1
- update from the 4.8 branch
  - GCC 4.8.1 release
  - PRs c++/56930, c++/57319, fortran/57217, target/49146, target/56742
- backport Intel Silvermont enablement and tuning from trunk
- backport 3 small AMD improvement patches from trunk

* Sun May 26 2013 Jakub Jelinek <jakub@redhat.com> 4.8.0-8
- update from the 4.8 branch
  - std::chrono::steady_clock ABI fixes from 4.8.0-7

* Fri May 24 2013 Jakub Jelinek <jakub@redhat.com> 4.8.0-7
- update from the 4.8 branch
  - PRs c++/57016, c++/57317, c++/57325, c++/57388, libffi/56033,
	libstdc++/57336, middle-end/57344, middle-end/57347, plugins/56754,
	rtl-optimization/57341, target/56732, target/57356,
	tree-optimization/57303, tree-optimization/57318,
	tree-optimization/57321, tree-optimization/57330, tree-ssa/57385
  - std::chrono::steady_clock now really steady

* Fri May 17 2013 Jakub Jelinek <jakub@redhat.com> 4.8.0-6
- update from the 4.8 branch
  - PRs c++/56782, c++/56998, c++/57041, c++/57196, c++/57243, c++/57252,
	c++/57253, c++/57254, c++/57274, c++/57279, middle-end/57251,
	rtl-optimization/57281, rtl-optimization/57300, target/45359,
	target/46396, target/57264
- backport color diagnostics support from trunk, enable with
  -fdiagnostics-color=auto, -fdiagnostics-color=always or
  having non-empty GCC_COLORS variable in environment
- backport -fstack-protector-strong support from trunk

* Fri May 10 2013 Jakub Jelinek <jakub@redhat.com> 4.8.0-5
- update from the 4.8 branch
  - PRs bootstrap/54281, bootstrap/54659, c++/57047, c++/57068, c++/57222,
	fortran/57142, libstdc++/57212, middle-end/56988, target/55033,
	target/57237, tree-optimization/57200, tree-optimization/57214
- fix up strlen pass (PR tree-optimization/57230)

* Tue May  7 2013 Jakub Jelinek <jakub@redhat.com> 4.8.0-4
- update from the 4.8 branch
  - PRs ada/56474, c++/50261, c++/56450, c++/56859, c++/56970, c++/57064,
	c++/57092, c++/57183, debug/57184, fortran/51825, fortran/52512,
	fortran/53685, fortran/56786, fortran/56814, fortran/56872,
	fortran/56968, fortran/57022, libfortran/51825, libfortran/52512,
	libfortran/56786, libstdc++/57010, middle-end/57103,
	rtl-optimization/56605, rtl-optimization/56847,
	rtl-optimization/57003, rtl-optimization/57130,
	rtl-optimization/57131, rtl-optimizations/57046, sanitizer/56990,
	target/44578, target/55445, target/56797, target/56866, target/57018,
	target/57091, target/57097, target/57098, target/57106, target/57108,
	target/57150, tree-optimization/57051, tree-optimization/57066,
	tree-optimization/57083, tree-optimization/57104,
	tree-optimization/57149, tree-optimization/57185
  - fix gcj with -fsection-anchors (#952673, PR libgcj/57074)
- enable libitm on s390{,x}
- error when linking with both -fsanitize=address and -fsanitize=thread
  (#957778)

* Fri Apr 19 2013 Jakub Jelinek <jakub@redhat.com> 4.8.0-3
- update from the 4.8 branch
  - PRs c++/56388, fortran/56816, fortran/56994, rtl-optimization/56992,
	target/56890, target/56903, target/56948, tree-optimization/56962,
	tree-optimization/56984
- fix up LRA caused miscompilation of xulrunner on i?86
  (#949553, PR rtl-optimization/56999)
- reassoc fix for -Ofast -frounding-math (PR tree-optimization/57000)

* Fri Apr 12 2013 Jakub Jelinek <jakub@redhat.com> 4.8.0-2
- update from the 4.8 branch
  - PRs c++/35722, c++/45282, c++/52014, c++/52374, c++/52748, c++/54277,
	c++/54359, c++/54764, c++/55532, c++/55951, c++/55972, c++/56039,
	c++/56447, c++/56582, c++/56646, c++/56692, c++/56699, c++/56722,
	c++/56728, c++/56749, c++/56772, c++/56774, c++/56793, c++/56794,
	c++/56821, c++/56895, c++/56913, debug/56819, fortran/54932,
	fortran/56696, fortran/56735, fortran/56737, fortran/56782,
	libstdc++/55977, libstdc++/55979, libstdc++/56002, libstdc++/56678,
	libstdc++/56834, lto/56777, middle-end/56694, middle-end/56768,
	middle-end/56883, other/55274, rtl-optimization/48182,
	rtl-optimization/56745, sanitizer/55702, target/54805, target/55487,
	target/56560, target/56720, target/56771, tree-optimization/48184,
	tree-optimization/48186, tree-optimization/48762,
	tree-optimization/56407, tree-optimization/56501,
	tree-optimization/56817, tree-optimization/56837,
	tree-optimization/56899, tree-optimization/56918,
	tree-optimization/56920

* Fri Mar 22 2013 Jakub Jelinek <jakub@redhat.com> 4.8.0-1
- update from the 4.8 branch
  - GCC 4.8.0 release
  - PRs c++/56607, other/43620
  - fix length in .debug_aranges in some cases
- improve debug info for optimized away global vars (PR debug/56608)
- don't warn about signed 1-bit enum bitfields containing values 0 and -1
  or just -1 (PR c/56566)

* Wed Mar 20 2013 Jakub Jelinek <jakub@redhat.com> 4.8.0-0.18
- update from the 4.8 branch
  - PRs libstdc++/56468, target/56640, tree-optimization/56635,
	tree-optimization/56661
- package libasan_preinit.o

* Sat Mar 16 2013 Jakub Jelinek <jakub@redhat.com> 4.8.0-0.17
- update from trunk and the 4.8 branch
  - PRs ada/52123, c++/51412, c++/51494, c++/51884, c++/52183, c++/56222,
	c++/56346, c++/56565, c++/56567, c++/56611, c++/56614, debug/56307,
	fortran/56575, fortran/56615, libstdc++/56492, libstdc++/56609,
	libstdc++/56613, lto/56557, middle-end/56524, middle-end/56571,
	target/40797, target/49880, target/56470, target/56591, target/56619,
	testsuite/54119, tree-optimization/53265, tree-optimization/56478,
	tree-optimization/56570, tree-optimization/56608

* Thu Mar  7 2013 Jakub Jelinek <jakub@redhat.com> 4.8.0-0.16
- updated from trunk
  - PRs bootstrap/56509, c++/54383, c++/55135, c++/56464, c++/56530,
	c++/56534, c++/56543, debug/55364, debug/56510, libquadmath/55473,
	lto/50293, lto/56515, middle-end/50494, middle-end/56294,
	middle-end/56525, middle-end/56526, middle-end/56548,
	rtl-optimization/56484, rtl-optimization/56494, target/56529,
	tree-optimization/56270, tree-optimization/56521,
	tree-optimization/56539, tree-optimization/56559
  - include arm-cores.def in gcc-python-plugin on arm (#910926)
- include vxworks-dummy.h in gcc-python-plugin where needed (PR plugins/45078)

* Mon Mar  4 2013 Jakub Jelinek <jakub@redhat.com> 4.8.0-0.15
- updated from trunk
  - PRs c++/10291, c++/40405, c++/52688, c++/55632, c++/55813, c++/56243,
	c++/56358, c++/56359, c++/56377, c++/56395, c++/56403, c++/56419,
	c++/56438, c++/56481, fortran/54730, fortran/56385, fortran/56416,
	fortran/56477, fortran/56491, libfortran/30162, libstdc++/56011,
	libstdc++/56012, middle-end/45472, middle-end/56077,
	middle-end/56108, middle-end/56420, middle-end/56461,
	rtl-optimization/50339, rtl-optimization/56466, sanitizer/56393,
	sanitizer/56454, target/48901, target/52500, target/52501,
	target/52550, target/54639, target/54640, target/54662, target/56444,
	target/56445, target/56455, testsuite/52641, tree-optimization/55481,
	tree-optimization/56175, tree-optimization/56294,
	tree-optimization/56310, tree-optimization/56415,
	tree-optimization/56426, tree-optimization/56443,
	tree-optimization/56448
- fnsplit fix (PR tree-optimization/56424)

* Wed Feb 20 2013 Jakub Jelinek <jakub@redhat.com> 4.8.0-0.14
- updated from trunk
  - PRs asan/56330, c++/51242, c++/54276, c++/56373, libquadmath/56379,
	middle-end/55889, middle-end/56349, pch/54117,
	rtl-optimization/56348, target/52555, target/54685, target/56214,
	target/56347, tree-optimization/55334, tree-optimization/56321,
	tree-optimization/56350, tree-optimization/56366,
	tree-optimization/56381, tree-optimization/56384,
	tree-optimization/56396, tree-optimization/56398
- add BuildRequires: /usr/bin/pod2man to fix man pages generation
- don't ICE on bogus inline asm in kernel (#912857, PR inline-asm/56405)
- fix up info page building with texinfo 5.0 (PR bootstrap/56258)
- devirtualization ICE fix (PR tree-optimization/56265)

* Fri Feb 15 2013 Jakub Jelinek <jakub@redhat.com> 4.8.0-0.13
- updated from trunk
  - PRs bootstrap/56327, c++/52026, c++/54922, c++/55003, c++/55220,
	c++/55223, c++/55232, c++/55582, c++/55670, c++/55680, c++/56323,
	c++/56343, fortran/53818, fortran/56224, fortran/56318,
	libstdc++/56111, lto/50494, target/55431, target/55941,
	testsuite/56138
- asan fixes (PR sanitizer/56330)
- asan speedup - use 0x7fff8000 shadow offset instead of 1LL << 44 on
  x86_64

* Wed Feb 13 2013 Jakub Jelinek <jakub@redhat.com> 4.8.0-0.12
- updated from trunk
  - PRs c++/55710, c++/55879, c++/55993, c++/56135, c++/56155, c++/56285,
	c++/56291, c/44938, fortran/46952, fortran/56204, inline-asm/56148,
	libitm/55693, lto/56295, lto/56297, middle-end/56288,
	sanitizer/56128, target/52122, testsuite/56082
  - fix IRA bug that caused reload ICE on ARM (#910153, target/56184)
  - attempt harder to fold "n" constrainted asm input operands in C++
    with -O0 (#910421, c++/56302)

* Mon Feb 11 2013 Jakub Jelinek <jakub@redhat.com> 4.8.0-0.11
- updated from trunk
  - PRs c++/56238, c++/56247, c++/56268, fortran/55362, libstdc++/56267,
	libstdc++/56278, libstdc++/56282, rtl-optimization/56246,
	rtl-optimization/56275, target/56043, tree-optimization/56264,
	tree-optimization/56273
- improve expansion of mem1 op= mem2 (PR rtl-optimization/56151)

* Fri Feb  8 2013 Jakub Jelinek <jakub@redhat.com> 4.8.0-0.10
- updated from trunk
  - PRs bootstrap/56227, c++/56235, c++/56237, c++/56239, c++/56241,
	debug/53363, fortran/54339, fortran/55789, libstdc++/56193,
	libstdc++/56216, lto/56231, middle-end/56181,
	rtl-optimization/56195, rtl-optimization/56225, target/50678,
	target/54009, target/54131, tree-optimization/56250
  - fix Ada frontend miscompilation with profiledbootstrap (#906516,
    PR rtl-optimization/56178)
- restore parsing of ppc inline asm dialects (#909298, PR target/56256)
- fix up libiberty old regex (PR other/56245)
- fix IRA -O0 -g code debug regression (PR debug/53948)

* Wed Feb  6 2013 Jakub Jelinek <jakub@redhat.com> 4.8.0-0.9
- updated from trunk
  - PRs c++/54122, c++/56177, c++/56208, debug/54793, fortran/47517,
	fortran/50627, fortran/54195, fortran/56008, fortran/56054,
	libstdc++/56202, lto/56168, middle-end/56113, middle-end/56167,
	middle-end/56217, rtl-optimization/56131, sanitizer/55617,
	target/52123, target/54601, target/55146, target/56186,
	tree-optimization/53185, tree-optimization/53342,
	tree-optimization/54386, tree-optimization/55789,
	tree-optimization/56188
  - fix up stdarg pass (PR tree-optimization/56205, #906367)
  - remove unused thread_local bitfield (#907882)
- fix cselim pass on calls that might free memory (PR tree-optimization/52448)
- fix libgfortran internal_pack (PR fortran/55978)
- fix up .debug_loc for first function in CU, if it contains empty ranges
  at the beginning of the function (PR debug/56154, #904252)
- fix ppc64 indirect calls (PR target/56228, #908388)

* Thu Jan 31 2013 Jakub Jelinek <jakub@redhat.com> 4.8.0-0.8
- updated from trunk
  - PRs c++/56162, debug/54410, debug/54508, debug/55059, fortran/54107,
	fortran/56138, libgomp/55561, libstdc++/54314, lto/56147,
	middle-end/53073, other/53413, other/54620, rtl-optimization/56144,
	sanitizer/55374, target/39064, target/56121, tree-optimization/55270,
	tree-optimization/56064, tree-optimization/56113,
	tree-optimization/56150, tree-optimization/56157

* Tue Jan 29 2013 Jakub Jelinek <jakub@redhat.com> 4.8.0-0.7
- updated from trunk
  - PRs c++/56095, c++/56104, c/56078, fortran/53537, fortran/55984,
	fortran/56047, inline-asm/55934, libstdc++/56085, libstdc++/56112,
	other/54814, other/56076, rtl-optimization/56117, target/54663,
	target/56114, testsuite/56053, tree-optimization/55927,
	tree-optimization/56034, tree-optimization/56035,
	tree-optimization/56094, tree-optimization/56098,
	tree-optimization/56125

* Thu Jan 24 2013 Jakub Jelinek <jakub@redhat.com> 4.8.0-0.6
- updated from trunk
  - PRs c++/53609, c++/55944, c++/56067, c++/56071, fortran/56081,
	libgomp/51376, libgomp/56073, libquadmath/56072, middle-end/56074,
	sanitizer/55989, target/49069, target/54222, target/55686,
	target/56028
- update TeX related BuildRequires (#891460)

* Tue Jan 22 2013 Jakub Jelinek <jakub@redhat.com> 4.8.0-0.5
- updated from trunk
  - PRs c++/56059, fortran/55919, rtl-optimization/56023,
	tree-optimization/56051
- fix up cloog dlopen patches for upgrade to cloog-0.18.0
- fix Fortran OpenMP OOP ICE (PR fortran/56052)

* Mon Jan 21 2013 Jakub Jelinek <jakub@redhat.com> 4.8.0-0.4
- updated from trunk
  - PRs ada/864, bootstrap/55792, bootstrap/55961, c++/52343, c++/55663,
	c++/55753, c++/55801, c++/55878, c++/55893, c/48418, debug/49888,
	debug/53235, debug/53671, debug/54114, debug/54402, debug/55579,
	debug/56006, driver/55470, driver/55884, fortran/42769, fortran/45836,
	fortran/45900, fortran/47203, fortran/52865, fortran/53876,
	fortran/54286, fortran/54678, fortran/54990, fortran/54992,
	fortran/55072, fortran/55341, fortran/55618, fortran/55758,
	fortran/55763, fortran/55806, fortran/55852, fortran/55868,
	fortran/55935, fortran/55983, libmudflap/53359, libstdc++/51007,
	libstdc++/55043, libstdc++/55233, libstdc++/55594, libstdc++/55728,
	libstdc++/55847, libstdc++/55861, libstdc++/55908, lto/45375,
	middle-end/55114, middle-end/55851, middle-end/55882,
	middle-end/55890, middle-end/56015, other/55973, other/55982,
	rtl-optimization/52573, rtl-optimization/53827,
	rtl-optimization/55153, rtl-optimization/55547,
	rtl-optimization/55672, rtl-optimization/55829,
	rtl-optimization/55833, rtl-optimization/55845,
	rtl-optimization/56005, sanitizer/55488, sanitizer/55679,
	sanitizer/55844, target/42661, target/43961, target/54461,
	target/54908, target/55301, target/55433, target/55565,
	target/55718, target/55719, target/55876, target/55897,
	target/55940, target/55948, target/55974, target/55981,
	target/56058, testsuite/54622, testsuite/55994,
	tree-optimization/44061, tree-optimization/48189,
	tree-optimization/48766, tree-optimization/52631,
	tree-optimization/53465, tree-optimization/54120,
	tree-optimization/54767, tree-optimization/55273,
	tree-optimization/55569, tree-optimization/55823,
	tree-optimization/55862, tree-optimization/55875,
	tree-optimization/55888, tree-optimization/55920,
	tree-optimization/55921, tree-optimization/55955,
	tree-optimization/55964, tree-optimization/55995,
	tree-optimization/56029, tree-optimization/55264
- fix up multiversioning (PR c++/55742)
- fix up ICE with target attribute (PR middle-end/56022)
- update isl to 0.11.1 and cloog to 0.18.0

* Sun Jan  6 2013 Jakub Jelinek <jakub@redhat.com> 4.8.0-0.3
- new package
