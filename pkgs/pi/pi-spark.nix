{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "pi-spark";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "zlliang";
    repo = "pi-spark";
    rev = "v${version}";
    hash = "sha256-fsXshFrPVZfS/p4hOeZRhVdbKodI2bhgbrrHfmtOPJs=";
  };

  # The upstream lockfile has three duplicate peer-package entries without
  # integrity fields. Add the matching npm registry integrities so Nix can
  # prefetch dependencies reproducibly.
  # pi-spark 0.15.0 expects newer Pi config helpers; keep it compatible with
  # our Pi by falling back to the standard config paths when those helpers are
  # unavailable at runtime.
  postPatch = ''
      substituteInPlace src/config/index.ts \
        --replace-fail 'return [join(getAgentDir(), fileName), join(cwd, CONFIG_DIR_NAME, fileName)];' 'const agentDir = getAgentDir() ?? join(process.env.HOME ?? "", ".pi", "agent");
    const configDirName = CONFIG_DIR_NAME ?? ".pi";
    return [join(agentDir, fileName), join(cwd, configDirName, fileName)];'

      substituteInPlace package-lock.json \
        --replace-fail '"resolved": "https://registry.npmjs.org/@earendil-works/pi-agent-core/-/pi-agent-core-0.79.7.tgz",' '"resolved": "https://registry.npmjs.org/@earendil-works/pi-agent-core/-/pi-agent-core-0.79.7.tgz",
        "integrity": "sha512-kbwGwqq2oy0fr1WYCCgKavUriEL7pWQN/vkF8oCnZ8H+0xu86kAp1iHEVWsMm+NyslLCe4SA1ushfMT/yFhQfQ==",' \
        --replace-fail '"resolved": "https://registry.npmjs.org/@earendil-works/pi-ai/-/pi-ai-0.79.7.tgz",' '"resolved": "https://registry.npmjs.org/@earendil-works/pi-ai/-/pi-ai-0.79.7.tgz",
        "integrity": "sha512-KTe2euBoBEmFb0W+KR05Im8Qq4coU+eo46++UgNAfT3L8OIBv3QU+/pif9EqaFQ1QUmirv8kgy4TQltvrCu7iQ==",' \
        --replace-fail '"resolved": "https://registry.npmjs.org/@earendil-works/pi-tui/-/pi-tui-0.79.7.tgz",' '"resolved": "https://registry.npmjs.org/@earendil-works/pi-tui/-/pi-tui-0.79.7.tgz",
        "integrity": "sha512-FtPN6H8gBvaVJWmPAmtB2dviecoCyrxB6SJUBuZ62p8zdiDgDlfAiYxNqTA2/R2iklqBZA83YcLLFWeMAyFuHw==",'

      sed -i \
        -e 's/^      "integrity": "sha512-kbwGwqq2oy0fr1WYCCgKavUriEL7pWQN\/vkF8oCnZ8H+0xu86kAp1iHEVWsMm+NyslLCe4SA1ushfMT\/yFhQfQ==",/  "integrity": "sha512-kbwGwqq2oy0fr1WYCCgKavUriEL7pWQN\/vkF8oCnZ8H+0xu86kAp1iHEVWsMm+NyslLCe4SA1ushfMT\/yFhQfQ==",/' \
        -e 's/^      "integrity": "sha512-KTe2euBoBEmFb0W+KR05Im8Qq4coU+eo46++UgNAfT3L8OIBv3QU+\/pif9EqaFQ1QUmirv8kgy4TQltvrCu7iQ==",/  "integrity": "sha512-KTe2euBoBEmFb0W+KR05Im8Qq4coU+eo46++UgNAfT3L8OIBv3QU+\/pif9EqaFQ1QUmirv8kgy4TQltvrCu7iQ==",/' \
        -e 's/^      "integrity": "sha512-FtPN6H8gBvaVJWmPAmtB2dviecoCyrxB6SJUBuZ62p8zdiDgDlfAiYxNqTA2\/R2iklqBZA83YcLLFWeMAyFuHw==",/  "integrity": "sha512-FtPN6H8gBvaVJWmPAmtB2dviecoCyrxB6SJUBuZ62p8zdiDgDlfAiYxNqTA2\/R2iklqBZA83YcLLFWeMAyFuHw==",/' \
        package-lock.json
  '';

  npmDepsHash = "sha256-Cr7eHY9JJKzQVajTccNpSE1ywe+1mawJNEHqS8EIFBo=";
  npmDepsFetcherVersion = 2;
  npmFlags = ["--legacy-peer-deps"];
  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R . $out/
    runHook postInstall
  '';

  meta = {
    description = "Pi package that polishes your daily experience";
    homepage = "https://github.com/zlliang/pi-spark";
    license = lib.licenses.mit;
  };
}
