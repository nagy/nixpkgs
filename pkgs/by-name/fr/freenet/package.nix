{
  lib,
  stdenv,
  fetchFromGitHub,
  jdk_headless,
  jre_headless,
  gradle_8,
  bash,
  coreutils,
  replaceVars,
  nixosTests,
  writeText,
}:

let
  gradle = gradle_8;
  jdk = jdk_headless;
  # headless daemon: the full JRE would drag the GUI stack into the closure
  jre = jre_headless;

  seednodes = fetchFromGitHub {
    name = "freenet-seednodes";
    owner = "hyphanet";
    repo = "seedrefs";
    rev = "b34dbc4d021c58c4a108214a71a9e1ab986c4e14";
    hash = "sha256-c04gKNPZtiIdmKmPJ71iXIEXzOoBMw32I2rAsN1+a8Q=";
    postFetch = ''
      cat $out/* > $out/seednodes.fref
    '';
  };

in
stdenv.mkDerivation rec {
  pname = "freenet";
  version = "01506";

  src = fetchFromGitHub {
    owner = "hyphanet";
    repo = "fred";
    tag = "build${version}";
    hash = "sha256-MmI/e/Sh4WeSSw2//xpmJtF5/oC9+eauXnTMLuojb2A=";
  };

  nativeBuildInputs = [
    gradle
    jdk
  ];

  wrapper = replaceVars ./freenetWrapper {
    inherit
      bash
      coreutils
      jre
      seednodes
      ;
    # replaced in installPhase
    CLASSPATH = null;
  };

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  # Replaces the default gradle init script, whose reproducible-archive
  # flags break this build. The only thing it adds is a task that copies
  # the resolved runtime classpath (configurations.runtimeClasspath) next
  # to the built jar; installPhase ships exactly those jars. Using gradle's
  # own resolution means exactly one version of each artifact ends up in
  # the classpath — no stale duplicates like the bcprov copy that used to
  # need filtering out of the dependency cache.
  gradleInitScript = writeText "copy-runtime-deps.gradle" ''
    gradle.projectsLoaded {
      rootProject.allprojects {
        task copyRuntimeDeps(type: Copy) {
          into new File(project.buildDir, 'runtime-deps')
          // lazy: evaluated at execution, after the java plugin is applied
          from { configurations.runtimeClasspath }
        }
      }
    }
  '';

  gradleFlags = [ "-Dorg.gradle.java.home=${jdk}" ];

  gradleBuildTask = "jar copyRuntimeDeps";

  installPhase = ''
    runHook preInstall

    install -Dm644 build/libs/freenet.jar $out/share/freenet/freenet.jar
    mkdir -p $out/bin $out/lib
    # The jars gradle resolved for the runtime classpath; includes
    # freenet-ext, byte-identical to the upstream release jar. The
    # wrapper's classpath wildcard ($out/lib/*) is expanded by the JVM
    # launcher, so no classpath string needs baking here.
    install -Dm644 build/runtime-deps/*.jar $out/lib/
    install -Dm755 ${wrapper} $out/bin/freenet
    substituteInPlace $out/bin/freenet \
      --subst-var-by CLASSPATH "$out/lib/*:$out/share/freenet/freenet.jar"

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) freenet;
  };

  meta = {
    description = "Decentralised and censorship-resistant network";
    homepage = "https://freenetproject.org/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ nagy ];
    platforms = with lib.platforms; linux;
    changelog = "https://github.com/hyphanet/fred/blob/build${version}/NEWS.md";
    mainProgram = "freenet";
  };
}
