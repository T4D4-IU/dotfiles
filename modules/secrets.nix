{inputs, ...}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = "${inputs.my-secrets}/secrets.yaml";
    defaultSopsFormat = "yaml";

    #age.keyFile = "/home/t4d4/.config/sops/age/keys.txt";
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  };
}
