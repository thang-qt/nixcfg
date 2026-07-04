{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "pi-multi-account";
  version = "1.13.5";

  src = fetchurl {
    url = "https://registry.npmjs.org/pi-multi-account/-/pi-multi-account-${version}.tgz";
    hash = "sha256-WeciDpNehPzwQiq0ry3DDv72HUGdbejDWLnEtRbBM8g=";
  };

  sourceRoot = "package";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R . $out/
    runHook postInstall
  '';

  meta = {
    description = "Automatic multi-account failover and rotation for Pi Agent";
    homepage = "https://pi.dev/packages/pi-multi-account";
    license = lib.licenses.mit;
  };
}
