{
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      latex-packages = with pkgs; [
        (texlive.combine { inherit (texlive) scheme-full; })
      ];

      dev-packages = with pkgs; [
        latex-packages
        tex-fmt
        gnumake
        sioyek
      ];
    in
    {
      formatter.${system} = pkgs.nixpkgs-fmt;

      devShell.${system} = pkgs.mkShell {
        buildInputs = latex-packages ++ dev-packages;
      };

      packages.${system} = rec {
        default = document;
        document = pkgs.stdenv.mkDerivation {
          name = "document";
          src = ./.;

          buildInputs = [ pkgs.gnumake latex-packages pkgs.which ];

          installPhase = ''
            runHook preInstall

            cp B4-backinline.pdf $out

            runHook postInstall
          '';
        };
      };
    };
}
