require 'formula'

class Bioformats < Formula
  homepage 'http://www.openmicroscopy.org/site/products/bio-formats'

  url 'http://downloads.openmicroscopy.org/bio-formats/5.0.2/artifacts/bioformats-5.0.2.zip'
  sha1 '2b286741dec8a7b8ec4244f60aef410c07973194'

  depends_on :python
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
  def test
    system "showinf", "-version"
  end
end
