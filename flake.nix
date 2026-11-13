{
  description = "pandora - a parallax-scrolling wallpaper daemon for wayland";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ];
    in
    {
      packages = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.rustPlatform.buildRustPackage {
          pname = "pandora";
          version = "1.0.0";
          src = ./.;
          cargoLock.lockFile = ./Cargo.lock;

          meta = {
            description = "Parallax-scrolling wallpaper daemon for wayland";
            homepage = "https://github.com/PandorasFox/pandora";
            license = nixpkgs.lib.licenses.gpl2Only;
            platforms = nixpkgs.lib.platforms.linux;
            mainProgram = "pandora";
          };
        };
      });

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [ cargo rustc rustfmt clippy rust-analyzer ];
            env.RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
          };
        });
    };
}
