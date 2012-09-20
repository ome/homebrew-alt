require 'formula'

class Bioformats < Formula
  homepage 'https://www.openmicroscopy.org'

  head 'https://github.com/openmicroscopy/bioformats.git', :branch => 'develop'
  url 'https://github.com/openmicroscopy/bioformats.git', :tag => 'v4.4.2'
  version '4.4.2'

  def install

    args = ["ant", "clean" ,"tools", "utils"]
    system *args

    rm Dir["tools/*.bat"]
    bin.install Dir["artifacts/loci_tools.jar"]
    bin.install Dir["tools/*"]
  end
end