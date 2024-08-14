{ stdenv, libxenon, stdenv32, fat, stage, xell2 ? null }:

if stage == 1 then
  stdenv.mkDerivation {
    name = "xell1";
    src = ./.;
    hardeningDisable = [ "stackprotector" "format" ];
    # CROSS is used by lv1 and must be 64bit
    CROSS = "${stdenv.hostPlatform.config}-";
    preBuild = ''
      cp ${xell2}/stage2.elf32.gz .
    '';
    makeFlags = [
      "xell-1f.bin"
      "xell-1f_cygnos_demon.bin"
      "xell-2f.bin"
      "xell-2f_cygnos_demon.bin"
      "xell-gggggg.bin"
      "xell-gggggg_cygnos_demon.bin"
    ];
    installPhase = ''
      mkdir -p $out/nix-support
      cp *.bin $out/
      cd $out
      for bin in *.bin; do
        echo "file binary-dist $(realpath $bin)" >> $out/nix-support/hydra-build-products
      done
    '';
  }
else
stdenv.mkDerivation {
  name = "xell2";
  inherit libxenon;
  buildInputs = [ libxenon fat ];
  nativeBuildInputs = [ stdenv32.cc ];
  # CROSS is used by lv1 and must be 64bit
  CROSS = "${stdenv.hostPlatform.config}-";
  # PREFIX is used by lv2 and must be 32bit
  PREFIX = "${stdenv32.hostPlatform.config}-";
  DEVKITXENON = "${libxenon}/devkitxenon";
  src = ./.;
  installPhase = ''
    mkdir $out
    cp -v stage2.elf* $out/
  '';
}
