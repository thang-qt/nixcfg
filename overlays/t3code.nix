final: prev: {
  # Temporary workaround for https://github.com/NixOS/nixpkgs/pull/555921.
  t3code =
    (prev.t3code.override {
      t3code-unwrapped = prev.t3code.unwrapped.overrideAttrs (old: {
        postPatch =
          (old.postPatch or "")
          + ''
            # Upstream's example contains public release identifiers, not secrets.
            # Connect configuration must be embedded in both client and server.
            cp .env.example .env
          '';

        postFixup =
          (old.postFixup or "")
          + final.lib.optionalString final.stdenv.hostPlatform.isLinux ''
            echo 'MimeType=x-scheme-handler/t3code;' >> "$out/share/applications/t3code.desktop"
          '';
      });
    }).overrideAttrs (old: {
      postBuild =
        (old.postBuild or "")
        + final.lib.optionalString final.stdenv.hostPlatform.isLinux ''
          wrapProgram "$out/bin/t3code-desktop" \
            --set T3CODE_DESKTOP_LAUNCHER_PATH "$out/bin/t3code-desktop" \
            --prefix PATH : ${final.lib.makeBinPath [final.desktop-file-utils final.xdg-utils]}
        '';
    });
}
