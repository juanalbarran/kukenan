# src/packages/neovim/java/_dependencies.nix
{pkgs}:
with pkgs; let
  jdtls-with-lombok = writeShellScriptBin "jdtls" ''
    export JDTLS_JVM_ARGS="-javaagent:${lombok}/share/java/lombok.jar"
    exec ${jdt-language-server}/bin/jdtls "$@"
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

  unzip
  curl
]
