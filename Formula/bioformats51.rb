require 'formula'

class Bioformats51 < Formula
  homepage 'http://www.openmicroscopy.org/site/products/bio-formats'

  url 'http://downloads.openmicroscopy.org/bio-formats/5.1.8/artifacts/bioformats-5.1.8.zip'
  sha256 'db95e9fd002b710c6fbeca3ff8bb92a17e8ce4cad013eb6ed050edc390ccf98a'

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
