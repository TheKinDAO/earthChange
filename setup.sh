#!/bin/bash

echo 'This is what worked on my Debian system.'
# wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
# source ~/.bashrc
# nvm install 12

# npm install -g npm near-cli npx yarn

# if [[ -f /usr/bin/apt-get ]]; then
#     sudo apt-get update
#     sudo apt-get install curl build-essential libclang-dev
# fi

# # install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# source ~/.cargo/env
# rustup target add wasm32-unknown-unknown
