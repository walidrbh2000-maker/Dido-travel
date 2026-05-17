import React, { createContext, useContext, useState, useEffect } from 'react';
import adminAPI from './services/adminAPI.js';

const AdminContext = createContext();

export const useAdmin = () => {
  const ctx = useContext(AdminContext);
  if (!ctx) throw new Error('useAdmin must be used within AdminProvider');
  return ctx;
};

export const AdminProvider = ({ children }) => {
  const [admin, setAdmin] = useState(null);
  const [loading, setLoading] = useState(false);
  // true pendant la vérification initiale de la session
  const [initializing, setInitializing] = useState(true);

  // ── Restaurer la session au chargement ─────────────────────────────────────
  useEffect(() => {
    const raw = localStorage.getItem('admin_session');
    if (raw) {
      try {
        const session = JSON.parse(raw);
        // session = { token, user }
        setAdmin(session);
      } catch {
        localStorage.removeItem('admin_session');
      }
    }
    setInitializing(false);
  }, []);

  // ── Connexion ──────────────────────────────────────────────────────────────
  const adminLogin = async (email, password) => {
    setLoading(true);
    try {
      const data = await adminAPI.login(email, password);
      // data = { message, user, token }
      const session = { token: data.token, user: data.user };
      setAdmin(session);
      localStorage.setItem('admin_session', JSON.stringify(session));
      return session;
    } finally {
      setLoading(false);
    }
  };

  // ── Déconnexion ────────────────────────────────────────────────────────────
  const adminLogout = async () => {
    setLoading(true);
    try {
      await adminAPI.logout();
    } catch {
      // ignorer
    } finally {
      setAdmin(null);
      localStorage.removeItem('admin_session');
      setLoading(false);
    }
  };

  return (
    <AdminContext.Provider
      value={{ admin, adminLogin, adminLogout, loading, initializing }}
    >
      {children}
    </AdminContext.Provider>
  );
};
