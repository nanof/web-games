# Portal de juegos HTML5

Sitio estático para publicar tus juegos en el navegador. El catálogo se define en [`games.json`](games.json) y se despliega gratis en [GitHub Pages](https://pages.github.com/).

## Estructura

```
web-games/
├── index.html          # Galería principal
├── games.json          # Lista de juegos (editar para añadir nuevos)
├── css/style.css
├── js/main.js
└── games/
    └── mi-juego/
        ├── index.html
        └── thumb.png   # Captura ~640×360 (16:9)
```

## Añadir un juego nuevo

1. Crea la carpeta `games/mi-juego/` con tu `index.html` y los assets del juego.
2. Añade una captura `thumb.png` en esa misma carpeta (recomendado 640×360 px).
3. Agrega una entrada en `games.json`:

```json
{
  "id": "mi-juego",
  "title": "Mi Juego",
  "description": "Breve descripción del juego",
  "path": "games/mi-juego/index.html",
  "thumbnail": "games/mi-juego/thumb.png",
  "tags": ["arcade"],
  "date": "2026-06-01"
}
```

Campos obligatorios: `id`, `title`, `path`, `thumbnail`.

4. Sube los cambios a GitHub:

```bash
git add .
git commit -m "Añadir juego: Mi Juego"
git push
```

El sitio se actualizará solo en unos minutos.

## Probar en local

Abrir `index.html` directamente no funciona bien porque el navegador bloquea `fetch()` de archivos locales. Usa un servidor estático:

```bash
npx serve .
```

Luego abre `http://localhost:3000` en el navegador.

## Despliegue (GitHub Pages)

### Opción rápida (recomendada)

```powershell
gh auth login
.\scripts\deploy.ps1
```

El script crea el repo `web-games`, sube el código y activa GitHub Pages. La URL será `https://<tu-usuario>.github.io/web-games/`.

### Opción manual

1. Sube el repo a GitHub (`gh repo create web-games --public --source=. --remote=origin --push`).
2. Ve a **Settings → Pages**.
3. En **Source**, elige **Deploy from a branch**.
4. Branch: `main`, Folder: `/ (root)`.
5. Guarda. La URL será `https://<tu-usuario>.github.io/web-games/`.

Opcional: añade en `games.json` el campo `site.repo` con la URL de tu repositorio para mostrar el enlace en el pie de página.

## Volver al portal desde un juego

En cada juego puedes añadir un enlace de vuelta:

```html
<a href="../../index.html">← Volver al portal</a>
```

(Ajusta la ruta según la profundidad de la carpeta del juego.)
