{ melpaBuild, fetchFromGitHub }:

melpaBuild {
  pname = "terra-mode";
  version = "0-unstable";

  src = fetchFromGitHub {
    owner = "terralang";
    repo = "terra-mode";
    rev = "ceef8cae5bddc70ee3d5d4d00aa323e3cd6a11be";
    hash = "sha256-t6d7MVGJVFereQBwDf47wsJCVwH7fjLK3vELLXQslS4=";
  };

  preBuild = ''
    rm init-tryout.el
  '';

  meta = {
    homepage = "https://github.com/terralang/terra-mode";
    description = "Emacs major mode for Terra";
  };
}
