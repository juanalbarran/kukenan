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

  # Spring Boot language server and its jdtls extension jars, taken from the
  # vscode-spring-boot extension (latest stable on Open VSX). Not in nixpkgs.
  vscode-spring-boot = stdenvNoCC.mkDerivation {
    pname = "vscode-spring-boot";
    version = "2.4.1";
    src = fetchurl {
      url = "https://open-vsx.org/api/VMware/vscode-spring-boot/2.4.1/file/VMware.vscode-spring-boot-2.4.1.vsix";
      name = "vscode-spring-boot-2.4.1.zip";
      hash = "sha256-aXHyu8UTqUTn+QfkjsaPZISNaJYw1WFr9U7wgDNJ9u0=";
    };
    nativeBuildInputs = [unzip];
    unpackPhase = "unzip -q $src 'extension/language-server/*' 'extension/jars/*'";
    installPhase = ''
      mkdir -p $out/share/vscode-spring-boot
      cp -r extension/language-server extension/jars $out/share/vscode-spring-boot/
    '';
  };

  # Outputs the extension directory (language-server/ and jars/) — consumed by
  # spring-boot.lua and lsp-java.lua
  spring-boot-path = writeShellScriptBin "spring-boot-path" ''
    echo ${vscode-spring-boot}/share/vscode-spring-boot
  '';

  # Starts the Spring Boot LS on the same OpenJDK 21 jdtls runs on. The flags
  # are the ones VS Code passes, with the heap capped at 1G and the same GC
  # flags as jdtls, so it hands unused heap back to the OS
  spring-boot-ls = writeShellScriptBin "spring-boot-ls" ''
    exec ${jdk21}/bin/java \
      -Xmx1G \
      -XX:TieredStopAtLevel=1 \
      -XX:+UseParallelGC \
      -XX:GCTimeRatio=4 \
      -XX:AdaptiveSizePolicyWeight=90 \
      -Djdk.util.zip.disableZip64ExtraFieldValidation=true \
      -Dsts.lsp.client=vscode \
      -Dspring.config.location=classpath:/application.properties \
      -Dspring.profiles.active=file-logging \
      -Dlogging.file.name=/dev/null \
      -Dlogging.level.root=warn \
      -jar ${vscode-spring-boot}/share/vscode-spring-boot/language-server/spring-boot-language-server-2.4.1-SNAPSHOT-exec.jar \
      "$@"
  '';
in [
  jdtls-with-lombok
  java-debug-path
  java-test-paths
  junit-console-path
  spring-boot-path
  spring-boot-ls

  google-java-format
  mvnd

  unzip
  curl
]
