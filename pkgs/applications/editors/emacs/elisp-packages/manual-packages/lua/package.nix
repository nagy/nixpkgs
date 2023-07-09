{
  lib,
  stdenv,
  lua,
  melpaBuild,
  pkg-config,
  fetchFromGitHub,
}:

melpaBuild {
  pname = "lua";
  version = "0-unstable-2022-01-24";

  src = fetchFromGitHub {
    owner = "syohex";
    repo = "emacs-lua";
    rev = "8c100ce9e97a627287b57b021869318ad290a17f";
    hash = "sha256-mf/BNImUrtwJI0i8ahgY3e3hpLzdoSyMwGz4qNLVjGQ=";
  };

  preBuild = ''
    make LUA_VERSION=${lua.luaversion}
  '';

  ignoreCompilationError = false;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ lua ];

  files = ''(:defaults "lua-core${stdenv.hostPlatform.extensions.sharedLibrary}")'';

  meta = with lib; {
    homepage = "https://github.com/syohex/emacs-lua";
    description = "Lua engine from Emacs Lisp";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nagy ];
  };
}
