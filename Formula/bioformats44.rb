require 'formula'

class Bioformats44 < Formula
  homepage 'http://www.openmicroscopy.org/site/products/bio-formats'

  url 'https://github.com/openmicroscopy/bioformats/archive/v4.4.10.tar.gz'
  sha1 '875c552aea03107d5e4e9b55320b0abf5918effa'

  option 'without-ome-tools', 'Do not build OME Tools.'

  depends_on :ant => :build
  # build generates a version number with 'git show' command
  # but Homebrew build runs in temp copy created via git checkout-index,
  # so 'git show' does not work.
  patch :DATA

  def install
    # Build libraries
    args = ["ant", "clean" ,"tools", "utils"]
    if build.with? 'ome-tools'
        args << 'tools-ome'
    end
    system *args

    # Remove Windows files
    rm Dir["tools/*.bat"]

    # Copy artifacts
    bin.install "artifacts/loci_tools.jar"
    if build.with? 'ome-tools'
      bin.install "artifacts/ome_tools.jar"
      bin.install "artifacts/ome-io.jar"
    end

    # Copy command line-tools
    bin.install Dir["tools/*"]
  end
  test do
    system "showinf", "-version"
  end
end

__END__
diff --git a/ant/common.xml b/ant/common.xml
index 149bb2d..a8ed9a7 100644
--- a/ant/common.xml
+++ b/ant/common.xml
@@ -107,7 +107,9 @@ Type "ant -p" for a list of targets.
     </if>
 
     <!-- set release version by default if nothing is set -->
-    <property name="release.version" value="UNKNOWN"/>
+    <property name="vcs.revision" value="d853f51"/>
+    <property name="vcs.date" value="Tue Jan 14 11:59:30 2014 -0800"/>
+    <property name="release.version" value="4.4.10"/>
   </target>
 
 </project>
