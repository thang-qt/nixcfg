{inputs, ...}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  # Every NixOS host uses one pre-provisioned native age identity. Fail closed
  # when it is missing rather than generating an identity that cannot decrypt
  # ciphertext addressed to the previous recipient.
  sops.age = {
    keyFile = "/var/lib/sops-nix/key.txt";
    generateKey = false;
    sshKeyPaths = [];
  };
  sops.gnupg.sshKeyPaths = [];

  systemd.tmpfiles.rules = [
    "d /var/lib/sops-nix 0700 root root -"
  ];
}
