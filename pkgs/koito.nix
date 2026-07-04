{
  lib,
  fetchFromGitHub,
  stdenv,
  buildGoModule,
  nodejs,
  pkg-config,
  vips,
  yarn-berry_4,
}: let
  version = "0.3.2";
  src = fetchFromGitHub {
    owner = "gabehf";
    repo = "Koito";
    rev = "v${version}";
    hash = "sha256-68+Z4Alzu+4v/PxU1IOboqZkF1pO+y6gswuO+HPS7dk=";
  };

  yarn = yarn-berry_4;

  sourceRoot = "${src.name}/client";
  missingHashes = ./koito-data/missing-hashes.json;
  offlineCache = yarn.fetchYarnBerryDeps {
    inherit src sourceRoot missingHashes;
    hash = "sha256-VIlWld21GScJ/2UUkKQISM9jyU9wCVwwDNKkge+K044=";
  };

  frontend = stdenv.mkDerivation {
    pname = "koito-frontend";
    inherit version src sourceRoot missingHashes offlineCache;

    nativeBuildInputs = [
      nodejs
      yarn.yarnBerryConfigHook
      yarn
    ];

    env.VITE_KOITO_VERSION = version;

    buildPhase = ''
      runHook preBuild
      yarn run build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/client
      cp -r build/client/* $out/client/
      runHook postInstall
    '';
  };
in
  buildGoModule {
    pname = "koito";
    inherit version src;

    vendorHash = "sha256-W/+ByBlEPd4yIUD/E28q93fz6wYgvhwyBvJL8Fm1lNY=";

    env.CGO_ENABLED = "1";

    nativeBuildInputs = [pkg-config];
    buildInputs = [vips];

    ldflags = [
      "-s"
      "-w"
      "-X main.Version=${version}"
    ];

    subPackages = ["cmd/api"];

    postInstall = ''
      mkdir -p $out/share/koito/client/build/client
      mkdir -p $out/share/koito/client/public

      cp -r ${frontend}/client/* $out/share/koito/client/build/client/
      cp -r $src/client/public/* $out/share/koito/client/public/
      cp -r $src/db $out/share/koito/
      cp -r $src/assets $out/share/koito/

      mv $out/bin/api $out/bin/koito
    '';

    meta = with lib; {
      description = "ListenBrainz-compatible scrobbler";
      homepage = "https://github.com/gabehf/Koito";
      license = licenses.mit;
      platforms = platforms.linux;
      mainProgram = "koito";
    };
  }
