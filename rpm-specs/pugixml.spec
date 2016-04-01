%define debug_package %{nil}

Name:           pugixml
Version:        1.4
Release:        2.el6
Summary:        A light-weight C++ XML processing library
Group:          Development/Libraries
License:        MIT
URL:            http://pugixml.org
Source0:        http://pugixml.googlecode.com/files/%{name}-%{version}.tar.gz

BuildRequires:  cmake

%description
pugixml is a light-weight C++ XML processing library.
It features:
- DOM-like interface with rich traversal/modification capabilities
- Extremely fast non-validating XML parser which constructs the DOM tree from
  an XML file/buffer
- XPath 1.0 implementation for complex data-driven tree queries
- Full Unicode support with Unicode interface variants and automatic encoding
  conversions


%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name}%{?_isa} = %{version}-%{release}

%description devel
Development files for package %{name}.

%prep
%setup -q

%build
cd scripts
#cmakelists file was directly edited for fixes since patching was failing before i realized the spec file from epel erroneously had a "-c" passed to setup
%cmake CMakeLists.txt
make

%install
mkdir -p %{buildroot}%{_includedir}
mkdir -p %{buildroot}%{_datadir}/%{name}
mkdir -p %{buildroot}%{_libdir}
mkdir -p %{buildroot}%{_docdir}/%{name}

install -p -m 0644 contrib/* %{buildroot}%{_datadir}/%{name}/
install -p -m 0644 readme.txt %{buildroot}%{_docdir}/%{name}/
cp -a docs/* %{buildroot}%{_docdir}/%{name}/
install -p -m 0644 src/*.hpp %{buildroot}%{_includedir}/
install -p -m 0755 scripts/lib%{name}.so.%{version} %{buildroot}%{_libdir}/
cp -a scripts/lib%{name}.so.1 %{buildroot}%{_libdir}/
cp -a scripts/lib%{name}.so %{buildroot}%{_libdir}/

%post -p /sbin/ldconfig

%postun -p /sbin/ldconfig

%files
%{_docdir}/%{name}/readme.txt
%{_libdir}/*.so.*

%files devel
%exclude %{_docdir}/%{name}/readme.txt
%{_docdir}
%{_libdir}/*.so
%{_datadir}/%{name}
%{_includedir}/*.hpp


%changelog
* Wed Jul 23 2014 - 1.4-2
- Fixed lib symlink problem.

* Mon Jul 07 2014 - 1.4-1
- Initial builds for EL6 and EL7 with upstream source.

* Wed Apr 25 2012 Richard Shaw <hobbes1069@gmail.com> - 1.0-3
- Inital build for EPEL.

* Sat Jan 14 2012 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 1.0-3
- Rebuilt for https://fedoraproject.org/wiki/Fedora_17_Mass_Rebuild

* Thu Jan 05 2012 Richard Shaw <hobbes1069@gmail.com> - 1.0-2
- Rebuild for GCC 4.7.0.

* Fri Jul 08 2011 Richard Shaw <hobbes1069@gmail.com> - 1.0-1
- Initial Release
