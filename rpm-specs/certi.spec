Summary: ceRTI
Name: CERTI
Version: 3.4.0
Release: 1
Source0: %{name}-%{version}.tar.gz
License: RTI Software License
Group: System Environment/Libraries
BuildRoot: %{_builddir}/%{name}-%{version}-root
BuildRequires: cmake
BuildRequires: bison
BuildRequires: flex
BuildRequires: libxml2

%description
ceRTI

%prep
%setup -q

%build
mkdir -p %{_builddir}/build_%{name}-%{version}
mkdir -p %{_builddir}/%{name}-%{version}-root/usr
cd %{_builddir}/build_%{name}-%{version}
cmake -DCMAKE_INSTALL_PREFIX=%{_builddir}/%{name}-%{version}-root/usr ../%{name}-%{version}
make -j 8

%install
cd %{_builddir}/build_%{name}-%{version}
make install
cp -a %{_builddir}/%{name}-%{version}-root/usr %{buildroot}/.

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
/usr
