# Ashen

Tema quase-monocromático para VS Code. Fundo neutro frio, foreground bege dessaturado
e desvios mínimos de matiz para separar keyword, tipo e string sem quebrar a sensação
de uma única cor.

## Paleta base

Todas as cores de token derivam de 8 valores. Eles estão no topo de
`themes/ashen-color-theme.json`, no bloco de comentários `PALETA BASE`.

| Papel | Hex | Onde aparece |
| --- | --- | --- |
| Fundo | `#0F0E0F` | `editor.background` |
| Foreground | `#e3dac9` | variáveis, funções, números, chaves JSON/YAML |
| Keyword / storage | `#937f88` | `public`, `if`, `return`, `this`, `null`, decorators Python |
| Tipo / classe | `#93867f` | classes, interfaces, enums, heranças, `support.function`, anotações, **constantes** |
| String | `#5a6055` | strings e template literals |
| Neutro | `#bebab4` | tags HTML/Vue/JSX, escapes, unidades CSS, `token.info-token` |
| Erro | `#78353f` | diagnósticos, `invalid` |
| Warning | `#6a5037` | diagnósticos, `invalid.deprecated` |

O truque do efeito monocromático: `#937f88`, `#93867f` e `#88937f` são permutações
dos mesmos três canais. Mesma saturação, mesma luminosidade, matiz rotacionada.
Se você trocar uma delas, troque mantendo esse padrão — qualquer cor mais saturada
quebra o conjunto imediatamente.

Escala de cinzas derivada (chrome da interface), do mais escuro ao mais claro:

```
#0c0b0c  activity/side/status bar, tabs inativas
#0F0E0F  editor
#141314  widgets, inputs, menus, hover cards
#1c191a  bordas, hover de lista, keybinding labels
#262223  indent guides, selection inativa
#2b2728  bordas de widget, selection de lista, botões
#3a3436  selection do editor, hover de botão
#4a4245  focus border, peek view border
#5e5853  comentários, foreground desabilitado
#6d6761  tabs inativas, breadcrumb, inlay hints
#8a827a  operadores, pontuação, namespace, description
#a79f95  activity bar, side bar foreground
#bab2a6  foreground geral da interface
#c7bfb4  parâmetros, terminal
#d4cbbc  propriedades e campos
#e3dac9  foreground principal
```

## Como experimentar

A extensão já está linkada em `~/.vscode/extensions/ashen`. O ciclo é:

1. Abra `themes/ashen-color-theme.json` e edite o hex que quiser.
2. `Ctrl+Shift+P` → **Developer: Reload Window**.
3. Veja o resultado nos arquivos de `samples/`.

Para ver várias linguagens ao mesmo tempo, abra o workspace e use
`View: Split Editor` com `Sample.java` + `sample.tsx` + `sample.rs` lado a lado.

### Descobrir o escopo de um token

Quando uma cor não mudar onde você esperava, o escopo é outro:

`Ctrl+Shift+P` → **Developer: Inspect Editor Tokens and Scopes**, então clique no
token. O popup mostra o `textmate scope` e o `semantic token type`, e qual regra do
tema está vencendo.

Atenção: `semanticTokenColors` tem precedência sobre `tokenColors` nas linguagens com
language server (Java, TypeScript, Rust, Go, Python). Se editar `tokenColors` e nada
mudar, a cor está vindo de `semanticTokenColors` — ajuste lá.

## Arquivos

```
package.json                        manifesto da extensão
themes/ashen-color-theme.json       o tema inteiro (paleta no topo)
samples/                            amostras por linguagem para avaliar
  Sample.java  sample.tsx  sample.vue  sample.rs  sample.go
  sample.py    sample.sql  sample.sh  sample.yml  sample.json  sample.md
.vscode/launch.json                 F5 abre um Extension Host de teste
```

## Empacotar

```bash
npx --yes @vscode/vsce package
code --install-extension ashen-0.0.1.vsix
```

## Migrando do seu settings.json

As customizações manuais sobre o *Monochrome Dark* agora estão todas no tema.
Depois de selecionar **Ashen**, remova de `settings.json` os blocos
`editor.tokenColorCustomizations["[Monochrome Dark]"]` e
`workbench.colorCustomizations["[Monochrome Dark]"]` — eles não se aplicam a este
tema e só vão confundir a próxima iteração. Se quiser testar um hex sem reload,
use um bloco `"[Ashen]"` temporário e depois mova o valor para o arquivo do tema.
