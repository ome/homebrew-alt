require 'formula'

class Bioformats < Formula
  homepage 'http://www.openmicroscopy.org/site/products/bio-formats'

  head 'https://github.com/openmicroscopy/bioformats.git', :branch => 'dev_4_4'
  url 'https://github.com/openmicroscopy/bioformats/archive/v4.4.9.tar.gz'
  sha1 '6f867488709183118b901986d1fda4631e219174'

  devel do
    url 'https://github.com/openmicroscopy/bioformats/archive/v5.0.0-beta1.tar.gz'
    version '5.0.0-beta1'
    sha1 '9d5ee6b5c414318e1718fdba2a8c88d3cfe64dd3'
  end

  depends_on :python if build.devel?
  depends_on 'genshi' => :python if build.devel?
  option 'without-ome-tools', 'Do not build OME Tools.'

  def patches
    # build generates a version number with 'git show' command
    # but Homebrew build runs in temp copy created via git checkout-index,
    # so 'git show' does not work.
    DATA if not (build.head? or build.devel?)
  end

  def install
    # Build libraries
    args = ["ant", "clean" ,"tools", "utils"]
    if not build.include? 'without-ome-tools'
        args << 'tools-ome'
    end
    system *args

    # Remove Windows files
    rm Dir["tools/*.bat"]

    # Copy artifacts
    bin.install Dir["artifacts/loci_tools.jar"]
    if not build.include? 'without-ome-tools'
      bin.install Dir["artifacts/ome_tools.jar"]
      bin.install Dir["artifacts/ome-io.jar"]
    end

    # Copy command line-tools
    bin.install Dir["tools/*"]
  end
  def test
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
+    <property name="vcs.revision" value="22bff853fa"/>
+    <property name="vcs.date" value="Tue Oct 15 09:11:40 2013 -0700"/>
+    <property name="release.version" value="4.4.9"/>
   </target>
 
 </project>
