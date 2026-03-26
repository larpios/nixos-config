# System user accounts.
{config, ...}: {
  users.users."${config.username}" = {
    isNormalUser = true;
    description = "${config.username}";
    extraGroups = ["networkmanager" "wheel" "docker"];
  };
}
