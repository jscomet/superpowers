# Installing Superpowers for Codex

1. Clone this repository to a permanent location:
   ```bash
   git clone https://github.com/jscomet/superpowers.git ~/.codex/superpowers
   ```

2. Create symlinks for each skill you want available:
   ```bash
   for skill in ~/.codex/superpowers/skills/*/; do
     ln -s "$skill" ~/.codex/skills/"$(basename "$skill")"
   done
   ```

3. Restart Codex CLI. Skills will be auto-discovered from the symlinks.
