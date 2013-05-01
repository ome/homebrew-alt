require 'formula'

class Bioformats < Formula
  homepage 'http://www.openmicroscopy.org/site/products/bio-formats'

  head 'https://github.com/openmicroscopy/bioformats.git', :branch => 'dev_4_4'
  url 'https://github.com/openmicroscopy/bioformats/archive/v4.4.7.tar.gz'
  version '4.4.7'
  sha1 'a28b91592bcee585d9741dde81eb60a2ced3fd6b'

  devel do
    url 'https://github.com/openmicroscopy/bioformats.git', :branch => 'develop'
    version '5.0.0-DEV'
  end

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
end

__END__
diff --git a/ant/common.xml b/ant/common.xml
index 1b5fb9a..a598447 100644
--- a/ant/common.xml
+++ b/ant/common.xml
@@ -49,6 +49,11 @@ Type "ant -p" for a list of targets.
         <propertyregex property="vcs.date"
           input="${git.info}" regexp="Date: +([^\n]*)" select="\1"/>
       </then>
+      <else>
+        <property name="vcs.revision" value="19cb7c1e3d"/>
+        <property name="vcs.date"
+          value="Wed Apr 24 23:55:11 2013 -0700"/>
+      </else>
     </if>
 
     <!-- set release version from repository URL -->
