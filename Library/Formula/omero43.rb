require 'formula'

class Omero43 < Formula
  homepage 'https://www.openmicroscopy.org'

  url 'https://github.com/joshmoore/openmicroscopy/tarball/v.4.3.1'
  md5 '630394a13bf6debcc7b93c58f02d1d52'
  sha1 'dd3d9d1d748a5a43e59aba0669c0c163a624f884'

  depends_on 'zeroc-ice33'

  keg_only "OMERO uses a single symlink for access"

  def options
    [
      ["--with-cpp", "Build OmeroCpp libraries."]
    ]
  end

  def install
    args = ["./build.py", "-Dice.home=#{HOMEBREW_PREFIX}", "-Ddist.dir=#{prefix}"]
    if ARGV.include? '--with-cpp'
        args << 'build-all'
    else
        args << 'build-default'
    end
    system *args
  end

end
