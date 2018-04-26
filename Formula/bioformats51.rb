require 'formula'

class Bioformats51 < Formula
  homepage 'http://www.openmicroscopy.org/site/products/bio-formats'

  url 'http://downloads.openmicroscopy.org/bio-formats/5.1.10/artifacts/bioformats-5.1.10.zip'
  sha256 '4bae68c8e99c6df8dae699f331b1554e6be040b34e05ca47ae93bd77841b8bc2'

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
