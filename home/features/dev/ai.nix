{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.dev.ai;
in
{
  options.features.dev.ai = {
    claude-code.enable = mkEnableOption "Claude Code CLI";
    codex.enable = mkEnableOption "Codex CLI";
    markitdown.enable = mkEnableOption "markitdown CLI (+ MCP server for Claude Code)";
  };

  config = mkMerge [
    (mkIf cfg.claude-code.enable {
      programs.claude-code = {
        enable = true;
        context = ./claude/CLAUDE.md;
        # Claude Code writes to settings.json itself (plugin toggles, theme),
        # so merge declared values instead of linking a read-only file
        mutableSettings = true;
        settings = {
          theme = "auto";
          enabledPlugins = {
            "frontend-design@anthropic-plugin-directory" = true;
            "code-review-anthropics@anthropic-plugin-directory" = true;
            "code-simplifier@anthropic-plugin-directory" = true;
            "feature-dev@anthropic-plugin-directory" = true;
            "security-guidance@anthropic-plugin-directory" = true;
            "42crunch-api-security-testing@anthropic-plugin-directory" = true;
            "writing-skills@anthropic-plugin-directory" = true;
          };
        };
        # one entry per skill: a path here would replace all of ~/.claude/skills,
        # including the skills Claude syncs from the account
        skills = {
          feature-review = ./claude/skills/feature-review;
        };
      };
    })
    (mkIf cfg.codex.enable {
      programs.codex.enable = true;
    })
    (mkIf cfg.markitdown.enable {
      home.packages = [ pkgs.markitdown ];
      # MCP only registered when Claude Code is enabled
      programs.claude-code.mcpServers = mkIf cfg.claude-code.enable {
        markitdown = {
          type = "stdio";
          command = getExe pkgs.markitdown-mcp;
        };
      };
    })
  ];
}
