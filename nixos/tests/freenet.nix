{ lib, ... }:

{
  name = "freenet";
  meta.maintainers = [ lib.maintainers.nagy ];

  nodes.machine = {
    services.freenet.enable = true;
  };

  testScript = ''
    machine.wait_for_unit("freenet.service")
    machine.wait_for_open_port(8888)
    assert "Freenet" in machine.wait_until_succeeds("curl -sfL localhost:8888")
    machine.succeed("systemctl stop freenet")
    machine.wait_for_closed_port(8888)
  '';
}
