%define debug_package %{nil}

# trim changelog included in binary rpms
%global _changelog_trimtime %(date +%s -d "1 year ago")

Name:    qwt
Summary: Qt Widgets for Technical Applications
Version: 6.1.0
Release: 1.el6

License: LGPLv2 with exceptions
URL:     http://qwt.sourceforge.net
Group:   System Environment/Libraries
Source:  http://downloads.sourceforge.net/%{name}/%{name}-%{version}.tar.bz2

## upstreamable patches
# add pkgconfig support
Patch50: qwt-6.1.0-pkgconfig.patch
# use QT_INSTALL_ paths instead of custom prefix
Patch51: qwt-6.1.0-qt_install_paths.patch

BuildRequires: pkgconfig(QtGui) pkgconfig(QtSvg)
%{?_qt4_version:Requires: qt4%{?_isa} >= %{_qt4_version}}

Provides: qwt6 = %{version}-%{release}
Provides: qwt6%{_isa} = %{version}-%{release}

%description
The Qwt library contains GUI Components and utility classes which are primarily
useful for programs with a technical background.
Besides a 2D plot widget it provides scales, sliders, dials, compasses,
thermometers, wheels and knobs to control or display values, arrays
or ranges of type double.

%package devel
Summary:  Development files for %{name}
Provides: qwt6-devel = %{version}-%{release}
Provides: qwt6-devel%{_isa} = %{version}-%{release}
Requires: %{name}%{?_isa} = %{version}-%{release}
%description devel
%{summary}.

%package doc
Summary: Developer documentation for %{name}
BuildArch: noarch
%description doc
%{summary}.



%prep
%setup -q

%patch50 -p1 -b .pkgconfig
%patch51 -p1 -b .qt_install_paths

%build
%{?_qt4_qmake}

make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make install INSTALL_ROOT=%{buildroot}

# fixup doc path bogosity
mv %{buildroot}%{_qt4_docdir}/html/html \
   %{buildroot}%{_qt4_docdir}/html/qwt

mkdir -p %{buildroot}%{_mandir}
mv %{buildroot}%{_qt4_docdir}/html/man/man3 \
   %{buildroot}%{_mandir}/


%clean
rm -rf $RPM_BUILD_ROOT

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%files
%defattr(-,root,root,-)
%doc COPYING
%doc README
%{_qt4_libdir}/libqwt.so.6*
%{?_qt4_plugindir}/designer/libqwt_designer_plugin.so
# subpkg ? -- rex
%{_qt4_libdir}/libqwtmathml.so.6*

%files devel
%defattr(-,root,root,-)
%{_qt4_headerdir}/qwt/
%{_qt4_libdir}/libqwt.so
%{_qt4_libdir}/libqwtmathml.so
%{_qt4_libdir}/qt4/mkspecs/features/qwt*
%{_qt4_libdir}/pkgconfig/qwt.pc

%files doc
%defattr(-,root,root,-)
# own these to avoid needless dep on qt/qt-doc
%dir %{_qt4_docdir}
%dir %{_qt4_docdir}/html/
%{_qt4_docdir}/html/qwt/
%{_mandir}/man3/*


%changelog
* Tue Oct 29 2013 Rex Dieter <rdieter@fedoraproject.org> - 6.1.0-1
- qwt-6.1.0
- QtDesigner plugin doesn't link to the proper header directory path (#824447)

* Sun Aug 04 2013 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 6.0.1-4
- Rebuilt for https://fedoraproject.org/wiki/Fedora_20_Mass_Rebuild

* Thu Feb 14 2013 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 6.0.1-3
- Rebuilt for https://fedoraproject.org/wiki/Fedora_19_Mass_Rebuild

* Mon Nov 26 2012 Rex Dieter <rdieter@fedoraproject.org> 6.0.1-2
- qwtbuild.pri: drop CONFIG+=silent

* Tue Aug 14 2012 Rex Dieter <rdieter@fedoraproject.org> - 6.0.1-1
- qwt-6.0.1 (#697168)
- add pkgconfig support

* Fri Aug 03 2012 Rex Dieter <rdieter@fedoraproject.org> 5.2.2-6
- qwt*.pc : +Requires: QtGui QtSvg

* Thu Aug 02 2012 Rex Dieter <rdieter@fedoraproject.org> 5.2.2-5
- pkgconfig support

* Tue Jul 31 2012 Rex Dieter <rdieter@fedoraproject.org> - 5.2.2-4
- Provides: qwt5-qt4(-devel)
- pkgconfig-style deps
 
- * Sat Jul 21 2012 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 5.2.2-3
- Rebuilt for https://fedoraproject.org/wiki/Fedora_18_Mass_Rebuild

* Sat Jan 14 2012 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 5.2.2-2
- Rebuilt for https://fedoraproject.org/wiki/Fedora_17_Mass_Rebuild

* Sun Aug 07 2011 Rex Dieter <rdieter@fedoraproject.org> 5.2.2-1
- 5.2.2

* Thu Jul 14 2011 Rex Dieter <rdieter@fedoraproject.org> 5.2.1-3
- .spec cosmetics
- use %%_qt4_ macros
- -doc subpkg here (instead of separately built)

* Tue Feb 08 2011 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 5.2.1-2
- Rebuilt for https://fedoraproject.org/wiki/Fedora_15_Mass_Rebuild

* Fri Apr 16 2010 Frank Büttner <frank-buettner@gmx.net> - 5.2.1-1
- update to 5.2.1 

* Fri Feb 05 2010 Frank Büttner <frank-buettner@gmx.net> - 5.2.0-1
- fix wrong lib names

* Fri Feb 05 2010 Frank Büttner <frank-buettner@gmx.net> - 5.2.0-0
- update to 5.2.0

* Sun Jul 26 2009 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 5.1.1-4
- Rebuilt for https://fedoraproject.org/wiki/Fedora_12_Mass_Rebuild

* Wed Feb 25 2009 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 5.1.1-3
- Rebuilt for https://fedoraproject.org/wiki/Fedora_11_Mass_Rebuild

* Sun Jan 04 2009 Frank Büttner <frank-buettner@gmx.net> - 5.1.1-2
 - modify path patch

* Sun Jan 04 2009 Frank Büttner <frank-buettner@gmx.net> - 5.1.1-1
 -update to 5.1.1

* Mon Feb 18 2008 Fedora Release Engineering <rel-eng@fedoraproject.org> - 5.0.2-6
- Autorebuild for GCC 4.3

* Sat Sep 29 2007 Frank Büttner <frank-buettner@gmx.net> - 5.0.2-5
 - add EPEL support

* Sat Sep 29 2007 Frank Büttner <frank-buettner@gmx.net> - 5.0.2-4
- remove parallel build, because it will fail sometimes

* Fri Sep 28 2007 Frank Büttner <frank-buettner@gmx.net> - 5.0.2-3
- fix some errors in the spec file

* Fri Jul 06 2007 Frank Büttner <frank-buettner@gmx.net> - 5.0.2-2
- fix some errors in the spec file

* Mon Jun 11 2007 Frank Büttner <frank-buettner@gmx.net> - 5.0.2-1
- update to 5.0.2
- split doc

* Thu May 15 2007 Frank Büttner <frank-buettner@gmx.net> - 5.0.1-1
 - start

