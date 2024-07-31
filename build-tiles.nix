{
  stdenv,
  writeText,
  jq,
  mbutil,
  tilemaker,
  unzip,
  osmium-tool,
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
  stdenv.mkDerivation {
    inherit src;
    name = "${src.name}.mbtiles";

    unpackPhase = "true";

    buildInputs = [jq mbutil tilemaker unzip osmium-tool];

    buildPhase = ''
      jq -c '. * input' ${tilemaker}/share/tilemaker/config-openmaptiles.json ${tilemaker-config} > config.json
      ${
        if renumber
        then "osmium renumber -i. -o data.osm.pbf ${src}"
        else "ln -s ${src} data.osm.pbf"
      }
      tilemaker --input data.osm.pbf ${args} --output $out --config=config.json
    '';

    dontInstall = true;
  }
