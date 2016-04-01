Name:		levmar	
Version:	2.6
Release:	1%{?dist}
Summary:	Levenberg-Marquardt nonlinear least squares algorithm
Group:		System Environment/Libraries
License:	GPLv2+
URL:		http://www.ics.forth.gr/~lourakis/levmar/
Source0:	%{name}-%{version}.tgz
BuildRoot:	%{_builddir}/%{name}-%{version}-root
BuildRequires:	dos2unix

%description
levmar is a native ANSI C implementation of the Levenberg-Marquardt
optimization algorithm.  Both unconstrained and constrained (under linear
equations, inequality and box constraints) Levenberg-Marquardt variants are
included.  The LM algorithm is an iterative technique that finds a local
minimum of a function that is expressed as the sum of squares of nonlinear
functions.  It has become a standard technique for nonlinear least-squares
problems and can be thought of as a combination of steepest descent and the
Gauss-Newton method.  When the current solution is far from the correct on,
the algorithm behaves like a steepest descent method: slow, but guaranteed
to converge.  When the current solution is close to the correct solution, it
becomes a Gauss-Newton method.

%prep
%setup -q
dos2unix -k README.txt

%build
mkdir -p %{_builddir}/%{name}-%{version}-root/build
sed -i '/#define HAVE_LAPACK/d' %{_builddir}/%{name}-%{version}/levmar.h
make liblevmar.a 

%install
rm -rf %{buildroot}
mkdir -p %{_builddir}/%{name}-%{version}-root/usr/include/liblevmar
install -D -p -m 755 liblevmar.a %{buildroot}%{_libdir}/liblevmar.a
install -D -p -m 644 compiler.h %{buildroot}%{_includedir}/liblevmar/compiler.h
install -D -p -m 644 levmar.h %{buildroot}%{_includedir}/liblevmar/levmar.h
install -D -p -m 644 lm.h %{buildroot}%{_includedir}/liblevmar/lm.h
install -D -p -m 644 misc.h %{buildroot}%{_includedir}/liblevmar/misc.h

%clean
rm -rf %{buildroot}

%post -p /sbin/ldconfig

%postun -p /sbin/ldconfig

%files
%defattr(-,root,root,-)
%doc README.txt LICENSE
/usr/include/liblevmar
/usr/lib64/liblevmar.a

%changelog

