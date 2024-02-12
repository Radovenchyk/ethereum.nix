#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix-prefetch jq nix

set -e

dirname="$(dirname "$0")"
rootDir="$(git -C "$dirname" rev-parse --show-toplevel)"
pname="besu"

updateVersion() {
  local version=$1
  sed -i "s/version = \"[0-9.]*\";/version = \"$version\";/g" "${dirname}/default.nix"
}

updateHash() {
  local version=$1
  local url="https://hyperledger.jfrog.io/hyperledger/${pname}-binaries/${pname}/${version}/${pname}-${version}.tar.gz"

  local output=$(nix store prefetch-file --json "$url")
  local sriHash=$(echo "$output" | jq -r .hash)

  sed -i "s|\"hash\" = \"[a-zA-Z0-9\/+-=]*\";|\"hash\" = \"${sriHash}\";|g" "${dirname}/default.nix"
}

currentVersion=$(nix show-derivation "${rootDir}#${pname}" | jq -r '.[].env.version')
latestVersion=$(curl -s "https://hyperledger.jfrog.io/artifactory/api/search/latestVersion?g=org.hyperledger.besu.internal&a=besu")

if [[ "$currentVersion" == "$latestVersion" ]]; then
  echo "Besu is up to date: ${currentVersion}"
  exit 0
fi

echo "Updating Besu from ${currentVersion} to ${latestVersion}"

updateVersion "$latestVersion"
updateHash "$latestVersion"
