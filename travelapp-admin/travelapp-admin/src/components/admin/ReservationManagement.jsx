import React, { useState, useEffect, useCallback } from 'react';
import {
  Calendar,
  RefreshCw,
  Info,
  User,
  Plane,
  Hotel,
  ChevronDown,
} from 'lucide-react';
import adminAPI from '../../services/adminAPI.js';
import { Table, Badge, Pagination, ErrorBanner } from './shared.jsx';

// ── Helpers ───────────────────────────────────────────────────────────────────
const STATUTS = ['en_attente', 'confirmee', 'annulee', 'payee'];

const statColor = (s) =>
  ({
    en_attente: 'amber',
    confirmee: 'green',
    annulee: 'red',
    payee: 'blue',
  }[s] ?? 'slate');

const statLabel = (s) =>
  ({
    en_attente: 'En attente',
    confirmee: 'Confirmée',
    annulee: 'Annulée',
    payee: 'Payée',
  }[s] ?? s);

const fmtDate = (s) =>
  s
    ? new Date(s).toLocaleDateString('fr-FR', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric',
      })
    : '—';

const fmtMoney = (v) =>
  v !== undefined && v !== null
    ? Number(v).toLocaleString('fr-DZ') + ' DZD'
    : '—';

// ── Stat cards mini ───────────────────────────────────────────────────────────
const MiniStat = ({ label, value, color }) => {
  const colors = {
    amber: 'bg-amber-50 dark:bg-amber-900/20 text-amber-700 dark:text-amber-400',
    green: 'bg-emerald-50 dark:bg-emerald-900/20 text-emerald-700 dark:text-emerald-400',
    red: 'bg-red-50 dark:bg-red-900/20 text-red-700 dark:text-red-400',
    blue: 'bg-blue-50 dark:bg-blue-900/20 text-blue-700 dark:text-blue-400',
    slate: 'bg-slate-50 dark:bg-slate-800 text-slate-700 dark:text-slate-300',
  };
  return (
    <div
      className={`rounded-xl px-4 py-3 flex items-center justify-between ${colors[color]}`}
    >
      <span className="text-xs font-semibold uppercase tracking-wider opacity-80">
        {label}
      </span>
      <span className="text-xl font-bold">{value}</span>
    </div>
  );
};

// ── Ligne détail dépliable ────────────────────────────────────────────────────
const ReservationRow = ({ r }) => {
  const [expanded, setExpanded] = useState(false);

  return (
    <>
      <tr
        className="hover:bg-slate-50 dark:hover:bg-slate-800/50 transition cursor-pointer"
        onClick={() => setExpanded((v) => !v)}
      >
        {/* Référence */}
        <td className="px-5 py-3.5">
          <div className="flex items-center gap-2">
            <ChevronDown
              className={`w-3.5 h-3.5 text-slate-400 transition-transform duration-200 ${
                expanded ? 'rotate-180' : ''
              }`}
            />
            <span className="font-mono text-xs font-bold text-slate-800 dark:text-white bg-slate-100 dark:bg-slate-800 px-2 py-0.5 rounded-lg">
              {r.reference}
            </span>
          </div>
        </td>

        {/* Destination / vol */}
        <td className="px-5 py-3.5">
          <div className="flex items-center gap-1.5">
            <Plane className="w-3.5 h-3.5 text-blue-400 flex-shrink-0" />
            <div>
              <p className="font-medium text-slate-800 dark:text-white text-sm">
                {r.vol?.destination?.name ?? '—'}
              </p>
              <p className="text-xs text-slate-400">
                {r.vol?.compagnie} · {r.vol?.numero_vol}
              </p>
            </div>
          </div>
        </td>

        {/* Dates */}
        <td className="px-5 py-3.5 text-xs text-slate-600 dark:text-slate-400">
          <p>{fmtDate(r.date_debut)}</p>
          <p className="text-slate-400">→ {fmtDate(r.date_fin)}</p>
        </td>

        {/* Personnes */}
        <td className="px-5 py-3.5 text-center">
          <span className="inline-flex items-center gap-1 text-sm text-slate-600 dark:text-slate-300">
            <User className="w-3.5 h-3.5" />
            {r.nombre_personnes}
          </span>
        </td>

        {/* Prix */}
        <td className="px-5 py-3.5 font-bold text-slate-800 dark:text-white text-sm whitespace-nowrap">
          {fmtMoney(r.prix_total)}
        </td>

        {/* Statut */}
        <td className="px-5 py-3.5">
          <Badge color={statColor(r.statut)}>{statLabel(r.statut)}</Badge>
        </td>

        {/* Date création */}
        <td className="px-5 py-3.5 text-xs text-slate-400">
          {fmtDate(r.created_at)}
        </td>
      </tr>

      {/* Ligne dépliée — détails supplémentaires */}
      {expanded && (
        <tr className="bg-slate-50 dark:bg-slate-800/30">
          <td colSpan={7} className="px-8 py-4">
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4 text-xs">
              {/* Hôtel */}
              <div className="flex items-start gap-2">
                <Hotel className="w-3.5 h-3.5 text-violet-500 mt-0.5 flex-shrink-0" />
                <div>
                  <p className="font-semibold text-slate-600 dark:text-slate-400 uppercase tracking-wide mb-0.5">
                    Hôtel
                  </p>
                  <p className="text-slate-800 dark:text-white">
                    {r.hotel?.nom ?? 'Sans hôtel'}
                  </p>
                </div>
              </div>

              {/* Type trajet */}
              <div>
                <p className="font-semibold text-slate-600 dark:text-slate-400 uppercase tracking-wide mb-0.5">
                  Type trajet
                </p>
                <p className="text-slate-800 dark:text-white capitalize">
                  {r.type_trajet?.replace('_', ' ') ?? '—'}
                </p>
              </div>

              {/* Vol retour */}
              <div>
                <p className="font-semibold text-slate-600 dark:text-slate-400 uppercase tracking-wide mb-0.5">
                  Vol retour
                </p>
                <p className="text-slate-800 dark:text-white">
                  {r.vol_retour_id ? `ID #${r.vol_retour_id}` : 'Aller simple'}
                </p>
              </div>

              {/* Guide */}
              <div>
                <p className="font-semibold text-slate-600 dark:text-slate-400 uppercase tracking-wide mb-0.5">
                  Guide
                </p>
                <p className="text-slate-800 dark:text-white">
                  {r.guide_id ? `ID #${r.guide_id}` : 'Sans guide'}
                </p>
              </div>
            </div>
          </td>
        </tr>
      )}
    </>
  );
};

// ── Main ──────────────────────────────────────────────────────────────────────
const ReservationManagement = () => {
  const [items, setItems] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [search, setSearch] = useState('');
  const [filterStatut, setFilterStatut] = useState('all');
  const [page, setPage] = useState(1);
  const [refreshing, setRefreshing] = useState(false);
  const PER = 15;

  const load = useCallback(
    async (silent = false) => {
      if (!silent) setLoading(true);
      else setRefreshing(true);
      setError('');
      try {
        const res = await adminAPI.getReservations({ per_page: 200 });
        // Laravel retourne { data: [...], total, ... } pour les paginated
        setItems(res.data ?? res ?? []);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
        setRefreshing(false);
      }
    },
    []
  );

  useEffect(() => {
    load();
  }, [load]);

  // ── Filtrage local ──────────────────────────────────────────────────────────
  const filtered = items.filter((r) => {
    const matchSearch =
      r.reference?.toLowerCase().includes(search.toLowerCase()) ||
      r.vol?.destination?.name
        ?.toLowerCase()
        .includes(search.toLowerCase()) ||
      r.vol?.compagnie?.toLowerCase().includes(search.toLowerCase());

    const matchStatut =
      filterStatut === 'all' || r.statut === filterStatut;

    return matchSearch && matchStatut;
  });

  // ── Stats rapides ───────────────────────────────────────────────────────────
  const stats = {
    en_attente: items.filter((r) => r.statut === 'en_attente').length,
    confirmee: items.filter((r) => r.statut === 'confirmee').length,
    payee: items.filter((r) => r.statut === 'payee').length,
    annulee: items.filter((r) => r.statut === 'annulee').length,
  };

  const totalPages = Math.ceil(filtered.length / PER);
  const slice = filtered.slice((page - 1) * PER, page * PER);

  return (
    <div className="p-8 max-w-7xl space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center gap-4">
        <div className="flex-1">
          <h1 className="text-xl font-bold text-slate-800 dark:text-white flex items-center gap-2">
            <Calendar className="w-5 h-5 text-rose-500" />
            Réservations
          </h1>
          <p className="text-sm text-slate-500 dark:text-slate-400 mt-0.5">
            {filtered.length} résultat(s) · {items.length} au total
          </p>
        </div>

        {/* Controls */}
        <div className="flex items-center gap-3 flex-wrap">
          {/* Search */}
          <input
            type="text"
            value={search}
            onChange={(e) => {
              setSearch(e.target.value);
              setPage(1);
            }}
            placeholder="Référence, destination…"
            className="pl-4 pr-4 py-2 text-sm bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-700 rounded-xl text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500 w-52 transition"
          />

          {/* Filtre statut */}
          <select
            value={filterStatut}
            onChange={(e) => {
              setFilterStatut(e.target.value);
              setPage(1);
            }}
            className="px-3 py-2 text-sm bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-700 rounded-xl text-slate-700 dark:text-slate-300 focus:outline-none focus:ring-2 focus:ring-blue-500 transition"
          >
            <option value="all">Tous les statuts</option>
            {STATUTS.map((s) => (
              <option key={s} value={s}>
                {statLabel(s)}
              </option>
            ))}
          </select>

          {/* Refresh */}
          <button
            onClick={() => load(true)}
            disabled={refreshing}
            className="flex items-center gap-2 px-4 py-2 text-sm font-medium text-slate-600 dark:text-slate-300 bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-700 rounded-xl hover:bg-slate-50 dark:hover:bg-slate-800 transition disabled:opacity-50"
          >
            <RefreshCw
              className={`w-4 h-4 ${refreshing ? 'animate-spin' : ''}`}
            />
            Actualiser
          </button>
        </div>
      </div>

      {/* Stats rapides */}
      {!loading && items.length > 0 && (
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
          <MiniStat label="En attente" value={stats.en_attente} color="amber" />
          <MiniStat label="Confirmées" value={stats.confirmee} color="green" />
          <MiniStat label="Payées" value={stats.payee} color="blue" />
          <MiniStat label="Annulées" value={stats.annulee} color="red" />
        </div>
      )}

      {/* Info banner — limitation backend */}
      <div className="bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 rounded-xl px-4 py-3 flex items-start gap-3">
        <Info className="w-4 h-4 text-blue-500 flex-shrink-0 mt-0.5" />
        <div className="text-xs text-blue-700 dark:text-blue-400 space-y-0.5">
          <p className="font-semibold">Vue lecture seule</p>
          <p>
            L'API actuelle filtre les réservations par utilisateur connecté.
            Pour une vue globale de toutes les réservations, un endpoint{' '}
            <code className="font-mono bg-blue-100 dark:bg-blue-900/40 px-1 py-0.5 rounded">
              GET /admin/reservations
            </code>{' '}
            doit être ajouté au backend Laravel.
          </p>
        </div>
      </div>

      <ErrorBanner message={error} />

      {/* Table */}
      <Table
        headers={[
          'Référence',
          'Vol / Destination',
          'Dates',
          'Pers.',
          'Prix total',
          'Statut',
          'Créé le',
        ]}
        loading={loading}
        empty={
          items.length === 0
            ? "Aucune réservation associée à ce compte admin. Un endpoint dédié est nécessaire pour voir toutes les réservations."
            : "Aucun résultat pour ces filtres."
        }
      >
        {slice.map((r) => (
          <ReservationRow key={r.id} r={r} />
        ))}
      </Table>

      <Pagination current={page} total={totalPages} onChange={setPage} />
    </div>
  );
};

export default ReservationManagement;
