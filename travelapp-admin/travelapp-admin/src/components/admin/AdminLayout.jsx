import React, { useState, useEffect } from 'react';
import { Routes, Route, Link, Navigate, useNavigate, useLocation } from 'react-router-dom';
import {
  LayoutDashboard,
  Plane,
  Hotel,
  MapPin,
  Users2,
  Calendar,
  LogOut,
  Menu,
  X,
  ChevronRight,
  Compass,
} from 'lucide-react';
import { useAdmin } from '../../AdminContext.jsx';
import ThemeToggle from '../ThemeToggle.jsx';

import AdminDashboard from './AdminDashboard.jsx';
import VolManagement from './VolManagement.jsx';
import HotelManagement from './HotelManagement.jsx';
import DestinationManagement from './DestinationManagement.jsx';
import GuideManagement from './GuideManagement.jsx';
import ReservationManagement from './ReservationManagement.jsx';

const NAV = [
  { id: 'dashboard',    label: 'Dashboard',     icon: LayoutDashboard, path: '/admin/dashboard' },
  { id: 'vols',         label: 'Vols',           icon: Plane,           path: '/admin/vols' },
  { id: 'hotels',       label: 'Hôtels',         icon: Hotel,           path: '/admin/hotels' },
  { id: 'destinations', label: 'Destinations',   icon: MapPin,          path: '/admin/destinations' },
  { id: 'guides',       label: 'Guides',         icon: Compass,         path: '/admin/guides' },
  { id: 'reservations', label: 'Réservations',   icon: Calendar,        path: '/admin/reservations' },
];

const AdminLayout = () => {
  const { admin, adminLogout, initializing } = useAdmin();
  const navigate = useNavigate();
  const location = useLocation();
  const [collapsed, setCollapsed] = useState(false);
  const [loggingOut, setLoggingOut] = useState(false);

  useEffect(() => {
    if (!initializing && !admin) {
      navigate('/admin/login', { replace: true });
    }
  }, [admin, initializing, navigate]);

  if (initializing) {
    return (
      <div className="flex h-screen items-center justify-center bg-slate-100 dark:bg-slate-900">
        <div className="w-8 h-8 border-4 border-blue-600 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  if (!admin) return null;

  const handleLogout = async () => {
    setLoggingOut(true);
    await adminLogout();
    navigate('/admin/login', { replace: true });
  };

  const isActive = (path) => location.pathname === path;

  return (
    <div className="flex h-screen bg-slate-100 dark:bg-slate-950 overflow-hidden">
      {/* ── Sidebar ──────────────────────────────────────────────────────────── */}
      <aside
        className={`flex flex-col bg-white dark:bg-slate-900 border-r border-slate-200 dark:border-slate-800 transition-all duration-300 ${
          collapsed ? 'w-16' : 'w-60'
        }`}
      >
        {/* Logo */}
        <div className="flex items-center gap-3 px-4 h-16 border-b border-slate-200 dark:border-slate-800">
          <div className="flex-shrink-0 w-8 h-8 bg-gradient-to-br from-blue-600 to-indigo-600 rounded-lg flex items-center justify-center">
            <Plane className="w-4 h-4 text-white" />
          </div>
          {!collapsed && (
            <span className="font-bold text-slate-800 dark:text-white text-sm tracking-tight truncate">
              TravelApp Admin
            </span>
          )}
          <button
            onClick={() => setCollapsed((c) => !c)}
            className="ml-auto text-slate-400 hover:text-slate-700 dark:hover:text-slate-200 transition"
          >
            {collapsed ? <Menu className="w-4 h-4" /> : <X className="w-4 h-4" />}
          </button>
        </div>

        {/* User info */}
        {!collapsed && (
          <div className="px-4 py-4 border-b border-slate-200 dark:border-slate-800">
            <div className="flex items-center gap-3">
              <div className="w-9 h-9 rounded-xl bg-gradient-to-br from-blue-500 to-indigo-600 flex items-center justify-center text-white font-bold text-sm flex-shrink-0">
                {admin.user?.name?.[0]?.toUpperCase() ?? 'A'}
              </div>
              <div className="min-w-0">
                <p className="text-sm font-semibold text-slate-800 dark:text-white truncate">
                  {admin.user?.name ?? 'Admin'}
                </p>
                <p className="text-xs text-blue-500 font-medium truncate">
                  {admin.user?.email ?? ''}
                </p>
              </div>
            </div>
          </div>
        )}

        {/* Nav */}
        <nav className="flex-1 px-2 py-4 space-y-1 overflow-y-auto">
          {NAV.map((item) => {
            const Icon = item.icon;
            const active = isActive(item.path);
            return (
              <Link
                key={item.id}
                to={item.path}
                title={collapsed ? item.label : undefined}
                className={`flex items-center gap-3 px-3 py-2.5 rounded-xl transition-all duration-150 group ${
                  active
                    ? 'bg-blue-600 text-white shadow-lg shadow-blue-600/20'
                    : 'text-slate-600 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 hover:text-slate-900 dark:hover:text-white'
                }`}
              >
                <Icon className={`w-4 h-4 flex-shrink-0 ${active ? 'text-white' : ''}`} />
                {!collapsed && (
                  <>
                    <span className="text-sm font-medium flex-1 truncate">{item.label}</span>
                    {active && <ChevronRight className="w-3 h-3 opacity-70" />}
                  </>
                )}
              </Link>
            );
          })}
        </nav>

        {/* Footer */}
        <div className="px-2 py-4 border-t border-slate-200 dark:border-slate-800 space-y-2">
          {!collapsed && (
            <div className="flex items-center justify-between px-3 py-2">
              <span className="text-xs text-slate-500 dark:text-slate-400">Thème</span>
              <ThemeToggle />
            </div>
          )}
          <button
            onClick={handleLogout}
            disabled={loggingOut}
            title={collapsed ? 'Déconnexion' : undefined}
            className="w-full flex items-center gap-3 px-3 py-2.5 rounded-xl text-red-500 hover:bg-red-50 dark:hover:bg-red-900/20 transition-all duration-150 disabled:opacity-50"
          >
            <LogOut className="w-4 h-4 flex-shrink-0" />
            {!collapsed && (
              <span className="text-sm font-medium">
                {loggingOut ? 'Déconnexion…' : 'Déconnexion'}
              </span>
            )}
          </button>
        </div>
      </aside>

      {/* ── Main content ──────────────────────────────────────────────────────── */}
      <main className="flex-1 overflow-y-auto">
        <Routes>
          <Route path="dashboard"    element={<AdminDashboard />} />
          <Route path="vols"         element={<VolManagement />} />
          <Route path="hotels"       element={<HotelManagement />} />
          <Route path="destinations" element={<DestinationManagement />} />
          <Route path="guides"       element={<GuideManagement />} />
          <Route path="reservations" element={<ReservationManagement />} />
          <Route path="*"            element={<Navigate to="/admin/dashboard" replace />} />
        </Routes>
      </main>
    </div>
  );
};

export default AdminLayout;
