{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  prismlauncher,
  kdePackages,
  qrencode,
  tomlplusplus,
  libarchive,
  libglvnd,
  zlib,
  stdenv,
}: let
  # Use the fork's published binary, but retain Nixpkgs' Qt, graphics, Java,
  # and Minecraft runtime integration instead of its portable runtime bundle.
  binary = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "prismlauncher-offline-unwrapped";
    version = "11.1.1";

    src = fetchurl {
      url = "https://github.com/Diegiwg/PrismLauncher-Cracked/releases/download/${finalAttrs.version}/PrismLauncher-Linux-Qt6-Portable-${finalAttrs.version}.tar.gz";
      hash = "sha256-jZ3obf9lWLvmjfU48zvi0ORot6hE1YHUgQXz7iXuZ48=";
    };

    sourceRoot = ".";
    nativeBuildInputs = [autoPatchelfHook];
    buildInputs = [
      kdePackages.qtbase
      kdePackages.qtnetworkauth
      qrencode
      tomlplusplus
      libarchive
      libglvnd
      zlib
      stdenv.cc.cc.lib
    ];

    dontConfigure = true;
    dontBuild = true;
    dontWrapQtApps = true;

    installPhase = ''
      runHook preInstall

      install -Dm755 shared/bin/prismlauncher $out/bin/prismlauncher
      # The release requires this older SONAME; use Nixpkgs for other libraries.
      install -Dm755 shared/lib/libcmark.so.0.30.2 $out/lib/libcmark.so.0.30.2
      mkdir -p $out/share
      cp -r share/{PrismLauncher,applications,icons,man,metainfo,mime} $out/share/
      substituteInPlace $out/share/applications/org.prismlauncher.PrismLauncher.desktop \
        --replace-fail 'Name=Prism Launcher (Cracked)' 'Name=Prism Launcher (Offline)'

      runHook postInstall
    '';

    meta = {
      description = "Unofficial Prism Launcher fork for local/offline accounts";
      longDescription = ''
        Prism Launcher fork supporting local accounts without Microsoft
        authentication. Intended for offline play; do not add real Microsoft
        accounts. Updates are managed through Nix rather than the portable updater.
      '';
      homepage = "https://github.com/Diegiwg/PrismLauncher-Cracked";
      changelog = "https://github.com/Diegiwg/PrismLauncher-Cracked/releases/tag/${finalAttrs.version}";
      license = lib.licenses.gpl3Only;
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
      platforms = ["x86_64-linux"];
      maintainers = [];
      mainProgram = "prismlauncher";
    };
  });
in
  (prismlauncher.override {
    # The standard wrapper passes its MSA client ID to the unwrapped package.
    # This prebuilt offline-only release has no configurable authentication ID.
    prismlauncher-unwrapped = lib.makeOverridable (_: binary) {};
  }).overrideAttrs (_: {
    pname = "prismlauncher-offline";
    inherit (binary) meta;
  })
