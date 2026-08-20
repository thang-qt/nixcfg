{
  lib,
  stdenvNoCC,
  fetchurl,
}:
stdenvNoCC.mkDerivation rec {
  pname = "rpiv-btw";
  version = "2.5.2";

  src = fetchurl {
    url = "https://registry.npmjs.org/@juicesharp/rpiv-btw/-/rpiv-btw-${version}.tgz";
    hash = "sha256-j1JT6tsCj5KWg7DpfSNoTOaN4ogzlmVjqWooaG7To+s=";
  };

  sourceRoot = "package";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R . $out/
    runHook postInstall
  '';

  meta = {
    description = "Pi /btw slash command for side questions without polluting the main transcript";
    homepage = "https://github.com/juicesharp/rpiv-mono/tree/main/packages/rpiv-btw";
    license = lib.licenses.mit;
  };
}
