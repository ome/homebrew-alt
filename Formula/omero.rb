require 'formula'

class Omero < Formula
  homepage 'https://www.openmicroscopy.org'

  url 'https://github.com/openmicroscopy/openmicroscopy.git', :tag => 'v.4.4.0-RC1'  
  version '4.4.0-RC1'

  depends_on 'mplayer'
  depends_on 'zeroc-ice33'

  def options
    [
      ["--with-cpp", "Build OmeroCpp libraries."]
    ]
  end

  def install
    # Create config file to specify dist.dir (see #9203)
    (Pathname.pwd/"etc/local.properties").write config_file
    
    args = ["./build.py", "-Dice.home=#{HOMEBREW_PREFIX}"]
    if ARGV.include? '--with-cpp'
        args << 'build-all'
    else
        args << 'build-default'
    end
    system *args
    ice_link
    
    # Remove .bat files from bin directory
    Dir[prefix/"bin/*.bat"].each do |file|
      rm file
    end
  end
  
  def config_file
    <<-EOF.undent
      dist.dir=#{prefix}
    EOF
  end

  def ice_link
    ohai "Linking zeroc libaries"
    python = lib+"python"

    zeroc = Formula.factory('zeroc-ice33')
    zp = zeroc.prefix+"python"
    zp.cd { Dir["*"].each {|p| ln_sf zp + p, python + File.basename(p) }}

  end

  def caveats; <<-EOS.undent

    For non-homebrew Python, you need to set your PYTHONPATH:
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
