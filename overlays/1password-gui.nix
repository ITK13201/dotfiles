# 1Password 8.12.42 で同梱された chrome_crashpad_handler が nixpkgs の patchelf 対象から漏れており、
# libglib が見つからず起動するとメインプロセスが停止する。interpreter と rpath を補う。
final: prev: {
  _1password-gui = prev._1password-gui.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      crashpad=$out/share/1password/chrome_crashpad_handler
      if [ -f "$crashpad" ]; then
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$crashpad"
        patchelf --set-rpath ${final.lib.makeLibraryPath [ final.glib ]} "$crashpad"
      fi
    '';
  });
}
