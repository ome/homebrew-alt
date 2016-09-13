class Bioformats52 < Formula
  desc "Library for reading proprietary image file formats"
  homepage "http://www.openmicroscopy.org/site/products/bio-formats"
  url "http://downloads.openmicroscopy.org/bio-formats/5.2.2/artifacts/bioformats-5.2.2.zip"
  sha256 "fbc01f12dd3d5d08f5dcf46fec7476a30c219fcd38937720d32c2c4a6625625d"

  depends_on :python => :build
  depends_on :ant => :build

  def install
    # Build libraries
    args = ["ant", "clean", "tools", "utils"]
    system *args

    # Remove Windows files
    rm Dir["tools/*.bat"]

    # Copy artifacts
    bin.install "artifacts/bioformats_package.jar"

    # Copy command line-tools
    bin.install Dir["tools/*"]
  end
  test do
    system "showinf", "-version"
  end
end
