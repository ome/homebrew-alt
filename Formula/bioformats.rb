class Bioformats < Formula
  desc "Library for reading proprietary image file formats"
  homepage "http://www.openmicroscopy.org/site/products/bio-formats"
  url "http://downloads.openmicroscopy.org/bio-formats/5.9.1/artifacts/bioformats-5.9.1.zip"
  sha256 "2d5b00ea8073eb60a82796ae168fcacceed6360f45c8406c23388296fb12c428"

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
