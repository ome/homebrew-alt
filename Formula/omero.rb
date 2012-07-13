require 'formula'

class Omero < Formula
  homepage 'https://www.openmicroscopy.org'

  url 'https://github.com/openmicroscopy/openmicroscopy.git', :tag => 'v.4.4.0'
  version '4.4.0'

  depends_on 'mplayer'

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

    # Remove Windows files from bin directory
    rm Dir[prefix/"bin/*.bat"]
  end

  def config_file
    <<-EOF.undent
      dist.dir=#{prefix}
    EOF
  end

  def patches
    # build generates a version number with 'git describe' command
    # but Homebrew build runs in temp copy created via git checkout-index,
    # so 'git describe' does not work.
    DATA
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

__END__
diff --git a/build.xml b/build.xml
index a00ac93..9bd4b05 100644
--- a/build.xml
+++ b/build.xml
@@ -906,7 +906,7 @@ omero.version=${omero.version}
                 <echo>${version.describe.clean}-ice${versions.ice_lib}</echo>
             </try>
             <catch>
-                <echo>UNKNOWN-ice${versions.ice_lib}</echo>
+                <echo>4.4.0-RC2-ice${versions.ice_lib}</echo>
             </catch>
         </trycatch>
