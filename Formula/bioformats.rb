require 'formula'

class Bioformats < Formula
  homepage 'http://www.openmicroscopy.org/site/products/bio-formats'

  head 'https://github.com/openmicroscopy/bioformats.git', :branch => 'dev_4_4'
  url 'https://github.com/openmicroscopy/bioformats/archive/v4.4.10.tar.gz'
  sha1 '875c552aea03107d5e4e9b55320b0abf5918effa'

  devel do
    url 'https://github.com/openmicroscopy/bioformats/archive/v5.0.0-rc1.tar.gz'
    version '5.0.0-rc1'
    sha1 '56d0cfad860bc20021b21e18c1bc4e635ba71ce8'
  end

  resource 'genshi' do
    url 'https://pypi.python.org/packages/source/G/Genshi/Genshi-0.7.tar.gz'
    sha1 'f34b762736d2814bcdea075f6b01b9de6c61aa61'
  end

  depends_on :python if build.devel?
  option 'without-ome-tools', 'Do not build OME Tools.'

  def patches
    # build generates a version number with 'git show' command
    # but Homebrew build runs in temp copy created via git checkout-index,
    # so 'git show' does not work.
    DATA if not (build.head? or build.devel?)
  end

  def install
    if build.devel?
      ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
      install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]

      resource('genshi').stage { system "python", *install_args }
    end
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
+    <property name="vcs.revision" value="d853f51"/>
+    <property name="vcs.date" value="Tue Jan 14 11:59:30 2014 -0800"/>
+    <property name="release.version" value="4.4.10"/>
   </target>
 
 </project>
