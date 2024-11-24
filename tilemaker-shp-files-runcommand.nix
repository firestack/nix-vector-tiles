{ lib
		, runCommand
		, fetchFromGitHub
		, curl
		, cacert
		, unzip
		}: runCommand "tilemaker-shp-files" {

			src = fetchFromGitHub {
				owner = "systemed";
				repo = "tilemaker";
				rev = "eab08d189ad97ddf5db7d915bcabe42ad3dab6af";
				hash = "sha256-A4I2xwB7E+7iwaLt8NGoAVrPLSmu6l8wNURu9EUqyTk=";
			};

			outputHashAlgo = "sha256";
			outputHashMode = "recursive";
			outputHash = "sha256-SLMz2tAEj78/irgKzORuaOrSYaMpOZII9HPQlvZrzUk=";

			buildInputs = [ curl unzip ];

			SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt";
		}
		(lib.concatLines [
			"mkdir -p $out"
			"pushd $out"
			"bash -x $src/get-landcover.sh"
			"bash -x $src/get-coastline.sh"
		])
