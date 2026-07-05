{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "pi-subagents";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "nicobailon";
    repo = "pi-subagents";
    rev = "v${version}";
    hash = "sha256-534OtNSO5/YBM3/407wFMf8dwfImw1e38251mnEn63Y=";
  };

  jitiSrc = fetchurl {
    url = "https://registry.npmjs.org/jiti/-/jiti-2.7.0.tgz";
    hash = "sha512-AC/7JofJvZGrrneWNaEnJeOLUx+JlGt7tNa0wZiRPT4MY1wmfKjt2+6O2p2uz2+skll8OZZmJMNqeke7kKbNgQ==";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R agents prompts skills src install.mjs package.json README.md CHANGELOG.md $out/

    # Async/background execution resolves jiti from the pi-subagents package root.
    # Vendor it here instead of relying on mutable `npm install -g jiti` state.
    mkdir -p $out/node_modules/jiti
    tar -xzf ${jitiSrc} -C $out/node_modules/jiti --strip-components=1

    runHook postInstall
  '';

  meta = {
    description = "Pi extension for delegating tasks to subagents";
    homepage = "https://github.com/nicobailon/pi-subagents";
    license = lib.licenses.mit;
  };
}
