require 'formula'

class ZerocIce34 < Formula

  url 'http://www.zeroc.com/download/Ice/3.4/Ice-3.4.2.tar.gz'
  sha256 'dcf0484495b6df0849ec90a00e8204fe5fe1c0d3882bb438bf2c1d062f15c979'
  homepage 'http://www.zeroc.com'

  option 'doc', 'Install documentation'
  option 'demo', 'Build demos'
  option 'with-java', 'Build Java library'
  option 'with-python', 'Build Python library'

  depends_on 'berkeley-db46' => '--without-java'
  depends_on 'mcpp'
  depends_on :python
  depends_on :ant => :build if build.with? 'java'
  # other dependencies listed for Ice are for additional utilities not compiled

  # Inline Patch
  #  * for Ice-3.4.2 to work with Berkeley DB 5.X rather than 4.X
  #  * for Ice-3.4.2 to compile with JDK-7
  #    See http://www.zeroc.com/forums/help-center/5561-java-7-support.html
  patch :DATA

  # Patch for Ice-3.4.2 to compile with clang
  patch :p0 do
    url "http://downloads.openmicroscopy.org/patches/ice_for_clang_2012-03-05.txt"
    sha256 'e5f3b0c0cd52d2e586e8cc8ae99912a4439f781037ca244ff351987875248bec'
  end

  # Patch for Ice-3.4.2 to compile under OSX Mavericks
  #See http://trac.macports.org//ticket/42459
  patch :p1 do
    url "https://github.com/ome/zeroc-ice/commit/ed8542e692.diff"
    sha256 'e1dbf3cea334429e926c8bb36fc2f925318e7b8fff294250350455f8590b65ff'
  end if MacOS.version == :mavericks

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

      # Unset ICE_HOME as it interferes with the build
      ENV.delete('ICE_HOME')
      ENV["PYTHON_HOME"] = Pathname.new `python-config --prefix`.chomp
      Dir.chdir "py" do
        system "make"
        system "make install"
      end
    end

  end
  test do
    system "slice2java", "--version"
    system "icegridnode", "--version"
  end
end

__END__
--- ./cpp/src/Freeze/MapI.cpp
+++ ./cpp/src/Freeze/MapI.cpp
@@ -1487,10 +1487,10 @@

     try
     {
-#if DB_VERSION_MAJOR != 4
-#error Freeze requires DB 4.x
+#if DB_VERSION_MAJOR < 4
+#error Freeze requires DB 4.x or greater
 #endif
-#if DB_VERSION_MINOR < 3
+#if DB_VERSION_MAJOR == 4 && DB_VERSION_MINOR < 3
         _db->stat(&s, 0);
 #else
         _db->stat(_connection->dbTxn(), &s, 0);

--- a/java/src/IceInternal/OutgoingConnectionFactory.java
+++ b/java/src/IceInternal/OutgoingConnectionFactory.java
@@ -17,7 +17,7 @@ public final class OutgoingConnectionFactory
     private static class MultiHashMap<K, V> extends java.util.HashMap<K, java.util.List<V>>
     {
         public void
-        put(K key, V value)
+        putOne(K key, V value)
         {
             java.util.List<V> list = this.get(key);
             if(list == null)
@@ -693,9 +693,9 @@ public final class OutgoingConnectionFactory
             throw ex;
        }
 
-        _connections.put(ci.connector, connection);
-        _connectionsByEndpoint.put(connection.endpoint(), connection);
-        _connectionsByEndpoint.put(connection.endpoint().compress(true), connection);
+        _connections.putOne(ci.connector, connection);
+        _connectionsByEndpoint.putOne(connection.endpoint(), connection);
+        _connectionsByEndpoint.putOne(connection.endpoint().compress(true), connection);
         return connection;
     }
