require 'formula'

class Omero < Formula
  homepage 'https://www.openmicroscopy.org'

  url 'https://github.com/openmicroscopy/openmicroscopy/tarball/v.4.3.4'
  md5 'c5b32ba1452ae2e038c1fc9b5760c811'
  sha1 '2cb765f6b2de3a208ea5df5847473bf27056e830'
  version '4.3.4'

  depends_on 'zeroc-ice33'

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
    ice_link
  end

  def ice_link
    ohai "Linking zeroc libaries"
    icepath = lib+"python"+"zeroc-ice33"

    zeroc = Formula.factory('zeroc-ice33')
    ln_s zeroc.prefix+"python", icepath
  end

  def caveats; <<-EOS.undent
    For non-homebrew Python, you need to amend your PYTHONPATH like so:
    export PYTHONPATH=#{lib}/python:$PYTHONPATH
    EOS
  end
  def test
    mktemp do
      (Pathname.pwd/'test.py').write <<-EOS.undent
        #!/usr/bin/env python
        import Ice
        EOS

      system "python", "test.py"
    end
  end
end
