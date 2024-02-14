{
  bls,
  buildGoModule,
  fetchFromGitHub,
  mcl,
  mockgen,
  nix-update-script,
}: let
  pname = "sedge";
  version = "1.2.3";
in
  buildGoModule {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "NethermindEth";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-7KTNDRqQ84bB+oyO2JYLjbDxDjyx9uAOuHpWSV0VGWE=";
    };
    vendorHash = "sha256-Fasmr5h8CyWEPNHMKp1OL+s/A9TObx2fq1EgRf9HN4o=";
    proxyVendor = true;

    buildInputs = [bls mcl];
    nativeBuildInputs = [mockgen];

    preBuild = ''
      go generate ./...
    '';

    ldflags = [
      "-s"
      "-w"
      "-X github.com/NethermindEth/sedge/internal/utils.Version=v${version}"
    ];

    subPackages = ["cmd/sedge"];

    passthru.updateScript = nix-update-script {
      extraArgs = ["--flake"];
    };

    meta = {
      description = "A one-click setup tool for PoS network/chain validators and nodes.";
      homepage = "https://docs.sedge.nethermind.io/";
      mainProgram = "sedge";
      platforms = ["x86_64-linux"];
    };
  }
