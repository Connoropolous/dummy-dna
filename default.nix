let

 # point this to your local config.nix file for this project
 # example.config.nix shows and documents a lot of the options
 config = import ./config.nix;

 # START HOLONIX IMPORT BOILERPLATE
 holonix = import (
  if ! config.holonix.use-github
  then config.holonix.local.path
  else fetchTarball {
   url = "https://github.com/${config.holonix.github.owner}/${config.holonix.github.repo}/tarball/${config.holonix.github.ref}";
   sha256 = config.holonix.github.sha256;
  }
 ) { config = config; };
 # END HOLONIX IMPORT BOILERPLATE

in
with holonix.pkgs;
{
 dev-shell = stdenv.mkDerivation (holonix.shell // {
  name = "dev-shell";

  shellHook = holonix.pkgs.lib.concatStrings [
   holonix.shell.shellHook
   # NIX_ENFORCE_PURITY to fix = note: impure path `/[...]' used in link
   # https://nixos.wiki/wiki/Development_environment_with_nix-shell
  ];

  buildInputs = [ ]
   ++ holonix.shell.buildInputs
   ++ config.buildInputs
  ;
 });
}
