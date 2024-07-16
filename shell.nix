# Unfinished, hard.

with import <nixpkgs> {};
with pkgs.python3Packages;

buildPythonPackage rec {
  name = "TypeDB";
  src = /home/jeff/hode6/typedb_driver_python;
  propagatedBuildInputs = [ parse ];
}
