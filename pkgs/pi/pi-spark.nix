{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "pi-spark";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "zlliang";
    repo = "pi-spark";
    rev = "v${version}";
    hash = "sha256-6JBOchC1qY/0dXZ9+iyuM5cV64KBjBHbDT6UkRfnzcQ=";
  };

  postPatch = ''
    substituteInPlace package-lock.json \
      --replace-fail 'https://mirrors.tencent.com/npm/' 'https://registry.npmjs.org/'

    awk '
      index($0, "node_modules/@earendil-works/pi-coding-agent/node_modules/@earendil-works/pi-agent-core") { integrity = "sha512-L1lw0lwR5LXCzGEeHD9XNEruU2bg0H8clOA8ySdGMHvxutp8GC+yZL6MZp4tqQRnLKP3gHmY7TrWzQ3YnFdJYQ==" }
      index($0, "node_modules/@earendil-works/pi-coding-agent/node_modules/@earendil-works/pi-ai") { integrity = "sha512-N9RDk8q0eglGiy+NqTZ3Ev2j+6oFNXSAJa8b0CYhvWB9HGiKZjsoCESXkUvMDLybrn0wXp75sdsoBzEtHxk9kA==" }
      index($0, "node_modules/@earendil-works/pi-coding-agent/node_modules/@earendil-works/pi-client") { integrity = "sha512-fHXgw1FdLDh+uw42SvTkJRBfgc3nsrslghvbRFEAxdjfcOxJt7hPsTj4HHNK96wMy1f+zvQYL8Y2znvFoZ8JDA==" }
      index($0, "node_modules/@earendil-works/pi-coding-agent/node_modules/@earendil-works/pi-protocol") { integrity = "sha512-Fc28cCYGg5+aRnMzbAD7QAi6Xl//kbETyFroLHCs3Zf4oaXH9L2gzBqVLVAwrKIKeS0uffUrmihocGTECfKW6Q==" }
      index($0, "node_modules/@earendil-works/pi-coding-agent/node_modules/@earendil-works/pi-telemetry") { integrity = "sha512-g6hLxEfAUk3zJlDmFWhWHJNcYXYiNGeWuJC9YkcHpkdkj0gxD4uaMNNNU3QsAEJXW9Qcxnl21+U8GfhVsc8C5g==" }
      index($0, "node_modules/@earendil-works/pi-coding-agent/node_modules/@earendil-works/pi-tui") { integrity = "sha512-nbs0FeZJ5rWDD6VpKfXXmYbEHnHqb40V9glE2l9f8ftoWpsP8nw0WcXK8jOjfRsDPnT9dJHy3dItOHdn/AFGjA==" }
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

  npmDepsHash = "sha256-HqH6RTjkP1OX/1Yxdwkmtddju+YfnBA5H2eRqet5awE=";
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
    description = "Pi package that polishes your daily experience";
    homepage = "https://github.com/zlliang/pi-spark";
    license = lib.licenses.mit;
  };
}
