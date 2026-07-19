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

  home.file.".claude/hooks" = {
    source = ../../../../config/claude/hooks;
    recursive = true;
    force = true;
  };

  home.file.".claude/skills" = {
    source = ../../../../config/claude/skills;
    recursive = true;
    force = true;
  };
}
