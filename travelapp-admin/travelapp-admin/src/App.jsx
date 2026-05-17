import React from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import AdminLogin from './components/admin/AdminLogin.jsx';
import AdminLayout from './components/admin/AdminLayout.jsx';

export default function App() {
  return (
    <Routes>
      <Route path="/admin/login" element={<AdminLogin />} />
      <Route path="/admin/*" element={<AdminLayout />} />
      <Route path="*" element={<Navigate to="/admin/login" replace />} />
    </Routes>
  );
}
