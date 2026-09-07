# busstabell

Realtidstavla för kommande avgångar. En enda statisk HTML-fil — ingen backend,
ingen databas. Hämtar direkt från `realtime-api.trafiklab.se` i webbläsaren.

Live: **https://busstabell.jaghjalpermigsjalv.com** (bakom Cloudflare Access).

## API-nyckel — sätts EN gång

Skaffa en gratis nyckel:

1. Registrera dig på <https://www.trafiklab.se/>.
2. Skapa ett projekt och lägg till API:t **"Trafiklab Realtime APIs"**
   (ej "GTFS Regional Realtime").
3. Kopiera nyckeln.

Lägg den i `~/busstabell/.env` på VPS:en (ej i git):

```
TRAFIKLAB_KEY=din-nyckel
TRAFIKLAB_STOP=740069150
```

Vid start skriver containern `/srv/config.json` ur dessa, och sidan läser den —
så nyckeln funkar på **alla enheter** utan att mata in något i appen. ⚙-panelen
finns kvar som lokal override (sparas i den enhetens `localStorage`).

## Drift

| | |
|---|---|
| Hosting | Hetzner-VPS, Docker Compose, bakom kant-Caddyn i `jaghjalpermigsjalv`-stacken |
| Deploy | Push `master` → GitHub Actions → SSH → `docker compose up -d --build` |
| Container | `caddy:2-alpine`, sidan inbakad, serverar `:3000` |
| Nätverk | Delat externt Docker-nätverk `web` (kant-Caddyn proxar hit) |

### Engångsuppsättning på VPS:en

```sh
docker network create web        # om det inte redan finns
cd ~ && git clone git@github.com:Erik-Astrom/busstabell.git
cd busstabell
printf 'TRAFIKLAB_KEY=din-nyckel\nTRAFIKLAB_STOP=740069150\n' > .env
docker compose up -d --build
```

GitHub-secrets (Settings → Secrets → Actions): `SSH_HOST`, `SSH_USER`, `SSH_KEY`
— samma som i `jaghjalpermigsjalv`-repot.

## Lokalt

```sh
python3 -m http.server 3000    # → http://localhost:3000
```
