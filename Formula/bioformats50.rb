require 'formula'

class Bioformats50 < Formula
  homepage 'http://www.openmicroscopy.org/site/products/bio-formats'

  url 'http://downloads.openmicroscopy.org/bio-formats/5.0.8/artifacts/bioformats-5.0.8.zip'
  sha256 'bc059541de55b027488aa5af784c5c807d65602409d3589b6367ffdfc00653fb'

  depends_on "python@2" => :build
  depends_on "ant" => :build

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
