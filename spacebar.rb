class Spacebar < Formula
  desc "A minimal status bar for macOS."
  homepage "https://github.com/wxsh/spacebar"
  version "0.1.2"
  url "https://github.com/wxsh/spacebar/archive/#{version}.tar.gz"
  sha256 "796a639fb667bf11043497bb99464edf27f328e2cde1305c68186cbd156dcfcd"
  head "https://github.com/cmacrae/spacebar.git"

  depends_on :macos => :high_sierra

  def install
    (var/"log/spacebar").mkpath
    man.mkpath

    ENV.O2
    system "make", "install"

    bin.install "#{buildpath}/bin/spacebar"
    (pkgshare/"examples").install "#{buildpath}/examples/spacebarrc"
    man1.install "#{buildpath}/doc/spacebar.1"
  end

  def caveats; <<~EOS
    Copy the example configuration into your home directory:
      cp #{opt_pkgshare}/examples/spacebarrc ~/.spacebarrc
    Logs will be found in
      #{var}/log/spacebar/spacebar.[out|err].log
    EOS
  end

  plist_options :manual => "spacebar"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/spacebar</string>
      </array>
      <key>EnvironmentVariables</key>
      <dict>
        <key>PATH</key>
        <string>#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
      </dict>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
      <key>StandardOutPath</key>
      <string>#{var}/log/spacebar/spacebar.out.log</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/spacebar/spacebar.err.log</string>
    </dict>
    </plist>
    EOS
  end

  test do
    assert_match "spacebar-v#{version}", shell_output("#{bin}/spacebar --version")
  end
end
