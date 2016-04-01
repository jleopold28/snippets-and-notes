%define debug_package %{nil}

Name:          qwtpolar
Version:       1.0.1
Release:       2.el6
Summary:       Qwt/Qt Polar Plot Library
Group:         System Environment/Libraries
License:       LGPLv2 with exceptions
URL:           http://qwtpolar.sourceforge.net
Source0:       http://downloads.sourceforge.net/%{name}/%{name}-%{version}.tar.bz2

Patch0:        %{name}-1.0.1-paths.patch
# fix qreal != double assumptions (for arm)
Patch1:        qwtpolar-1.0.1-qreal.patch

BuildRequires: qwt-devel = 6.0.1

%description
The QwtPolar library contains classes for displaying values on a polar
coordinate system. It is an add-on package for the Qwt Library.

%package devel
Summary:        Development Libraries for %{name}
Group:          Development/Libraries
Requires:       %{name}%{?_isa} = %{version}-%{release}

%description devel
This package contains the files necessary
to develop applications using QwtPolar.

%package doc
Summary:        Developer documentation for %{name}
BuildArch:      noarch

%description doc
This package contains developer documentation for QwtPolar.


%prep
%setup -q
%patch0 -p1 -b .paths
%patch1 -p1 -b .qreal

rm -rf doc/man
chmod 644 COPYING


%build
%{?_qt4_qmake} CONFIG+=install-qt
make %{?_smp_mflags}
#hilarious hack to fix qt_install_path bug in mkspecs (this is fixed in 1.1.0)
mv qwtpolarconfig.hak qwtpolarconfig.pri

%install
make install INSTALL_ROOT=%{buildroot}

mv %{buildroot}/%{_qt4_docdir}/html/html \
   %{buildroot}/%{_qt4_docdir}/html/%{name}

%post -p /sbin/ldconfig

%postun -p /sbin/ldconfig


%files 
%doc COPYING CHANGES
%{_libdir}/lib%{name}.so.*
%{?_qt4_plugindir}/designer/libqwt_polar_designer_plugin.so

%files devel
%{_includedir}/qwt_polar*.h
%{_libdir}/lib%{name}.so
%{_qt4_libdir}/qt4/mkspecs/features/%{name}*

%files doc
%doc examples
# Own these to avoid needless dep on qt/qt-doc
%dir %{_qt4_docdir}
%dir %{_qt4_docdir}/html/
%{_qt4_docdir}/html/%{name}/


%changelog
* Fri Apr 18 2014 - 1.0.1-2
- added qt_install_path macro hack so mkspecs configure correctly (fixed appropriately in newer version)

* Tue Dec 18 2012 Rex Dieter <rdieter@fedoraproject.org> 1.0.1-1.1
- fix qreal != double assumptions (for arm)

* Sat Nov 24 2012 Volker Fröhlich <volker27@gmx.at> 1.0.1-1
- New upstream release
- Move designer plug-in to main package
- Split off doc sub-package
- Add isa macro to Requires of devel
- Make better use of qt macros

* Sat Jul 21 2012 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 0.1.0-7
- Rebuilt for https://fedoraproject.org/wiki/Fedora_18_Mass_Rebuild

* Sat Jan 14 2012 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 0.1.0-6
- Rebuilt for https://fedoraproject.org/wiki/Fedora_17_Mass_Rebuild

* Mon Jul 11 2011 Volker Fröhlich <volker27@gmx.at> 0.1.0-5
- Don't build with multiple workers

* Thu Jul 07 2011 Volker Fröhlich <volker27@gmx.at> 0.1.0-4
- Replace optimization on linker call and remove pthread link
- Explicit make call
- Produce proper developer documentation
- Drop defattr lines

* Mon Jun 06 2011 Volker Fröhlich <volker27@gmx.at> 0.1.0-3
- Removed waste word from description

* Sat May 21 2011 Volker Fröhlich <volker27@gmx.at> 0.1.0-2
- Use upstream's summary

* Sat May 21 2011 Volker Fröhlich <volker27@gmx.at> 0.1.0-1
- Initial packaging for Fedora
