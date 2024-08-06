{
  fetchFromGitHub,
}: {
  maptiler-basic-gl-style =  fetchFromGitHub {
    owner = "openmaptiles";
    repo =  "maptiler-basic-gl-style";
    rev = "tags/v1.9";
    sha256 = "sha256-LRzk0/r2bkAl4qxGNzhRs7QojsNmBWdUUD/d4aqzWu4=";
  };

  osm-bright-gl-style =  fetchFromGitHub {
    owner = "openmaptiles";
    repo =  "osm-bright-gl-style";
    rev = "tags/v1.9";
    sha256 = "sha256-X1ueE6cVTEA1D9ctjHMqWJQhdM37RZxciCBQUaQyG64=";
    passthru.hi = "1";
  };

  positron-gl-style =  fetchFromGitHub {
    owner = "openmaptiles";
    repo =  "positron-gl-style";
    rev = "tags/v1.8";
    sha256 = "sha256-TV3a9in+q5WYS90GhIs1I8JNSUPJy67CmiPdIK1ZO0o=";
  };

  dark-matter-gl-style =  fetchFromGitHub {
    owner = "openmaptiles";
    repo =  "dark-matter-gl-style";
    rev = "tags/v1.8";
    sha256 = "sha256-+xT/QbU+VcTepD4A05sA5c97xAgXOwcIbAKPaifKYxQ=";
  };

  maptiler-terrain-gl-style =  fetchFromGitHub {
    owner = "openmaptiles";
    repo =  "maptiler-terrain-gl-style";
    rev = "tags/v1.7";
    sha256 = "sha256-xXe596/b7+gF6bEW00hEppDLho53ivlsRGHfHd5Vu1E=";
  };

  maptiler-3d-gl-style =  fetchFromGitHub {
    owner = "openmaptiles";
    repo =  "maptiler-3d-gl-style";
    rev = "9fc742213ec52f0489efb909bfc79eee0015b810";
    sha256 = "sha256-vZSAUMEYmg0/qzq8JiNQZsN8dUNM6+71mPr27m8nDHc=";
  };

  fiord-color-gl-style =  fetchFromGitHub {
    owner = "openmaptiles";
    repo =  "fiord-color-gl-style";
    rev = "tags/v1.5";
    sha256 = "sha256-Vc+pO8NfMFe6j9P7/5RkS4G6yHTG2jOvFc4Iy0jaAck=";
  };

  maptiler-toner-gl-style =  fetchFromGitHub {
    owner = "openmaptiles";
    repo =  "maptiler-toner-gl-style";
    rev = "339e5b74c918e8b2787bb4910282d61a5de1d5ee";
    sha256 = "sha256-z3s1fPxEpjXzxPUg4tkPqdp8zvnrK7+L3QOa8uhF8wE=";
  };

  osm-liberty =  fetchFromGitHub {
    owner = "maputnik";
    repo =  "osm-liberty";
    rev = "539d0525421eb5be901ede630c49947dfe5a343f";
    sha256 = "sha256-njf1hqIRfoZUnHr3kUGlfCvVBZkIM9ZM6lR8WroOR9s=";
  };
}
