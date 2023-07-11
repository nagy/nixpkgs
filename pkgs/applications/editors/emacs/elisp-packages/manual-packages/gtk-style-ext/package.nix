{
  pkgs,
  lib,
  trivialBuild,
  pkg-config,
  fetchFromGitHub,
  autoreconfHook,
  gtk3,
}:

let
  libExt = pkgs.stdenv.targetPlatform.extensions.sharedLibrary;
in
trivialBuild {
  pname = "gtk-style-ext";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "Soft";
    repo = "emacs-gtk-style-ext";
    rev = "master";
    hash = "sha256-HCgNQ5qwzM1N5LXXz6TRYfs6GHEfwn85XEpYH7TGb9o=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [ gtk3 ];

  preBuild = ''
    make
    ln -s .libs/gtk-style-ext-sys${libExt}
  '';

  preInstall = ''
    install -Dm644 -t $out/share/emacs/site-lisp/ .libs/gtk-style-ext-sys${libExt}
  '';

  meta = with lib; {
    # homepage = "https://github.com/syohex/emacs-lua";
    # description = "Lua engine from Emacs Lisp";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nagy ];
  };
}
