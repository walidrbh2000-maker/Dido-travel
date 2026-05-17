/**
 * adminAPI.js
 * Service API centralisé pour le dashboard admin TravelApp.
 * Cible le backend Laravel PHP via JWT.
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
    // Nécessaire pour ngrok (évite la page d'avertissement)
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

  const res = await fetch(`${BASE_URL}${path}`, options);

  // Réponse vide (ex : 204 No Content)
  if (res.status === 204) return null;

  const data = await res.json().catch(() => ({}));

  if (!res.ok) {
    // Laravel retourne toujours un champ `message`
    throw new Error(data.message ?? `Erreur HTTP ${res.status}`);
  }

  return data;
}

// ── Pagination helper ─────────────────────────────────────────────────────────

function qs(params = {}) {
  const p = { per_page: 100, ...params };
  return new URLSearchParams(p).toString();
}

// ── API publique ──────────────────────────────────────────────────────────────

const adminAPI = {
  // ── Auth ────────────────────────────────────────────────────────────────────
  async login(email, password) {
    const data = await request('POST', '/login', { email, password });
    if (data.user?.role !== 'admin') {
      throw new Error('Accès réservé aux administrateurs');
    }
    return data; // { message, user, token }
  },

  async logout() {
    try {
      await request('POST', '/logout');
    } catch {
      // On ignore les erreurs de déconnexion côté serveur
    }
  },

  async getMe() {
    return request('GET', '/me');
  },

  // ── Dashboard stats ──────────────────────────────────────────────────────────
  // Le backend n'a pas d'endpoint /stats dédié.
  // On agrège les métadonnées de pagination (total) de chaque ressource.
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
      // Les réservations nécessitent auth — peut échouer si token expiré
    }

    const total = (settled) =>
      settled.status === 'fulfilled' ? (settled.value?.total ?? 0) : 0;

    return {
      totalVols: total(vols),
      totalHotels: total(hotels),
      totalDestinations: total(destinations),
      totalGuides: total(guides),
      totalReservations: reservations?.total ?? 0,
    };
  },

  // ── Destinations ─────────────────────────────────────────────────────────────
  async getDestinations(params = {}) {
    return request('GET', `/destinations?${qs(params)}`);
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
    return request('GET', `/vols?${qs(params)}`);
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

  // ── Hotels ────────────────────────────────────────────────────────────────────
  async getHotels(params = {}) {
    return request('GET', `/hotels?${qs(params)}`);
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
  async getGuides(params = {}) {
    return request('GET', `/guides?${qs(params)}`);
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

  // ── Réservations (lecture seule pour l'admin via token admin) ─────────────────
  async getReservations(params = {}) {
    return request('GET', `/reservations?${qs(params)}`);
  },
};

export default adminAPI;
