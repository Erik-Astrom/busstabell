# busstabell

Realtidstavla för kommande avgångar (Trafiklab Realtime API). En enda statisk
HTML-fil — ingen backend, ingen databas. Hämtar direkt från
`realtime-api.trafiklab.se` i webbläsaren.

Live: **https://busstabell.jaghjalpermigsjalv.com** (bakom Cloudflare Access).

## API-nyckel

Nyckeln matas in i appens **Inställningar**-panel och sparas i webbläsarens
`localStorage` — den ligger alltså aldrig i repot eller på servern.

Skaffa en gratis nyckel:

1. Registrera dig på <https://www.trafiklab.se/>.
2. Skapa ett projekt och lägg till API:t **"Realtidsinformation 4"**
   (`realtime-api`, GTFS Realtime).
3. Kopiera nyckeln, öppna ⚙ Inställningar i appen och klistra in den.
   Sätt även **Hållplats-ID** (t.ex. `740069150`).

## Drift

| | |
|---|---|
| Hosting | Hetzner-VPS, Docker Compose, bakom kant-Caddyn i `jaghjalpermigsjalv`-stacken |
| Deploy | Push till `master` → GitHub Actions → SSH → `docker compose up -d --build` |
| Container | `caddy:2-alpine` med sidan inbakad, serverar på `:3000` |
| Nätverk | Delat externt Docker-nätverk `web` (kant-Caddyn proxar hit) |

### Engångsuppsättning på VPS:en

```sh
docker network create web        # om det inte redan finns
cd ~ && git clone git@github.com:Erik-Astrom/busstabell.git
cd busstabell && docker compose up -d --build
```

GitHub-secrets som deploy-workflowen behöver (Settings → Secrets → Actions):
`SSH_HOST`, `SSH_USER`, `SSH_KEY` — samma värden som i `jaghjalpermigsjalv`-repot.

## Lokalt

```sh
python3 -m http.server 3000    # och öppna http://localhost:3000
```
