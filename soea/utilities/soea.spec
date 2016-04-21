%define debug_package %{nil}

Name: soea
Summary: Single Objective Evolutionary Algorithm
Version: beta
Release: BUILDID.el6
License: Proprietary
Group: Applications/Engineering
Source: soea-%{version}.tar.gz
BuildRoot: %{_builddir}/%{name}-%{version}-root
BuildRequires: pugixml-devel >= 1.2
BuildRequires: gcc48-c++
BuildRequires: cmake28
BuildRequires: mysql++-devel

%description
SOEA is a genetic algorithm that aggressively and efficiently optimizes a single objective.

%prep
%setup -q

%build
/usr/bin/cmake28 -D RELEASE:BOOL=TRUE -D EL6:BOOL=TRUE CMakeLists.txt
make -j 4

%install
mkdir -p %{buildroot}%{_bindir}
cp -a soea %{buildroot}%{_bindir}/.
mkdir -p %{buildroot}%{_datadir}/soea

%clean
rm -rf $RPM_BUILD_ROOT 

%post 

%postun 

%files 
%defattr(-, root, root)
%{_bindir}
%{_datadir}/soea

%changelog
* Wed Jul 30 2014 - beta-BUILDID
- Beta

* Mon Jul 14 2014 - alpha-40
- Alpha
