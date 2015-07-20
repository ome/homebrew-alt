require 'formula'

class BerkeleyDb45 < Formula
  url 'http://download.oracle.com/berkeley-db/db-4.5.20.tar.gz'
  homepage 'http://www.oracle.com/technology/products/berkeley-db/index.html'
  sha256 'f52cd5cea899823dd200d56556f70b33c55e48a33bb7b65ee128968dc10ca82d'

  keg_only "Older version"

  option 'without-java', 'Compile without Java support.'

  def install
    # BerkeleyDB dislikes parallel builds
    ENV.deparallelize
    ENV.O3 # takes an hour or more with link time optimisation

    args = ["--disable-debug",
            "--prefix=#{prefix}", "--mandir=#{man}",
            "--enable-cxx"]
    args << "--enable-java" if build.with? 'java'

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
