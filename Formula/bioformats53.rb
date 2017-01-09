class Bioformats53 < Formula
  desc "Library for reading proprietary image file formats"
  homepage "http://www.openmicroscopy.org/site/products/bio-formats"
  url "http://downloads.openmicroscopy.org/bio-formats/5.3.2/artifacts/bioformats-5.3.2.zip"
  sha256 "f9dde792dc24f7cf27e558dda8d0f69dddfde4d41a4339f79e5bb5fd11793ea8"

  depends_on "ant" => :build

  def install
    # Build libraries
    args = ["ant", "clean", "tools"]
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
