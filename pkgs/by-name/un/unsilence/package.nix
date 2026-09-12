{
  lib,
  fetchFromGitHub,
  python3Packages,
  ffmpeg,
}:
python3Packages.buildPythonPackage rec {
  pname = "unsilence";
  version = "1.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lagmoellertim";
    repo = "unsilence";
    rev = version;
    hash = "sha256-M4Ek1JZwtr7vIg14aTa8h4otIZnPQfKNH4pZE4GpiBQ=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    packaging
    rich
  ];

  makeWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ ffmpeg ]}"
  ];

  doCheck = false;
  pythonImportsCheck = [ "unsilence" ];

  # Replace pkg_resources (removed from setuptools >= 81) with packaging
  postPatch = ''
    substituteInPlace unsilence/lib/tools/ffmpeg_version.py \
      --replace-fail 'from pkg_resources import parse_version' \
        'from packaging.version import parse as parse_version'
  '';

  pythonRelaxDeps = [ "rich" ];

  meta = {
    homepage = "https://github.com/lagmoellertim/unsilence";
    description = "Console Interface and Library to remove silent parts of a media file";
    mainProgram = "unsilence";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ esau79p ];
  };
}
