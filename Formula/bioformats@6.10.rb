class BioformatsAT610 < Formula
  desc "Library for reading proprietary image file formats"
  homepage "https://www.openmicroscopy.org/bio-formats"
  url "https://downloads.openmicroscopy.org/bio-formats/6.10.1/artifacts/bioformats-6.10.1.zip"
  sha256 "4da7005c27dc7f8a98a81c8f84df196fd0db1af20e300bea55595e2e08ef93d5"

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
