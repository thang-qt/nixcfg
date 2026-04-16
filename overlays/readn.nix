final: prev: {
  yarr = prev.yarr.overrideAttrs (oldAttrs: {
    pname = "readn";

    src = prev.fetchFromGitHub {
      owner = "thang-qt";
      repo = "Readn";
      rev = "77dbb2acfbf73fc8303d9f3f8f4a40d67135fcdf";
      hash = "sha256-LBuWcR/RVc584DUQi3aDrm0i0nUGUkX0yfp7cUPRZDc=";
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
