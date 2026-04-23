# Helper to wrap interactive shells (bash, zsh) with a default shell replacement.
# This prevents dropping into an unwanted shell when $TERM is valid.
{
  lib,
  defaultShell,
}: {
  bash.interactiveShellInit = ''
    if ! [ "$TERM" = "dumb" ] && [ -z "$BASH_EXECUTION_STRING" ]; then
      exec "${lib.getExe defaultShell}"
    fi
  '';

  zsh.interactiveShellInit = ''
    if ! [ "$TERM" = "dumb" ] && [ -z "$ZSH_EXECUTION_STRING" ]; then
      exec "${lib.getExe defaultShell}"
    fi
  '';

  fish.enable = true;
}
