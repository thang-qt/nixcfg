{
  lib,
  stdenvNoCC,
  fetchurl,
  python3,
}:

stdenvNoCC.mkDerivation rec {
  pname = "pi-multi-account";
  version = "1.13.14";

  src = fetchurl {
    url = "https://registry.npmjs.org/pi-multi-account/-/pi-multi-account-${version}.tgz";
    hash = "sha256-GB+j7TJHlGrEAKWju049ygfLpYr2CAtBHJ3d8qebae4=";
  };

  sourceRoot = "package";

  nativeBuildInputs = [ python3 ];

  postPatch = ''
    # Keep pi-multi-account scoped to providers it manages when configured.
    # Keep errors from unmanaged external providers outside Codex account
    # rotation.
    python3 - <<'PY'
    from pathlib import Path
    path = Path("index.ts")
    text = path.read_text()
    replacements = [
        ("includeCursor?: boolean;", "includeCursor?: boolean;\n\trescueUnmanagedProviders?: boolean;"),
        ('| "includeCursor"', '| "includeCursor"\n\t\t| "rescueUnmanagedProviders"'),
        (
            "includeCursor: true,\n\tproviderOrder: DEFAULT_PROVIDER_ORDER,",
            "includeCursor: true,\n\trescueUnmanagedProviders: true,\n\tproviderOrder: DEFAULT_PROVIDER_ORDER,",
        ),
        (
            "includeCursor: raw.includeCursor ?? true,\n\t\tproviderOrder: order.filter(",
            "includeCursor: raw.includeCursor ?? true,\n\t\trescueUnmanagedProviders: raw.rescueUnmanagedProviders ?? true,\n\t\tproviderOrder: order.filter(",
        ),
        (
            "if (!managed) {\n\t\t\tif (",
            "if (!managed) {\n\t\t\tif (!config.rescueUnmanagedProviders) return;\n\t\t\tif (",
        ),
    ]
    for old, new in replacements:
        if old not in text:
            raise SystemExit(f"missing pi-multi-account patch target: {old!r}")
        text = text.replace(old, new, 1)
    path.write_text(text)
    PY
  '';

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
