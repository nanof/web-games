async function loadCatalog() {
  const grid = document.getElementById("games-grid");
  const emptyState = document.getElementById("empty-state");
  const errorState = document.getElementById("error-state");
  const titleEl = document.getElementById("site-title");
  const descEl = document.getElementById("site-description");

  try {
    const response = await fetch("games.json");
    if (!response.ok) {
      throw new Error(`No se pudo cargar games.json (${response.status})`);
    }

    const data = await response.json();

    if (data.site?.title) {
      titleEl.textContent = data.site.title;
      document.title = data.site.title;
    }

    if (data.site?.description) {
      descEl.textContent = data.site.description;
    } else {
      descEl.textContent = "";
    }

    const games = data.games ?? [];

    if (games.length === 0) {
      grid.innerHTML = "";
      emptyState.hidden = false;
      return;
    }

    emptyState.hidden = true;
    grid.innerHTML = games.map(renderCard).join("");
  } catch (err) {
    console.error(err);
    grid.innerHTML = "";
    errorState.textContent =
      "Error al cargar el catálogo. Si abres el archivo directamente, usa un servidor local (ver README).";
    errorState.hidden = false;
  }
}

function renderCard(game) {
  const title = escapeHtml(game.title ?? "Sin título");
  const description = escapeHtml(game.description ?? "");
  const path = escapeAttr(game.path ?? "#");
  const thumbnail = escapeAttr(game.thumbnail ?? "");
  const alt = escapeAttr(game.title ?? "Captura del juego");
  const tags = (game.tags ?? [])
    .map((tag) => `<li class="game-card__tag">${escapeHtml(tag)}</li>`)
    .join("");

  const tagsHtml =
    tags.length > 0
      ? `<ul class="game-card__tags" aria-label="Etiquetas">${tags}</ul>`
      : "";

  return `
    <article class="game-card">
      <img class="game-card__thumb" src="${thumbnail}" alt="${alt}" loading="lazy" width="640" height="360">
      <div class="game-card__body">
        <h2 class="game-card__title">${title}</h2>
        <p class="game-card__description">${description}</p>
        ${tagsHtml}
        <a class="game-card__play" href="${path}">Jugar</a>
      </div>
    </article>
  `;
}

function escapeHtml(str) {
  return String(str)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

function escapeAttr(str) {
  return escapeHtml(str).replace(/'/g, "&#39;");
}

loadCatalog();
