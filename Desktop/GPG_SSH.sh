#!/bin/bash
read -p "Do you want to use existing key (e) or generate a new one (n)? " new
if [ $new == "e" ];
then
  gpg --list-secret-keys --keyid-format=long
else
  read -p "Are you on version 2.1.17 or greater? (y/n) " version
  if [ $version == "y" ];
  then
    gpg --full-generate-key
  else
    gpg --default-new-key-algo rsa4096 --gen-key
  fi
  keygen=$(gpg --list-secret-keys --keyid-format=long|awk '/sec/{if (length($2)>0) print $2}');
  IFS='/'  
  read -a keyarr <<<"$keygen"
  key=${keyarr[1]}
  echo "Paste the following ASCII code on github"
  gpg --armor --export $key
  echo "Type 'ok' when done "
  read ok
  if [ $ok == "ok" ];
  then
    git config --global user.signingkey $key
  fi
fi