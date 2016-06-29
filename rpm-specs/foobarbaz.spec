%define debug_package %{nil}

Name: 		foobarbaz
Version: 	3
Release: 	1.el7
Summary: 	foobarbaz
Group: 		Silly
License: 	GNU
URL: 		  http://www.internet.com
Source0:	foobarbaz-%{version}.tar.gz

Requires: foolicious = 1
Requires: bartastic = 2
Requires: baznificient = 1

%description
foobarbaz

%package -n foolicious
Version: 1
Summary: foo
Group: Silly

%description -n foolicious
foo

%package -n bartastic
Version: 2
Summary: bar
Group: Silly

%description -n bartastic
bar

%package -n baznificient
Version: 1
Summary: baz
Group: Silly

%description -n baznificient
baz

%prep
%setup -qn foobarbaz

%build

%install
mkdir %{buildroot}%{_sysconfdir}
cp -a * %{buildroot}%{_sysconfdir}/.
touch %{buildroot}%{_sysconfdir}/foobarbaz

%files
%{_sysconfdir}/foobarbaz

%files -n foolicious
%{_sysconfdir}/foo

%files -n bartastic
%{_sysconfdir}/bar

%files -n baznificient
%{_sysconfdir}/baz

%changelog
