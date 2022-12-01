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
      enable = lib.mkEnableOption (lib.mdDoc "Freenet daemon");

      nice = lib.mkOption {
        type = lib.types.int;
        default = 10;
        description = "Set the nice level for the Freenet daemon";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.freenet = {
      inherit (pkgs.freenet.meta) description;
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = lib.getExe pkgs.freenet;
        User = "freenet";
        UMask = "0007";
        WorkingDirectory = varDir;
        Nice = cfg.nice;

        # Hardening
        PrivateDevices = true;
        PrivateTmp = true;
        RestrictRealtime = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        NoNewPrivileges = true;
        ProtectProc = "invisible";
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
