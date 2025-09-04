let
  thang = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHBJBKQp7sDnkrA4tzX04AYCTsUdmhXwjZhXLVaKv4eP";
  satellite = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINnk4Fgq7ovbGagkZF6pbQ5I3hEfTjM7l8EblQHZei7G thang@nixos";
in
{
  "warp_priv_key.age".publicKeys = [ satellite ];
  "vaultwarden_env.age".publicKeys = [ satellite ];
  "openwebui_env.age".publicKeys = [ satellite ];
  "readn_auth.age".publicKeys = [ satellite ];
}
