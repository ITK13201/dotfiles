{ ... }:

{
  home.file.".claude/CLAUDE.md" = {
    source = ../../../../config/claude/CLAUDE.md;
    force = true;
  };

  home.file.".claude/settings.json" = {
    source = ../../../../config/claude/settings.json;
    force = true;
  };

}
