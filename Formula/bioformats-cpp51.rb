class BioformatsCpp51 < Formula
  desc "Libraries and tools for microscopy images including OME-TIFF"
  homepage "http://www.openmicroscopy.org/site/products/bio-formats"
  url "http://downloads.openmicroscopy.org/bio-formats/5.1.2/artifacts/bioformats-5.1.2.zip"
  sha256 "7b92979f49434cf3e8930dcfeec6571f09f1fcb65ef5e51ecb87f16585d46186"
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
    sha256 "94933b64e2fe0807da0612c574a021c0dac28c7bd3c4a23723ae5a39ea8f3d04"
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

  test do
    system "bf-test", "--usage"
    system "bf-test", "info", "--usage"
  end
end
