require 'formula'

class Scc < Formula
  homepage 'https://github.com/snoopycrimecop/snoopycrimecop'
  head 'https://github.com/snoopycrimecop/snoopycrimecop.git', :branch => 'master'
  url 'https://github.com/snoopycrimecop/snoopycrimecop/archive/0.1.0.tar.gz'
  version '0.1.0'
  sha1 '08c6349db028be5287eb7d410c697a67ada6ad38'

  def install
    File.rename("scc.py", "scc")
    bin.install("scc")
  end

  def test
    system "scc -h"
  end
end
