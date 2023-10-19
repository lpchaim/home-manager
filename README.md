# My [Home Manager] configuration

> [Nix] and [Home Manager] powered userspace applications

These are my personal dotfiles and userspace applications, done the Nix way.
They focus on providing a baseline, reproducible environment for development and productivity.

This is still very much a WIP, but I guess repos like this are never quite done. Still, it's been my daily driver for a while and it feels solid enough.

## Features
- [x] Select [Nerd Fonts] for patched fonts with extra glyphs
- [x] Productivity and QoL tools such as htop, mcfly, tldr, ripgrep and zoxide
- [x] Text editors: vim, neovim, kakoune and helix <sub>Why, yes, I *have* been experimenting with modal editors, how could you tell?</sub>
- [x] ZSH with oh-my-zsh plugins
- [x] [Nushell](https://www.nushell.sh/)
- [x] Starship prompt

## How to use
- [Download a release](https://github.com/lpchaim/home-manager/releases/latest)
- Extract to `~/.config/home-manager`
- Import `customizations.nix` into your `home.nix`
  - I.e. add `imports = [ ./customizations.nix ];`
  - Disabling modules is as easy as commenting the corresponding line out
- Run `home-manager switch`

[ansible]: https://www.ansible.com/
[home manager]: https://nix-community.github.io/home-manager/
[nerd fonts]: https://www.nerdfonts.com/
[nix]: https://nixos.org/
