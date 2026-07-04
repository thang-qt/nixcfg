{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "pi-commandcode-provider";
  version = "0.4.1";

  src = fetchurl {
    url = "https://registry.npmjs.org/pi-commandcode-provider/-/pi-commandcode-provider-${version}.tgz";
    hash = "sha256-vuIt+rrSCYrDfkpckJ1L0QrawzZRW6iH3VnbZBk5HP4=";
  };

  sourceRoot = "package";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R . $out/
    runHook postInstall
  '';

  meta = {
    description = "Pi custom provider for Command Code API";
    homepage = "https://pi.dev/packages/pi-commandcode-provider";
    license = lib.licenses.mit;
  };
}
