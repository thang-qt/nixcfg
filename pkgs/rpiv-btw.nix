{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "rpiv-btw";
  version = "1.1.5";

  src = fetchurl {
    url = "https://registry.npmjs.org/@juicesharp/rpiv-btw/-/rpiv-btw-${version}.tgz";
    hash = "sha256-S4/tzfg9E7vLJqdWZHF7PqzNnDMMJH+cIsd0sLQYpGM=";
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
