def Settings( **kwargs ):
    language = kwargs.get( 'language' )

    # CONFIGURAÇÃO PARA PHP (Usando Intelephense que você instalou via npm)
    if language == 'php':
        return {
            'ls': {
                'intelephense.files.maxSize': 5000000,
                'intelephense.diagnostics.enable': True,
                'intelephense.completion.fullyQualifyImportedSymbols': True,
                'intelephense.phpVersion': '8.2' # Ajuste para a versão do seu Fedora
            }
        }

    # CONFIGURAÇÃO PARA C/C++ (Desenvolvimento GTK e Estudos NetBSD)
    if language in [ 'c', 'cpp', 'objc', 'objcpp' ]:
        return {
            'flags': [
                '-x', 'c++',
                '-Wall',
                '-Wextra',
                '-I/usr/include/gtkmm-3.0',
                '-I/usr/include',
                '-I./',
                # Aqui você aponta para onde os fontes do NetBSD estão no seu FEDORA
                '-I/home/jbonifacio/netbsd/src/sys', 
            ],
        }

    return {}
