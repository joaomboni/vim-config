#!/bin/bash

# Cores para o output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# CONFIGURAÇÃO: Substitua pelo link real do seu repositório no GitHub
# Exemplo: https://github.com/jbonifacio/meu-vim-config
REPO_URL="https://github.com/joaomboni/vim-config.git"

echo -e "${BLUE}===> Iniciando Instalação do Ambiente Completo (Fedora)${NC}"

# 1. Instalação de pacotes do sistema
echo -e "${GREEN}[1/7] Instalando dependências DNF e Vim-X11...${NC}"
sudo dnf install -y vim python3-devel cmake gcc-c++ nodejs go git ccls curl \
                    vim-X11 wl-clipboard xclip

# 2. Configuração de Aliases
echo -e "${GREEN}[2/7] Configurando Aliases para Clipboard...${NC}"
for shell_config in "$HOME/.zshrc" "$HOME/.bashrc"; do
    if [ -f "$shell_config" ]; then
        if ! grep -q "alias vim='vimx'" "$shell_config"; then
            echo "alias vim='vimx'" >> "$shell_config"
            echo "Alias 'vimx' adicionado a $shell_config"
        fi
    fi
done

# 3. Servidor de Linguagem PHP
echo -e "${GREEN}[3/7] Instalando Intelephense (PHP)...${NC}"
if ! command -v intelephense &> /dev/null; then
    sudo npm install -g intelephense
fi

# 4. Organização de pastas e Gerenciador de Plugins
echo -e "${GREEN}[4/7] Preparando vim-plug...${NC}"
mkdir -p ~/.vim/autoload ~/.vim/plugged
if [ ! -f ~/.vim/autoload/plug.vim ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# 5. Sincronização das configurações (Lógica Inteligente)
echo -e "${GREEN}[5/7] Sincronizando .vimrc e .ycm_extra_conf.py...${NC}"
mkdir -p ~/.vim

if [ -f "./.vimrc" ] && [ -f "./.ycm_extra_conf.py" ]; then
    echo "Sincronizando a partir de arquivos locais..."
    cp .vimrc ~/.vimrc
    cp .ycm_extra_conf.py ~/.vim/.ycm_extra_conf.py
else
    echo "Sincronizando a partir do GitHub..."
    curl -sL "${REPO_URL}/raw/main/.vimrc" -o ~/.vimrc
    curl -sL "${REPO_URL}/raw/main/.ycm_extra_conf.py" -o ~/.vim/.ycm_extra_conf.py
fi

# 6. Instalação de Plugins
echo -e "${GREEN}[6/7] Instalando plugins do Vim...${NC}"
# Usamos vimx para garantir suporte a clipboard durante o setup se necessário
vimx +PlugInstall +qall

# 7. Compilação do YouCompleteMe
echo -e "${GREEN}[7/7] Compilando YouCompleteMe...${NC}"
if [ -d "$HOME/.vim/plugged/YouCompleteMe" ]; then
    cd "$HOME/.vim/plugged/YouCompleteMe"
    if [ ! -f ./third_party/ycmd/ycm_core.so ]; then
        # Compila para todas as linguagens suportadas
        python3 install.py --all
    fi
fi

echo -e "${BLUE}===> AMBIENTE PRONTO!${NC}"
echo -e "${BLUE}DICA: Reinicie o terminal ou rode 'source ~/.zshrc' para ativar o 'vim'.${NC}"
