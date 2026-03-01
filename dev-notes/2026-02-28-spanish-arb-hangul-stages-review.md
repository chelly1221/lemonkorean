---
date: 2026-02-28
category: Mobile
title: Revision de traducciones al espanol - Etapas Hangul 1-11
author: Claude Opus 4.6
tags: [i18n, localization, spanish, hangul, arb]
priority: medium
---

# Revision de traducciones al espanol (app_es.arb) - Etapas Hangul 1-11

## Resumen

Revision completa de todas las claves ARB `hangulS*` (Etapas 1-11) en el archivo de localizacion espanol. Se corrigieron problemas de consistencia terminologica, texto sin traducir, concordancia de genero y normalizacion de tono.

## Cambios realizados

### 1. Texto sin traducir (ingles residual)
- `hangulS5LMStep4Title`: "Stage 5 completado!" -> "Etapa 5 completada!"
- `hangulS4L8Step4Q0`: "en ingles" -> reformulado a "Que significa?"
- `hangulS4L8Step4Q1`: "en ingles" -> reformulado a "Que significa?"

### 2. Inconsistencia "Nivel" vs "Etapa"
Todas las claves `hangulStageXTitle` usan "Etapa". Se unificaron 14 ocurrencias internas que usaban "Nivel":
- `hangulS1L9Step0Title`, `hangulS1L9Step3Title`, `hangulS1L9Step3Msg`, `hangulS1CompleteTitle`
- `hangulS5LMStep3Title`, `hangulS5LMStep3Msg`, `hangulS5CompleteTitle`, `hangulS5LMTitle`
- `hangulS7L5Step4Msg`
- `hangulS11L6Title`, `hangulS11L6Step0Desc`, `hangulS11L6Step1Title`, `hangulS11L6Step1Msg`
- `hangulS11LMStep4Title`, `hangulS11CompleteTitle`
- `hangulGoToLevel1`

### 3. Normalizacion "completa" -> "completada"
Se unificaron ~25 titulos de leccion/mision/etapa que usaban "completa" en vez de "completada":
- Etapa 1: 6 lecciones individuales (S1L1-S1L6)
- Etapa 8: 9 lecciones + 1 mision + titulo de etapa
- Etapa 9: 6 lecciones + titulo de etapa + mision
- Etapa 11: 5 lecciones + titulo de etapa

### 4. Normalizacion "Felicitaciones" -> "Felicidades"
Se unificaron 6 ocurrencias a "Felicidades" (tono mas calido y natural para app de aprendizaje):
- `hangulS3L7Step3Msg`, `hangulS4L7SummaryMsg`, `hangulS5LMStep3Msg`
- `hangulS6LMStep3Msg`, `hangulS10L6Step1Msg`, `hangulS11L7Step6Title`

### 5. Capitalizacion de "Etapa" en cuerpo de mensajes
- `hangulS6L8Step2Msg`: "etapa 6" -> "Etapa 6"
- `hangulS10L6Title`: "etapa 10" -> "Etapa 10"

### 6. Formato de titulos con preposicion faltante
- `hangulS6LMTitle`: "Mision Etapa 6" -> "Mision de la Etapa 6"
- `hangulS9L7Title`: "Repaso Etapa 9" -> "Repaso de la Etapa 9"

### 7. Capitalizacion de highlights
- `hangulS5L1Step0Highlights`: "Posicion inicial" -> "posicion inicial" (consistencia con otros highlights)

### 8. Redundancia en descripcion
- `hangulS8L4Step0Desc`: Eliminada repeticion del titulo "ㅇ es especial!" en la descripcion

### 9. Puntuacion faltante en titulo de etapa
- `hangulS4L7SummaryMsg`: Agregados dos puntos faltantes en "Etapa 4 Consonantes" -> "Etapa 4: Consonantes"

## Archivos modificados
- `mobile/lemon_korean/lib/l10n/app_es.arb`

## Verificacion
- Archivo validado como JSON valido despues de todos los cambios
- Total de cambios: ~55 correcciones individuales
