# Prompt do ícone — Ashen

Pixel art 16-bit, 128×128. Usa somente cores do tema, excluindo verde (`#5a6055`),
vermelho (`#78353f`) e laranja (`#6a5037`).

## Prompt

```
16-bit pixel art icon, 128x128 pixels, crisp hard-edged pixels with no
anti-aliasing and no blur, nearest-neighbor scaling, visible square pixel grid.

Subject: a single lit oil lamp made of smooth ceramic, seen from the side,
resting on a flat stone ledge. A thin wisp of smoke curls up from the spout.
Centered composition with generous empty margin, readable as a silhouette
at 16x16.

Strict palette - use ONLY these nine colors, no others, no gradients:
  #0F0E0F  near-black background (fills the entire canvas)
  #1c191a  deepest shadow
  #2b2728  cast shadow under the lamp
  #4a4245  outline and dark edges
  #5e5853  mid shadow on the ceramic
  #937f88  dusty mauve - the lamp body base tone
  #93867f  warm taupe - the stone ledge and lamp foot
  #bebab4  warm light grey - rim light on the lamp's upper edge
  #e3dac9  pale bone - the flame and the brightest highlight

Rendering rules:
  Flat color fields with deliberate 2-3 step dithering (checkerboard pattern)
  where tones meet; no smooth gradients anywhere.
  The flame is the only truly bright element: a small 4-5 pixel teardrop in
  #e3dac9, with #bebab4 immediately around it. No glow, no bloom, no halo.
  The smoke is a sparse broken line of #5e5853 single pixels.
  Keep the whole image desaturated and muted - this is a near-monochrome
  scene lit by one weak flame, almost dusk-dark.
  Outline the lamp in #4a4245, one pixel wide, not pure black.

Negative: no green, no red, no orange, no yellow, no blue, no saturated color,
no neon, no glow effects, no gradients, no anti-aliasing, no text, no letters,
no logos, no 3D rendering, no photorealism, no watermark, no border frame.
```

## Origem das cores

As 5 da paleta base que sobraram após as exclusões:

| Hex | Papel no tema |
| --- | --- |
| `#0F0E0F` | fundo do editor |
| `#e3dac9` | foreground principal |
| `#937f88` | keywords |
| `#93867f` | tipos e classes |
| `#bebab4` | tags, markup |

Essas três têm luminosidade quase igual (53.7%, 53.7%, 72.5%), insuficiente para
dar volume em pixel art. Os 4 degraus de sombra abaixo vêm do próprio tema:

| Hex | Papel no tema |
| --- | --- |
| `#1c191a` | bordas, hover de lista |
| `#2b2728` | bordas de widget |
| `#4a4245` | focus border |
| `#5e5853` | comentários |

## Variações para testar

- **Objeto:** brasa apagando numa lareira · vela quase no fim · lanterna de papel
- **Enquadramento:** `isometric 3/4 view` no lugar de `seen from the side`
- **Densidade:** `32x32 pixel grid upscaled to 128x128` deixa os pixels maiores
  e mais legíveis como ícone pequeno

## Pós-processamento

Modelos de imagem raramente respeitam a paleta ao pé da letra. Depois de gerar:

```bash
# força o resultado para a paleta exata
magick entrada.png -dither None -remap paleta.png -filter point -resize 128x128 icon.png
```

Onde `paleta.png` é uma faixa de 9 pixels com as cores acima.
