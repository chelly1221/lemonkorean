Bundled stroke-order animation assets.

Naming:
- uXXXX.webp (preferred)
- uXXXX.gif (fallback)

Where XXXX is the Unicode code point of the compatibility jamo.
Examples:
- ㄱ (U+3131) -> u3131.webp
- ㄴ (U+3134) -> u3134.webp
- ㅏ (U+314F) -> u314f.webp

The app will automatically prefer these bundled files for playback.
If a file is missing, it falls back to the in-app painter animation.
