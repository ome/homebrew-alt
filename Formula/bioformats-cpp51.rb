require 'formula'

class BioformatsCpp51 < Formula
  homepage "http://www.openmicroscopy.org/site/products/bio-formats"
  url "http://downloads.openmicroscopy.org/bio-formats/5.1.2/artifacts/bioformats-5.1.2.zip"
  sha1 "b39f78ef63beb599633d34c1778239a5bfed9a88"
  head "https://github.com/openmicroscopy/bioformats.git"

  option "without-check", "Skip build time tests (not recommended)"
  option "with-qt5", "Build with Qt5 (used for OpenGL image rendering)"
  option "with-docs", "Build API reference and manual pages"

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "libpng" => :build
  depends_on "libtiff" => :build
  depends_on "xerces-c" => :build
  depends_on "graphicsmagick" => :optional if build.with? "check"
  depends_on "qt5" => :build if build.with? "qt5"
  depends_on "glm" => :build if build.with? "qt5"
  depends_on "doxygen" => :build if build.with? "docs"
  depends_on "graphviz" => :build if build.with? "docs"

  needs :cxx11

  resource "sphinx" do
    url "https://pypi.python.org/packages/source/S/Sphinx/Sphinx-1.2.3.tar.gz"
    sha1 "3a11f130c63b057532ca37fe49c8967d0cbae1d5"
  end

  def install
    if build.with? "docs"
      ENV.prepend_create_path "PYTHONPATH", buildpath+"sphinx/lib/python2.7/site-packages"
      ENV.prepend_path "PATH", buildpath+"sphinx/bin"
    end
    ENV.prepend_path "PATH", "#{HOMEBREW_PREFIX}/opt/qt5/bin" if build.with? "qt5"

    args = ["-DCMAKE_INSTALL_PREFIX=#{prefix}",
            "-DCMAKE_BUILD_TYPE=Release",
            "-DCMAKE_VERBOSE_MAKEFILE=ON",
            "-Wno-dev"]

    args << "-Dtest=OFF" if build.without? "check"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"

      if build.with? "check"
        system "ctest", "-V"
      end

      system "make", "install"
    end
  end

end
