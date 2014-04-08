require 'formula'

class Omero44 < Formula
  homepage 'http://www.openmicroscopy.org/site/products/omero'

  url 'https://github.com/openmicroscopy/openmicroscopy.git', :tag => 'v.4.4.10'

  option 'with-cpp', 'Build OmeroCpp libraries.'
  option 'with-ice33', 'Use Ice 3.3.'
  option 'with-ice34', 'Use Ice 3.4.'

  depends_on :python
  depends_on :fortran
  depends_on 'ccache' => :recommended
  depends_on 'pkg-config' => :build
  depends_on 'hdf5'
  depends_on 'jpeg'
  depends_on 'ice' if build.without? 'ice33' and build.without? 'ice34'
  depends_on 'zeroc-ice34' => 'with-python' if build.with? 'ice34'
  depends_on 'zeroc-ice33' if build.with? 'ice33'
  depends_on 'mplayer' => :recommended

  def install
    # Create config file to specify dist.dir (see #9203)
    (Pathname.pwd/"etc/local.properties").write config_file

    if build.without? 'ice33' and build.without? 'ice34'
       ENV['SLICEPATH'] = "#{HOMEBREW_PREFIX}/share/Ice-3.5/slice"
    end
    args = ["./build.py", "-Dice.home=#{ice_prefix}"]
    if build.with? 'cpp'
      args << 'build-all'
    else
      args << 'build-default'
    end
    system *args

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
    DATA
  end

  def ice_prefix
    if build.with? 'ice33'
      Formula['zeroc-ice33'].opt_prefix
    elsif build.with? 'ice34'
      Formula['zeroc-ice34'].opt_prefix
    else
      Formula['ice'].opt_prefix
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
+                <echo>4.4.10</echo>
             </catch>
         </trycatch>
         </sequential>

