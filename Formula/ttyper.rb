class Ttyper < Formula
  desc "Terminal-based typing test"
  homepage "https://github.com/max-niederman/ttyper"
  url "https://github.com/max-niederman/ttyper/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "de168b56dfe71ac24c91c012b2c6bbd30fa5102a15dae53a8566ec2930c6b10e"
  license "MIT"
  head "https://github.com/max-niederman/ttyper", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "ttyper #{version}", shell_output(bin/"ttyper --version").chomp
  end
end
