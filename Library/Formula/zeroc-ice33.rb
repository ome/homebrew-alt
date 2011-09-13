require 'formula'

class ZerocIce33 < Formula
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

  url 'http://www.zeroc.com/download/Ice/3.3/Ice-3.3.1.tar.gz'
  md5 '1f37dfcec4662fcde030553fb447d064'
  sha1 '08d0f32bdb7d909b4a531d45cccfa97bdde649aa'

  head 'git://github.com/joshmoore/zeroc-ice.git', :tag => 'Ice-3.3.1'

  depends_on 'mcpp'
  depends_on 'berkeley-db46'

  def install

    ohai "Creating symbolic link for slice"

    share.mkpath
    ln_s prefix+"slice", share

    bdb46 = Formula.factory('berkeley-db46')
    mcpp = Formula.factory('mcpp')

    system "cd cpp && make MCPP_HOME=#{mcpp.prefix} DB_HOME=#{bdb46.prefix} OPTIMIZE=yes prefix=#{prefix} install"

    ENV["ICE_HOME"] = "#{prefix}"
    system "cd rb && make OPTIMIZE=yes prefix=#{prefix} install"
    system "cd py && make OPTIMIZE=yes prefix=#{prefix} install"

  end

  def caveats; <<-EOS.undent
    Skipping build of ice-java due to jgoodies requirement.
    Download jar from http://zeroc.com

    Skipping build of ice-php due to compile issues:
    See http://www.zeroc.com/forums/help-center/4467-couldnt-compile-icephp-ice-3-3-1-php-5-3-0-a.html
    EOS
  end
end
