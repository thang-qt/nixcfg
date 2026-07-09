{
  lib,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "trakt-scrobbler";
  version = "1.9.0b1";
  pyproject = true;

  src = python3Packages.fetchPypi {
    pname = "trakt_scrobbler";
    inherit version;
    hash = "sha256-Guk4TZK834sPt7WZJRV1OM6dKE2zZYsfr8adMztfAuw=";
  };

  build-system = [ python3Packages.hatchling ];

  propagatedBuildInputs = with python3Packages; [
    requests
    urllib3
    guessit
    appdirs
    confuse
    urlmatch
    pydantic
    desktop-notifier
    typer
  ];

  # Importing creates appdirs under $HOME, which is not writable in the Nix build sandbox.
  dontCheckRuntimeDeps = true;

  meta = {
    description = "Scrobbler for trakt.tv that supports VLC, Plex, MPC-HC, and MPV";
    homepage = "https://github.com/iamkroot/trakt-scrobbler";
    license = lib.licenses.gpl2Only;
    mainProgram = "trakts";
    platforms = lib.platforms.linux;
  };
}
