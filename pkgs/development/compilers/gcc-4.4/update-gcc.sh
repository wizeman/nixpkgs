#!/bin/sh

if [ $# -ne 1 ]
then
    echo "Usage: $(basename $0) VERSION"
    echo
    echo "Download and GPG-check component tarballs for GCC VERSION."
    exit 1
fi

version="$1"

set -e

out="sources.nix"

declare -A options

options["core"]="/* langC */ true"
options["g++"]="langCC"
options["fortran"]="langFortran"
options["java"]="langJava"
options["ada"]="langAda"

cat > "$out"<<EOF
/* Automatically generated by \`$(basename $0)', do not edit.
   For GCC ${version}.  */
{ fetchurl, optional, version, langC, langCC, langFortran, langJava, langAda }:

assert version == "${version}";
EOF

for component in core g++ fortran java ada
do
    dir="ftp.gnu.org/gnu/gcc/gcc-${version}"
    file="gcc-${component}-${version}.tar.bz2"
    url="${dir}/${file}"

    path_and_hash="$(nix-prefetch-url "$url" 2>&1 | grep -E '^(hash|path) is')"
    path="$(echo $path_and_hash | sed -e's/^.*path is \([^ ]\+\).*$/\1/g')"
    hash="$(echo $path_and_hash | sed -e's/^.*hash is \([^ ]\+\).*$/\1/g')"

    rm -f "${url}.sig"
    wget "${url}.sig"
    gpg --verify "${file}.sig" "${path}" || gpg2 --verify "${file}.sig" "${path}"
    rm "${file}.sig"

    cat >> "$out" <<EOF
optional ${options[$component]} (fetchurl {
  url = "mirror://gcc/releases/gcc-\${version}/gcc-${component}-\${version}.tar.bz2";
  sha256 = "${hash}";
}) ++
EOF
done

cat >> "$out" <<EOF
[]
EOF

echo "result stored in \`$out'"
