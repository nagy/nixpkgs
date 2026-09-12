{
  lib,
  stdenv,
  fetchFromCodeberg,
  rustPlatform,
  meson,
  ninja,
  pkg-config,
  cargo,
  rustc,
  blueprint-compiler,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
  libshumate,
  alsa-lib,
  espeak,
  sqlite,
  glib-networking,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jogger";
  version = "1.4.0";

  src = fetchFromCodeberg {
    owner = "baarkerlounger";
    repo = "jogger";
    tag = finalAttrs.version;
    hash = "sha256-pY5U229cL3w78GIegke53aYMzumzkpzX/CxXm6VgqG0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-h+q8VATE5rEh4szBUkvsGl82qlhuKzILW6LPFhQqeEQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    cargo
    rustc
    blueprint-compiler
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
    libshumate
    alsa-lib
    espeak
    sqlite
    glib-networking
  ];

  meta = {
    description = "App for Gnome Mobile to Track running and other workouts";
    homepage = "https://codeberg.org/baarkerlounger/jogger";
    license = with lib.licenses; [
      gpl3Plus
      cc0
    ];
    mainProgram = "jogger";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
