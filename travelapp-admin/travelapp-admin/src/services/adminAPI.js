/**
 * adminAPI.js
 * Service API centralisé pour le dashboard admin TravelApp.
 * Cible le backend Laravel/PHP via JWT.
 *
 * Base URL : https://tiger-sudoku-tiara.ngrok-free.dev/api/v1
 */

const BASE_URL = 'https://tiger-sudoku-tiara.ngrok-free.dev/api/v1';

// ── Helpers internes ──────────────────────────────────────────────────────────

function getSession() {
  try {
    const raw = localStorage.getItem('admin_session');
    return raw ? JSON.parse(raw) : null;
  } catch {
    return null;
  }
}

function getToken() {
  return getSession()?.token ?? null;
}

function buildHeaders(extra = {}) {
  const token = getToken();
  return {
    'Content-Type': 'application/json',
    Accept: 'application/json',
    // Nécessaire pour ngrok — évite la page d'avertissement interstitielle
    'ngrok-skip-browser-warning': 'true',
    ...(token ? { Authorization: `Bearer ${token}` } : {}),
    ...extra,
  };
}

async function request(method, path, body = null) {
  const options = {
    method,
    headers: buildHeaders(),
  };

  if (body !== null) {
    options.body = JSON.stringify(body);
  }

  let res;
  try {
    res = await fetch(`${BASE_URL}${path}`, options);
  } catch (networkErr) {
    throw new Error('Impossible de joindre le serveur. Vérifiez votre connexion ou le tunnel ngrok.');
  }

  // Réponse vide (204 No Content ou body vide)
  if (res.status === 204) return null;

  const text = await res.text();
  let data = {};
  if (text) {
    try {
      data = JSON.parse(text);
    } catch {
      // Réponse non-JSON (ex: page HTML ngrok)
      throw new Error(`Réponse inattendue du serveur (HTTP ${res.status}).`);
    }
  }

  if (!res.ok) {
    // Erreurs de validation Laravel (422)
    if (res.status === 422 && data.errors) {
      const firstError = Object.values(data.errors).flat()[0];
      throw new Error(firstError ?? 'Erreur de validation');
    }
    throw new Error(data.message ?? `Erreur HTTP ${res.status}`);
  }

  return data;
}

// ── Query string helper ───────────────────────────────────────────────────────
function qs(params = {}) {
  // Supprimer les valeurs undefined/null
  const clean = Object.fromEntries(
    Object.entries({ per_page: 100, ...params }).filter(
      ([, v]) => v !== undefined && v !== null
    )
  );
  return new URLSearchParams(clean).toString();
}

// ── API publique ──────────────────────────────────────────────────────────────
const adminAPI = {

  // ── Authentification ─────────────────────────────────────────────────────────
  async login(email, password) {
    const data = await request('POST', '/login', { email, password });
    if (data.user?.role !== 'admin') {
      // Déconnexion immédiate si non-admin
      try { await request('POST', '/logout'); } catch { /* ignore */ }
      throw new Error('Accès réservé aux administrateurs.');
    }
    return data; // { message, user, token }
  },

  async logout() {
    try {
      await request('POST', '/logout');
    } catch {
      // On ignore les erreurs serveur lors du logout
    }
  },

  async getMe() {
    return request('GET', '/me');
  },

  // ── Statistiques dashboard ───────────────────────────────────────────────────
  // Le backend n'a pas d'endpoint /stats dédié.
  // On agrège les `total` retournés par les endpoints paginés.
  async getDashboardStats() {
    const [vols, hotels, destinations, guides] = await Promise.allSettled([
      request('GET', `/vols?per_page=1`),
      request('GET', `/hotels?per_page=1`),
      request('GET', `/destinations?per_page=1`),
      request('GET', `/guides?per_page=1`),
    ]);

    let reservations = null;
    try {
      reservations = await request('GET', `/reservations?per_page=1`);
    } catch {
      // Peut échouer si le token est expiré ou si l'admin n'a pas de réservations
    }

    const total = (settled) =>
      settled.status === 'fulfilled'
        ? (settled.value?.total ?? settled.value?.meta?.total ?? 0)
        : 0;

    return {
      totalVols: total(vols),
      totalHotels: total(hotels),
      totalDestinations: total(destinations),
      totalGuides: total(guides),
      totalReservations: reservations?.total ?? reservations?.meta?.total ?? 0,
    };
  },

  // ── Destinations ─────────────────────────────────────────────────────────────
  async getDestinations(params = {}) {
    const data = await request('GET', `/destinations?${qs(params)}`);
    // Normalise : { data: [...] } ou directement [...]
    return Array.isArray(data) ? { data } : data;
  },
  async createDestination(body) {
    return request('POST', '/admin/destinations', body);
  },
  async updateDestination(id, body) {
    return request('PUT', `/admin/destinations/${id}`, body);
  },
  async deleteDestination(id) {
    return request('DELETE', `/admin/destinations/${id}`);
  },

  // ── Vols ─────────────────────────────────────────────────────────────────────
  async getVols(params = {}) {
    const data = await request('GET', `/vols?${qs(params)}`);
    return Array.isArray(data) ? { data } : data;
  },
  async createVol(body) {
    return request('POST', '/admin/vols', body);
  },
  async updateVol(id, body) {
    return request('PUT', `/admin/vols/${id}`, body);
  },
  async deleteVol(id) {
    return request('DELETE', `/admin/vols/${id}`);
  },

  // ── Hôtels ───────────────────────────────────────────────────────────────────
  async getHotels(params = {}) {
    const data = await request('GET', `/hotels?${qs(params)}`);
    return Array.isArray(data) ? { data } : data;
  },
  async createHotel(body) {
    return request('POST', '/admin/hotels', body);
  },
  async updateHotel(id, body) {
    return request('PUT', `/admin/hotels/${id}`, body);
  },
  async deleteHotel(id) {
    return request('DELETE', `/admin/hotels/${id}`);
  },

  // ── Guides ────────────────────────────────────────────────────────────────────
  // NOTE : L'endpoint public GET /guides filtre automatiquement disponible=true.
  // Pour l'admin, on récupère en deux passes et on fusionne si nécessaire.
  // Solution propre → ajouter GET /admin/guides côté backend.
  async getGuides(params = {}) {
    const data = await request('GET', `/guides?${qs(params)}`);
    return Array.isArray(data) ? { data } : data;
  },
  async createGuide(body) {
    return request('POST', '/admin/guides', body);
  },
  async updateGuide(id, body) {
    return request('PUT', `/admin/guides/${id}`, body);
  },
  async deleteGuide(id) {
    return request('DELETE', `/admin/guides/${id}`);
  },

  // ── Réservations (lecture) ────────────────────────────────────────────────────
  // Actuellement filtrées par user_id côté backend → retourne les résas de l'admin.
  // Pour voir TOUTES les résas, ajouter GET /admin/reservations au backend.
  async getReservations(params = {}) {
    try {
      const data = await request('GET', `/reservations?${qs(params)}`);
      return Array.isArray(data) ? { data } : data;
    } catch (err) {
      // Si non authentifié ou token expiré
      throw err;
    }
  },
};

export default adminAPI;
