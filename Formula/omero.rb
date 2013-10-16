require 'formula'

class Omero < Formula
  homepage 'http://www.openmicroscopy.org/site/products/omero'

  head 'https://github.com/openmicroscopy/openmicroscopy.git', :branch => 'dev_4_4'
  url 'https://github.com/openmicroscopy/openmicroscopy.git', :tag => 'v.4.4.9'

  devel do
    url 'https://github.com/openmicroscopy/openmicroscopy.git', :tag => 'v.5.0.0-beta1'
    version '5.0.0-beta1'
  end

  option 'with-cpp', 'Build OmeroCpp libraries.'
  option 'with-ice33', 'Use Ice 3.3.'

  depends_on :python
  depends_on :fortran
  depends_on 'ccache' => :recommended
  depends_on 'pkg-config' => :build
  depends_on 'hdf5'
  depends_on 'jpeg'
  depends_on 'zeroc-ice34' => 'with-python' unless build.with? 'ice33'
  depends_on 'zeroc-ice33' if build.with? 'ice33'
  depends_on 'mplayer' => :recommended
  depends_on 'genshi' => :python if build.devel?

  def install
    # Create config file to specify dist.dir (see #9203)
    (Pathname.pwd/"etc/local.properties").write config_file

    args = ["./build.py", "-Dice.home=#{ice_prefix}"]
    if build.with? 'cpp'
        args << 'build-all'
    else
        args << 'build-default'
    end
    system *args
    ice_link

    # Remove Windows files from bin directory
    rm Dir[prefix/"bin/*.bat"]

    # Rename and copy the python dependencies installation script
    mv "docs/install/python_deps.sh", "docs/install/omero_python_deps"
    bin.install "docs/install/omero_python_deps"
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
    DATA if not (build.head? or build.devel?)
  end

  def ice_link
    ohai "Linking zeroc libaries"
    python = lib+"python"

    zp = ice_prefix+"python"
    zp.cd { Dir["*"].each {|p| ln_sf zp + p, python + File.basename(p) }}

  end

  def ice_prefix
    unless build.with? 'ice33'
      Formula.factory('zeroc-ice34').opt_prefix
    else
      Formula.factory('zeroc-ice33').opt_prefix
    end
  end

  def caveats;
    s = <<-EOS.undent

    For non-homebrew Python, you need to set your PYTHONPATH:
    export PYTHONPATH=#{lib}/python:$PYTHONPATH

    EOS

    python_caveats = <<-EOS.undent
    To finish the installation, execute omero_python_deps in your
    shell:
      .#{bin}/omero_python_deps

    EOS
    s += python_caveats
    return s
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
index efa9e62..976df1a 100644
--- a/build.xml
+++ b/build.xml
@@ -1036,7 +1036,7 @@ omero.version=${omero.version}
                 <propertyregex property="version.describe" input="${fullversion}" regexp="@{regexp}" select="@{select}"/>
             </try>
             <catch>
-                <echo>UNKNOWN</echo>
+                <echo>4.4.9</echo>
             </catch>
         </trycatch>
         </sequential>

