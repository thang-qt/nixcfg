{
  lib,
  stdenvNoCC,
  fetchurl,
}:
stdenvNoCC.mkDerivation rec {
  pname = "rpiv-web-tools";
  version = "2.5.2";

  src = fetchurl {
    url = "https://registry.npmjs.org/@juicesharp/rpiv-web-tools/-/rpiv-web-tools-${version}.tgz";
    hash = "sha256-DlDN+DylF3JhUM7vMm6xD3kzdkejw386PgKBe4w/zZk=";
  };

  rpivConfigSrc = fetchurl {
    url = "https://registry.npmjs.org/@juicesharp/rpiv-config/-/rpiv-config-${version}.tgz";
    hash = "sha256-Fti/shSrLz92mXlHmRZwY+41d5BMxhfS+BJIrLoGzFY=";
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
