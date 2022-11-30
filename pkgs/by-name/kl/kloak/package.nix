{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  ronn,
  libsodium,
  libevdev,
}:

stdenv.mkDerivation {
  pname = "kloak";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "vmonaco";
    repo = "kloak";
    rev = "d343f5e41124ff32ee78badeee540dfdea59b8ac";
    sha256 = "sha256-QP6hpSBATFb0ugnjkVMf7cLM2WHKSUZbCwPfDDaWjVY=";
  };

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    ronn
  ];

  buildInputs = [
    libsodium
    libevdev
  ];

  outputs = [
    "out"
    "man"
  ];

  patchPhase = ''
    runHook prePatch

    substituteInPlace Makefile --replace gcc $CC

    runHook postPatch
  '';

  postBuild = ''
    ronn --roff man/{kloak,eventcap}.8.ronn
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin kloak eventcap
    installManPage man/{kloak,eventcap}.8

    runHook postInstall
  '';

  meta = {
    description = "Keystroke-level online anonymization kernel: obfuscates typing behavior at the device level";
    homepage = "https://github.com/vmonaco/kloak";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nagy ];
    mainProgram = "kloak";
  };
}
