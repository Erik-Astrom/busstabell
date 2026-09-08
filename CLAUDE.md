# busstabell — kontext för Claude

Statisk realtidstavla för bussavgångar. **En enda fil, `index.html`** — ingen
backend, ingen databas, ingen byggkedja. Hämtar direkt från
`realtime-api.trafiklab.se` i webbläsaren.

Live: `https://busstabell.jaghjalpermigsjalv.com` (bakom Cloudflare Access,
samma inloggning som Eriks övriga sajter).

## Arkitektur

- `index.html` bakas in i en `caddy:2-alpine`-image (`Dockerfile`), serverar på
  `:3000`. `docker-entrypoint.sh` skriver `/srv/config.json` ur miljövariabler
  vid start.
- Kör som en Compose-tjänst (`busstabell`) på det delade externa Docker-nätet
  `web`. Kant-Caddyn (i repot `jaghjalpermigsjalv`) terminerar TLS och proxar hit.
- Config-ordning i appen: `/config.json` (från `.env` på servern) → `localStorage`
  (per-webbläsare-override via ⚙) → inbyggda default.

## `.env` på VPS:en (`~/busstabell/.env`, ej i git)

```
TRAFIKLAB_KEY=…            # "Trafiklab Realtime APIs", EJ "GTFS Regional Realtime"
TRAFIKLAB_STOP=740069150   # "Till jobb" (Skrattmåsvägen)
TRAFIKLAB_STOP_FROM=740021667  # "Från jobb" (Hötorget T-bana)
```

## Funktioner i index.html

- **Två flikar** — "Till jobb" och "Från jobb", var sin hållplats (`TABS`-objektet).
  Bara aktiv flik pollar API:et.
- `FILTER` (per flik) — "Från jobb" visar bara avgångar söderut (mot Hagsätra/
  Farsta strand/Skarpnäck-grenarna); norrgående döljs.
- `HIGHLIGHT` (per flik) — "Till jobb": blått för Liljeholmen/Älvsjö, orange för
  Farsta centrum. "Från jobb": grönt + fetstil för linje 19 (mot Högdalen).
- Hållplatssökning i ⚙ (`/v1/stops/name/{q}`), skärm-vaken-toggle (Screen Wake
  Lock), live-nedräkning var 10:e sek, omhämtning vid `visibilitychange`.

## Trafiklab departures-schema (v1)

`departures[]`: `scheduled`, `realtime`, `delay` (sek), `canceled`, `is_realtime`,
`route.{designation,name,transport_mode,transport_mode_code,direction,destination.name}`,
`scheduled_platform.designation` / `realtime_platform.designation`. Topp-nivå:
`stops[]` (med `name`). `transport_mode` ∈ BUS/METRO/TRAIN/TRAM/TAXI/BOAT.

## Deploy

Push till `master` → (auto-deploy när SSH-secrets är satta, annars manuellt):
`cd ~/busstabell && git pull && docker compose up -d --build` på VPS:en som
`deploy`. Verifiera lokalt före push: `docker build` + kör + `curl :3000/` och
`curl :3000/config.json`.

## Bredare bild

Detta är en av tre sajter på Erik's VPS. Cross-projekt-kontext + status finns i
Claude Codes minne när man kör från `~/Work/jaghjalpermigsjalv` (`subdomaner`-minnet).
