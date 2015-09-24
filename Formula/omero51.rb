require 'formula'

class Omero51 < Formula
  homepage 'http://www.openmicroscopy.org/site/products/omero'

  url 'http://downloads.openmicroscopy.org/omero/5.1.4/artifacts/openmicroscopy-5.1.4.zip'
  sha256 'f0a94d3a3bcaa9254dca1bb1d0bb8a9257121df2429f324d51c1030efab13f75'

  option 'with-cpp', 'Build OmeroCpp libraries.'
  option 'with-ice34', 'Use Ice 3.4.'

  depends_on :python
  depends_on :fortran
  depends_on 'ccache' => :recommended
  depends_on 'pkg-config' => :build
  depends_on 'hdf5'
  depends_on 'jpeg'
  depends_on 'zeroc-ice35' => 'with-python' if build.without? 'ice34'
  depends_on 'zeroc-ice34' => 'with-python' if build.with? 'ice34'
  depends_on 'mplayer' => :recommended
  depends_on 'nginx' => :optional
  depends_on 'cmake' if build.with? 'cpp'

  def install
    # Create config file to specify dist.dir (see #9203)
    (Pathname.pwd/"etc/local.properties").write config_file

    if build.without? 'ice34'
       ENV['SLICEPATH'] = "#{HOMEBREW_PREFIX}/share/Ice-3.5/slice"
    end
    args = ["./build.py", "-Dice.home=#{ice_prefix}"]
    if build.with? 'cpp'
      args << 'build-all'
    else
      args << 'build-default'
    end
    system *args

    # Remove Windows files from bin directory
    rm Dir[prefix/"bin/*.bat"]

    # Rename and copy the python dependencies installation script
    mv "docs/install/python_deps.sh", "docs/install/omero_python_deps"
    bin.install "docs/install/omero_python_deps"
  end

  def config_file
    <<-EOF.undent
      dist.dir=#{prefix}
    EOF
  end

  def ice_prefix
    if build.with? 'ice34'
      Formula['zeroc-ice34'].opt_prefix
    else
      Formula['zeroc-ice35'].opt_prefix
    end
  end

  def caveats;
    s = <<-EOS.undent

    For non-homebrew Python, you need to set your PYTHONPATH:
    export PYTHONPATH=#{lib}/python:$PYTHONPATH

    EOS

    python_caveats = <<-EOS.undent
    To finish the installation, execute omero_python_deps in your
    shell:
      .#{bin}/omero_python_deps

    EOS
    s += python_caveats
    return s
  end

  test do
    system "omero", "version"
  end
end
