class Bioformats < Formula
  desc "Library for reading proprietary image file formats"
  homepage "https://www.openmicroscopy.org/bio-formats"
  url "https://downloads.openmicroscopy.org/bio-formats/6.11.1/artifacts/bioformats-6.11.1.zip"
  sha256 "7813454baa750d1062637eb24c1fe8992aa91b03d4e6f242d89300a31aa20441"

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
