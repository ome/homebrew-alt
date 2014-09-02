require 'formula'

class Bioformats < Formula
  homepage 'http://www.openmicroscopy.org/site/products/bio-formats'

  url 'http://downloads.openmicroscopy.org/bio-formats/5.0.4/artifacts/bioformats-5.0.4.zip'
  sha1 '731d48a0dc8a74cf83d016af5c09b8b5c2cca6d4'

  depends_on :python => :build
  depends_on :ant => :build
  depends_on 'genshi' => :python

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
