{ lib
, stdenv
, symlinkJoin
, build-pbf-glyphs
, jq
, writeText
, fontconfig
}: {
  name,
  fonts,
}:
stdenv.mkDerivation rec {
  inherit name;

  src = symlinkJoin {
    name = "combined-system-fonts";
    paths = fonts;
  };

  buildInputs = [jq fontconfig];

  buildPhase = ''
    declare -A fonts

    function append-font() {
      IFS=: read -r font_file name <<< "$0"
      fonts[$name] = $font_file
    }

    font_list=$(fc-scan \
      ${src} \
      --format "%{file}:%{fullname}\n")

    for font in $font_list; do
      append-font $font
    done

    for font in wanted_fonts


     ${lib.getExe build-pbf-glyphs} tmp-in/ tmp-out/

  '';

  installPhase = ''
    mkdir -p $out/share
    mv fonts $out/share/map-fonts
  '';
}
