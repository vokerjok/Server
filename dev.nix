{ pkgs, ... }: {
  channel = "stable-23.11";

  packages = [
    pkgs.nodejs_20
    pkgs.python3
    pkgs.firefox-bin
    pkgs.proot
    pkgs.file
  ];

  env = {};

  idx = {
    extensions = [];

    previews = {
      enable = true;
      previews = {
        web = {
          command = [ "python3" "-m" "http.server" "$PORT" "--bind" "0.0.0.0" ];
          manager = "web";
        };
      };
    };

    workspace = {
      onCreate = {
        default = {
          openFiles = [ "style.css" "main.js" "index.html" ];
        };
      };

      # Auto run Firefox headless saat workspace start/restart
      onStart = {
        auto-run-root = ''
          bash setup.sh
        '';
      };
    };
  };
}
