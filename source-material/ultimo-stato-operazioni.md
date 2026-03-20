# Liminal Manifold — Stato Operazioni

> Ultimo aggiornamento: 2026-03-05 01:21 CET — Sito in bozza, versione definitiva nel weekend

## Posizione progetto
- **Root:** `/media/sf_Shared/Projects/websites/liminal-manifold/`
- **Source material:** `/media/sf_Shared/Projects/websites/liminal-manifold/source-material/`
- **Build locale (per test):** `/tmp/lm-build/` (copia temporanea per buildare su ext4)

## Stack tecnologico
- **Framework:** Astro 5.18.0
- **Styling:** Tailwind CSS 3.4
- **Integrazioni:** @astrojs/mdx, @astrojs/sitemap, @astrojs/tailwind, @astrojs/rss, @tailwindcss/typography
- **Hosting:** Hostinger (DEFINITIVO, non Vercel)
- **Contenuti:** Astro Content Collections (Markdown con frontmatter + schema Zod)

## Estetica (aggiornata)
- Dark/liminal, glitch aesthetic, cyberpunk editorial
- Sfondo: #0a0a0a, accenti: cyan (#06b6d4) — primario, viola (#8b5cf6), magenta (#d946ef)
- **Font: Montserrat** (tutti i pesi, da Google Fonts) — sostituisce JetBrains Mono + Inter
- Logo: `public/logo.png` (versione con glow blu-bianco su nero) — integrato in header, hero, footer, favicon
- Effetti: glow cyan/violet su logo, hover transitions, noise texture
- **Tagline ufficiale: "Higher dimensions repository"** — usata in hero, footer, description SEO

## Struttura pagine (11 pagine, tutte funzionanti ✅)
1. **Homepage** (`/`) — Hero con logo, tagline, teaser artisti e release recenti
2. **Artists** (`/artists`) — Griglia di tutti gli artisti
3. **Artist detail** (`/artists/[slug]`) — Bio, discografia/bibliografia, link
4. **Music** (`/music`) — Catalogo release musicali
5. **Books** (`/books`) — Catalogo libri con link Amazon
6. **Blog** (`/blog`) — Lista post
7. **Blog post** (`/blog/[slug]`) — Singolo post
8. **About** (`/about`) — Chi è Liminal Manifold
9. **Contact** (`/contact`) — Form contatto + newsletter signup
10. **RSS** (`/rss.xml`) — Feed RSS blog
11. **Sitemap** (`/sitemap-index.xml`) — Generata automaticamente

## Social (implementati)
- **X (Twitter):** https://x.com/LiminalManifold
- **Instagram:** https://www.instagram.com/liminalmanifold
- **TikTok:** https://www.tiktok.com/@liminalmanifold
- **YouTube:** https://www.youtube.com/@LiminalManifold
- Icone SVG in: Header (desktop + mobile), Footer (brand column + lista Connect)
- Tracking: `data-track="social"` `data-social-id="social-X"` su ogni link

## Click Tracking (implementato)
Sistema basato su GA4 events, definito in `BaseLayout.astro`:
- `social_click` — click su social (platform, link_url)
- `amazon_click` — click su link Amazon (item_name, link_url)
- `streaming_click` — click su link Spotify/streaming (platform, item_name)
- `cta_click` — click su CTA (cta_label)
- `newsletter_signup` — iscrizione newsletter
- Tutti gli eventi includono: timestamp, device_type (mobile/desktop), referrer, page
- Attributi HTML per il tracking: `data-track`, `data-social-id`, `data-platform`, `data-item`, `data-label`

## Google Analytics 4 — DA FARE
**⚠️ GAS: segui le istruzioni nella sezione "Istruzioni per Gas" più in basso**
- Placeholder Measurement ID: `G-XXXXXXXXXX` in `src/layouts/BaseLayout.astro`
- Sostituire con ID reale dopo aver creato la proprietà GA4

## Google Search Console — DA FARE
- Placeholder verifica: `VERIFICATION_CODE_HERE` in `src/layouts/BaseLayout.astro`
- Sostituire con codice reale dopo aver aggiunto il sito in Search Console

## Content Collections (src/content/)

### Schema Artists (`src/content/artists/`)
- `name` (string), `slug` (string, optional), `type` (musician|writer|illustrator)
- `bio` (string), `image` (string, optional), `links` (array {platform, url}), `featured` (bool)

### Schema Releases (`src/content/releases/`)
- `title`, `artist` (string ref), `date`, `type` (album|ep|single)
- `cover`, `description`, `links` (array {platform, url})

### Schema Books (`src/content/books/`)
- `title`, `author` (string ref), `date`, `cover`, `description`
- `amazonUrl`, `genre`, `pages` (optional)

### Schema Blog (`src/content/blog/`)
- `title`, `date`, `author`, `tags` (array), `image`, `excerpt`

## Contenuti placeholder attuali
- **Artisti:** Pudgy Cat (musician), Unlisted Specimens (musician), Mara Voss (writer/sockpuppet)
- **Release:** Eat Sleep Dream Repeat (album, Pudgy Cat)
- **Libri:** Catnip & Chaos, Mayhem & Meows, Signal Decay (tutti di Mara Voss)
- **Blog:** "Welcome to the Manifold" (post inaugurale)

## File modificati nel secondo sprint (2026-02-27)
- `src/styles/global.css` — Montserrat, colori aggiornati (cyan come primario), `.social-icon`, `.logo-glow`
- `tailwind.config.mjs` — fontFamily: mono+sans → Montserrat
- `src/components/Header.astro` — logo PNG, social icons SVG, nav links
- `src/components/Footer.astro` — logo PNG, social icons SVG (brand + lista)
- `src/layouts/BaseLayout.astro` — favicon PNG, GA4 tag + click tracker, sameAs social, tagline in description
- `src/pages/index.astro` — logo in hero, tagline, data-track su tutti i CTA/links
- `public/logo.png` — logo ufficiale (glow, da source-material)
- `public/logont.png` — logo nero su trasparente (da source-material)

## Componenti (src/components/)
- `Header.astro` — Navigazione principale + social icons
- `Footer.astro` — Footer con link, social icons e credits
- `ArtistCard.astro` — Card per griglia artisti
- `BookCard.astro` — Card per griglia libri
- `ReleaseCard.astro` — Card per griglia release

## Integrazioni predisposte
- ✅ Sitemap automatica
- ✅ RSS feed per blog
- ✅ SEO meta tags + Open Graph + Twitter Cards
- ✅ JSON-LD structured data (Organization con sameAs social)
- ✅ robots.txt
- ✅ Click tracking (GA4 events)
- ✅ Social buttons (X, Instagram, TikTok, YouTube)
- ✅ Logo ufficiale integrato
- ✅ Font Montserrat
- ✅ Tagline "Higher dimensions repository"
- ⬜ Google Analytics 4 (Measurement ID da inserire — istruzioni sotto)
- ⬜ Google Search Console (codice verifica da inserire — istruzioni sotto)
- ⬜ Google Merchant Center (futuro)

## Build
- **Nota:** `/media/sf_Shared` è un shared folder VirtualBox — `npm install` fallisce per permessi symlink
- **Workaround:** copiare in `/tmp/lm-build/` → `npm install` → `npx astro build` → verificato ✅
- L'ultimo build completato: 11 pagine, 0 errori (2026-02-27 17:33)

## Fix applicati
- Schema `slug` reso opzionale (Astro 5 usa `artist.id` dal filename)
- Dynamic routes fixate: `artist.id` invece di `artist.data.slug`
- Astro dev server binda su IPv6 only — risolto con `serve.cjs` (Node http-server su IPv4)
- CSS `@import` spostato prima di `@tailwind` (fix warning)

## Problemi noti / rimasti
- Blog slug genera path con `.md` nel URL (`/blog/welcome-to-the-manifold.md/`) — da fixare
- Immagini: tutte placeholder. Servono immagini reali
- Link: tutti placeholder (spotify, amazon, ecc.). Servono link reali

## Cosa manca (TODO aggiornato)
- [ ] **GA4 Measurement ID** — inserire in BaseLayout.astro (istruzioni sotto)
- [ ] **Search Console verifica** — inserire in BaseLayout.astro (istruzioni sotto)
- [ ] Fix blog slug (.md nel path)
- [ ] Immagini reali per artisti (foto/artwork)
- [ ] Cover reali per release e libri
- [ ] Link reali (Spotify, Amazon, Bandcamp, ecc.)
- [ ] Aggiungere altri sockpuppet/scrittori KDP
- [ ] Aggiungere altri release musicali
- [ ] Mailing list provider (Mailchimp/Buttondown)
- [ ] Shop/merchandising (futuro, placeholder "Coming Soon")
- [ ] Deploy su Vercel
- [ ] Dominio custom (liminalmanifold.com?)

## ⚡ ISTRUZIONI PER GAS — Google Analytics 4 + Search Console

### Step 1: Crea proprietà Google Analytics 4
1. Vai su https://analytics.google.com/
2. Clicca **"Start measuring"** o **"Crea proprietà"**
3. Nome proprietà: `Liminal Manifold`
4. Fuso orario: `Italy (GMT+1)`, valuta: EUR
5. Categoria settore: Media/Intrattenimento
6. Clicca avanti → **"Web"** come tipo di stream
7. URL sito: il tuo dominio (es. `liminalmanifold.com` o URL Vercel)
8. Nome stream: `Liminal Manifold Web`
9. Copia il **Measurement ID** (formato `G-XXXXXXXXXX`)

### Step 2: Inserisci il Measurement ID nel sito
Apri `/media/sf_Shared/Projects/websites/liminal-manifold/src/layouts/BaseLayout.astro`
Sostituisci **entrambe** le occorrenze di `G-XXXXXXXXXX` con il tuo ID reale.

### Step 3: Crea proprietà Google Search Console
1. Vai su https://search.google.com/search-console/
2. Clicca **"Aggiungi proprietà"**
3. Scegli **"Prefisso URL"** → inserisci il tuo URL
4. Metodo di verifica: scegli **"Tag HTML"**
5. Copia il contenuto dell'attributo `content` dal meta tag che ti fornisce Google
   (es. `xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`)
6. Apri `BaseLayout.astro`, trova la riga:
   `<meta name="google-site-verification" content="VERIFICATION_CODE_HERE" />`
7. Sostituisci `VERIFICATION_CODE_HERE` con il codice copiato al passo 5
8. Rebuilda e deploya → poi clicca "Verifica" in Search Console

### Step 4: Colin (AI) può fare qualcosa autonomamente?
- ❌ **Creare proprietà GA4/Search Console**: NO — richiede accesso all'account Google di Gas
- ❌ **Verificare dominio**: NO — richiede DNS o file su server
- ✅ **Tutto il codice di integrazione**: GIÀ FATTO — il tag GA4 + tracker eventi è nel codice
- ✅ **Aggiornare il codice con ID reali**: SÌ — una volta che Gas mi dà i codici

### Step 5: Verifica che il tracking funzioni
Dopo aver messo il Measurement ID reale e deployato:
1. Apri il sito in Chrome
2. Apri DevTools → Console
3. Clicca un'icona social → dovresti vedere `[LM Track] social_click {...}` in console
4. In GA4 → Reports → Realtime → dovresti vedere l'evento entro 30 secondi

## Chi ha fatto cosa
- **Colin Ritman** (Claude Code): struttura progetto, tutte le pagine, componenti, content collections, estetica, contenuti placeholder — prima bozza + secondo sprint (logo, font, tagline, social, tracking)
- **Liam** (sessione principale): fix schema/routing, build verification, troubleshooting dev server

## Note tecniche
- La cartella `source-material/` contiene materiale di riferimento che NON va caricato su hosting
- Per aggiungere un artista: creare file `.md` in `src/content/artists/`
- Per aggiungere un libro: creare file `.md` in `src/content/books/`
- Per aggiungere una release: creare file `.md` in `src/content/releases/`
- Per aggiungere un blog post: creare file `.md` in `src/content/blog/`
- Build locale: `cp -r . /tmp/lm-build && cd /tmp/lm-build && npm install && npx astro build`
- Dev server: `npx astro dev --port 4321` (attenzione: binda IPv6, usare serve.cjs per IPv4)

---

## Sprint 3 — GA4 + Search Console (2026-02-27 18:00 CET)

### Completato in questo sprint:
- ✅ **GA4 Measurement ID inserito**: `G-PN90PR47BG` in `src/layouts/BaseLayout.astro` (entrambi i punti: script URL + config)
- ✅ **Google Search Console verification file**: `googlef97757eb57426715.html` copiato in `public/` — sarà servito alla root del sito dopo il deploy
- ✅ **Build verificato**: 11 pagine, 0 errori (`npx astro build --outDir /tmp/lm-build`)
- ✅ **Sito ora in staging** — non più "mockup"

### Prossimi passi:
- [ ] Deploy su Netlify / hosting definitivo
- [ ] Verifica Search Console dopo il deploy (cliccare "Verifica" nella console)
- [ ] Verificare dati real-time in GA4 dopo il deploy

## Aggiornamento 2026-02-27 19:52

### Decisioni
- **Hosting definitivo: Hostinger** (NON Vercel) — il dominio punta lì
- Deploy = `npx astro build` → upload `dist/` su Hostinger via FTP/file manager
- Sito rinominato da "mockup" a **staging**

### Sprint 3 (Colin)
- GA4 Measurement ID `G-PN90PR47BG` inserito in BaseLayout.astro
- File verifica Search Console `googlef97757eb57426715.html` in `public/`
- Build OK, 11 pagine, 0 errori

### Da fare
- [ ] Deploy su Hostinger (serve accesso FTP + dominio esatto)
- [ ] Verificare Search Console dopo deploy
- [ ] Continuare sviluppo sito (contenuti reali, immagini, link)

---

## 2026-03-20 (AGGIORNAMENTO — 6 NUOVI LIBRI + 5 AUTORI)

### Libri aggiunti alla pagina /books:

**Liminal Sci-Fi (sezione esistente, libri aggiunti):**
- "Almost Human" di Vera Blackwell — Amazon: B0GKQV93XQ
- "How To Delete A Soul" di Vera Blackwell — Amazon: B0GJN5T79H

**Nuove sezioni create:**
- "Liminal Thriller": The Grief Algorithm (Lauren Hayes, B0GM1VK88B) + Sleep Mode (Morgan Wells, B0GP2QJDJ6)
- "Liminal Fantasy": The Unchosen One (Cassandra Whitfield, B0GPFS5J6H)
- "Liminal Romance": The Ink Between Us (Chiara Bellini, B0GM7K9RDH)

### Autori aggiunti alla pagina /artists e con pagina individuale:
- Vera Blackwell (`/artists/vera-blackwell/`)
- Cassandra Whitfield (`/artists/cassandra-whitfield/`)
- Lauren Hayes (`/artists/lauren-hayes/`)
- Morgan Wells (`/artists/morgan-wells/`)
- Chiara Bellini (`/artists/chiara-bellini/`)

### Immagini:
- 6 copertine JPG convertite a WebP (q90) in `images/books/`
- 5 foto autori copiate da `amazon-kdp/author-photos/` in `images/artists/`
- Tutti i file sincronizzati anche in `dist/`

### Note tecniche:
- Sito modificato direttamente sugli HTML statici (no Astro source su questa macchina)
- La root folder (`/media/sf_Shared/Projects/websites/liminal-manifold/`) e il `dist/` sono allineati
- Deploy: caricare `dist/` su Hostinger (FTP/cPanel)
