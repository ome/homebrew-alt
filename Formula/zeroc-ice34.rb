require 'formula'

class ZerocIce34 < Formula

  url 'http://www.zeroc.com/download/Ice/3.4/Ice-3.4.2.tar.gz'
  sha1 '8c84d6e3b227f583d05e08251e07047e6c3a6b42'
  homepage 'http://www.zeroc.com'

  depends_on 'berkeley-db46' => '--without-java'
  depends_on 'mcpp'
  depends_on :python
  # other dependencies listed for Ice are for additional utilities not compiled

  def patches
    # Patch for Ice-3.4.2 to work with Berkely DB 5.X rather than 4.X
    {:p0 => "http://www.zeroc.com/forums/attachments/patches/973d1330948195-patch-compiling-ice-clang-gcc4-7-ice_for_clang_2012-03-05.txt",
     :p1 =>"https://raw.github.com/gist/1619052/5be2a4bed2d4f1cf41ce9b95141941a252adaaa2/Ice-3.4.2-db5.patch"}
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

  option 'doc', 'Install documentation'
  option 'demo', 'Build demos'
  option 'with-java', 'Build Java library'
  option 'with-python', 'Build Python library'

  def install
    ENV.O2
    inreplace "cpp/config/Make.rules" do |s|
      s.gsub! "/opt/Ice-$(VERSION)", prefix
      s.gsub! "/opt/Ice-$(VERSION_MAJOR).$(VERSION_MINOR)", prefix
    end

    # what want we build?
    wb = 'config src include'
    wb += ' doc' if build.include? 'doc'
    wb += ' demo' if build.include? 'demo'

    inreplace "cpp/Makefile" do |s|
      s.change_make_var! "SUBDIRS", wb
    end

    inreplace "cpp/config/Make.rules.Darwin" do |s|
      s.change_make_var! "CXXFLAGS", "#{ENV.cflags} -Wall -D_REENTRANT"
    end

    cd "cpp" do
      system "make"
      system "make install"
    end

    if build.with? 'java'
      Dir.chdir "java" do
        system "ant ice-jar"
        Dir.chdir "lib" do
          lib.install ['Ice.jar', 'ant-ice.jar']
        end
      end
    end

    if build.with? 'python'

      inreplace "py/config/Make.rules" do |s|
        s.gsub! "/opt/Ice-$(VERSION)", prefix
        s.gsub! "/opt/Ice-$(VERSION_MAJOR).$(VERSION_MINOR)", prefix
      end

      ENV["PYTHON_HOME"] = python.prefix if python.brewed? and python.framework?
      Dir.chdir "py" do
        system "make"
        system "make install"
      end
    end

  end
end
