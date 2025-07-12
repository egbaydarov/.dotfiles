{ pkgs ? import <nixpkgs> {} }:

pkgs.buildGoModule rec {
  pname = "twitchalarm";
  version = "1.0.3";

  src = pkgs.fetchFromGitHub {
    owner = "egbaydarov";
    repo = "twitchalarm";
    rev = "master";
    sha256 = "sha256-jAA3oojMUjXiFrPei1FxX9yX+e0DL4WBT+r4YGRm078=";
  };

  vendorHash = "sha256-TTg8kaVTVZIUJ5u/YvMveGQOsbZPR5MXa4CLO8dLSgI=";

  CGO_ENABLED = 0;

  doCheck = false;

  # Ensure we don't call their Makefile
  subPackages = [ "." ]; # point to main package or ./cmd if needed

  meta = with pkgs.lib; {
    description = "";
    homepage = "https://github.com/egbaydarov/twitchalarm";
    license = licenses.mit;
    maintainers = [];
  };
}
