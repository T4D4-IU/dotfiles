{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gobuster # Tool used to brute-force URIs and DNS subdomains.
    sniffnet # Cross-platform application to monitor your network traffic with ease
    metasploit # Metasploit Framework - a collection of exploits
  ];
}
