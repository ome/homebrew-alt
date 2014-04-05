require 'formula'

class Bioformats < Formula
  homepage 'http://www.openmicroscopy.org/site/products/bio-formats'

  url 'http://downloads.openmicroscopy.org/bio-formats/5.0.1/artifacts/bioformats-5.0.1.zip'
  sha1 '32e1a3ea1d755c0fd6c93bfbb1f3d98d228725b8'

  depends_on :python
  depends_on 'genshi' => :python

  def install
    # Build libraries
    args = ["ant", "clean" ,"tools", "utils"]
    system *args

    # Remove Windows files
    rm Dir["tools/*.bat"]

    # Copy artifacts
    bin.install Dir["artifacts/bioformats_package.jar"]

    # Copy command line-tools
    bin.install Dir["tools/*"]
  end
  def test
    system "showinf", "-version"
  end
end
