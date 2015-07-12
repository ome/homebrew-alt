require 'formula'

class BerkeleyDb46 < Formula
  url 'http://download.oracle.com/berkeley-db/db-4.6.21.tar.gz'
  homepage 'http://www.oracle.com/technology/products/berkeley-db/index.html'
  sha256 '53ea9c9f03746a0aa415e6706e9c6da18ca18148f20ad1465b182411a7985e21'

  keg_only "Older version"

  option 'without-java', 'Compile without Java support.'

  def install
    # BerkeleyDB dislikes parallel builds
    ENV.deparallelize
    ENV.O3 # takes an hour or more with link time optimisation

    args = ["--disable-debug",
            "--prefix=#{prefix}", "--mandir=#{man}",
            "--enable-cxx"]
    args << "--enable-java" if build.with? "java"

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
