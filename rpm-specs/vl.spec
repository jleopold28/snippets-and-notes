%define debug_package %{nil}

Name: vl
Version: 1.3.2
Release: 3.el6
Summary: Vector Library
Source: vl-%{version}.tar.gz
License: BSD-like
Group: System Environment/Libraries
BuildRoot: /var/tmp/%{name}-root
Prefix: /usr
URL: http://www.cs.cmu.edu/~ajw/software/

%description 
VL is a C++ vector library, oriented towards graphics use, having optimized
2-, 3- and 4-vectors as well as generic vectors and matrices, sparse vectors
and matrices, inline mathematic operations, and lots of other stuff.

%prep
%setup -n vl-%{version}

%build
#change from static archive to shared object
sed -i 's/\.a/\.so/' %{_builddir}/%{name}-%{version}/makefiles/lib.mf
sed -i 's/ar rcu/gcc \$\(LD_FLAGS\) -o/' %{_builddir}/%{name}-%{version}/makefiles/lib.mf
#technically the below LD_FLAGS reassignment propagates to executable linker flags, but there are no executables in vl so the prog.mf is superfluous and we can safely do this
sed -i 's/LD_FLAGS    \=/LD_FLAGS \= -fPIC -shared/' %{_builddir}/%{name}-%{version}/makefiles/config-linux_RH.mf
make linux_RH
make

%install
rm -rf $RPM_BUILD_ROOT
#64-bit install location
sed -i 's/\/lib/\/lib64/' %{_builddir}/%{name}-%{version}/Makefile
sed -i 's/\/lib/\/lib64/' %{_builddir}/%{name}-%{version}/makefiles/lib.mf
make DEST=$RPM_BUILD_ROOT/usr install
rm -r $RPM_BUILD_ROOT/usr/doc

%clean
rm -rf $RPM_BUILD_ROOT

%files
%doc README LICENSE doc/vl.html
/usr/include/*
/usr/lib64/*

%changelog
* Fri Apr 18 2014 - 1.3.2-3
- removed dependency on compact-gcc34 by updating use of iostream/iomanip in code

* Wed Sep 18 2013 - 1.3.2-2
- changed libraries from 32-bit static archives to 64-bit shared objects

* Wed Aug 14 2013 - 1.3.2-1
- initial release
