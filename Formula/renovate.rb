require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.128.0.tgz"
  sha256 "3bf35af508481ebf8fbabd2d7f983c8735a3f6f3f0a29777b49f1a2614d076b0"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99f7a538e0d9494ea2957e7e9338e03fb151b396bb1b5719e871a1dfa05ef7ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cbb1a2365d0fd42a93025c3010fc3c2d752fd46e38ac55b223cc6a6eb30ce3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a94c488a6191f2de016bb5050722e6220feafd44b2afb7a5df09fd4cd4fe1c65"
    sha256 cellar: :any_skip_relocation, ventura:        "a9adc59dc37cb1b34ddb43b91d901d4c7df5c9b7b249c8eedeaa0ddbe6999442"
    sha256 cellar: :any_skip_relocation, monterey:       "cf6e4af31e9f54c4ecc79dfc1a174f17ed8bead7756340f3a492a9e98bd7dcb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc8ca7b030c7df4b766dce6ab930e98d41254a5a7ba2db84eba2d520e13f6626"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e2441bfcd94a38b50d63f6b96a604e99664d9645637433b606d2c1402aad7d7"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
