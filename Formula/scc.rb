require 'formula'

class Scc < Formula
  homepage 'https://github.com/snoopycrimecop/snoopycrimecop'

  head 'https://github.com/snoopycrimecop/snoopycrimecop.git', :branch => 'master'

  def install
    File.rename("scc.py", "scc")
    bin.install("scc")
  end
end
