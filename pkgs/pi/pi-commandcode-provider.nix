{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "pi-commandcode-provider";
  version = "0.4.3";

  src = fetchurl {
    url = "https://registry.npmjs.org/pi-commandcode-provider/-/pi-commandcode-provider-${version}.tgz";
    hash = "sha256-wZ2OrFoBCtinmu1sv45acvJ3HDqX2jKP0ALW5lb4cuk=";
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
