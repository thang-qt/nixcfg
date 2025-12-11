final: prev: {
  yarr = prev.yarr.overrideAttrs (oldAttrs: {
    pname = "readn";

    src = prev.fetchFromGitHub {
      owner = "thang-qt";
      repo = "Readn";
      rev = "980d73161966a23db9bbf9558ebed5f05a2018f0";
      hash = "sha256-SiEsU8CFOs+gb7z0X/Bptth23kZQ5YX6LQVxE8e5b6Q=";
    };

    vendorHash = null;
    version = "2.5-thang-qt";

    ldflags = oldAttrs.ldflags ++ [ "-X main.Version=2.5-thang-qt" ];

    # Disable version check since the binary name changed
    doInstallCheck = false;

    meta = oldAttrs.meta // {
      description = "Yet another rss reader";
      homepage = "https://github.com/thang-qt/Readn";
      changelog = "https://github.com/thang-qt/Readn/blob/master/doc/changelog.txt";
      mainProgram = "readn";
      maintainers = oldAttrs.meta.maintainers ++ [ final.lib.maintainers.thang ];
    };
  });
}
