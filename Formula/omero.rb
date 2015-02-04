require 'formula'

class Omero < Formula
  homepage 'http://www.openmicroscopy.org/site/products/omero'

  url 'http://downloads.openmicroscopy.org/omero/5.0.7/artifacts/openmicroscopy-5.0.7.zip'
  sha1 'e5cd00ce00b0b76eb33afb3422d65da49dd7954a'

  option 'with-cpp', 'Build OmeroCpp libraries.'
  option 'with-ice33', 'Use Ice 3.3.'
  option 'with-ice34', 'Use Ice 3.4.'

  depends_on :python
  depends_on :fortran
  depends_on 'ccache' => :recommended
  depends_on 'pkg-config' => :build
  depends_on 'hdf5'
  depends_on 'jpeg'
  depends_on 'ice' => 'with-python' if build.without? 'ice33' and build.without? 'ice34'
  depends_on 'zeroc-ice34' => 'with-python' if build.with? 'ice34'
  depends_on 'zeroc-ice33' if build.with? 'ice33'
  depends_on 'mplayer' => :recommended
  depends_on 'nginx' => :optional

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

  # build generates a version number with 'git describe' command
  # but Homebrew build runs in temp copy created via git checkout-index,
  # so 'git describe' does not work.
  patch :DATA

  def ice_prefix
    if build.with? 'ice33'
      Formula['zeroc-ice33'].opt_prefix
    elsif build.with? 'ice34'
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
+        <property name="release.version" value="5.0.7"/>
+        <property name="release.shortversion" value="5.0.7"/>
+        <property name="vcs.revision" value="274796b"/>
+        <property name="vcs.date" value="Tue Feb 3 10:27:00 2015 +0000"/>
+</project>
