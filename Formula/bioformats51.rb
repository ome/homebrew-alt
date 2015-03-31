require 'formula'

class Bioformats51 < Formula
  homepage 'http://www.openmicroscopy.org/site/products/bio-formats'

  url 'http://downloads.openmicroscopy.org/bio-formats/5.1.0/artifacts/bioformats-5.1.0.zip'
  sha1 '2c6578b2ec665da23d1afd61fe776bb1eff4dbaf'

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
