{ pkgs ? import <nixpkgs> {}
, mkShellNoCC ? pkgs.mkShellNoCC
, nodejs_20 ? pkgs.nodejs_20
, pkg-config ? pkgs.pkg-config
, pixman ? pkgs.pixman
, cairo ? pkgs.cairo
, pango ? pkgs.pango
}: mkShellNoCC {
	packages = [
		nodejs_20
		pkg-config
		pixman
		cairo
		pango
	];
}
