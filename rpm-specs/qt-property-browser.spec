%define debug_package %{nil}

Name: qt-propery-browser
Summary: Component of discontinued Qt Solutions collection
Version: 42013
Release: 1.el6
License: Abandoned/Open
Group: System Environment/Libraries
Url: https://qt.gitorious.org/qt-solutions
Source0: qt-property-browser-%{version}.tar.gz
BuildRoot: %{_builddir}/%{name}-%{version}-%{release}-root

BuildRequires: qt-devel >= 4.0

%description
The Qt Property Browser library and documentation

%package devel

Summary:    Discontinued component of Qt
Group:      System Environment/Libraries
Requires:   %{name} = %{version}-%{release}

%description devel
The Qt Property Browser development headers and library

%prep
%setup -q

%build
/bin/sh configure
/usr/bin/qmake-qt4
/usr/bin/make

%install
/bin/mkdir -p %{buildroot}%{_libdir}
/bin/cp -a lib/libQtSolutions_PropertyBrowser-head.so.1.0.0 %{buildroot}%{_libdir}/libQtPropertyBrowser.so.42013
/bin/ln -s /usr/lib64/libQtPropertyBrowser.so.42013 %{buildroot}%{_libdir}/libQtPropertyBrowser.so

/bin/mkdir -p %{buildroot}%{_docdir}
/bin/cp -a doc %{buildroot}%{_docdir}/qt-property-browser-42013

/bin/mkdir -p %{buildroot}%{_includedir}
/bin/mkdir %{buildroot}%{_includedir}/QtPropertyBrowser
/bin/cp -a src/*.h %{buildroot}%{_includedir}/QtPropertyBrowser/.

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%files
%{_libdir}/libQtPropertyBrowser.so.42013
%{_docdir}/qt-property-browser-42013

%files devel
%{_libdir}/libQtPropertyBrowser.so
%{_includedir}/QtPropertyBrowser

%changelog
* Thu Mar 6 2014 - 42013-1
- Initial Build and Release for EL6
