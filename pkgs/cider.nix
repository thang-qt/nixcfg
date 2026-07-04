{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  cairo,
  cups,
  dbus,
  expat,
  gdk-pixbuf,
  glib,
  gtk3,
  libdrm,
  libgbm,
  libnotify,
  libpulseaudio,
  libuuid,
  libxkbcommon,
  libxcb,
  libx11,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxrandr,
  libxrender,
  libxscrnsaver,
  libxtst,
  mesa,
  nspr,
  nss,
  pango,
  systemd,
  xdg-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cider";
  version = "4.0.0";

  src = fetchurl {
    url = "https://repo.cider.sh/apt/pool/main/cider-v${finalAttrs.version}-linux-x64.deb";
    hash = "sha256-Z5B7VQatTEktt4e7aF5EGDTufgwfRHJzCZ1Lia/aIFk=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libgbm
    libnotify
    libpulseaudio
    libuuid
    libxkbcommon
    libxcb
    libx11
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxrandr
    libxrender
    libxscrnsaver
    libxtst
    mesa
    nspr
    nss
    pango
    stdenv.cc.cc.lib
    systemd
    xdg-utils
  ];

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb --fsys-tarfile $src | tar --extract --no-same-owner --no-same-permissions

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/share
    cp -r usr/lib/cider $out/lib/
    cp -r usr/share/applications usr/share/pixmaps $out/share/

    install -d $out/bin
    makeWrapper $out/lib/cider/Cider $out/bin/cider \
      --prefix PATH : ${lib.makeBinPath [ xdg-utils ]}

    runHook postInstall
  '';

  meta = {
    description = "A cross-platform Apple Music experience built on Vue.js";
    homepage = "https://cider.sh";
    downloadPage = "https://repo.cider.sh/apt";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "cider";
  };
})
