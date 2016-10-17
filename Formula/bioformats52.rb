class Bioformats52 < Formula
  desc "Library for reading proprietary image file formats"
  homepage "http://www.openmicroscopy.org/site/products/bio-formats"
  url "http://downloads.openmicroscopy.org/bio-formats/5.2.4/artifacts/bioformats-5.2.4.zip"
  sha256 "dc1eaa755dcbb873f6df3c133b8ab3eadcdb29c331f2ddb8a83c2a7a49842ed5"

  depends_on "python" => :build
  depends_on "ant" => :build

  def install
    # Build libraries
    args = ["ant", "clean", "tools", "utils"]
    system *args

    # Remove Windows files
    rm Dir["tools/*.bat"]

    # Copy artifacts
    libexec.install "artifacts/bioformats_package.jar"

    # Copy command line-tools
    libexec.install Dir["tools/*"]

    %w[bfconvert domainlist formatlist ijview mkfake omeul showinf tiffcomment xmlindent xmlvalid].each do |fn|
      bin.install_symlink libexec/fn
    end
  end
  test do
    system "showinf", "-version"
    system "bfconvert", "-version"
  end
end
