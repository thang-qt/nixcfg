{
  lib,
  stdenv,
  fetchzip,
  meson,
  ninja,
  pkg-config,
  vala,
  gettext,
  desktop-file-utils,
  appstream-glib,
  glib,
  wrapGAppsHook4,
  gtk4,
  pantheon,
  libgee,
  json-glib,
  libportal,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "jorts";
  version = "4.4.0";

  src = fetchzip {
    url = "https://codeberg.org/elly-code/jorts/archive/${finalAttrs.version}.tar.gz";
    hash = "sha256-nsHNGxhQSaJ+UGlW2Qf62CFfpN1cvPfg3IoG/cktcRs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gettext
    desktop-file-utils
    appstream-glib
    glib
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    pantheon.granite7
    libgee
    json-glib
    libportal
  ];

  mesonFlags = [
    "-Dicon_variant=default"
    "-Dprofile=linux"
  ];

  postInstall = ''
    glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  meta = {
    description = "A sticky notes app for elementary OS";
    homepage = "https://codeberg.org/elly-code/jorts";
    license = lib.licenses.gpl3Plus;
    mainProgram = "page.codeberg.elly_code.jorts";
    platforms = lib.platforms.linux;
  };
})
