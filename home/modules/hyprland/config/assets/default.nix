{
  config,
  lib,
  username,
  ...
}:
with lib;
let
  cfg = config.custom.assets;
in
{
  options.custom.assets = {
    enable = mkEnableOption "Configure custom assets";
    assetsPath = mkOption {
      type = types.path;
      description = "Path to assets directory";
    };

    targetDir = mkOption {
      type = types.str;
      default = "/home/${username}/.config/cafeos-assets";
      description = "Target directory for assets";
    };
  };

  config = mkIf cfg.enable {
    home.file =
      let
        files = builtins.readDir cfg.assetsPath;

        fileMapper =
          fileName:
          nameValuePair "${cfg.targetDir}/${fileName}" { source = "${cfg.assetsPath}/${fileName}"; };

        isNotNixFile = fileName: !(hasSuffix ".nix" fileName);

        validFiles = filter isNotNixFile (builtins.attrNames files);

      in

      builtins.listToAttrs (map fileMapper validFiles);
  };
}
