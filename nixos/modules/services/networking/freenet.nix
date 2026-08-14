{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.freenet;
  varDir = "/var/lib/freenet";
in
{
  options = {
    services.freenet = {
      enable = lib.mkEnableOption "Freenet daemon";

      nice = lib.mkOption {
        type = lib.types.ints.between (-20) 19;
        default = 10;
        description = "Set the nice level for the Freenet daemon";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.freenet = {
      description = "Freenet daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        FREENET_HOME = varDir;
      };
      # TODO: remove the migration (and the matching block in
      # nixos/tests/freenet.nix) once NixOS 27.05 has shipped. It moves
      # data from installs that predate the FREENET_HOME pinning, which
      # lived under varDir/.local/share/freenet.
      preStart = ''
        d=${varDir}/.local/share/freenet
        [[ -d "$d" && ! -e ${varDir}/freenet.ini ]] && mv -v "$d"/* ${varDir}/ && rmdir "$d" || true
      '';
      serviceConfig = {
        ExecStart = lib.getExe pkgs.freenet;
        User = "freenet";
        UMask = "0007";
        WorkingDirectory = varDir;
        Nice = cfg.nice;
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };

    users.users.freenet = {
      group = "freenet";
      description = "Freenet daemon user";
      home = varDir;
      createHome = true;
      uid = config.ids.uids.freenet;
    };

    users.groups.freenet.gid = config.ids.gids.freenet;
  };

  meta.maintainers = with lib.maintainers; [ nagy ];
}
