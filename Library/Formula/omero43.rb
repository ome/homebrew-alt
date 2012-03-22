require 'formula'

class Omero43 < Formula
  homepage 'https://www.openmicroscopy.org'

  url 'https://github.com/joshmoore/openmicroscopy/tarball/v.4.3.4'
  md5 'c5b32ba1452ae2e038c1fc9b5760c811'
  sha1 '2cb765f6b2de3a208ea5df5847473bf27056e830'

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
