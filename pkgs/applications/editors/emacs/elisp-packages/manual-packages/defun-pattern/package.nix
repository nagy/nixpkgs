{
  lib,
  melpaBuild,
  fetchFromGitHub,
}:

melpaBuild {
  pname = "defun-pattern";
  version = "0-unstable-2022-05-20";

  src = fetchFromGitHub {
    owner = "ahyatt";
    repo = "defun-pattern";
    rev = "01f3e45b81a7d1e2b611aa30b2701096f342618c";
    hash = "sha256-ED9fuqL0sw1dlAJtNx3c0gDh8ugMq0pYrzdOIJfq7uo=";
  };

  meta = with lib; {
    homepage = "https://github.com/ahyatt/defun-pattern";
    description = "Library to allow the writing of defuns that operate using pattern-matching";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ nagy ];
  };
}
