{ lib
, stdenv
, fetchFromGitHub
, help2man
, installShellFiles
}:

stdenv.mkDerivation rec {
  pname = "darkhttpd";
  version = "1.16";

  src = fetchFromGitHub {
    owner = "emikulic";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dcNoGU08tu950PlwSghoZwGSaSbP8NJ5qhWUi3bAtZY=";
  };

  nativeBuildInputs = [ installShellFiles ];

  outputs = [ "out" "man" ];

  postBuild = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    ${help2man}/bin/help2man ./darkhttpd \
      --version-string=${version} --no-info --section 8 --output ${pname}.8
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin darkhttpd
    install -Dm644 -t $out/share/doc/${pname} README.md COPYING
    installManPage ${pname}.8

    runHook postInstall
  '';

  meta = with lib; {
    description = "Small and secure static webserver";
    mainProgram = "darkhttpd";
    homepage = "https://unix4lyfe.org/darkhttpd/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bobvanderlinden ];
    platforms = platforms.all;
  };
}
