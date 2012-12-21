require 'formula'

class Scc < Formula
  homepage 'https://github.com/openmicroscopy/snoopycrimecop'
  head 'https://github.com/openmicroscopy/snoopycrimecop.git', :branch => 'master'
  url 'https://github.com/openmicroscopy/snoopycrimecop/archive/0.2.1.tar.gz'
  version '0.2.1'
  sha1 '2658269f0c16ce6f2ad4873575a88e5c2661e58a'

  def install
    File.rename("scc.py", "scc")
    bin.install("scc")
  end

  def test
    system "scc -h"
  end
end
