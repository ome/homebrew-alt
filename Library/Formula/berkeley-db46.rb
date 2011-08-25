require 'formula'

class BerkeleyDb46 < Formula
  url 'http://download.oracle.com/berkeley-db/db-4.6.21.tar.gz'
  homepage 'http://www.oracle.com/technology/products/berkeley-db/index.html'
  md5 '718082e7e35fc48478a2334b0bc4cd11'

  keg_only "Older version"

  def options
    [['--without-java', 'Compile without Java support.']]
  end

  def install
    # BerkeleyDB dislikes parallel builds
    ENV.deparallelize
    ENV.O3 # takes an hour or more with link time optimisation

    args = ["--disable-debug",
            "--prefix=#{prefix}", "--mandir=#{man}",
            "--enable-cxx"]
    args << "--enable-java" unless ARGV.include? "--without-java"

    # BerkeleyDB requires you to build everything from the build_unix subdirectory
    Dir.chdir 'build_unix' do
      system "../dist/configure", *args
      system "make install"

      # use the standard docs location
      doc.parent.mkpath
      mv prefix+'docs', doc
    end
  end
end
