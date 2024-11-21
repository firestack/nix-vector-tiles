{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "map-sprite-packer";
  version = "unstable-2023-11-11";

  src = fetchFromGitHub {
    owner = "jmpunkt";
    repo = "map-sprite-packer";
    rev = "b41cd0e8df0314f41648e4384b8ba672d0d1d2fc";
    hash = "sha256-TwwpxpXoufjnkuNF3falqDm/Q0o3sQJKDSmC8/4007Y=";
  };

  cargoHash = "sha256-MCoZWsxF7auowvq+fofYhCS0oExehKSs3MC/lqEQ7fI=";

  meta = with lib; {
    description = "SVG icon packer for maps";
    homepage = "https://github.com/jmpunkt/map-sprite-packer";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "map-sprite-packer";
  };
}
