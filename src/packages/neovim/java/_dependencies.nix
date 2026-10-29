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

  # JUnit console launcher for neotest-java, pinned to the version and sha256
  # neotest-java 0.37.1 expects, so it never downloads one at runtime
  junit-console-jar = fetchurl {
    url = "https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/6.0.3/junit-platform-console-standalone-6.0.3.jar";
    sha256 = "3ba0d6150af79214a1411f9ea2fbef864eef68b68c89a17f672c0b89bff9d3a2";
  };

  # Outputs the JUnit console jar path — consumed by neotest.lua
  junit-console-path = writeShellScriptBin "junit-console-path" ''
    echo ${junit-console-jar}
  '';
in [
  jdtls-with-lombok
  java-debug-path
  java-test-paths
  junit-console-path

  google-java-format
  mvnd

  unzip
  curl
]
