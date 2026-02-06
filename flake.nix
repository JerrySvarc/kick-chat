{
  description = "Avalonia .NET 10 dev environment on NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        dotnet = pkgs.dotnet-sdk_10;  # Matches net10.0
        runtimeLibs = pkgs.lib.makeLibraryPath [
          pkgs.fontconfig
          pkgs.freetype
          pkgs.libjpeg_turbo
          pkgs.zlib
          pkgs.glib
          pkgs.cairo
          pkgs.pango
          pkgs.gtk3
          pkgs.libX11
          pkgs.libXext
          pkgs.libXrender
          pkgs.libXtst
          pkgs.alsa-lib
          pkgs.nss
          pkgs.cups
          pkgs.libpulseaudio
        ];
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            dotnet
            fontconfig
            freetype
            libjpeg_turbo
            zlib
            glib
            cairo
            pango
            gtk3
            libX11 libXext libXrender libXtst
            alsa-lib nss cups libpulseaudio
          ];

          shellHook = ''
            export DOTNET_ROOT=${dotnet}
            export PATH=${dotnet}/bin:$PATH
            export LD_LIBRARY_PATH=${runtimeLibs}:$LD_LIBRARY_PATH
            echo "Avalonia dev shell loaded - SkiaSharp deps ready!"
            echo "Run: dotnet restore && dotnet run"
          '';
        };
      }
    );
}
