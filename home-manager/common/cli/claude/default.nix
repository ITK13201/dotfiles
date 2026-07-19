{
  pkgs,
  inputs,
  lib,
  ...
}:

{
  home.file.".claude/CLAUDE.md" = {
    source = ../../../../config/claude/CLAUDE.md;
    force = true;
  };

  home.file.".claude/settings.json" = {
    source = ../../../../config/claude/settings.json;
    force = true;
  };

  home.file.".claude/plugins/marketplaces/compact-plus-local" = {
    source = inputs.compact-plus;
    force = true;
  };

  home.activation.compactPlusRemoveExistingDir = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
    mktDir="$HOME/.claude/plugins/marketplaces/compact-plus-local"
    if [ -d "$mktDir" ] && [ ! -L "$mktDir" ]; then
      $DRY_RUN_CMD rm -rf "$mktDir"
    fi
  '';

  home.activation.compactPlusPlugin = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    pluginsDir="$HOME/.claude/plugins"

    mktJson="$pluginsDir/known_marketplaces.json"
    if [ -f "$mktJson" ] && [ ! -L "$mktJson" ]; then
      tmp=$(${pkgs.jq}/bin/jq \
        '."compact-plus-local" = {"source": {"source": "github", "repo": "u-ichi/compact-plus"}, "installLocation": ($home + "/.claude/plugins/marketplaces/compact-plus-local"), "lastUpdated": "2026-07-19T00:00:00.000Z"}' \
        --arg home "$HOME" "$mktJson")
      echo "$tmp" > "$mktJson"
    else
      $DRY_RUN_CMD ${pkgs.coreutils}/bin/mkdir -p "$pluginsDir"
      printf '%s\n' '{"compact-plus-local":{"source":{"source":"github","repo":"u-ichi/compact-plus"},"installLocation":"'"$HOME"'/.claude/plugins/marketplaces/compact-plus-local","lastUpdated":"2026-07-19T00:00:00.000Z"}}' \
        > "$mktJson"
    fi

    instJson="$pluginsDir/installed_plugins.json"
    if [ -f "$instJson" ] && [ ! -L "$instJson" ]; then
      tmp=$(${pkgs.jq}/bin/jq \
        '.plugins["compact-plus@compact-plus-local"] = [{"scope": "user", "installPath": ($home + "/.claude/plugins/marketplaces/compact-plus-local"), "version": "1.0.4", "installedAt": "2026-07-19T00:00:00.000Z", "lastUpdated": "2026-07-19T00:00:00.000Z"}]' \
        --arg home "$HOME" "$instJson")
      echo "$tmp" > "$instJson"
    else
      $DRY_RUN_CMD ${pkgs.coreutils}/bin/mkdir -p "$pluginsDir"
      printf '%s\n' '{"version":2,"plugins":{"compact-plus@compact-plus-local":[{"scope":"user","installPath":"'"$HOME"'/.claude/plugins/marketplaces/compact-plus-local","version":"1.0.4","installedAt":"2026-07-19T00:00:00.000Z","lastUpdated":"2026-07-19T00:00:00.000Z"}]}}' \
        > "$instJson"
    fi
  '';
}
