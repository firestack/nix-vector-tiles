{ lib
, runCommand
, stdenv
, writeText
, jq
, mbutil
, tilemaker
, unzip
, osmium-tool
, tilemaker-shp-files
}: {
  name,
  src,
  config ? {},
  renumber ? false,
}: let
  tilemaker-config =
    writeText "app-config.json" (builtins.toJSON
      ({settings = {compress = "none";};} // config));
  args =
    if renumber
    then "--compact"
    else "";
  isCompressed =
    (builtins.hasAttr "settings" config)
    && (builtins.hasAttr "compress" config.settings)
    && config.settings.compress != "none";
  # then ''find tiles -name '*.pbf' -exec sh -c 'echo "$1" "$1.gz"' - '{}' +''
in
  stdenv.mkDerivation rec {
    inherit src;
    name = "${src.name or ""}.mbtiles";

    unpackPhase = "true";

    buildInputs = [jq mbutil tilemaker unzip osmium-tool];

    passthru.config = runCommand "tilemaker-config.json" {
      buildInputs = [ jq ];
    } ''
      jq -c '. * input' \
        ${tilemaker}/share/tilemaker/config-openmaptiles.json \
        ${tilemaker-config} \
        > $out
    '';

    # passthru.data =
    #   if renumber
    #   then runCommand "data.osm.pbf" {} ''
    #     osmium renumber -i. -o $out ${src}
    #   ''
    #   else src;

    buildPhase = ''
      ln -s ${tilemaker-shp-files}/landcover .
      ln -s ${tilemaker-shp-files}/coastline .
      ls -la
      ${
        if renumber
        then "osmium renumber -i. -o data.osm.pbf ${src}"
        else "ln -s ${src} data.osm.pbf"
      }

      tilemaker --input data.osm.pbf ${args} --output $out --config=${passthru.config}
    '';

    dontInstall = true;
    dontFixup = true;
  }
