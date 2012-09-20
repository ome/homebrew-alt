require 'formula'

class Bioformats < Formula
  homepage 'https://www.openmicroscopy.org'

  head 'https://github.com/openmicroscopy/bioformats.git', :branch => 'develop'
  url 'https://github.com/openmicroscopy/bioformats.git', :tag => 'v4.4.2'
  version '4.4.2'

  def options
    [
      ["--without-ome-tools", "Do not build OME Tools."]
    ]
  end
  
  def install
    # Build libraries
    args = ["ant", "clean" ,"tools", "utils"]
    if not ARGV.include? '--without-ome-tools'
        args << 'tools-ome'
    end
    system *args

    # Remove Windows files
    rm Dir["tools/*.bat"]

    # Copy artifacts
    bin.install Dir["artifacts/loci_tools.jar"]
    if not ARGV.include? '--without-ome-tools'
      bin.install Dir["artifacts/ome_tools.jar"]
      bin.install Dir["artifacts/ome-io.jar"]
    end
  
    # Copy command line-tools
    bin.install Dir["tools/*"]
  end
end