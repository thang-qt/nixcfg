{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchurl,
}:
buildNpmPackage rec {
  pname = "pi-mcp-adapter";
  version = "2.26.0";

  src = fetchFromGitHub {
    owner = "nicobailon";
    repo = "pi-mcp-adapter";
    rev = "v${version}";
    hash = "sha256-l8PDjwNk6SC4mzanp7gxOCsVm2NQcigNBl+7zs+CbWM=";
  };

  typeboxSrc = fetchurl {
    url = "https://registry.npmjs.org/typebox/-/typebox-1.3.3.tgz";
    hash = "sha256-MqzN8lNFA7nG0KcOsTgYgwfSML9kX5OCpub3qtFhtNw=";
  };

  postPatch = ''
    awk '
      index($0, "node_modules/@earendil-works/pi-coding-agent/node_modules/@earendil-works/pi-agent-core") { integrity = "sha512-evyzXYWCLQGmcaBYHlmSku02r8qoN4SGI60GZABo6iV+H+nqX+P9ud8fEZ4GmRq9mUSREvvfX+w9dA9ThF9C6w==" }
      index($0, "node_modules/@earendil-works/pi-coding-agent/node_modules/@earendil-works/pi-ai") { integrity = "sha512-wMsAdJMxuNri08vLqTyYVI201DQQezGhPSTkzYsHdw5dYX3rCNwEmSvpaAwhi7ELKI/2tE/CEgSWg/6iRxSgdQ==" }
      index($0, "node_modules/@earendil-works/pi-coding-agent/node_modules/@earendil-works/pi-client") { integrity = "sha512-/V5hGHE4Zq+jG0GtwIB9PyBUOGd6gBLZ7lkQYFKchKnxYHeH3rmWC5xw4kpnZKKBuBuFTdLVbU9vEjlAGMMb2A==" }
      index($0, "node_modules/@earendil-works/pi-coding-agent/node_modules/@earendil-works/pi-protocol") { integrity = "sha512-Ox1pciyeSPGEEUcxvR0/dJcrY7C6hrEGA8y71rOsvSIUlXN1Cbp/be/eoL71OGDBk5O97TeQPfWN6Ju/2Ehjww==" }
      index($0, "node_modules/@earendil-works/pi-coding-agent/node_modules/@earendil-works/pi-telemetry") { integrity = "sha512-180/xGJtsq7IoR3p9EKWjRd0e9M4DkxInhlo9xyD7prDC7Qrhqq+nhvwrW0lFjPfXcEI2FSHmGCSyvSJE9GsaQ==" }
      index($0, "node_modules/@earendil-works/pi-coding-agent/node_modules/@earendil-works/pi-tui") { integrity = "sha512-udeXFbgEhJ6JiB0uguwNVNkDy2FENfmtQwPcY+/iJ8GWeq18wkal1tKqa5YyeH0IqtX1vG0cGh8zfSYzyzVuLA==" }
      integrity != "" && index($0, "resolved") {
        print
        print sprintf("      %cintegrity%c: %c%s%c,", 34, 34, 34, integrity, 34)
        integrity = ""
        next
      }
      { print }
    ' package-lock.json > package-lock.json.tmp
    mv package-lock.json.tmp package-lock.json
  '';

  npmDepsHash = "sha256-QfssD73hzWrKbbJmmzWIYkT1OxaRdu9Ju+sMLIbiJtQ=";
  npmDepsFetcherVersion = 2;
  npmFlags = ["--legacy-peer-deps"];
  npmInstallFlags = ["--omit=dev"];
  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R . $out/

    # typebox is an optional peer in the upstream package but is imported at runtime.
    mkdir -p $out/node_modules
    tar -xzf ${typeboxSrc} -C $out/node_modules
    mv $out/node_modules/package $out/node_modules/typebox

    runHook postInstall
  '';

  meta = {
    description = "MCP adapter extension for Pi coding agent";
    homepage = "https://github.com/nicobailon/pi-mcp-adapter";
    license = lib.licenses.mit;
  };
}
