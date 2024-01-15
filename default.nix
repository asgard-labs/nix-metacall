{
  src-metacall-core,

  stdenv,
  cmake,
  pkg-config,

  backward-cpp,
  rapidjson,

  nodejs-lib,
  nodejs-pkgs,

  texlive,
  doxygen

}:

stdenv.mkDerivation
{

  name = "metacall-core";

  src = src-metacall-core;

  patches = [ ./cmake-skip-build-rpath.patch ];

  cmakeFlags = [
    "--debug-output"
    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
    "-DFETCHCONTENT_SOURCE_DIR_BACKWARDCPP=${backward-cpp.src}"
    "-DOPTION_BUILD_DETOURS=OFF"
    "-DOPTION_FORK_SAFE=OFF"
    "-DOPTION_BUILD_TESTS=OFF"
    "-DOPTION_BUILD_LOADERS_NODE=ON"
    "-DNODE_ROOT=${nodejs-lib}"
    "-DOPTION_BUILD_GUIX=ON"
    "-DOPTION_BUILD_SCRIPTS=OFF"
    "-DOPTION_BUILD_DOCS=ON"
  ];

  buildInputs = [ rapidjson nodejs-lib ];

  postConfigure = ''
    mkdir -p ./node_modules
    cp -r ${nodejs-pkgs}/lib/node_modules/node_loader_bootstrap/node_modules/* ./node_modules/
  '';

  postInstall = ''
    cp -r ${nodejs-pkgs}/lib/node_modules/node_loader_bootstrap/node_modules/* $out/lib/node_modules/
  '';

  nativeBuildInputs = [ cmake pkg-config doxygen texlive.combined.scheme-full ];
  
}
