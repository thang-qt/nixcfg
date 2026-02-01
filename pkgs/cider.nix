{
  lib,
  appimageTools,
  requireFile,
}:

let
  version = "3.1.8";
  pname = "cider";

  src = requireFile {
    name = "cider-v${version}-linux-x64.AppImage";
    sha256 = "1b5qllzk1r7jpxw19a90p87kpc6rh05nc8zdr22bcl630xh8ql5k";
    message = ''
      This Nix expression requires the Cider AppImage.
      Please add it to the Nix store with:
        nix-store --add-fixed sha256 ~/Downloads/cider-v${version}-linux-x64.AppImage
    '';
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm644 ${appimageContents}/Cider.desktop $out/share/applications/${pname}.desktop
    install -Dm644 ${appimageContents}/Cider.png $out/share/pixmaps/${pname}.png
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=Cider' 'Exec=${pname}'
  '';

  meta = {
    description = "A new look into listening and enjoying Apple Music in style and performance";
    homepage = "https://github.com/ciderapp/Cider";
    downloadPage = "https://github.com/ciderapp/Cider/releases";
    license = lib.licenses.agpl3Only;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "cider";
  };
}
