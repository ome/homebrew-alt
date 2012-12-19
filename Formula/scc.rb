require 'formula'

class Scc < Formula
  homepage 'https://github.com/openmicroscopy/snoopycrimecop'
  head 'https://github.com/openmicroscopy/snoopycrimecop.git', :branch => 'master'
  url 'https://github.com/openmicroscopy/snoopycrimecop/archive/0.2.0.tar.gz'
  version '0.2.0'
  sha1 '37d0328255b82732db41eb0f9da781ed295de6ef'

  def install
    File.rename("scc.py", "scc")
    bin.install("scc")
  end

  def test
    system "scc -h"
  end
end
