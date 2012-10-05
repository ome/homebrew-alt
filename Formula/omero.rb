require 'formula'

class Omero < Formula
  homepage 'https://www.openmicroscopy.org'

  head 'https://github.com/openmicroscopy/openmicroscopy.git', :branch => 'develop'
  url 'https://github.com/openmicroscopy/openmicroscopy.git', :tag => 'v.4.4.4'
  version '4.4.4'

  depends_on 'pkg-config'
  depends_on 'hdf5'
  depends_on 'libjpeg'
  depends_on 'gfortran'
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
index d9a57ec..6686c42 100644
--- a/build.xml
+++ b/build.xml
@@ -925,7 +925,7 @@ omero.version=${omero.version}
                 <propertyregex property="version.describe" input="${fullversion}" regexp="@{regexp}" select="@{select}"/>
             </try>
             <catch>
-                <echo>UNKNOWN</echo>
+                <echo>4.4.4</echo>
             </catch>
         </trycatch>
         </sequential>
