{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    # to update: nix flake lock --update-input nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs";
    libxenon.url = "github:xenon-emu/libxenon";
    libxenon.flake = false;
    libfat.url = "github:xenon-emu/libfat";
    libfat.flake = false;
  };
  outputs = { self, utils, nixpkgs, libxenon, libfat }:
  (utils.lib.eachSystem [ "ppc64" "ppc32" ] (system:
  let
    pkgsLut = {
      ppc32 = import nixpkgs {
        crossSystem = {
            config = "powerpc-none-eabi";
            libc = "newlib";
        };
        system = "x86_64-linux";
        overlays = [ self.overlay ];
      };
      ppc64 = import nixpkgs {
        crossSystem.config = "powerpc64-unknown-linux-gnuabielfv2";
        system = "x86_64-linux";
        overlays = [ self.overlay ];
      };
    };
    pkgs = pkgsLut.${system};
  in {
    packages = {
      inherit (pkgs) xell1 xell2;
    };
    devShell = pkgs.xell1;
  })) // {
    overlay = self: super: {
      libxenon = self.callPackage libxenon {};
      fat = self.callPackage libfat {};
      xell2 = self.callPackage ./xell.nix {
        inherit (self) fat libxenon;
        stage = 2;
      };
      xell1 = self.callPackage ./xell.nix {
        inherit (self) fat xell2 libxenon;
        stage = 1;
      };
    };
  };
}