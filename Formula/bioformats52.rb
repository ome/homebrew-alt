require 'formula'

class Bioformats52 < Formula
  homepage 'http://www.openmicroscopy.org/site/products/bio-formats'

  url 'http://downloads.openmicroscopy.org/bio-formats/5.2.1/artifacts/bioformats-5.2.1.zip'
  sha256 '9a4b838952dabee0ebb5472d33cb059f5edd0b3bb77308790801875f5ffc0413'

  depends_on :python => :build
  depends_on :ant => :build

  def install
    # Build libraries
    args = ["ant", "clean" ,"tools", "utils"]
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
