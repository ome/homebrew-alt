require 'formula'

class ZerocIce34 < Formula
  homepage 'https://github.com/joshmoore/zeroc-ice'

  # FROM github:
  # ------------
  # url 'https://github.com/joshmoore/zeroc-ice/tarball/Ice-3.3.1'
  # sha1 '1db95b5b168207b9d3fb8d03097440c5f5238f58'
  # md5 '7d8fab84c67272cde9fa7d3529d27caf'
  #
  # def install:
  #   system "mkdir cpp/lib cpp/bin"
  #   ...

  url 'http://download.zeroc.com/Ice/3.4/Ice-3.4.2.tar.gz'
  md5 'e97672eb4a63c6b8dd202d0773e19dc7'
  sha1 '8c84d6e3b227f583d05e08251e07047e6c3a6b42'

  head 'git://github.com/joshmoore/zeroc-ice.git', :tag => 'Ice-3.4.2'

  depends_on 'mcpp'
  depends_on 'berkeley-db46'

  def install

    ohai "Creating symbolic link for slice"

    share.mkpath
    ln_s prefix+"slice", share

    bdb46 = Formula.factory('berkeley-db46')
    mcpp = Formula.factory('mcpp')

    system "cd cpp && make MCPP_HOME=#{mcpp.prefix} DB_HOME=#{bdb46.prefix} OPTIMIZE=yes prefix=#{prefix} embedded_runpath_prefix=#{prefix} install"

    ENV["ICE_HOME"] = "#{prefix}"
    system "cd rb && make OPTIMIZE=yes prefix=#{prefix} embedded_runpath_prefix=#{prefix} install"
    system "cd py && make OPTIMIZE=yes prefix=#{prefix} embedded_runpath_prefix=#{prefix} install"

  end

  def caveats; <<-EOS.undent
    Skipping build of ice-java due to jgoodies requirement.
    Download jar from http://zeroc.com

    Skipping build of ice-php due to compile issues:
    See http://www.zeroc.com/forums/help-center/4467-couldnt-compile-icephp-ice-3-3-1-php-5-3-0-a.html
    EOS
  end
end
