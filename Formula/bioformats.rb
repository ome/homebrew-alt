class Bioformats < Formula
  desc "Library for reading proprietary image file formats"
  homepage "https://www.openmicroscopy.org/bio-formats"
  url "https://downloads.openmicroscopy.org/bio-formats/8.0.1/artifacts/bioformats-8.0.1.zip"
  sha256 "f945729d739828b993e70a76fad9e75b763bdc1b070266b7eed5b5f7ae3770d9"

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
