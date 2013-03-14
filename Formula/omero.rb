require 'formula'

class Omero < Formula
  homepage 'http://www.openmicroscopy.org/site/products/omero'

  head 'https://github.com/openmicroscopy/openmicroscopy.git', :branch => 'dev_4_4'
  url 'https://github.com/openmicroscopy/openmicroscopy.git', :tag => 'v.4.4.6'
  version '4.4.6'

  devel do
    url 'https://github.com/openmicroscopy/openmicroscopy.git', :branch => 'develop'
    version '5.0.0-DEV'
  end

  option 'with-cpp', 'Build OmeroCpp libraries.'
  option 'with-ice34', 'Use Ice 3.4.'

  depends_on 'ccache' => :recommended
  depends_on 'pkg-config' => :build
  depends_on 'hdf5'
  depends_on 'jpeg'
  depends_on 'gfortran'
  depends_on 'ome/alt/ice' if build.with? 'with-ice34'
  depends_on 'zeroc-ice33' unless build.with? 'with-ice34'
  depends_on 'mplayer' => :recommended

  def install
    # Create config file to specify dist.dir (see #9203)
    (Pathname.pwd/"etc/local.properties").write config_file

    args = ["./build.py", "-Dice.home=#{HOMEBREW_PREFIX}"]
    if build.include? 'with-cpp'
        args << 'build-all'
    else
        args << 'build-default'
    end
    system *args
    ice_link

    # Remove Windows files from bin directory
    rm Dir[prefix/"bin/*.bat"]

    if (build.head? or build.devel?)
      # Rename and copy the python dependencies installation script
      mv "docs/install/python_deps.sh", "docs/install/omero_python_deps"
      bin.install "docs/install/omero_python_deps"
    end
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

    if build.with? 'with-ice34'
      zeroc_prefix = Formula.factory('ome/alt/ice').opt_prefix
    else
      zeroc_prefix = Formula.factory('zeroc-ice33').opt_prefix
    end
    zp = zeroc_prefix+"python"
    zp.cd { Dir["*"].each {|p| ln_sf zp + p, python + File.basename(p) }}

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
    s += python_caveats if (build.head? or build.devel?)
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
index 6fd64ee..4387ce1 100644
--- a/build.xml
+++ b/build.xml
@@ -1016,7 +1016,7 @@ omero.version=${omero.version}
                 <propertyregex property="version.describe" input="${fullversion}" regexp="@{regexp}" select="@{select}"/>
             </try>
             <catch>
-                <echo>UNKNOWN</echo>
+                <echo>4.4.6</echo>
             </catch>
         </trycatch>
         </sequential>
diff --git a/components/bioformats/ant/common.xml b/components/bioformats/ant/common.xml
index 4a719ae..fe0dc55 100644
--- a/components/bioformats/ant/common.xml
+++ b/components/bioformats/ant/common.xml
@@ -49,6 +49,11 @@ Type "ant -p" for a list of targets.
         <propertyregex property="vcs.date"
           input="${git.info}" regexp="Date: +([^\n]*)" select="\1"/>
       </then>
+      <else>
+        <property name="vcs.revision" value="3f142f767a"/>
+        <property name="vcs.date"
+          value="Thu Feb 7 06:39:21 2013 -0800"/>
+      </else>
     </if>
 
     <!-- set release version from repository URL -->
