require 'formula'

class Omero43 < Formula
  homepage 'http://www.openmicroscopy.org/site/products/omero'

  url 'https://github.com/openmicroscopy/openmicroscopy/archive/v.4.3.4.tar.gz'
  sha256 '2716ab1e7265beb9706cf1fbcbefe0d9f1b2a69e9e0e564a9735fde5d5b2ef21'

  depends_on :python
  depends_on 'mplayer'
  depends_on 'zeroc-ice33'

  option "with-cpp", "Build OmeroCpp libraries."

  def install
    args = ["./build.py", "-Dice.home=#{HOMEBREW_PREFIX}", "-Ddist.dir=#{prefix}"]
    if build.with? 'cpp'
        args << 'build-all'
    else
        args << 'build-default'
    end
    system *args
    ice_link

    # Remove Windows files from bin directory
    rm Dir[prefix/"bin/*.bat"]
  end

  def ice_link
    ohai "Linking zeroc libaries"
    python = lib+"python"

    zeroc = Formula['zeroc-ice33']
    zp = zeroc.prefix+"python"
    zp.cd { Dir["*"].each {|p| ln_sf zp + p, python + File.basename(p) }}

  end

  def caveats; <<-EOS.undent

    For non-homebrew Python, you need to set your PYTHONPATH:
    export PYTHONPATH=#{lib}/python:$PYTHONPATH

    EOS
  end

  test do
    mktemp do
      (Pathname.pwd/'test.py').write <<-EOS.undent
        #!/usr/bin/env python
        import Ice
        EOS

      system "python", "test.py"
    end
  end
end
