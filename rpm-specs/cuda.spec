#NOTE: must add elrepo to mock config file in /etc/, otherwise buildrequires fails on nvidia drivers
%define _use_internal_dependency_generator 0
%define our_find_requires %{_builddir}/%{name}-%{version}/find_requires
%define debug_package %{nil}

Name:		cuda
Summary:	NVIDIA CUDA
Version:	5.5
Release:	22.el6
License:	LGPLv2 with exceptions
Group:          System Environment/Libraries
AutoReqProv:	no
Source:         %{name}-%{version}.tar.gz
Buildroot:      %{_builddir}/%{name}-%{version}-root
Requires:	freeglut-devel
Requires:    	glew-devel
Requires:	libXi-devel
Requires:	libXmu-devel
Requires:	nvidia-x11-drv > 319.23
Provides:	libcufft.so.5()(64bit)
Provides:	libcudart.so.5()(64bit)
Provides:       libcublas.so.5()(64bit)

%description
CUDA™ is a parallel computing platform and programming model invented by NVIDIA.
It enables dramatic increases in computing performance by harnessing the power of the graphics processing unit (GPU).

%prep
%setup -qn %{name}-%{version}

# Kludge to remove bogus odbc dependencies
cat <<EOF >%{our_find_requires}
#!/bin/sh
echo unixODBC
exec %{__find_requires} | /bin/egrep -v '^(libodbc(inst)?\.so)$'
exit 0
EOF
chmod +x %{our_find_requires}
%define __find_requires %{our_find_requires}

%build
mkdir -p %{_builddir}/%{name}-%{version}-root/usr/local/cuda
sh cuda_%{version}.22_linux_64.run -silent -toolkit -toolkitpath=%{_builddir}/%{name}-%{version}-root/usr/local/cuda-5.5

%install
install -m 0755 -d $RPM_BUILD_ROOT%{_sysconfdir}/ld.so.conf.d/
echo "/usr/local/cuda/lib64" > $RPM_BUILD_ROOT%{_sysconfdir}/ld.so.conf.d/cuda.conf
echo "/usr/local/cuda/lib" >> $RPM_BUILD_ROOT%{_sysconfdir}/ld.so.conf.d/cuda.conf
echo "/usr/lib64/nvidia" >> $RPM_BUILD_ROOT%{_sysconfdir}/ld.so.conf.d/cuda.conf
install -d %{buildroot}/usr/local
cp -a %{_builddir}/%{name}-%{version}-root/usr/local/cuda-5.5 %{buildroot}/usr/local/cuda

%clean
rm -rf %{buildroot}

%post -p /sbin/ldconfig

%postun -p /sbin/ldconfig

%files
%defattr(-,root,root)
/usr/local/cuda
/etc/ld.so.conf.d
