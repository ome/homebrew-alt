require 'formula'

class Bioformats < Formula
  homepage 'http://www.openmicroscopy.org/site/products/bio-formats'

  head 'https://github.com/openmicroscopy/bioformats.git', :branch => 'dev_4_4'
  url 'https://github.com/openmicroscopy/bioformats/archive/v4.4.8.tar.gz'
  sha1 '1d3e2239ec1fb86caa38c8285011600795570961'

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
index c2760a2..eeffb5d 100644
--- a/ant/common.xml
+++ b/ant/common.xml
@@ -49,6 +49,10 @@ Type "ant -p" for a list of targets.
         <propertyregex property="vcs.date"
           input="${git.info}" regexp="Date: +([^\n]*)" select="\1"/>
       </then>
+      <else>
+        <property name="vcs.revision" value="660f607f71"/>
+        <property name="vcs.date" value="Wed May 1 06:57:13 2013 -0700"/>
+      </else>
     </if>
 
     <!-- set release version from repository URL -->
