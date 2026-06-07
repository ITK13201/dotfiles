{ pkgs, lib, ... }:

let
  keybindings = [
    # line copy
    {
      key = "shift+alt+down";
      command = "editor.action.copyLinesDownAction";
      when = "editorTextFocus && !editorReadonly";
    }
    {
      key = "ctrl+shift+alt+down";
      command = "-editor.action.copyLinesDownAction";
      when = "editorTextFocus && !editorReadonly";
    }
    {
      key = "shift+alt+up";
      command = "editor.action.copyLinesUpAction";
      when = "editorTextFocus && !editorReadonly";
    }
    {
      key = "ctrl+shift+alt+up";
      command = "-editor.action.copyLinesUpAction";
      when = "editorTextFocus && !editorReadonly";
    }
    # plantuml
    {
      key = "ctrl+b";
      command = "editor.action.insertSnippet";
      when = "editorTextFocus && editorLangId == plantuml";
      args.snippet = "**\${TM_SELECTED_TEXT}**";
    }
    # latex
    {
      key = "ctrl+b";
      command = "editor.action.insertSnippet";
      when = "editorTextFocus && editorLangId == latex";
      args.snippet = "\\textbf{\${TM_SELECTED_TEXT}}";
    }
    {
      key = "ctrl+alt+p";
      command = "editor.action.insertSnippet";
      when = "editorTextFocus && editorLangId == latex";
      args.snippet = "\\texttt{\${TM_SELECTED_TEXT}}";
    }
    # markdown
    {
      key = "shift+4";
      command = "editor.action.insertSnippet";
      when = "editorTextFocus && editorLangId == markdown";
      args.snippet = "$\${TM_SELECTED_TEXT}$";
    }
    {
      key = "shift+enter";
      command = "editor.action.insertSnippet";
      when = "editorTextFocus && editorLangId == markdown";
      args.snippet = "  \n";
    }
    # terminal
    {
      key = "shift+enter";
      command = "workbench.action.terminal.sendSequence";
      when = "terminalFocus";
      args.text = "\u001b\r";
    }
    {
      key = "ctrl+shift+v";
      command = "-markdown.showPreview";
      when = "terminalFocus";
    }
    {
      key = "ctrl+shift+v";
      command = "workbench.action.terminal.paste";
      when = "terminalFocus";
    }
  ];
in

{
  xdg.configFile."Code/User/keybindings.json".text =
    lib.generators.toJSON { } keybindings;
}
