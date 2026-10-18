{
  lib,
  stdenv,
  fetchurl,
  unzip,
  autoPatchelfHook,
  makeWrapper,
  tmux,
  xdg-utils,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sesame-link";
  version = "0.1.33";

  src = fetchurl {
    url = "https://storage.googleapis.com/sesame-link/releases/v${finalAttrs.version}/sesame-link-v${finalAttrs.version}-x86_64-unknown-linux-gnu.zip";
    hash = "sha256-kr9ZBBT28ELaqoXBCGnPQrOqNRf3WXLzNRTzvluf7Nc=";
  };

  nativeBuildInputs = [unzip autoPatchelfHook makeWrapper];
  buildInputs = [stdenv.cc.cc.lib];

  installPhase = ''
    runHook preInstall
    install -Dm755 sesame-link $out/bin/sesame-link
    wrapProgram $out/bin/sesame-link \
      --prefix PATH : ${lib.makeBinPath [tmux xdg-utils]}
    runHook postInstall
  '';

  meta = {
    description = "Access local coding agent sessions through Sesame Link";
    homepage = "https://link.sesame.com";
    license = lib.licenses.unfree;
    sourceProvenance = [lib.sourceTypes.binaryNativeCode];
    platforms = ["x86_64-linux"];
    mainProgram = "sesame-link";
  };
})
