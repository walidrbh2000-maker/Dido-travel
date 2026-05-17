/**
 * Shared UI primitives for management pages.
 * CrudPage, ConfirmDialog, FormField, etc.
 */
import React, { useState } from 'react';
import { Search, Plus, Edit, Trash2, ChevronLeft, ChevronRight, X, Loader2, AlertTriangle } from 'lucide-react';

// ── Generic confirm dialog ────────────────────────────────────────────────────
export const ConfirmDialog = ({ message, onConfirm, onCancel, loading }) => (
  <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-sm">
    <div className="bg-white dark:bg-slate-900 rounded-2xl shadow-2xl max-w-sm w-full p-6 border border-slate-200 dark:border-slate-700">
      <div className="flex items-center gap-4 mb-4">
        <div className="w-12 h-12 rounded-xl bg-red-100 dark:bg-red-900/30 flex items-center justify-center">
          <AlertTriangle className="w-6 h-6 text-red-600 dark:text-red-400" />
        </div>
        <div>
          <p className="font-semibold text-slate-800 dark:text-white">Confirmation</p>
          <p className="text-sm text-slate-500 dark:text-slate-400">{message}</p>
        </div>
      </div>
      <div className="flex gap-3">
        <button
          onClick={onCancel}
          disabled={loading}
          className="flex-1 py-2.5 rounded-xl border border-slate-200 dark:border-slate-700 text-sm font-medium text-slate-600 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800 transition disabled:opacity-50"
        >
          Annuler
        </button>
        <button
          onClick={onConfirm}
          disabled={loading}
          className="flex-1 py-2.5 rounded-xl bg-red-600 hover:bg-red-700 text-white text-sm font-medium transition disabled:opacity-50 flex items-center justify-center gap-2"
        >
          {loading ? <Loader2 className="w-4 h-4 animate-spin" /> : null}
          Supprimer
        </button>
      </div>
    </div>
  </div>
);

// ── Modal wrapper ─────────────────────────────────────────────────────────────
export const Modal = ({ title, onClose, children }) => (
  <div className="fixed inset-0 z-40 flex items-start justify-center p-4 pt-16 bg-black/50 backdrop-blur-sm overflow-y-auto">
    <div className="bg-white dark:bg-slate-900 rounded-2xl shadow-2xl w-full max-w-2xl border border-slate-200 dark:border-slate-700 my-4">
      {/* Header */}
      <div className="flex items-center justify-between px-6 py-4 border-b border-slate-200 dark:border-slate-700">
        <h2 className="font-semibold text-slate-800 dark:text-white">{title}</h2>
        <button
          onClick={onClose}
          className="w-8 h-8 rounded-lg flex items-center justify-center text-slate-400 hover:text-slate-700 dark:hover:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800 transition"
        >
          <X className="w-4 h-4" />
        </button>
      </div>
      {/* Body */}
      <div className="p-6">{children}</div>
    </div>
  </div>
);

// ── Form field ────────────────────────────────────────────────────────────────
export const Field = ({ label, required, children, hint }) => (
  <div>
    <label className="block text-xs font-semibold text-slate-600 dark:text-slate-400 uppercase tracking-wider mb-1.5">
      {label} {required && <span className="text-red-500 normal-case">*</span>}
    </label>
    {children}
    {hint && <p className="text-xs text-slate-400 mt-1">{hint}</p>}
  </div>
);

export const Input = ({ className = '', ...props }) => (
  <input
    {...props}
    className={`w-full px-4 py-2.5 text-sm bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition ${className}`}
  />
);

export const Select = ({ children, className = '', ...props }) => (
  <select
    {...props}
    className={`w-full px-4 py-2.5 text-sm bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-slate-800 dark:text-white focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition ${className}`}
  >
    {children}
  </select>
);

export const Textarea = ({ className = '', ...props }) => (
  <textarea
    {...props}
    rows={3}
    className={`w-full px-4 py-2.5 text-sm bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition resize-none ${className}`}
  />
);

// ── Page header ───────────────────────────────────────────────────────────────
export const PageHeader = ({ title, subtitle, onAdd, addLabel = 'Nouveau', search, onSearch }) => (
  <div className="flex flex-col sm:flex-row sm:items-center gap-4 mb-6">
    <div className="flex-1">
      <h1 className="text-xl font-bold text-slate-800 dark:text-white">{title}</h1>
      {subtitle && <p className="text-sm text-slate-500 dark:text-slate-400 mt-0.5">{subtitle}</p>}
    </div>
    <div className="flex items-center gap-3">
      {onSearch && (
        <div className="relative">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
          <input
            type="text"
            value={search}
            onChange={(e) => onSearch(e.target.value)}
            placeholder="Rechercher…"
            className="pl-9 pr-4 py-2 text-sm bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-700 rounded-xl text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500 w-52 transition"
          />
        </div>
      )}
      {onAdd && (
        <button
          onClick={onAdd}
          className="flex items-center gap-2 px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white text-sm font-medium rounded-xl transition shadow-lg shadow-blue-600/20"
        >
          <Plus className="w-4 h-4" />
          {addLabel}
        </button>
      )}
    </div>
  </div>
);

// ── Action buttons ────────────────────────────────────────────────────────────
export const EditBtn = ({ onClick }) => (
  <button
    onClick={onClick}
    className="w-8 h-8 flex items-center justify-center rounded-lg bg-amber-50 dark:bg-amber-900/20 text-amber-600 dark:text-amber-400 hover:bg-amber-100 dark:hover:bg-amber-900/40 transition"
  >
    <Edit className="w-3.5 h-3.5" />
  </button>
);

export const DeleteBtn = ({ onClick }) => (
  <button
    onClick={onClick}
    className="w-8 h-8 flex items-center justify-center rounded-lg bg-red-50 dark:bg-red-900/20 text-red-500 dark:text-red-400 hover:bg-red-100 dark:hover:bg-red-900/40 transition"
  >
    <Trash2 className="w-3.5 h-3.5" />
  </button>
);

// ── Pagination ────────────────────────────────────────────────────────────────
export const Pagination = ({ current, total, onChange }) => {
  if (total <= 1) return null;
  const pages = Array.from({ length: Math.min(total, 7) }, (_, i) => {
    if (total <= 7) return i + 1;
    if (current <= 4) return i + 1;
    if (current >= total - 3) return total - 6 + i;
    return current - 3 + i;
  });

  return (
    <div className="flex items-center justify-center gap-1 mt-6">
      <button
        onClick={() => onChange(current - 1)}
        disabled={current === 1}
        className="w-8 h-8 flex items-center justify-center rounded-lg border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 text-slate-600 dark:text-slate-400 hover:bg-slate-50 dark:hover:bg-slate-800 disabled:opacity-40 disabled:cursor-not-allowed transition"
      >
        <ChevronLeft className="w-4 h-4" />
      </button>
      {pages.map((p) => (
        <button
          key={p}
          onClick={() => onChange(p)}
          className={`w-8 h-8 flex items-center justify-center rounded-lg text-sm font-medium transition ${
            p === current
              ? 'bg-blue-600 text-white shadow shadow-blue-600/20'
              : 'border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 text-slate-600 dark:text-slate-400 hover:bg-slate-50 dark:hover:bg-slate-800'
          }`}
        >
          {p}
        </button>
      ))}
      <button
        onClick={() => onChange(current + 1)}
        disabled={current === total}
        className="w-8 h-8 flex items-center justify-center rounded-lg border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 text-slate-600 dark:text-slate-400 hover:bg-slate-50 dark:hover:bg-slate-800 disabled:opacity-40 disabled:cursor-not-allowed transition"
      >
        <ChevronRight className="w-4 h-4" />
      </button>
    </div>
  );
};

// ── Table wrapper ─────────────────────────────────────────────────────────────
export const Table = ({ headers, children, loading, empty = 'Aucune donnée' }) => (
  <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 overflow-hidden">
    <div className="overflow-x-auto">
      <table className="w-full text-sm">
        <thead>
          <tr className="border-b border-slate-200 dark:border-slate-700">
            {headers.map((h) => (
              <th
                key={h}
                className="px-5 py-3.5 text-left text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase tracking-wider"
              >
                {h}
              </th>
            ))}
          </tr>
        </thead>
        <tbody className="divide-y divide-slate-100 dark:divide-slate-800">
          {loading ? (
            <tr>
              <td colSpan={headers.length} className="px-5 py-12 text-center">
                <Loader2 className="w-6 h-6 animate-spin text-blue-500 mx-auto" />
              </td>
            </tr>
          ) : React.Children.count(children) === 0 ? (
            <tr>
              <td
                colSpan={headers.length}
                className="px-5 py-12 text-center text-slate-400 dark:text-slate-500 text-sm"
              >
                {empty}
              </td>
            </tr>
          ) : (
            children
          )}
        </tbody>
      </table>
    </div>
  </div>
);

// ── Badge ─────────────────────────────────────────────────────────────────────
export const Badge = ({ children, color = 'slate' }) => {
  const map = {
    green:  'bg-emerald-100 dark:bg-emerald-900/30 text-emerald-700 dark:text-emerald-400',
    red:    'bg-red-100 dark:bg-red-900/30 text-red-700 dark:text-red-400',
    blue:   'bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-400',
    amber:  'bg-amber-100 dark:bg-amber-900/30 text-amber-700 dark:text-amber-400',
    slate:  'bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400',
    violet: 'bg-violet-100 dark:bg-violet-900/30 text-violet-700 dark:text-violet-400',
  };
  return (
    <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${map[color] ?? map.slate}`}>
      {children}
    </span>
  );
};

// ── Error / Toast ─────────────────────────────────────────────────────────────
export const ErrorBanner = ({ message }) =>
  message ? (
    <div className="mb-5 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 text-red-700 dark:text-red-400 text-sm rounded-xl px-4 py-3">
      ⚠️ {message}
    </div>
  ) : null;

// ── Submit button ─────────────────────────────────────────────────────────────
export const SubmitBtn = ({ loading, label = 'Enregistrer', className = '' }) => (
  <button
    type="submit"
    disabled={loading}
    className={`flex items-center justify-center gap-2 px-6 py-2.5 bg-blue-600 hover:bg-blue-700 text-white text-sm font-semibold rounded-xl transition disabled:opacity-50 disabled:cursor-not-allowed ${className}`}
  >
    {loading && <Loader2 className="w-4 h-4 animate-spin" />}
    {label}
  </button>
);
