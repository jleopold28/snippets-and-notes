#source gem is actually HEAD build of puppet-lint
%define debug_package %{nil}
%define rbname gemname
%define version 1.1.1
%define release 1

Summary: Gems to install puppet-lint, rspec-puppet, and serverspec
Name: ruby-gems-%{rbname}

Version: %{version}
Release: %{release}.el6
Group: Development/Ruby
License: Mixed
URL: http://rubygems.org
Source0: puppet-lint-1.1.1.gem
BuildRoot: %{_tmppath}/%{name}-%{version}-root
BuildArch: noarch
BuildRequires: puppet-agent >= 1.3.6
Requires: puppet-agent >= 1.3.6

%define gemdir /opt/puppetlabs/puppet/lib/ruby/gems/2.1.0
%define gembuilddir %{buildroot}%{gemdir}
%define puppetbin /opt/puppetlabs/puppet/bin

%description
Gems to install puppet-lint, rspec-puppet, and serverspec

%prep
%setup -T -c

%build

%install
%{__rm} -rf %{buildroot}
mkdir -p %{gembuilddir}
%{puppetbin}/gem install --local --install-dir %{gembuilddir} %{SOURCE0}
%{puppetbin}/gem install --install-dir %{gembuilddir} rspec-puppet
%{puppetbin}/gem install --install-dir %{gembuilddir} serverspec
mkdir -p %{buildroot}%{puppetbin}
mv %{gembuilddir}/bin/puppet-lint %{buildroot}/%{puppetbin}/.
mv %{gembuilddir}/bin/rspec-puppet-init %{buildroot}/%{puppetbin}/.
mv %{gembuilddir}/bin/serverspec-init %{buildroot}/%{puppetbin}/.

%clean
%{__rm} -rf %{buildroot}

%files
%defattr(-, root, root)
%{puppetbin}
%{gemdir}
%doc

%changelog
* Mon Feb 22 2016 Matt Schuchard <name@domain> 1.1.1-1
- Changelog
