{ pkgs }:
rec {
  inherit (pkgs) eggDerivation fetchegg;

  args = eggDerivation {
    name = "args-1.6.0";

    src = fetchegg {
      name = "args";
      version = "1.6.0";
      sha256 = "1y9sznh4kxqxvhd8k44bjx0s7xspp52sx4bn8i8i0f8lwch6r2g4";
    };

    buildInputs = [
      srfi-1
      srfi-13
      srfi-37
    ];
  };

  defstruct = eggDerivation {
    name = "defstruct-2.0";

    src = fetchegg {
      name = "defstruct";
      version = "2.0";
      sha256 = "0q1v1gdwqlpmwcsa4jnqldfqky9k7kvb83qgkhdyqym52bm5aln8";

    };

    buildInputs = [
       srfi-1
    ];
  };

  uri-generic = eggDerivation {
    name = "uri-generic-3.2";

    src = fetchegg {
      name = "uri-generic";
      version = "3.2";
      sha256 = "1lpvnk1mnhmrga149km7ygpy7fkq7z2pvw0mvpx2aql03l8gpdsj";

    };

    buildInputs = [
       matchable
       srfi-1
       srfi-14
    ];
  };

  uri-common = eggDerivation {
    name = "uri-common-2.0";

    src = fetchegg {
      name = "uri-common";
      version = "2.0";
      sha256 = "07rq7ppkyk3i85vqspc048pnj6gmjhj236z00chslli9xybqkgrd";

    };

    buildInputs = [
       uri-generic
       defstruct
       srfi-13
    ];
  };

  srfi-18 = eggDerivation {
    name = "srfi-18-0.1.6";

    src = fetchegg {
      name = "srfi-18";
      version = "0.1.6";
      sha256 = "00lykm5lqbrcxl3dab9dqwimpgm36v4ys2957k3vdlg4xdb1abfa";

    };

    buildInputs = [
    ];
  };

  foreigners = eggDerivation {
    name = "foreigners-1.5";

    src = fetchegg {
      name = "foreigners";
      version = "1.5";
      sha256 = "1mm91y61nlawgb7iqdrkz2fi9sc3fic07f5m1ig541b2hbscfiqy";

    };

    buildInputs = [
      matchable
    ];
  };

  feature-test = eggDerivation {
    name = "feature-test-0.2.0";

    src = fetchegg {
      name = "feature-test";
      version = "0.2.0";
      sha256 = "1dxdisv64d8alg6r45cwxf5gmdpcvql1hvlq808lgwphd7kvfpgr";

    };

    buildInputs = [
      srfi-13
      srfi-18
      foreigners
    ];
  };

  socket = eggDerivation {
    name = "socket-0.3.3";

    src = fetchegg {
      name = "socket";
      version = "0.3.3";
      sha256 = "04wfxrwjizvf1jdpfqp3r7381rp9lscrm3z21ihq2dc2lfzjgrxw";

    };

    buildInputs = [
      srfi-13
      srfi-18
      foreigners
      feature-test
    ];
  };

  matchable = eggDerivation {
    name = "matchable-1.1";

    src = fetchegg {
      name = "matchable";
      version = "1.1";
      sha256 = "084hm5dvbvgnpb32ispkp3hjili8z02hamln860r99jx68jx6j2v";
    };

    buildInputs = [
      
    ];
  };

  srfi-1 = eggDerivation {
    name = "srfi-1-0.5.1";

    src = fetchegg {
      name = "srfi-1";
      version = "0.5.1";
      sha256 = "15x0ajdkw5gb3vgs8flzh5g0pzl3wmcpf11iimlm67mw6fxc8p7j";
    };

    buildInputs = [
      
    ];
  };

  srfi-13 = eggDerivation {
    name = "srfi-13-0.3";

    src = fetchegg {
      name = "srfi-13";
      version = "0.3";
      sha256 = "0yaw9i6zhpxl1794pirh168clprjgmsb0xlr96drirjzsslgm3zp";
    };

    buildInputs = [
      srfi-14
    ];
  };

  srfi-14 = eggDerivation {
    name = "srfi-14-0.2.1";

    src = fetchegg {
      name = "srfi-14";
      version = "0.2.1";
      sha256 = "0gc33cx4xll9vsf7fm8jvn3gc0604kn3bbi6jfn6xscqp86kqb9p";
    };

    buildInputs = [
      
    ];
  };

  srfi-37 = eggDerivation {
    name = "srfi-37-1.4";

    src = fetchegg {
      name = "srfi-37";
      version = "1.4";
      sha256 = "17f593497n70gldkj6iab6ilgryiqar051v6azn1szhnm1lk7dwd";
    };

    buildInputs = [
      
    ];
  };
}

