class Bioformats < Formula
  desc "Library for reading proprietary image file formats"
  homepage "https://www.openmicroscopy.org/site/products/bio-formats"
  url "https://downloads.openmicroscopy.org/bio-formats/5.9.2/artifacts/bioformats-5.9.2.zip"
  sha256 "7f6ccd612dfe53a6a53c637568f8153f3f83b356354c8851da0e6b46b0ae9c18"

  depends_on "ant" => :build

  def install
    # Build libraries
    args = ["ant", "clean", "tools", "-Dmaven.repo.local",
            "#{buildpath}/.m2/repository"]
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
