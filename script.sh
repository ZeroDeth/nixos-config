#!/usr/bin/env bash

interpreter=$(nix eval --raw '((import <nixpkgs> { }).stdenv.glibc)')/lib/ld-linux-x86-64.so.2
libstdcxx=$(nix eval --raw '((import <nixpkgs> { }).stdenv.cc.cc.lib)')/lib/libstdc++.so.6
for dir in ~/.vscode-server/bin/*; do
  cd $dir

  patchelf \
    --set-interpreter $interpreter \
    --replace-needed libstdc++.so.6 $libstdcxx \
    node

  patchelf \
    --replace-needed libstdc++.so.6 $libstdcxx \
    node_modules/node-pty/build/Release/pty.node
done
