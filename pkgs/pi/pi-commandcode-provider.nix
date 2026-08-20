{
  lib,
  stdenvNoCC,
  fetchurl,
}:
stdenvNoCC.mkDerivation rec {
  pname = "pi-commandcode-provider";
  version = "0.5.1";

  src = fetchurl {
    url = "https://registry.npmjs.org/pi-commandcode-provider/-/pi-commandcode-provider-${version}.tgz";
    hash = "sha256-KjEOIFPJSY+vSrxWzlM2J/jkIvhok8vnFlSXrdqABgQ=";
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
    homepage = "https://github.com/patlux/pi-commandcode-provider";
    license = lib.licenses.mit;
  };
}
