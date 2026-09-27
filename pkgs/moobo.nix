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
  wrapGAppsHook3,
  gtk3,
  pantheon,
  libhandy,
  json-glib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "moobo";
  version = "0.1.3";

  src = fetchzip {
    url = "https://github.com/brain-child/moobo/archive/refs/tags/${finalAttrs.version}.tar.gz";
    hash = "sha256-H6cEK5gN8jkOxOmF05xLfoh98h6med9mtX8O2DRdKiA=";
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
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    pantheon.granite
    libhandy
    json-glib
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "meson.add_install_script ('meson/post_install.py')" ""
  '';

  postInstall = ''
    glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  meta = {
    description = "A moodboarding and note-taking application";
    homepage = "https://github.com/brain-child/moobo";
    license = lib.licenses.gpl3Plus;
    mainProgram = "com.github.brain_child.moobo";
    platforms = lib.platforms.linux;
  };
})
