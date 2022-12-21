# shell.nix
{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  name = "a2s-sensor-domain";

  buildInputs = with pkgs; [ pharo gradle ];
  shellHook = ''
    rm -f gradle-local.properties
    cat <<EOF > gradle-local.properties
    pharoPath=${pkgs.pharo}/bin/pharo
    pharoUiPath=${pkgs.pharo}/bin/pharo
    pharoArgs=--headless
    gtoolkitHome=$(pwd)
    # vim: syntax=sh ts=2 sw=2 sts=4 sr noet
    EOF
  '';
}
