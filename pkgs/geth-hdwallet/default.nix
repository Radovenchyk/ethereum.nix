{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "go-ethereum-hdwallet";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "miguelmota";
    repo = "go-ethereum-hdwallet";
    rev = "v${version}";
    hash = "sha256-sB2da9jukP6eTOU2w8e/J10xj/6LXapB0eogErmEPlA=";
  };

  postPatch = ''
    rm -rf vendor
  '';

  vendorHash = "sha256-SUqWVZe5Y0pBeRP7Zrp4WzvAB+lFkQioqJhi4L/Rqvs=";

  ldflags = ["-s" "-w"];

  doCheck = true;

  subPackages = ["cmd/geth-hdwallet"];

  meta = with lib; {
    description = "Ethereum HD Wallet derivations in Go (golang)";
    homepage = "https://github.com/miguelmota/go-ethereum-hdwallet";
    license = with licenses; [mit];
    mainProgram = "geth-hdwallet";
    platforms = ["x86_64-linux"];
  };
}
