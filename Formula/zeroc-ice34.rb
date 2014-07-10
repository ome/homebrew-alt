require 'formula'

class ZerocIce34 < Formula

  url 'https://github.com/sbesson/zeroc-ice.git', :branch => '342_109'
  homepage 'http://www.zeroc.com'

  depends_on 'berkeley-db46' => '--without-java'
  depends_on 'mcpp'
  depends_on :python
  # other dependencies listed for Ice are for additional utilities not compiled

  def patches
    {# Inline Patch
     #  * for Ice-3.4.2 to work with Berkeley DB 5.X rather than 4.X
     #  * for Ice-3.4.2 to compile with JDK-7
     #    See http://www.zeroc.com/forums/help-center/5561-java-7-support.html
     :p1 => DATA}
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

      ENV["PYTHON_HOME"] = Pathname.new `python-config --prefix`.chomp
      Dir.chdir "py" do
        system "make"
        system "make install"
      end
    end

  end
  def test
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
