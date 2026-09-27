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
  gtk3,
  pantheon,
  libhandy,
  libpulseaudio,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "elementary-mixer";
  version = "1.1.0";

  src = fetchzip {
    url = "https://github.com/ChildishGiant/mixer/archive/refs/tags/${finalAttrs.version}.tar.gz";
    hash = "sha256-UVCFxTnF+ukHkVoSlk1WGgwPQaJ+KC3z+yr2Pi1UJuA=";
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
  ];

  buildInputs = [
    gtk3
    pantheon.granite
    libhandy
    libpulseaudio
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "meson.add_install_script ('meson/post_install.py')" ""
  '';

  meta = {
    description = "A simple per-application audio volume mixer";
    homepage = "https://github.com/ChildishGiant/mixer";
    license = lib.licenses.gpl3Plus;
    mainProgram = "com.github.childishgiant.mixer";
    platforms = lib.platforms.linux;
  };
})
