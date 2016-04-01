#NOTE: must add elrepo to mock config file in /etc/, otherwise buildrequires fails on nvidia drivers
%define _use_internal_dependency_generator 0
%define our_find_requires %{_builddir}/%{name}-%{version}/find_requires
%define debug_package %{nil}

Name:		cuda4
Summary:	NVIDIA Cuda
Version:	4.2.9
Release:	1
License:	LGPLv2 with exceptions
Group:          System Environment/Libraries
AutoReqProv:	no
Source:         %{name}-%{version}.tar.gz
Buildroot:      %{_builddir}/%{name}-%{version}-root
BuildRequires:	freeglut-devel
BuildRequires:	libXi-devel
BuildRequires:	libXmu-devel
BuildRequires:	nvidia-x11-drv
Provides:	libcufft.so.4()(64bit)
Provides:	libcudart.so.4()(64bit)
Provides:       libcublas.so.4()(64bit)
Provides:       libcutil.a()(64bit)
Provides:       libparamgl.a()(64bit)
Provides:       librendercheckgl.a()(64bit)

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
mkdir -p %{_builddir}/%{name}-%{version}-root/usr/share/cuda
sh cudatoolkit_%{version}_linux_64_rhel6.0.run -- \
  --prefix=%{_builddir}/%{name}-%{version}-root/usr/share/cuda
sh gpucomputingsdk_%{version}_linux.run -- \
  --prefix=%{_builddir}/%{name}-%{version}-root/usr/share/cuda \
  --cuda=%{_builddir}/%{name}-%{version}-root/usr/share/cuda
cd %{_builddir}/%{name}-%{version}-root/usr/share/cuda/C
sed -ir 's/-lcuda/-L\/usr\/lib64\/nvidia\ -lcuda/' %{_builddir}/%{name}-%{version}-root/usr/share/cuda/C/common/common.mk
rm %{_builddir}/%{name}-%{version}-root/usr/share/cuda/C/common/common.mkr
make -j 8
make -j 8 dbg=1

%install
install -m 0755 -d $RPM_BUILD_ROOT%{_sysconfdir}/ld.so.conf.d/
echo "/usr/share/cuda/lib64" > $RPM_BUILD_ROOT%{_sysconfdir}/ld.so.conf.d/cuda4.conf
echo "/usr/share/cuda/lib" >> $RPM_BUILD_ROOT%{_sysconfdir}/ld.so.conf.d/cuda4.conf
echo "/usr/lib64/nvidia" >> $RPM_BUILD_ROOT%{_sysconfdir}/ld.so.conf.d/cuda4.conf
install -d %{buildroot}/usr/share
cp -a %{_builddir}/%{name}-%{version}-root/usr/share/cuda %{buildroot}/usr/share/.

%post -p /sbin/ldconfig

%postun -p /sbin/ldconfig

%clean

%files
%defattr(-,root,root)
/usr/share/cuda
/etc/ld.so.conf.d
