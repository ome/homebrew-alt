require 'formula'

class Omero51 < Formula
  homepage 'http://www.openmicroscopy.org/site/products/omero'

  url 'http://downloads.openmicroscopy.org/omero/5.1.0-m3/artifacts/openmicroscopy-5.1.0-m3.zip'
  sha1 '431b1df079a9bf4fa95dcb4e4a0fc673e11a6f45'

  option 'with-cpp', 'Build OmeroCpp libraries.'
  option 'with-ice34', 'Use Ice 3.4.'

  depends_on :python
  depends_on :fortran
  depends_on 'ccache' => :recommended
  depends_on 'pkg-config' => :build
  depends_on 'hdf5'
  depends_on 'jpeg'
  depends_on 'ice' => 'with-python' if build.without? 'ice34'
  depends_on 'zeroc-ice34' => 'with-python' if build.with? 'ice34'
  depends_on 'mplayer' => :recommended
  depends_on 'genshi' => :python
  depends_on 'nginx' => :optional

  def install
    # Create config file to specify dist.dir (see #9203)
    (Pathname.pwd/"etc/local.properties").write config_file

    if build.without? 'ice34'
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

  # build generates a version number with 'git describe' command
  # but Homebrew build runs in temp copy created via git checkout-index,
  # so 'git describe' does not work.
  patch :DATA

  def ice_prefix
    if build.with? 'ice34'
      Formula['zeroc-ice34'].opt_prefix
    else
      Formula[
        'ice'].opt_prefix
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

  test do
    system "omero", "version"
  end
end

__END__
diff --git a/components/bioformats/ant/gitversion.xml b/components/bioformats/ant/gitversion.xml
new file mode 100644
index 0000000..ff40ea9
--- /dev/null
+++ b/components/bioformats/ant/gitversion.xml
@@ -0,0 +1,7 @@
+<?xml version="1.0" encoding="utf-8"?>
+<project name="gitversion" basedir=".">
+        <property name="release.version" value="5.1.0-m3"/>
+        <property name="release.shortversion" value="5.1.0-m3"/>
+        <property name="vcs.revision" value="b97e94a"/>
+        <property name="vcs.date" value="2014-12-16 11:25:06 -0600"/>
+</project>



