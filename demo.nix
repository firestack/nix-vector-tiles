{
  symlinkJoin,
  linkFarm,
  writeShellScriptBin,
  miniserve,
  buildNpmPackage,
  fetchFromGitHub,
  callPackage,
}: {bundle}: let
  demo-html = linkFarm "" {
    "share/www/index.html" = ./demo.html;
  };
  serve = symlinkJoin {
    name = "combined-demo";
    paths = [demo-html bundle];
  };
in
  writeShellScriptBin "demo" ''
    ${miniserve}/bin/miniserve -p 8081 --header "Access-Control-Allow-Origin: *" ${serve}/share/www
  ''
