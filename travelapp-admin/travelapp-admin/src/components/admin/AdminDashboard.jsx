import React, { useState, useEffect } from 'react';
import { Plane, Hotel, MapPin, Compass, Calendar, TrendingUp, RefreshCw } from 'lucide-react';
import adminAPI from '../../services/adminAPI.js';
import { useAdmin } from '../../AdminContext.jsx';

// ── Stat card ─────────────────────────────────────────────────────────────────
const StatCard = ({ label, value, icon: Icon, gradient, loading }) => (
  <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 p-6 flex items-center gap-5">
    <div className={`w-14 h-14 rounded-2xl flex items-center justify-center flex-shrink-0 ${gradient}`}>
      <Icon className="w-7 h-7 text-white" />
    </div>
    <div>
      <p className="text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-1">
        {label}
      </p>
      {loading ? (
        <div className="h-8 w-16 bg-slate-200 dark:bg-slate-700 rounded-lg animate-pulse" />
      ) : (
        <p className="text-3xl font-bold text-slate-800 dark:text-white">
          {value.toLocaleString('fr-FR')}
        </p>
      )}
    </div>
  </div>
);

// ── Quick link card ───────────────────────────────────────────────────────────
const QuickLink = ({ to, label, desc, icon: Icon, color }) => {
  const colors = {
    blue:   'bg-blue-50 dark:bg-blue-900/20 text-blue-600 dark:text-blue-400',
    violet: 'bg-violet-50 dark:bg-violet-900/20 text-violet-600 dark:text-violet-400',
    emerald:'bg-emerald-50 dark:bg-emerald-900/20 text-emerald-600 dark:text-emerald-400',
    amber:  'bg-amber-50 dark:bg-amber-900/20 text-amber-600 dark:text-amber-400',
  };
  return (
    <a
      href={to}
      className="group flex items-center gap-4 bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 p-5 hover:border-blue-300 dark:hover:border-blue-700 hover:shadow-md transition-all duration-200"
    >
      <div className={`w-11 h-11 rounded-xl flex items-center justify-center flex-shrink-0 ${colors[color]}`}>
        <Icon className="w-5 h-5" />
      </div>
      <div className="min-w-0 flex-1">
        <p className="font-semibold text-slate-800 dark:text-white text-sm">{label}</p>
        <p className="text-xs text-slate-500 dark:text-slate-400 truncate">{desc}</p>
      </div>
    </a>
  );
};

// ── Main ──────────────────────────────────────────────────────────────────────
const AdminDashboard = () => {
  const { admin } = useAdmin();
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [refreshing, setRefreshing] = useState(false);

  const load = async (silent = false) => {
    if (!silent) setLoading(true);
    else setRefreshing(true);
    setError(null);
    try {
      const data = await adminAPI.getDashboardStats();
      setStats(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  };

  useEffect(() => { load(); }, []);

  const statCards = [
    { label: 'Vols programmés',  value: stats?.totalVols ?? 0,         icon: Plane,    gradient: 'bg-gradient-to-br from-blue-500 to-blue-700' },
    { label: 'Hôtels',          value: stats?.totalHotels ?? 0,        icon: Hotel,    gradient: 'bg-gradient-to-br from-violet-500 to-violet-700' },
    { label: 'Destinations',    value: stats?.totalDestinations ?? 0,  icon: MapPin,   gradient: 'bg-gradient-to-br from-emerald-500 to-emerald-700' },
    { label: 'Guides',          value: stats?.totalGuides ?? 0,        icon: Compass,  gradient: 'bg-gradient-to-br from-amber-500 to-amber-700' },
    { label: 'Réservations',    value: stats?.totalReservations ?? 0,  icon: Calendar, gradient: 'bg-gradient-to-br from-rose-500 to-rose-700' },
  ];

  return (
    <div className="p-8 space-y-8 max-w-7xl">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-slate-800 dark:text-white">
            Bonjour, {admin?.user?.name ?? 'Admin'} 👋
          </h1>
          <p className="text-slate-500 dark:text-slate-400 text-sm mt-1">
            Vue d'ensemble de TravelApp — {new Date().toLocaleDateString('fr-FR', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' })}
          </p>
        </div>
        <button
          onClick={() => load(true)}
          disabled={refreshing}
          className="flex items-center gap-2 px-4 py-2 text-sm font-medium text-slate-600 dark:text-slate-300 bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-700 rounded-xl hover:bg-slate-50 dark:hover:bg-slate-800 transition disabled:opacity-50"
        >
          <RefreshCw className={`w-4 h-4 ${refreshing ? 'animate-spin' : ''}`} />
          Actualiser
        </button>
      </div>

      {/* Error */}
      {error && (
        <div className="bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-2xl px-5 py-4 text-sm text-red-700 dark:text-red-400">
          ⚠️ {error}
        </div>
      )}

      {/* Stats grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5 gap-4">
        {statCards.map((s) => (
          <StatCard key={s.label} {...s} loading={loading} />
        ))}
      </div>

      {/* API info card */}
      <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 p-6">
        <div className="flex items-center gap-3 mb-4">
          <TrendingUp className="w-5 h-5 text-blue-500" />
          <h2 className="font-semibold text-slate-800 dark:text-white">Informations Backend</h2>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
          <div className="bg-slate-50 dark:bg-slate-800 rounded-xl p-4">
            <p className="text-xs font-semibold text-slate-500 uppercase tracking-wider mb-1">API Base URL</p>
            <p className="font-mono text-xs text-slate-700 dark:text-slate-300 break-all">
              https://tiger-sudoku-tiara.ngrok-free.dev/api/v1
            </p>
          </div>
          <div className="bg-slate-50 dark:bg-slate-800 rounded-xl p-4">
            <p className="text-xs font-semibold text-slate-500 uppercase tracking-wider mb-1">Authentification</p>
            <p className="font-mono text-xs text-slate-700 dark:text-slate-300">JWT Bearer Token</p>
          </div>
          <div className="bg-slate-50 dark:bg-slate-800 rounded-xl p-4">
            <p className="text-xs font-semibold text-slate-500 uppercase tracking-wider mb-1">Rôle</p>
            <p className="font-mono text-xs text-slate-700 dark:text-slate-300">
              {admin?.user?.role ?? '—'}
            </p>
          </div>
        </div>
      </div>

      {/* Quick links */}
      <div>
        <h2 className="font-semibold text-slate-700 dark:text-slate-300 text-sm mb-4 uppercase tracking-wider">
          Accès rapide
        </h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <QuickLink to="/admin/vols"         label="Gérer les vols"         desc="Créer, modifier, supprimer"    icon={Plane}    color="blue" />
          <QuickLink to="/admin/hotels"       label="Gérer les hôtels"       desc="Tarifs, disponibilité"         icon={Hotel}    color="violet" />
          <QuickLink to="/admin/destinations" label="Gérer les destinations"  desc="Pays, descriptions, photos"   icon={MapPin}   color="emerald" />
          <QuickLink to="/admin/guides"       label="Gérer les guides"        desc="Langues, tarifs, disponibilité"icon={Compass}  color="amber" />
        </div>
      </div>
    </div>
  );
};

export default AdminDashboard;
