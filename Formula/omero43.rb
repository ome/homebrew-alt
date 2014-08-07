require 'formula'

class Omero43 < Formula
  homepage 'http://www.openmicroscopy.org/site/products/omero'

  url 'https://github.com/openmicroscopy/openmicroscopy/archive/v.4.3.4.tar.gz'
  sha1 '44a90eb971a3b0f8fcba7afd41051ceb7f06cd6e'

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
