class Bioformats < Formula
  desc "Library for reading proprietary image file formats"
  homepage "https://www.openmicroscopy.org/bio-formats"
  url "https://downloads.openmicroscopy.org/bio-formats/6.9.0/artifacts/bioformats-6.9.0.zip"
  sha256 "5c5562f3ca8a2f95c9c45d986b1768f376db9871ae45a306440119c69bf64fb5"

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
