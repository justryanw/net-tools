{
  inputs = {
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, utils, ... }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};

    in rec {
      packages = {
	speed = pkgs.writeShellScriptBin "speed" ''
	  ssh $1 "iperf -s -1 -D" && iperf -c $1 && pkill iperf
	'';
      };

      devShell = pkgs.mkShell {
        buildInputs = (with pkgs; [
	  wirelesstools
	  owl
	  iw
	  nmap
	  busybox
        ]) ++ [
	  packages.speed
	];
      };
    }
  );
}
