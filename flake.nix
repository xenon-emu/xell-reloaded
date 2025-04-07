{
  inputs = {
    nixpkgs.url = "github:cleverca22/nixpkgs/ugly-test";
    nixpkgs2.url = "github:nixos/nixpkgs/nixos-unstable";
    xell.url = "github:cleverca22/xell-reloaded";
    xell.flake = false;
    libxenon.url = "github:cleverca22/libxenon";
    libxenon.flake = false;
    libfat.url = "github:cleverca22/libfat";
    libfat.flake = false;
  };
  nixConfig = {
    extra-substituters = [ "https://hydra.angeldsis.com/" ];
    extra-trusted-public-keys = [ "hydra.angeldsis.com-1:7s6tP5et6L8Y6sX7XGIwzX5bnLp00MtUQ/1C9t1IBGE=" ];
  };
  outputs = { self, nixpkgs, xell, libxenon, libfat, nixpkgs2 }:
  let
    host = import nixpkgs { system = "x86_64-linux"; };
    p = import nixpkgs {
      system = "x86_64-linux";
    };
    overlay32 = self: super: {
      libxenon = self.callPackage libxenon {};
      fat = self.callPackage libfat {};
      xell2 = p.callPackage xell {
        inherit (self) fat libxenon;
        stdenv32 = self.stdenv;
        stage = 2;
      };
      xell1 = p.callPackage xell {
        inherit (self) fat xell2 libxenon;
        stdenv32 = self.stdenv;
        stage = 1;
      };
    };
    pkgs32 = import nixpkgs {
      system = "x86_64-linux";
      crossSystem = {
        config = "powerpc-none-eabi";
        libc = "newlib";
      };
      overlays = [ overlay32 ];
    };
  in {
    packages = {
      powerpc-none-eabi = {
        inherit (pkgs32) libxenon fat xell1 xell2;
      };
    };
  };
}