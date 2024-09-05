with import <nixpkgs> {};

let
  unstable = import
    (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz")
    # reuse the current configuration
    { config = config; };
in
pkgs.mkShell {

  # add binaries
  packages = with pkgs.python311Packages; [
	unstable.zig
  ];

  # add build dependecies from list of derivations
  # inputsFrom = with pkgs; [
    
  # ];

#   # bash statements executed by nix-shell
#   shellHook = ''
#   export DEBUG=1;
# '';
}
