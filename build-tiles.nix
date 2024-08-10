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
}:
{ name
, extension ? "pmtiles"
, src
, config ? {}
, renumber ? false
}: stdenv.mkDerivation rec {
    inherit src;
    name = "${src.name or ""}.${extension}";

    # unpackPhase = "true";

    buildInputs = [jq mbutil tilemaker unzip];

    passthru.tilemaker-config =
      writeText "app-config.json" (
        builtins.toJSON ({settings.compress = "none";} // config)
      );

    passthru.config = runCommand "tilemaker-config.json" {
      buildInputs = [ jq ];
    } ''
      jq -c '. * input' \
        ${tilemaker}/share/tilemaker/config-openmaptiles.json \
        ${passthru.tilemaker-config} \
        > $out
    '';

    dontUnpack = true;
    passthru.data =
      if renumber
      then runCommand "${src.name or ""}.renumbered.osm.pbf" {
        buildInputs = [osmium-tool];
      } "osmium renumber -i. -o $out ${src}"
      else src;

    buildPhase = ''
      ln -s ${tilemaker-shp-files}/landcover .
      ln -s ${tilemaker-shp-files}/coastline .
      ls -la

      tilemaker \
        --input ${passthru.data} \
        --output $out \
        --config=${passthru.config} \
        --process=${tilemaker}/share/tilemaker/process-openmaptiles.lua \
        ${if renumber
          then "--compact"
          else ""
        }
    '';

    dontInstall = true;
    dontFixup = true;
  }
