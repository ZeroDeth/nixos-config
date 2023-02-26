{ config, pkgs, ... }:

# Not working from ChatGPT

{
  systemd.services."code-server" = {
    description = "VS Code in the browser";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    # Change these options to suit your needs
    environment = {
      PASSWORD = "your-password-here";
      EXTENSIONS = "ms-python.python ms-vscode.cpptools";
      BIND_ADDRESS = "0.0.0.0";
      PORT = "8080";
    };

    # The ExecStart line below assumes that you have created a user
    # for running code-server. If you want to run it as a different
    # user, you'll need to modify this line accordingly.
    execStart = ''${pkgs.code-server}/bin/code-server --bind-addr ${config.services.code-server.environment.BIND_ADDRESS}:${config.services.code-server.environment.PORT} --auth password --user-data-dir /var/lib/code-server --extensions ${config.services.code-server.environment.EXTENSIONS} --password ${config.services.code-server.environment.PASSWORD}'';

    # Enable auto-start at boot time
    wantedBy = [ "multi-user.target" ];
    restart = "always";
  };
}
