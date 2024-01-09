mkdir -p ./pkgs/node-pkgs

cd ./pkgs/node-pkgs/

cp @@src-metacall-core@@/source/loaders/node_loader/bootstrap/lib/package{,-lock}.json .

@@node2nix@@/bin/node2nix \
    -18 \
    -i ./package.json \
    -l ./package-lock.json
