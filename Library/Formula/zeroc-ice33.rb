require 'formula'

class ZerocIce33 < Formula
  homepage 'https://github.com/joshmoore/zeroc-ice'

  url 'https://nodeload.github.com/joshmoore/zeroc-ice/tarball/v.3.3.1-clang'
  md5 '2ea5e68cbcf91121c0c196f6096aff9a'
  sha1 '9055faf76ec7657e05036b7740d60bdc38e04f4a'


  head 'git://github.com/joshmoore/zeroc-ice.git', :tag => 'Ice-3.3.1'

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
