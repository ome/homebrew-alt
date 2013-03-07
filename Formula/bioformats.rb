require 'formula'

class Bioformats < Formula
  homepage 'http://www.openmicroscopy.org/site/products/bio-formats'

  head 'https://github.com/openmicroscopy/bioformats.git', :branch => 'dev_4_4'
  url 'https://github.com/openmicroscopy/bioformats.git', :tag => 'v4.4.6'
  version '4.4.6'

  devel do
    url 'https://github.com/openmicroscopy/bioformats.git', :branch => 'develop'
  end

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
end

__END__
diff --git a/ant/common.xml b/ant/common.xml
index 4a719ae..fe0dc55 100644
--- a/ant/common.xml
+++ b/ant/common.xml
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
