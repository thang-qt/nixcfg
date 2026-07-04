{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "rpiv-web-tools";
  version = "1.19.1";

  src = fetchurl {
    url = "https://registry.npmjs.org/@juicesharp/rpiv-web-tools/-/rpiv-web-tools-${version}.tgz";
    hash = "sha256-5P0T8JTusyj3L4cv2co1roD6DqJXLrhut8zq01cwCLc=";
  };

  rpivConfigSrc = fetchurl {
    url = "https://registry.npmjs.org/@juicesharp/rpiv-config/-/rpiv-config-${version}.tgz";
    hash = "sha256-2MbWTYISyyUY4Xtk93dbPp0TBSCVcud02asUDMHZOEc=";
  };

  sourceRoot = "package";

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -R . $out/

    mkdir -p $out/node_modules/@juicesharp
    tar -xzf $rpivConfigSrc -C $out/node_modules/@juicesharp
    mv $out/node_modules/@juicesharp/package $out/node_modules/@juicesharp/rpiv-config

    runHook postInstall
  '';

  meta = {
    description = "Pi extension. Web search and fetch for the model with pluggable providers";
    homepage = "https://github.com/juicesharp/rpiv-mono/tree/main/packages/rpiv-web-tools";
    license = lib.licenses.mit;
  };
}
