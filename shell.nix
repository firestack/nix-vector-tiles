{ pkgs ? import <nixpkgs> {}
, mkShellNoCC ? pkgs.mkShellNoCC
, nodejs_20 ? pkgs.nodejs_20
}: mkShellNoCC {
	packages = [
		nodejs_20
	];
}
