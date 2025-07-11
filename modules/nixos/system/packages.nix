{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # gnumake
    astal-shell
    bat
    binutils
    btop
    cacert
    curl
    diffutils
    dnsutils
    eza
    fd
    file
    fzf
    git
    git-lfs
    gnugrep
    gnused
    gnutar
    gnutls
    gzip
    helix
    lrzip
    micro
    ntfs3g
    openssl
    p7zip
    patch
    ripgrep
    trash-cli
    tzdata
    unrar
    unzip
    wget
    which
    whois
    yazi
    psmisc
    zip
  ];
}
