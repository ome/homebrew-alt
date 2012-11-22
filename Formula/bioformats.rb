require 'formula'

class Bioformats < Formula
  homepage 'http://www.openmicroscopy.org/site/products/bio-formats'

  head 'https://github.com/openmicroscopy/bioformats.git', :branch => 'dev_4_4'
  url 'https://github.com/openmicroscopy/bioformats.git', :tag => 'v4.4.5'
  version '4.4.5'

  option 'without-ome-tools', 'Do not build OME Tools.'

  def patches
    # build generates a version number with 'git show' command
    # but Homebrew build runs in temp copy created via git checkout-index,
    # so 'git show' does not work.
    DATA
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
index d238aa6..e2ef921 100644
--- a/ant/common.xml
+++ b/ant/common.xml
@@ -49,6 +49,9 @@ Type "ant -p" for a list of targets.
         <propertyregex property="vcs.date"
           input="${git.info}" regexp="Date: +([^\n]*)" select="\1"/>
       </then>
+      <else>
+        <property name="vcs.revision" value="03770c0"></property>
+         </else>
     </if>
