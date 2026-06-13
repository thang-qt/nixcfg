{
  pkgs,
  lib,
  ...
}:
let
  user = "thang";
  modelsHome = "/home/${user}/.local/share/ai-models";
  modelCache = "${modelsHome}/llama-cache";
  hfHome = "${modelsHome}/huggingface";
in
{
  environment.systemPackages = with pkgs; [
    llama-cpp-vulkan
    vulkan-tools
  ];

  # Models live in a hidden XDG-ish folder in $HOME. On pathway that folder is
  # bind-mounted to /data/thang/Models by data-binds.nix, so the big files stay
  # off the root disk.
  systemd.tmpfiles.rules = [
    "d /data/${user}/Models 0755 ${user} users - -"
    "d /data/${user}/Models/llama-cache 0755 ${user} users - -"
    "d /data/${user}/Models/huggingface 0755 ${user} users - -"
    "d /data/${user}/Models/huggingface/hub 0755 ${user} users - -"
    "d /home/${user}/.local 0755 ${user} users - -"
    "d /home/${user}/.local/share 0755 ${user} users - -"
    "d ${modelsHome} 0755 ${user} users - -"
  ];

  users.users.${user}.extraGroups = lib.mkAfter [
    "render"
    "video"
  ];

  environment.sessionVariables = {
    LLAMA_CACHE = modelCache;
    HF_HOME = hfHome;
    HF_HUB_CACHE = "${hfHome}/hub";
  };
}
