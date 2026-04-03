# Installing Superpowers for OpenCode

1. Clone this repository to a permanent location:
   ```bash
   git clone https://github.com/jscomet/superpowers.git ~/.config/opencode/plugins/superpowers
   ```

2. Add the plugin to your OpenCode config (`~/.config/opencode/config.json`):
   ```json
   {
     "plugins": [
       "~/.config/opencode/plugins/superpowers/.opencode/plugins/superpowers.js"
     ]
   }
   ```

3. Restart OpenCode. The plugin will auto-register the skills directory and inject bootstrap context.
