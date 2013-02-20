require 'formula'

class Scc < Formula
  homepage 'https://github.com/openmicroscopy/snoopycrimecop'
  head 'https://github.com/openmicroscopy/snoopycrimecop.git', :branch => 'master'
  url 'https://github.com/openmicroscopy/snoopycrimecop.git', :tag => '0.3.0'
  version '0.3.0'

  def install
    File.rename("scc.py", "scc")
    bin.install("scc")
  end

  def test
    system "scc -h"
  end
end
