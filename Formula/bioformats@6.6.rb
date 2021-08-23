class BioformatsAT66 < Formula
  desc "Library for reading proprietary image file formats"
  homepage "https://www.openmicroscopy.org/bio-formats"
  url "https://downloads.openmicroscopy.org/bio-formats/6.6.1/artifacts/bioformats-6.6.1.zip"
  sha256 "bcc97ad519954ccbbb87076f62cc4a11fcb9a0b139544abc5c39af1e06479184"

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
