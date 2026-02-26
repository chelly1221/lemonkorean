# Agent Runtime Rules

## Architecture Direction (Mandatory)

- Runtime target architecture is **Minimal Server**:
  - Server keeps only: `Auth + Progress + Social(SNS/DM/Voice)`.
  - App bundles and serves locally: `Hangul/Lessons/Vocabulary/Grammar/Theme defaults/Gamification defaults/Character catalog`.
- Do not introduce new runtime dependency on Content/Admin APIs for static learning content.
- For new features, classify data first:
  - `User-specific, mutable, cross-device sync required` -> server.
  - `Static or versioned curriculum/config/assets` -> app bundle/local storage.
- If content schema changes, update bundled source first (`mobile/lemon_korean/lib/data/local/`) and keep server optional.

## Flutter Run

- Always start `flutter run` in a TTY session.
- Do not use non-interactive/piped sessions for `flutter run`.
- Keep the TTY session alive so hot reload/hot restart input (`r`/`R`) is always available.

## Flutter Attach

- Always start `flutter attach` in a TTY session.
- Do not use non-interactive/piped sessions for `flutter attach`.
- Keep the TTY session alive so interactive debug commands remain available.
