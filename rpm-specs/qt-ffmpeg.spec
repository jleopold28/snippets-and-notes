#note for future releases: config.pro heavily edited in tarball
%define debug_package %{nil}

Name: qt-ffmpeg
Summary: Qt FFmpeg Wrapper for video frame encoding and decoding
Version: 72013
Release: 2.el6
License: New BSD License
Group: System Environment/Libraries
Url: http://code.google.com/p/qtffmpegwrapper
Source0: qt-ffmpeg-%{version}.tar.gz
BuildRoot: %{_builddir}/%{name}-%{version}-%{release}-root

BuildRequires: qt-devel >= 4.6
BuildRequires: ffmpeg-devel >= 0.10

%description
QtFFmpegWrapper provides a set of QT classes wrapping FFMPEG and allowing for video encoding and video decoding (no audio). It uses QT QImage to exchange video frames with the encoder/decoder.

%package devel

Summary:    Qt FFmpeg Wrapper for video frame encoding and decoding development files
Group:      System Environment/Libraries
Requires:   %{name} = %{version}-%{release}

%description devel
QtFFmpegWrapper provides a set of QT classes wrapping FFMPEG and allowing for video encoding and video decoding (no audio). It uses QT QImage to exchange video frames with the encoder/decoder.

%prep
%setup -q

%build
/usr/bin/qmake-qt4
/usr/bin/make

%install
/bin/mkdir -p %{buildroot}%{_libdir}
/bin/cp -a libQtFFmpeg.so.1.0.0 %{buildroot}%{_libdir}/libQtFFmpeg.so.72013
/bin/ln -s /usr/lib64/libQtFFmpeg.so.72013 %{buildroot}%{_libdir}/libQtFFmpeg.so

/bin/mkdir -p %{buildroot}%{_includedir}/QtFFmpeg
/bin/cp -a *.h %{buildroot}%{_includedir}/QtFFmpeg/.

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%files
%{_libdir}/libQtFFmpeg.so.72013

%files devel
%{_libdir}/libQtFFmpeg.so
%{_includedir}/QtFFmpeg

%changelog
* Wed May 7 2014 - 72013-2
- Fixed bad library symlink.

* Fri Jul 5 2013 - 72013-1
- Updated to be compatible with Qt5.

* Sat Mar 17 2012 - 32012-1
- New API encodeImagePts to set the presentation time stamp of a frame. This allows to create variable frame rate videos. See the example. 

* Sun Aug 21 2011 - 92011-1
- Migrated the repository from mercurial to subversion. The revision history is lost - the last mercurial version is the first checkin of the subversion.
- QVideoEncoder now allows to specify the video fps (previously fixed to 25)
