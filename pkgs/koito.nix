{ lib, fetchFromGitHub, stdenv, buildGoModule, fetchYarnDeps, yarnConfigHook, yarnBuildHook, nodejs, pkg-config, vips }:

let
  version = "0.1.4";
  src = fetchFromGitHub {
    owner = "gabehf";
    repo = "Koito";
    rev = "v${version}";
    hash = "sha256-PGxDtKIznvIdg9ACtksKA56oJPMp68Grzjvl98SEDL8=";
  };

  frontend = stdenv.mkDerivation {
    pname = "koito-frontend";
    inherit version src;
    sourceRoot = "${src.name}/client";

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = "${src}/client/yarn.lock";
      hash = "sha256-mkA24dhMfm36q/8upplDqSQD8wklz/ndaYQzv9ycyeA=";
    };

    nativeBuildInputs = [
      yarnConfigHook
      yarnBuildHook
      nodejs
    ];

    env.VITE_KOITO_VERSION = version;

    dontYarnInstall = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r build/client/* $out/
      runHook postInstall
    '';
  };
in
buildGoModule {
  pname = "koito";
  inherit version src;

  vendorHash = "sha256-e/gU29rPQUY+eugQxnjbb8UCJ3K4KCtRqJzBl5eFNxg=";

  env.CGO_ENABLED = "1";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ vips ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  subPackages = [ "cmd/api" ];

  postInstall = ''
    mkdir -p $out/share/koito/client/build/client
    mkdir -p $out/share/koito/client/public

    cp -r ${frontend}/* $out/share/koito/client/build/client/
    cp -r $src/client/public/* $out/share/koito/client/public/
    cp -r $src/db $out/share/koito/
    cp -r $src/assets $out/share/koito/

    mv $out/bin/api $out/bin/koito
  '';

  meta = with lib; {
    description = "ListenBrainz-compatible scrobbler";
    homepage = "https://github.com/gabehf/Koito";
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
    mainProgram = "koito";
  };
}
