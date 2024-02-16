{
  blst,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "mev-boost";
  version = "1.6.4844-dev5";

  src = fetchFromGitHub {
    owner = "flashbots";
    repo = "${pname}";
    rev = "v${version}";
    hash = "sha256-O/jaCVw6ZVD+R2EmWpWBqRrAMsmdUwuFrSXJ9BUscKM=";
  };

  vendorHash = "sha256-fQMUrdIerhQ7EEDNiA1ks9aXFPASvm+AdSjwGy1gxTY=";

  buildInputs = [blst];

  subPackages = ["cmd/mev-boost"];

  passthru.updateScript = nix-update-script {
    extraArgs = ["--flake"];
  };

  meta = {
    description = "MEV-Boost allows proof-of-stake Ethereum consensus clients to source blocks from a competitive builder marketplace";
    homepage = "https://github.com/flashbots/mev-boost";
    mainProgram = "mev-boost";
    platforms = ["x86_64-linux"];
  };
}
