{ lib, stdenv, fetchurl, autoPatchelfHook, makeWrapper, alsa-lib, libXtst, webkitgtk_4_1 }:

stdenv.mkDerivation (finalAttrs: {
  sourceRoot = ".";
  pname = "pano-scrobbler";
  version = "4.20";

  src = fetchurl {
    url = "https://github.com/kawaiiDango/pano-scrobbler/releases/download/420/pano-scrobbler-linux-x64.tar.gz";
    hash = "sha256-fCJ/5QwYy9T6ep2VEuT4QqBGFx5y47wxHCSh+VDWkQs=";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  buildInputs = [ alsa-lib libXtst webkitgtk_4_1 stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall

    install -d $out/opt/pano-scrobbler/lib
    shopt -s nullglob
    if [ -e lib ]; then
      install -m644 lib/*.so $out/opt/pano-scrobbler/lib/
    fi
    install -m644 ./*.so $out/opt/pano-scrobbler/ || true
    shopt -u nullglob

    install -m755 ./pano-scrobbler $out/opt/pano-scrobbler/pano-scrobbler

    install -d $out/bin
    makeWrapper $out/opt/pano-scrobbler/pano-scrobbler $out/bin/pano-scrobbler

    install -Dm644 pano-scrobbler.desktop $out/share/applications/pano-scrobbler.desktop
    substituteInPlace $out/share/applications/pano-scrobbler.desktop \
      --replace-fail "Exec=" "Exec=pano-scrobbler %U" \
      --replace-fail "Icon=" "Icon=pano-scrobbler"

    install -Dm644 pano-scrobbler.svg $out/share/icons/hicolor/scalable/apps/pano-scrobbler.svg
    install -Dm644 LICENSE $out/share/licenses/pano-scrobbler/LICENSE

    runHook postInstall
  '';

  meta = with lib; {
    description = "Feature packed cross-platform music tracker";
    homepage = "https://github.com/kawaiiDango/pano-scrobbler";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    mainProgram = "pano-scrobbler";
  };
})
