Summary: Libraries for distributed computing.
Name: pvm
Version: 3.4.6
Release: 2
Source: %{name}-%{version}.tar.gz
License: MIT and GPLv2+
Group: System Environment/Libraries
BuildRoot: %{_builddir}/%{name}-%{version}-root
BuildRequires: autoconf

%description
PVM3 (Parallel Virtual Machine) is a library and daemon that allows distributed processing environments to be constructed on heterogeneous machines and architectures.  Packaged with additional shared memory library and unofficial second release tag to disable being replaced with official RPM during an update.

%prep
%setup -q

%build
export PVM_ROOT=%{_builddir}/%{name}-%{version}
mkdir -p %{_builddir}/%{name}-%{version}-root/usr/share/doc/pvm-3.4.6 %{_builddir}/%{name}-%{version}-root/usr/share/man/man1 %{_builddir}/%{name}-%{version}-root/usr/share/man/man3 %{_builddir}/%{name}-%{version}-root/usr/share/pvm3 %{_builddir}/%{name}-%{version}-root/var/run/pvm3 %{_builddir}/%{name}-%{version}-root/usr/bin
sed -i 's/\(#\)\(\REGEXCONF*\)/\2/' %{_builddir}/%{name}-%{version}/src/Makefile.aimk
sed -i 's/\(#\)\(\REGEXCONFOS2*\)/\2/' %{_builddir}/%{name}-%{version}/src/Makefile.aimk
sed -i 's/\(#\)\(\REGEXOBJS*\)/\2/' %{_builddir}/%{name}-%{version}/src/Makefile.aimk
make -j 8

%install
export PVM_ROOT=%{_builddir}/%{name}-%{version}
mkdir -p %{buildroot}/usr/bin %{buildroot}/usr/share/doc/pvm-3.4.6 %{buildroot}/usr/share/pvm3 %{buildroot}/usr/share/man/man1 %{buildroot}/usr/share/man/man3
make install
cd %{_builddir}/%{name}-%{version}/shmd
../lib/aimk
/bin/cp -a %{_builddir}/%{name}-%{version}/console/LINUX64/pvm %{buildroot}/usr/bin
/bin/mv %{_builddir}/%{name}-%{version}/doc/* %{buildroot}/usr/share/doc/pvm-3.4.6
/bin/rmdir %{_builddir}/%{name}-%{version}/doc
/bin/mv %{_builddir}/%{name}-%{version}/man/man1/* %{buildroot}/usr/share/man/man1
/bin/mv %{_builddir}/%{name}-%{version}/man/man3/* %{buildroot}/usr/share/man/man3
/bin/rm -rf %{_builddir}/%{name}-%{version}/man
/bin/mv %{_builddir}/%{name}-%{version}/* %{buildroot}/usr/share/pvm3


%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
/usr/bin
/usr/share
