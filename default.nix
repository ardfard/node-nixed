{ pkgs ? import <nixpkgs> {} }:
let
  stdenv = pkgs.stdenv;
in rec {
  nodejs = stdenv.mkDerivation {
    name = "nodejs-0.10.7";
    src = pkgs.fetchurl {
      url = http://nodejs.org/dist/v0.10.7/node-v0.10.7.tar.gz;
      sha256 = "1q15siga6b3rxgrmy42310cdya1zcc2dpsrchidzl396yl8x5l92";
    };

    buildInputs = [pkgs.python] ++ stdenv.lib.optional stdenv.isLinux pkgs.utillinux;
    preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''export PATH=/usr/bin:/usr/sbin:$PATH'';

  };

  app = stdenv.mkDerivation {
    name = "application";
    src = ./app;
    buildInputs = [ nodejs ];
    PORT = "9000";
    installPhase = ''
      mkdir -p $out
      cp -r * $out
    '';
  };
}
