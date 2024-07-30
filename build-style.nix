{ lib
, runCommand
, jq
}:

{ name
, style-name ? name
, src
, overrideJson ? {}
}: let
  outputDir = "$out/share/map/styles/${style-name}";
in
  runCommand name {
    buildInputs = [jq];

    inputOverrideJson = builtins.toJSON overrideJson;
    passAsFile = ["inputOverrideJson"];
  } ''
      mkdir -p ${outputDir}

      jq \
        '. * input' \
        ${src}/style.json \
        $inputOverrideJsonPath \
      > ${outputDir}/style.json
    ''

