class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/e1/34/a5e61f64991f1bb399f74b8708cdf3834a7fda1e91c5cdb49389710537a7/svtplay-dl-4.23.tar.gz"
  sha256 "e8e89036893c6fc0cc62fbbe61ae4e47db2187940d71538b88876f4a4075d00d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "eab5bd738bba9d87c5f9ef8ca0729b4037e15b7c93bd12508e3fa902806bf123"
    sha256 cellar: :any,                 arm64_monterey: "042ea99ea5445853d9059bad011c84fdca967712e6488377d058dbef195738f9"
    sha256 cellar: :any,                 arm64_big_sur:  "457304fc3b9b39378f9624cfcba23957fa31b6eeb23e9a0059001e89f98f198f"
    sha256 cellar: :any,                 ventura:        "528ef701c7e09a35dee0ac88624d685599cc758f0282f53504c89fc900383fe7"
    sha256 cellar: :any,                 monterey:       "37d10e6abcee0ec540992ced1cbc9a24da442fd46c795656752d9fd2571a9279"
    sha256 cellar: :any,                 big_sur:        "87b7cad4b5b7aff166f16c342eb50c8bc182a9abe53067167440e96fbb29cf56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0407451fa0f5ab7ef7317018ef783367e774659cf1dc0202c81f5bc07b3be25a"
  end

  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@1.1"
  depends_on "pycparser"
  depends_on "python@3.11"
  depends_on "pyyaml"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/19/8c/47f061de65d1571210dc46436c14a0a4c260fd0f3eaf61ce9b9d445ce12f/cryptography-41.0.1.tar.gz"
    sha256 "d34579085401d3f49762d2f7d6634d6b6c2ae1242202e860f4d26b046e3a1006"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/d6/af/3b4cfedd46b3addab52e84a71ab26518272c23c77116de3c61ead54af903/urllib3-2.0.3.tar.gz"
    sha256 "bee28b5e56addb8226c96f7f13ac28cb4c301dd5ea8a6ca179c0b9835e032825"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      To use post-processing options:
        `brew install ffmpeg` or `brew install libav`.
    EOS
  end

  test do
    url = "https://tv.aftonbladet.se/abtv/articles/244248"
    match = "https://amd-ab.akamaized.net/ab/vod/2018/02/cdaefe0533c2561f00a41c52a2d790bd/1280_720_pkg.m3u8"
    assert_match match, shell_output("#{bin}/svtplay-dl -g #{url}")
  end
end
