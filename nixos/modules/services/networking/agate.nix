{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.agate;
  user = if cfg.user != null then cfg.user else "agate";
in

{

  ###### interface

  options = {

    services.agate = {

      enable = mkEnableOption
        "Agate, gemini server";

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/${user}/";
        description = ''
          The directory holding configuration, incoming and temporary files.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.agate;
        defaultText = "pkgs.agate";
        example = literalExample "pkgs.agate";
        description = ''
          The Agate package to use.
        '';
      };

      user = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The user the Agate daemon should run as.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    users.users = mkIf (cfg.user == null) [
      { name = "agate";
        description = "Agate daemon";
        group = "agate";
        uid = config.ids.uids.agate;
      } ];

    users.groups = mkIf (cfg.user == null) [
      { name = "agate";
        gid = config.ids.gids.agate;
      } ];

    systemd.services.agate = {
      description = "Agate daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      preStart = ''
        mkdir -p ${cfg.dataDir}
        chown ${user} ${cfg.dataDir}
      '';

      execStart = ''${pkgs.agate}/bin/agate'';
    };
  };
}
