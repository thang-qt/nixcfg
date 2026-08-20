{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "pi-subagents";
  version = "0.50.0";

  src = fetchFromGitHub {
    owner = "nicobailon";
    repo = "pi-subagents";
    rev = "v${version}";
    hash = "sha256-2lv3e6s+AVXL5Da/+PhSzG4b5Hc62+2MY0mjqSPBoVo=";
  };

  npmDepsHash = "sha256-61WhRXAS+JUDXQurNwdtc0ATi/gqrEcYnctvwDOa2B4=";
  npmDepsFetcherVersion = 2;
  npmFlags = ["--legacy-peer-deps"];
  npmInstallFlags = ["--omit=dev"];
  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R . $out/
    runHook postInstall
  '';

  meta = {
    description = "Pi extension for delegating tasks to subagents";
    homepage = "https://github.com/nicobailon/pi-subagents";
    license = lib.licenses.mit;
  };
}
