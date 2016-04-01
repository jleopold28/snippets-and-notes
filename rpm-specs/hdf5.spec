%define debug_package %{nil}

Name: hdf5
Summary: The HDF5 Data Collection Libraries
Version: 1.8.10
Release: 1.el5
License: BSD-style
Group: System Environment/Development/Libraries
Source: hdf5-1.8.10.tar.gz
URL: http://www.hdfgroup.org/HDF5
Buildroot: %{_tmppath}/%{name}-%{version}-%{release}-root
BuildRequires: gcc-c++, gcc-gfortran, ed
Requires: zlib
Requires: zlib-devel
Requires(post): /sbin/ldconfig
Requires(postun): /sbin/ldconfig
Prefix: /usr

%description					
The HDF5 technology suite includes:
    * A versatile data model that can represent very complex data objects and a wide variety of metadata.
    * A completely portable file format with no limit on the number or size of data objects in the collection.
    * A software library that runs on a range of computational platforms, from laptops to massively parallel systems, and implements a high-level API with C, C++, Fortran 90, and Java interfaces.
    * A rich set of integrated performance features that allow for access time and storage space optimizations.
    * Tools and applications for managing, manipulating, viewing, and analyzing the data in the collection.
The HDF5 data model, file format, API, library, and tools are open and distributed without charge.

%package devel
Summary: The HDF5 headers and development libraries
Group: System Environment/Libraries
Requires: hdf5 = %{version}-%{release}

%description devel
Headers, static libraries, and examples for the HDF5 libraries.

%prep				
%setup -n hdf5-1.8.10

%build				
			#macro used to configure the package with standard ./configure command
%configure --enable-fortran --enable-cxx --enable-static-exec --with-zlib=/usr

make				
                        # Some variable paths in h5cc and friends are set to /usr/...
                        # by configure.  A permanent solution is needed, but this will
                        # put the variables back for this release.
/bin/echo -e "/^exec_prefix/c\nexec_prefix="${prefix}"\n.\n/^libdir/c\nlibdir="${exec_prefix}/lib"\n.\n/^includedir/c\nincludedir="${prefix}/include"\n.\nw\nq" > ./scredfile
/bin/ed - ./tools/misc/h5cc < ./scredfile
/bin/ed - ./c++/src/h5c++ < ./scredfile
/bin/ed - ./fortran/src/h5fc < ./scredfile
/bin/rm -f ./scredfile

%install			
rm -rf $RPM_BUILD_ROOT		
make install DESTDIR=$RPM_BUILD_ROOT	

%post
if test `whoami` == root; then
   echo "Running /sbin/ldconfig"
   /sbin/ldconfig
fi
#%if $RPM_INSTALL_PREFIX != "/usr"
(cd $RPM_INSTALL_PREFIX/bin
  ./h5redeploy -force)
#%endif


%clean				
rm -rf $RPM_BUILD_ROOT		

%postun
if test `whoami` == root; then
   echo "Running /sbin/ldconfig"
   /sbin/ldconfig
fi

%files				
%defattr(-,root,root)			
%{_bindir}/*
%{_libdir}/*.so*
%doc ./COPYING
%doc ./release_docs/RELEASE.txt

%files devel
%defattr(-,root,root)			
%{_includedir}/*
%{_libdir}/*.a
%{_libdir}/*.la
%{_libdir}/libhdf5.settings
%dir %{_datadir}/hdf5_examples
%{_datadir}/hdf5_examples/*

#list of changes to this spec file since last version.
%changelog
* Thu Nov 1 2012 Larry Knox
lrknox@hdfgroup.org 1.8.10-1
- Created initial RPM for HDF5 1.8.10 release.

%changelog devel
* Thu Nov 1 2012 Larry Knox
lrknox@hdfgroup.org 1.8.10-1
- Created initial RPM for HDF5 1.8.10 release.
