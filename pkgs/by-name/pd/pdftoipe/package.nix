{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  poppler,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "pdftoipe";
  version = "7.2.29.2-unstable-2026-06-07";

  src = fetchFromGitHub {
    owner = "otfried";
    repo = "ipe-tools";
    # Pinned to a master commit that fixes the build against poppler 26.06;
    # no ipe-tools release tag includes it yet.
    rev = "3875da3ae31515dad4f2aa7ac5f59f2c2f70c32c";
    hash = "sha256-HXvzSNfFZtaaJrd2kdM+VrCZMSjVYjUfi1ZJQbmgg04=";
  };

  sourceRoot = "${src.name}/pdftoipe";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ poppler ];

  installPhase = ''
    install -D pdftoipe $out/bin/pdftoipe
  '';

  meta = {
    description = "Program that tries to convert arbitrary PDF documents to Ipe files";
    homepage = "https://github.com/otfried/ipe-tools";
    changelog = "https://github.com/otfried/ipe-tools/releases";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ yrd ];
    mainProgram = "pdftoipe";
  };
}
