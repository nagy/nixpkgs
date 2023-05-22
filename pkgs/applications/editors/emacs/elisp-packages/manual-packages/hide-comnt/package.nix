{
  lib,
  fetchurl,
  melpaBuild,
}:

melpaBuild {
  pname = "hide-comnt";
  version = "0-unstable-2019-11-21";

  src = fetchurl {
    url = "https://github.com/emacsmirror/emacswiki.org/raw/f08e9e45b4996a991a21a6a09851d7928d664974/hide-comnt.el";
    sha256 = "sha256-lmhkXqsf2NIjlnq5DT00/m6Yqjr0dRb0XhjwlBN9fGw=";
  };

  ignoreCompilationError = false;

  meta = with lib; {
    description = "Hide/show comments in code";
    homepage = "https://www.emacswiki.org/emacs/HideOrIgnoreComments";
    license = licenses.free;
    maintainers = with maintainers; [ nagy ];
  };
}
