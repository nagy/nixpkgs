{ lib, ... }:

{
  name = "freenet";
  meta = {
    maintainers = with lib.maintainers; [ nagy ];
  };

  nodes = {
    machine = {
      services.freenet.enable = true;
    };
  };

  testScript = ''
    machine.wait_for_unit("freenet.service")
    machine.wait_for_open_port(8888)
    machine.wait_until_succeeds("curl -sfL http://localhost:8888/ | grep Freenet")
    machine.succeed("systemctl stop freenet")
    # one-time migration: pre-FREENET_HOME installs kept data in
    # /var/lib/freenet/.local/share/freenet; it must move up a level
    machine.succeed("rm -rf /var/lib/freenet && mkdir -p /var/lib/freenet/.local/share/freenet && chown -R freenet:freenet /var/lib/freenet && touch /var/lib/freenet/.local/share/freenet/olddata-marker")
    machine.succeed("systemctl start freenet")
    machine.wait_for_open_port(8888)
    machine.wait_until_succeeds("test -f /var/lib/freenet/olddata-marker")
    machine.wait_until_succeeds("test ! -e /var/lib/freenet/.local/share/freenet")
    machine.succeed("systemctl stop freenet")
  '';
}
