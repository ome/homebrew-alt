require 'formula'

class Bioformats < Formula
  homepage 'http://www.openmicroscopy.org/site/products/bio-formats'

  url 'http://downloads.openmicroscopy.org/bio-formats/5.0.0/artifacts/bioformats-5.0.0.zip'
  sha1 'f850db7164e8c9576d9782d6ad65d17c544719a7'

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
