%define debug_package %{nil}
#
# spec file for package ruby19
#
# Copyright (c) 2013 SUSE LINUX Products GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via http://bugs.opensuse.org/
#


Name:           ruby19
Version:        1.9.3.p448
Release:        55.4.el6
#
%define pkg_version 1.9.3
%define patch_level p448
# keep in sync with macro file!
%define rb_binary_suffix 1.9
%define rb_ver  1.9.1
%define rb_arch %(echo %{_target_cpu}-linux | sed -e "s/ppc/powerpc/")
%define rb_libdir                         %{_libdir}/ruby/%{rb_ver}/
%define rb_archdir                        %{_libdir}/ruby/%{rb_ver}/%{rb_arch}
# keep in sync with macro file!
#
%if 0%{?suse_version} == 1100
%define needs_optimization_zero 1
%endif
# from valgrind.spec
%ifarch %ix86 x86_64 ppc ppc64
%define use_valgrind 1
%endif
%define run_tests 0
#
#
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
BuildRequires:  gdbm-devel
BuildRequires:  libffi-devel
BuildRequires:  libyaml-devel
BuildRequires:  ncurses-devel
BuildRequires:  openssl-devel
BuildRequires:  pkgconfig
BuildRequires:  readline-devel
BuildRequires:  tk-devel
BuildRequires:  zlib-devel
# this requires is needed as distros older than 11.3 have a buildignore on freetype2, without this the detection of the tk extension fails
BuildRequires:  freetype-devel
%if 0%{?suse_version} > 1010
BuildRequires:  xorg-x11-libX11-devel
%else
BuildRequires:  xorg-x11-proto-devel xorg-x11-xtrans-devel
%endif
%if 0%{?use_valgrind}
%if 0%{?suse_version} > 1020
BuildRequires:  valgrind-devel
%else
BuildRequires:  valgrind
%endif
%endif
#
Provides:       rubygem-rake = 0.9.2.2
Provides:       ruby(abi) = %{rb_ver}
#
Url:            http://www.ruby-lang.org/
Source:         ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-%{pkg_version}-%{patch_level}.tar.bz2
Source6:        ruby19.macros
Source7:        gem_install_wrapper.sh
Patch:          rubygems-1.5.0_buildroot.patch
Patch1:         ruby-1.9.2p290_tcl_no_stupid_rpaths.patch
Patch2:         ruby19-export_init_prelude.patch
Patch3:         ruby-sort-rdoc-output.patch
# PATCH-KNOWN-UPSTREAM: http://bugs.ruby-lang.org/issues/show/2294, bnc#796757, kkaempf@suse.de
Patch4:         thread_pthread.c-ruby_init_stack-ignore-STACK_END_ADDRESS.patch
#Patch5:         fix_cve-2013-4073.patch
#
Summary:        An Interpreted Object-Oriented Scripting Language
License:        BSD-2-Clause or Ruby
Group:          Development/Languages/Ruby

%description
Ruby is an interpreted scripting language for quick and easy
object-oriented programming.  It has many features for processing text
files and performing system management tasks (as in Perl).  It is
simple, straight-forward, and extensible.

* Ruby features:

- Simple Syntax

- *Normal* Object-Oriented features (class, method calls, for
   example)

- *Advanced* Object-Oriented features(Mix-in, Singleton-method, for
   example)

- Operator Overloading

- Exception Handling

- Iterators and Closures

- Garbage Collection

- Dynamic Loading of Object Files (on some architectures)

- Highly Portable (works on many UNIX machines; DOS, Windows, Mac,
BeOS, and more)


%package devel
Summary:        Development files to link against Ruby
Group:          Development/Languages/Ruby
Requires:       %{name} = %{version}
Provides:       rubygems19 = 1.3.7
Provides:       rubygems19_with_buildroot_patch
Requires:       ruby-common

%description devel
Development files to link against Ruby.

%package devel-extra
Summary:        Special development files of ruby, normally not installed
Group:          Development/Languages/Ruby
Requires:       %{name}-devel = %{version}

%description devel-extra
Development files to link against Ruby.

%package tk
Summary:        TCL/TK bindings for Ruby
Group:          Development/Languages/Ruby
Requires:       %{name} = %{version}

%description tk
TCL/TK bindings for Ruby

%package doc-ri
Summary:        Ruby Interactive Documentation
Group:          Development/Languages/Ruby
Requires:       %{name} = %{version}
%if 0%{?suse_version} >= 1120
BuildArch:      noarch
%endif

%description doc-ri
This package contains the RI docs for ruby

%package doc-html
Summary:        This package contains the HTML docs for ruby
Group:          Development/Languages/Ruby
Requires:       %{name} = %{version}
%if 0%{?suse_version} >= 1120
BuildArch:      noarch
%endif

%description doc-html
This package contains the HTML docs for ruby

%package examples
Summary:        Example scripts for ruby
Group:          Development/Languages/Ruby
Requires:       %{name} = %{version}
%if 0%{?suse_version} >= 1120
BuildArch:      noarch
%endif

%description examples
Example scripts for ruby

%package test-suite
Requires:       %{name} = %{version}
Summary:        An Interpreted Object-Oriented Scripting Language
Group:          Development/Languages/Ruby
%if 0%{?suse_version} >= 1120
BuildArch:      noarch
%endif

%description test-suite
Ruby is an interpreted scripting language for quick and easy
object-oriented programming.  It has many features for processing text
files and performing system management tasks (as in Perl).  It is
simple, straight-forward, and extensible.

* Ruby features:

- Simple Syntax

- *Normal* Object-Oriented features (class, method calls, for
   example)

- *Advanced* Object-Oriented features(Mix-in, Singleton-method, for
   example)

- Operator Overloading

- Exception Handling

- Iterators and Closures

- Garbage Collection

- Dynamic Loading of Object Files (on some architectures)

- Highly Portable (works on many UNIX machines; DOS, Windows, Mac,
BeOS, and more)

%prep
%setup -q -n ruby-%{pkg_version}-%{patch_level}
%patch
%patch1
%patch2 -p1
%patch3 -p1
%patch4
%if 0%{?needs_optimization_zero}
touch -r configure configure.timestamp
perl -p -i.bak -e 's|-O2|-O0|g' configure
diff -urN configure{.bak,} ||:
touch -r configure.timestamp configure
%endif
find sample -type f -print0 | xargs -r0 chmod a-x
grep -Erl '^#! */' benchmark bootstraptest ext lib sample test \
  | xargs -r perl -p -i -e 's|^#!\s*\S+(\s+.*)?$|#!/usr/bin/ruby1.9$1|'

%build
%if 0%{?needs_optimization_zero}
export CFLAGS="%{optflags}"
export CFLAGS="${CFLAGS//-O2/}"
export CXXFLAGS="$CFLAGS"
export FFLAGS="$CFLAGS"
%endif
%configure \
  --program-suffix=%{rb_binary_suffix}  \
  --with-soname=ruby%{rb_binary_suffix} \
  --target=%{_target_platform} \
  %if 0%{?use_valgrind}
  --with-valgrind \
  %endif
  --with-mantype=man \
  --enable-shared \
  --disable-static \
  --disable-rpath
%{__make} all V=1

%install
%make_install V=1
%{__install} -D -m 0644 %{S:6} %{buildroot}/etc/rpm/macros.ruby19
echo "%defattr(-,root,root,-)" > devel-extra-excludes
echo "%defattr(-,root,root,-)" > devel-extra-list
for i in iseq.h insns.inc insns_info.inc revision.h version.h  thread_pthread.h \
  ruby_atomic.h method.h id.h vm_core.h vm_opts.h node.h debug.h eval_intern.h; do
  install -m 644 $i %{buildroot}%{_includedir}/ruby-%{rb_ver}/
  echo "%exclude %{_includedir}/ruby-%{rb_ver}/$i" >> devel-extra-excludes  
  echo "%{_includedir}/ruby-%{rb_ver}/$i" >> devel-extra-list
done

%if 0%{?run_tests}

%check
export LD_LIBRARY_PATH="$PWD"
# we know some tests will fail when they do not find a /usr/bin/ruby
make check V=1 ||:
%endif

%post   -p /sbin/ldconfig

%postun -p /sbin/ldconfig

%files
%defattr(-,root,root,-)
%config(noreplace) /etc/rpm/macros.ruby19
%{_bindir}/erb%{rb_binary_suffix}
%{_bindir}/gem%{rb_binary_suffix}
%{_bindir}/irb%{rb_binary_suffix}
%{_bindir}/rake%{rb_binary_suffix}
%{_bindir}/rdoc%{rb_binary_suffix}
%{_bindir}/ri%{rb_binary_suffix}
%{_bindir}/ruby%{rb_binary_suffix}
%{_bindir}/testrb%{rb_binary_suffix}
%{_libdir}/libruby%{rb_binary_suffix}.so.1.9*
%{_libdir}/ruby/
%exclude %{rb_libdir}/multi-tk.rb
%exclude %{rb_libdir}/remote-tk.rb
%exclude %{rb_libdir}/tcltk.rb
%exclude %{rb_libdir}/tk*.rb
%exclude %{rb_libdir}/tk/
%exclude %{rb_libdir}/tkextlib/
%exclude %{rb_archdir}/tcltklib.so
%exclude %{rb_archdir}/tkutil.so
%{_mandir}/man1/ri%{rb_binary_suffix}.1*
%{_mandir}/man1/irb%{rb_binary_suffix}.1*
%{_mandir}/man1/erb%{rb_binary_suffix}.1*
%{_mandir}/man1/rake%{rb_binary_suffix}.1*
%{_mandir}/man1/ruby%{rb_binary_suffix}.1*
%doc ChangeLog  COPYING  COPYING.ja  GPL  KNOWNBUGS.rb  LEGAL  NEWS  README  README.EXT  README.EXT.ja  README.ja  ToDo doc/* sample/

%files devel -f devel-extra-excludes
%defattr(-,root,root,-)
%{_includedir}/ruby-%{rb_ver}
%{_libdir}/libruby%{rb_binary_suffix}.so
%{_libdir}/libruby%{rb_binary_suffix}-static.a
%{_libdir}/pkgconfig/ruby-1.9.pc

%files devel-extra -f devel-extra-list

%files tk
%defattr(-,root,root,-)
%{rb_libdir}/multi-tk.rb
%{rb_libdir}/remote-tk.rb
%{rb_libdir}/tcltk.rb
%{rb_libdir}/tk*.rb
%{rb_libdir}/tk/
%{rb_libdir}/tkextlib/
%{rb_archdir}/tcltklib.so
%{rb_archdir}/tkutil.so

%files doc-ri
%defattr(-,root,root,-)
%dir %{_datadir}/ri/
%{_datadir}/ri/%{rb_ver}/

%changelog
* Tue Jul  2 2013 jmassaguerpla@suse.com
- update to 1.9.3.p392
  This release includes a fix for CVE-2013-4073 (bnc#827265)
  And some other bugfixes are also included
  see /usr/share/doc/packages/ruby19/Changelog for more details
* Fri Mar  1 2013 jmassaguerpla@suse.com
- update to 1.9.3 p392
  This release includes security fixes about bundled JSON and
  REXML.
  * Denial of Service and Unsafe Object Creation Vulnerability
    in JSON (CVE-2013-0269)
  * Entity expansion DoS vulnerability in REXML (XML bomb)
  And some small bugfixes are also included
  see /usr/share/doc/packages/ruby19/Changelog for more details
* Fri Feb  8 2013 kkaempf@suse.com
- replace bind_stack.patch with upstream patch (bnc#796757)
  (thread_pthread.c-ruby_init_stack-ignore-STACK_END_ADDRESS.patch)
  * thread_pthread.c (ruby_init_stack): ignore `STACK_END_ADDRESS'
    if Ruby interpreter is running on co-routine.
* Wed Feb  6 2013 mrueckert@suse.de
- update to 1.9.3 p385 (bnc#802406)
  XSS exploit of RDoc documentation generated by rdoc
  (CVE-2013-0256)
  for other changes see /usr/share/doc/packages/ruby19/Changelog
* Tue Jan  8 2013 coolo@suse.com
- readd the private header *atomic.h
* Fri Jan  4 2013 kkaempf@suse.com
- added bind_stack.patch: (bnc#796757)
  Fixes stack boundary issues when embedding Ruby into
  threaded C code (Ruby bug #2294)
* Sun Dec 30 2012 coolo@suse.com
- update to 1.9.3 p362
  * many bug fixes.
* Tue Nov 13 2012 coolo@suse.com
- update to 1.9.3 p327 (bnc#789983)
  CVE-2012-5371 and plenty of other fixes
* Tue Nov  6 2012 coolo@suse.com
- make sure the rdoc output is more stable for build-compare
  (new patch ruby-sort-rdoc-output.patch)
* Sat Nov  3 2012 coolo@suse.com
- update to 1.9.3 p286 (bnc#783511, bnc#791199)
  This release includes some security fixes, and many other bug fixes.
  $SAFE escaping vulnerability about Exception#to_s / NameError#to_s
  (CVE-2012-4464, CVE-2012-4466)
  Unintentional file creation caused by inserting an illegal NUL character
  many other bug fixes. (CVE-2012-4522)
  See Changelog for the complete set
- remove ruby-1.8.7_safe_level_bypass.patch as it's upstream
* Fri Oct 26 2012 mrueckert@suse.de
- added ruby-1.8.7_safe_level_bypass.patch: (bnc#783511)
  Fixes a SAFE_LEVEL bypass in name_err_to_s and exc_to_s.
  CVE-2012-4464
* Thu Oct 18 2012 coolo@suse.com
- remove build depencency on ca certificates - only causing cycles
* Thu Sep 13 2012 coolo@suse.com
- one more header needed for rubygem-ruby-debug-base19
* Fri Sep  7 2012 coolo@suse.com
- install vm_core.h and its dependencies as ruby-devel-extra
* Wed Aug  1 2012 coolo@suse.com
- move the provides to the ruby package instead
* Fri Jul 27 2012 coolo@suse.com
- add provides for the internal gems
* Thu Jul 26 2012 coolo@suse.com
- fix macros
* Mon Jul  9 2012 coolo@suse.com
- gem_install_wrapper no longer necessary
* Mon Jun  4 2012 idonmez@suse.com
- Add patch to export ruby_init_prelude, ruby bug #5174
* Fri May 11 2012 coolo@suse.com
- there is no obvious use for the vim buildrequires and it's causing
  a build cycle (because vim really requires ruby) - so remove it
* Fri May 11 2012 coolo@suse.com
- rubygem-rake is still named like this
* Thu May 10 2012 coolo@suse.com
- update to 1.9.3 p194
  - update rubygems to 1.8.23 to verify ssl certificates
  - other bug fixes
* Tue May  8 2012 coolo@suse.com
- readd the requires on ruby-common to fix gems suffix
* Sun Mar 11 2012 coolo@suse.com
- let gems of 1.9 install bins without suffix
* Fri Mar  9 2012 coolo@suse.com
- remove provides for ruby and ruby-devel, only generates conflicts
  with wrapper package
* Wed Mar  7 2012 mrueckert@suse.de
- update license:
  Ruby is licensed under BSD 2 Clause or Ruby License now.
* Wed Mar  7 2012 coolo@suse.com
- update to 1.9.3 p125
  - Fix for Ruby OpenSSL module: Allow "0/n splitting" as a
  prevention for the TLS BEAST attack
  - Fixed: LLVM/clang support [Bug #5076]
  - Fixed: GCC 4.7 support [Bug #5851]
  - other bug fixes
* Mon Oct 31 2011 mrueckert@suse.de
- update to 1.9.3 preview 0
* Mon Jul 18 2011 mrueckert@suse.de
- override rb_arch macro from the rpm in the spec file
  rb_arch in rpm is still using host_cpu instead of target_cpu. for
  older distros we will need the override anyway. this allows us to
  reduce the sed part in the marco  to just ppc/powerpc.
- related to the first change:
  pass --target={_target_platform} to configure (we used to do that
  on 1.8 already)
- provide unversioned package names
- rip out bleakhouse support for now to make merging easier
- install macros file
- reorder some file list lines to make merging easier
- use a ruby variable instead of calculating rb_ver in the macros
  file. (more important for 1.8)
* Mon Jul 18 2011 mrueckert@suse.de
- update 1.9.2 p290
  some important fixes:
  - require 'date'; Date.new === nil throws an undefined method
    error for coerce on p180 - this has now been fixed
  - The Thread.kill segfaults when the object to be killed isn't a
    thread bug has been resolved.
  - Tweaks to reduce segmentation faults when using zlib on x86-64
    Darwin (OS X) - always good
  - Modification to prevent random number sequence repetition on
    forked child processes in SecureRandom
  - Fix to io system to resolve a Windows-only bug where characters
    are being read incorrectly due to ASCII not being treated as 7
    bit
  - A tweak to Psych (the YAML parser) to plug a memory leak
  - Load paths are now always expanded by rb_et_expanded_load_path
    (I think this might yield a performance gain?)
  - Fixes to Psych's treatment and testing of string taint
  - Prevention of temporary objects being garbage collected in some
    cases
  - Fixes to resolve compilation problems with Visual C++ 2010
  - A fix so that Tk's extconf.rb would run successfully
  - Lots of Tk related fixes generally
  - A fix to string parsing to resolve an obscure
    symbol-containing-newlines parsing bug
  for the complete changes see /usr/share/doc/packages/ruby19/ChangeLog
- refresh tcl rpath patch:
  old ruby-1.9.2p180_tcl_no_stupid_rpaths.patch
  new ruby-1.9.2p290_tcl_no_stupid_rpaths.patch
* Fri May  6 2011 mrueckert@suse.de
- sync with d:l:r:1.9/ruby19
* Fri May  6 2011 mrueckert@suse.de
- update 1.9.2 p180
- added ruby-1.9.2p180_tcl_no_stupid_rpaths.patch
  - remove the other path entries that are unneeded on our system
- dropped ruby-1.9.1-rc2_gc_64bit_warning.patch
* Thu Aug 26 2010 mrueckert@suse.de
- build fiddle -> new dep libffi
* Thu Aug 26 2010 mrueckert@suse.de
- update to 1.9.2 p0
* Wed Apr  7 2010 mrueckert@suse.de
- split out tk bindings
* Wed Apr  7 2010 mrueckert@suse.de
- fixed tk support, though it still has a warning about missing
  nativethread support in tcl/tk
* Wed Apr  7 2010 mrueckert@suse.de
- update to snapshot of today
* Mon Feb  2 2009 mrueckert@suse.de
- update to p0
- drop ruby-1.9.1-rc2_rb_time_timeval_prototype.patch:
  fix included
* Wed Jan 21 2009 mrueckert@suse.de
- add ruby-1.9.1-rc2_gc_64bit_warning.patch
  do not cast a pointer to int
- add ruby-1.9.1-rc2_rb_time_timeval_prototype.patch
  copy the complete prototype for the function
* Wed Jan 21 2009 mrueckert@suse.de
- update to rc2
- remove ruby-1.9.1-preview2_mkconfig_continued_line.patch:
  included in update
* Mon Dec  8 2008 mrueckert@suse.de
- added ruby-1.9.1-preview2_mkconfig_continued_line.patch:
  handle continued lines with empty values
* Sat Dec  6 2008 mrueckert@suse.de
- initial package
