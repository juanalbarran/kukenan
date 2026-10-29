# src/packages/neovim/java/_dependencies.nix
{pkgs}:
with pkgs; let
  # The nixpkgs jdtls launcher only takes JVM options as --jvm-arg flags.
  # It starts with -Xms1G and no -Xmx; the GC flags are vscode-java's defaults,
  # they make jdtls hand unused heap back to the OS.
  jdtls-with-lombok = writeShellScriptBin "jdtls" ''
    exec ${jdt-language-server}/bin/jdtls \
      --jvm-arg=-javaagent:${lombok}/share/java/lombok.jar \
      --jvm-arg=-Xmx2G \
      --jvm-arg=-XX:+UseParallelGC \
      --jvm-arg=-XX:GCTimeRatio=4 \
      --jvm-arg=-XX:AdaptiveSizePolicyWeight=90 \
      --jvm-arg=-Dsun.zip.disableMemoryMapping=true \
      "$@"
  '';

  # Outputs the java-debug plugin jar path — consumed by lsp-java.lua to populate bundles
  java-debug-path = writeShellScriptBin "java-debug-path" ''
    find ${vscode-extensions.vscjava.vscode-java-debug} -name "com.microsoft.java.debug.plugin-*.jar" | head -1
  '';

  # Outputs all vscode-java-test jars (one per line) — consumed by lsp-java.lua
  java-test-paths = writeShellScriptBin "java-test-paths" ''
    find ${vscode-extensions.vscjava.vscode-java-test} -name "*.jar" | grep -v "sources\|javadoc"
  '';
in [
  jdtls-with-lombok
  java-debug-path
  java-test-paths

  google-java-format
  temurin-bin
  mvnd

  unzip
  curl
]
