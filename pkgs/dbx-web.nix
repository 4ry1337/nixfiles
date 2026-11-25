{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dbx-web";
  version = "0.6.71";

  src = fetchurl {
    url = "https://github.com/t8y2/dbx/releases/download/v${finalAttrs.version}/DBX_${finalAttrs.version}_x64-browser-static.tar.gz";
    hash = "sha256-UZnQ2k9V8Ko38JHGF01SE4WJOV80cslBAotDHCgE7NU=";
  };

  # Static musl binary with the frontend embedded; nothing to patch or strip.
  dontPatchELF = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/dbx-web-bin $out/bin/dbx-web
    runHook postInstall
  '';

  meta = with lib; {
    description = "DBX database client, browser (web server) build";
    homepage = "https://github.com/t8y2/dbx";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "dbx-web";
  };
})
