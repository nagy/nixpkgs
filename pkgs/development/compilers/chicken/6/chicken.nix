{
  lib,
  stdenv,
  fetchurl,
  darwin,
  bootstrap-chicken ? null,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chicken";
  version = "6.0.0";

  binaryVersion = 12;

  src = fetchurl {
    url = "https://code.call-cc.org/releases/${finalAttrs.version}/chicken-${finalAttrs.version}.tar.gz";
    sha256 = "0hzl875whdnkyv06x0gq57s0nl9np9d9nhkyfckav1xnn595b0wj";
  };

  # Disable two broken tests: "static link" and "linking tests"
  postPatch = ''
    sed -i tests/runtests.sh -e "/static link/,+4 { s/^/# / }"
    sed -i tests/runtests.sh -e "/linking tests/,+11 { s/^/# / }"
  '';

  setupHook = lib.optional (bootstrap-chicken != null) ./setup-hook.sh;

  # Since CHICKEN 6, a configure script is used to prepare the sources for
  # building (it writes config.make, which is included by GNUmakefile).
  configureFlags = [
    "--platform=${
      with stdenv;
      if isDarwin then
        "macosx"
      else if isCygwin then
        "cygwin"
      else if (isFreeBSD || isOpenBSD) then
        "bsd"
      else if isSunOS then
        "solaris"
      else
        "linux" # Should be a sane default
    }"
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "--host=${stdenv.hostPlatform.config}"
  ];

  nativeBuildInputs = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    darwin.autoSignDarwinBinariesHook
  ];

  buildInputs = lib.optionals (bootstrap-chicken != null) [
    bootstrap-chicken
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;
  postCheck = ''
    ./csi -R chicken.pathname -R chicken.platform \
       -p "(assert (equal? \"${toString finalAttrs.binaryVersion}\" (pathname-file (car (repository-path)))))"
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "csi -version";
  };

  meta = {
    homepage = "https://call-cc.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      corngood
      nagy
      konst-aa
    ];
    platforms = lib.platforms.unix;
    description = "Portable compiler for the Scheme programming language";
    longDescription = ''
      CHICKEN is a compiler for the Scheme programming language.
      CHICKEN produces portable and efficient C, supports almost all
      of the R5RS Scheme language standard, and includes many
      enhancements and extensions. CHICKEN runs on Linux, macOS,
      Windows, and many Unix flavours.
    '';
  };
})
