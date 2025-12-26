final: prev: {
  yarr = prev.yarr.overrideAttrs (oldAttrs: {
    pname = "readn";

    src = prev.fetchFromGitHub {
      owner = "thang-qt";
      repo = "Readn";
      rev = "8f2980b704c7f60b590feabfce4c83d3f14a91f7";
      hash = "sha256-+SEdOarNKZ5/8tb8Ih+WsXHRv/OSp33Lg4/TYwirq2o=";
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
