import React, { useState, useEffect, useCallback } from 'react';
import adminAPI from '../../services/adminAPI.js';
import {
  PageHeader, Table, Modal, Field, Input, Textarea, Select,
  EditBtn, DeleteBtn, ConfirmDialog, Badge, Pagination,
  ErrorBanner, SubmitBtn,
} from './shared.jsx';

// ── Form default ──────────────────────────────────────────────────────────────
const empty = { name: '', country: '', description: '', is_popular: false };

// ── Destination form modal ────────────────────────────────────────────────────
const DestinationForm = ({ initial, onClose, onSaved }) => {
  const [form, setForm] = useState(initial ?? empty);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');

  const set = (k) => (e) =>
    setForm((p) => ({ ...p, [k]: e.target.type === 'checkbox' ? e.target.checked : e.target.value }));

  const handleSubmit = async (e) => {
    e.preventDefault();
    setSaving(true);
    setError('');
    try {
      if (initial?.id) {
        await adminAPI.updateDestination(initial.id, form);
      } else {
        await adminAPI.createDestination(form);
      }
      onSaved();
    } catch (err) {
      setError(err.message);
    } finally {
      setSaving(false);
    }
  };

  return (
    <Modal title={initial?.id ? 'Modifier la destination' : 'Nouvelle destination'} onClose={onClose}>
      <ErrorBanner message={error} />
      <form onSubmit={handleSubmit} className="space-y-4">
        <div className="grid grid-cols-2 gap-4">
          <Field label="Nom" required>
            <Input value={form.name} onChange={set('name')} placeholder="Paris" required />
          </Field>
          <Field label="Pays" required>
            <Input value={form.country} onChange={set('country')} placeholder="France" required />
          </Field>
        </div>
        <Field label="Description">
          <Textarea value={form.description ?? ''} onChange={set('description')} placeholder="Décrivez cette destination…" />
        </Field>
        <Field label="Image URL">
          <Input value={form.image ?? ''} onChange={set('image')} placeholder="https://…" />
        </Field>
        <label className="flex items-center gap-3 cursor-pointer">
          <input
            type="checkbox"
            checked={!!form.is_popular}
            onChange={set('is_popular')}
            className="w-4 h-4 rounded text-blue-600"
          />
          <span className="text-sm text-slate-700 dark:text-slate-300 font-medium">Destination populaire</span>
        </label>
        <div className="flex justify-end gap-3 pt-2">
          <button type="button" onClick={onClose} className="px-5 py-2.5 text-sm rounded-xl border border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800 transition">
            Annuler
          </button>
          <SubmitBtn loading={saving} label={initial?.id ? 'Mettre à jour' : 'Créer'} />
        </div>
      </form>
    </Modal>
  );
};

// ── Main ──────────────────────────────────────────────────────────────────────
const DestinationManagement = () => {
  const [items, setItems] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [search, setSearch] = useState('');
  const [modal, setModal] = useState(null);         // null | 'create' | row
  const [toDelete, setToDelete] = useState(null);
  const [deleting, setDeleting] = useState(false);
  const [page, setPage] = useState(1);
  const PER = 15;

  const load = useCallback(async () => {
    setLoading(true);
    setError('');
    try {
      const res = await adminAPI.getDestinations({ per_page: 100 });
      setItems(res.data ?? res ?? []);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { load(); }, [load]);

  const filtered = items.filter(
    (d) =>
      d.name?.toLowerCase().includes(search.toLowerCase()) ||
      d.country?.toLowerCase().includes(search.toLowerCase())
  );

  const totalPages = Math.ceil(filtered.length / PER);
  const slice = filtered.slice((page - 1) * PER, page * PER);

  const handleDelete = async () => {
    setDeleting(true);
    try {
      await adminAPI.deleteDestination(toDelete.id);
      setToDelete(null);
      load();
    } catch (err) {
      setError(err.message);
      setToDelete(null);
    } finally {
      setDeleting(false);
    }
  };

  return (
    <div className="p-8 max-w-7xl">
      <PageHeader
        title="Destinations"
        subtitle={`${filtered.length} destination(s)`}
        onAdd={() => setModal('create')}
        addLabel="Nouvelle destination"
        search={search}
        onSearch={(v) => { setSearch(v); setPage(1); }}
      />
      <ErrorBanner message={error} />
      <Table
        headers={['Destination', 'Pays', 'Populaire', 'Description', 'Actions']}
        loading={loading}
        empty="Aucune destination"
      >
        {slice.map((d) => (
          <tr key={d.id} className="hover:bg-slate-50 dark:hover:bg-slate-800/50 transition">
            <td className="px-5 py-3.5 font-medium text-slate-800 dark:text-white">{d.name}</td>
            <td className="px-5 py-3.5 text-slate-600 dark:text-slate-300">{d.country}</td>
            <td className="px-5 py-3.5">
              <Badge color={d.is_popular ? 'blue' : 'slate'}>{d.is_popular ? 'Oui' : 'Non'}</Badge>
            </td>
            <td className="px-5 py-3.5 text-slate-500 dark:text-slate-400 max-w-xs truncate text-xs">
              {d.description ?? '—'}
            </td>
            <td className="px-5 py-3.5">
              <div className="flex items-center gap-1.5">
                <EditBtn onClick={() => setModal(d)} />
                <DeleteBtn onClick={() => setToDelete(d)} />
              </div>
            </td>
          </tr>
        ))}
      </Table>
      <Pagination current={page} total={totalPages} onChange={setPage} />

      {modal && (
        <DestinationForm
          initial={modal === 'create' ? null : modal}
          onClose={() => setModal(null)}
          onSaved={() => { setModal(null); load(); }}
        />
      )}

      {toDelete && (
        <ConfirmDialog
          message={`Supprimer « ${toDelete.name} » ?`}
          onConfirm={handleDelete}
          onCancel={() => setToDelete(null)}
          loading={deleting}
        />
      )}
    </div>
  );
};

export default DestinationManagement;
