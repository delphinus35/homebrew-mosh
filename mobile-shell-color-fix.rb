require "formula"

class MobileShellColorFix < Formula
  homepage "http://mosh.mit.edu/"
  url "https://mosh.mit.edu/mosh-1.2.4.tar.gz"
  sha256 "e74d0d323226046e402dd469a176075fc2013b69b0e67cea49762c957175df46"
  revision 2

  head do
    url "https://github.com/keithw/mosh.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  patch :p1 do
    url 'https://github.com/cgull/mosh/commit/51312f0a54011ea12407f5d8caa17bf77cdf990a.patch'
    sha1 'd3a232f443ed87c89ea188face068b786a1027ec'
  end

  option "with-check", "Run build-time tests"

  depends_on "openssl"
  depends_on "pkg-config" => :build
  depends_on "protobuf"

  conflicts_with 'mobile-shell', :because => 'both install an `mosh` binary'

  def install
    system "./autogen.sh" if build.head?

    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scripts/mosh", "'mosh-client", "\'#{bin}/mosh-client"

    # Upstream prefers O2:
    # https://github.com/keithw/mosh/blob/master/README.md
    ENV.O2
    system "./configure", "--prefix=#{prefix}", "--enable-completion"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end

  test do
    ENV["TERM"]="xterm"
    system "#{bin}/mosh-client", "-c"
  end
end
