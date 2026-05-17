import React, { useState, useEffect, useCallback } from 'react';
import { Plane } from 'lucide-react';
import adminAPI from '../../services/adminAPI.js';
import {
  PageHeader, Table, Modal, Field, Input, Select,
  EditBtn, DeleteBtn, ConfirmDialog, Badge, Pagination,
  ErrorBanner, SubmitBtn,
} from './shared.jsx';

const CLASSES = ['economique', 'affaires', 'premiere'];
const STATUTS = ['programme', 'en_vol', 'atterri', 'annule'];

const statColor = (s) =>
  ({ programme: 'blue', en_vol: 'green', atterri: 'slate', annule: 'red' }[s] ?? 'slate');

const emptyVol = {
  compagnie: '', numero_vol: '', destination_id: '',
  date_depart: '', date_arrivee: '', prix: '',
  places_disponibles: '150', classe: 'economique', statut: 'programme',
};

// ── Form modal ────────────────────────────────────────────────────────────────
const VolForm = ({ initial, destinations, onClose, onSaved }) => {
  const [form, setForm] = useState(
    initial?.id
      ? {
          compagnie: initial.compagnie,
          numero_vol: initial.numero_vol,
          destination_id: initial.destination_id,
          date_depart: initial.date_depart?.slice(0, 16) ?? '',
          date_arrivee: initial.date_arrivee?.slice(0, 16) ?? '',
          prix: initial.prix,
          places_disponibles: initial.places_disponibles,
          classe: initial.classe,
          statut: initial.statut,
        }
      : emptyVol
  );
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');

  const set = (k) => (e) => setForm((p) => ({ ...p, [k]: e.target.value }));

  const handleSubmit = async (e) => {
    e.preventDefault();
    setSaving(true);
    setError('');
    try {
      const payload = {
        ...form,
        prix: parseFloat(form.prix),
        places_disponibles: parseInt(form.places_disponibles),
        destination_id: parseInt(form.destination_id),
      };
      if (initial?.id) {
        await adminAPI.updateVol(initial.id, payload);
      } else {
        await adminAPI.createVol(payload);
      }
      onSaved();
    } catch (err) {
      setError(err.message);
    } finally {
      setSaving(false);
    }
  };

  return (
    <Modal title={initial?.id ? 'Modifier le vol' : 'Nouveau vol'} onClose={onClose}>
      <ErrorBanner message={error} />
      <form onSubmit={handleSubmit} className="space-y-4">
        <div className="grid grid-cols-2 gap-4">
          <Field label="Compagnie" required>
            <Input value={form.compagnie} onChange={set('compagnie')} placeholder="Air Algérie" required />
          </Field>
          <Field label="N° de vol" required>
            <Input value={form.numero_vol} onChange={set('numero_vol')} placeholder="AH123" required />
          </Field>
        </div>
        <Field label="Destination" required>
          <Select value={form.destination_id} onChange={set('destination_id')} required>
            <option value="">— Choisir une destination —</option>
            {destinations.map((d) => (
              <option key={d.id} value={d.id}>{d.name} ({d.country})</option>
            ))}
          </Select>
        </Field>
        <div className="grid grid-cols-2 gap-4">
          <Field label="Départ" required>
            <Input type="datetime-local" value={form.date_depart} onChange={set('date_depart')} required />
          </Field>
          <Field label="Arrivée" required>
            <Input type="datetime-local" value={form.date_arrivee} onChange={set('date_arrivee')} required />
          </Field>
        </div>
        <div className="grid grid-cols-3 gap-4">
          <Field label="Prix (DZD)" required>
            <Input type="number" min="0" step="0.01" value={form.prix} onChange={set('prix')} placeholder="45000" required />
          </Field>
          <Field label="Places dispo" required>
            <Input type="number" min="0" value={form.places_disponibles} onChange={set('places_disponibles')} required />
          </Field>
          <Field label="Classe" required>
            <Select value={form.classe} onChange={set('classe')}>
              {CLASSES.map((c) => <option key={c} value={c}>{c}</option>)}
            </Select>
          </Field>
        </div>
        <Field label="Statut">
          <Select value={form.statut} onChange={set('statut')}>
            {STATUTS.map((s) => <option key={s} value={s}>{s}</option>)}
          </Select>
        </Field>
        <div className="flex justify-end gap-3 pt-2">
          <button type="button" onClick={onClose} className="px-5 py-2.5 text-sm rounded-xl border border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800 transition">Annuler</button>
          <SubmitBtn loading={saving} label={initial?.id ? 'Mettre à jour' : 'Créer'} />
        </div>
      </form>
    </Modal>
  );
};

// ── Main ──────────────────────────────────────────────────────────────────────
const VolManagement = () => {
  const [items, setItems] = useState([]);
  const [destinations, setDestinations] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [search, setSearch] = useState('');
  const [modal, setModal] = useState(null);
  const [toDelete, setToDelete] = useState(null);
  const [deleting, setDeleting] = useState(false);
  const [page, setPage] = useState(1);
  const PER = 15;

  const load = useCallback(async () => {
    setLoading(true);
    setError('');
    try {
      const [vRes, dRes] = await Promise.all([
        adminAPI.getVols({ per_page: 100 }),
        adminAPI.getDestinations({ per_page: 100 }),
      ]);
      setItems(vRes.data ?? vRes ?? []);
      setDestinations(dRes.data ?? dRes ?? []);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { load(); }, [load]);

  const filtered = items.filter(
    (v) =>
      v.compagnie?.toLowerCase().includes(search.toLowerCase()) ||
      v.numero_vol?.toLowerCase().includes(search.toLowerCase()) ||
      v.destination?.name?.toLowerCase().includes(search.toLowerCase())
  );

  const totalPages = Math.ceil(filtered.length / PER);
  const slice = filtered.slice((page - 1) * PER, page * PER);

  const handleDelete = async () => {
    setDeleting(true);
    try {
      await adminAPI.deleteVol(toDelete.id);
      setToDelete(null);
      load();
    } catch (err) {
      setError(err.message);
      setToDelete(null);
    } finally {
      setDeleting(false);
    }
  };

  const fmtDate = (s) =>
    s ? new Date(s).toLocaleDateString('fr-FR', { day: '2-digit', month: '2-digit', year: '2-digit', hour: '2-digit', minute: '2-digit' }) : '—';

  return (
    <div className="p-8 max-w-7xl">
      <PageHeader
        title="Gestion des Vols"
        subtitle={`${filtered.length} vol(s)`}
        onAdd={() => setModal('create')}
        addLabel="Nouveau vol"
        search={search}
        onSearch={(v) => { setSearch(v); setPage(1); }}
      />
      <ErrorBanner message={error} />
      <Table
        headers={['Vol', 'Destination', 'Départ', 'Arrivée', 'Prix', 'Places', 'Classe', 'Statut', 'Actions']}
        loading={loading}
        empty="Aucun vol"
      >
        {slice.map((v) => (
          <tr key={v.id} className="hover:bg-slate-50 dark:hover:bg-slate-800/50 transition">
            <td className="px-5 py-3.5">
              <div className="flex items-center gap-2">
                <Plane className="w-4 h-4 text-blue-500 flex-shrink-0" />
                <div>
                  <p className="font-semibold text-slate-800 dark:text-white text-xs font-mono">{v.numero_vol}</p>
                  <p className="text-xs text-slate-500">{v.compagnie}</p>
                </div>
              </div>
            </td>
            <td className="px-5 py-3.5 text-slate-700 dark:text-slate-300 text-sm">
              {v.destination?.name ?? '—'}
            </td>
            <td className="px-5 py-3.5 text-slate-600 dark:text-slate-400 text-xs whitespace-nowrap">{fmtDate(v.date_depart)}</td>
            <td className="px-5 py-3.5 text-slate-600 dark:text-slate-400 text-xs whitespace-nowrap">{fmtDate(v.date_arrivee)}</td>
            <td className="px-5 py-3.5 font-semibold text-slate-800 dark:text-white text-sm">
              {Number(v.prix).toLocaleString('fr-DZ')} DZD
            </td>
            <td className="px-5 py-3.5 text-slate-600 dark:text-slate-400 text-sm">{v.places_disponibles}</td>
            <td className="px-5 py-3.5">
              <Badge color={{ economique: 'slate', affaires: 'blue', premiere: 'violet' }[v.classe] ?? 'slate'}>
                {v.classe}
              </Badge>
            </td>
            <td className="px-5 py-3.5">
              <Badge color={statColor(v.statut)}>{v.statut}</Badge>
            </td>
            <td className="px-5 py-3.5">
              <div className="flex items-center gap-1.5">
                <EditBtn onClick={() => setModal(v)} />
                <DeleteBtn onClick={() => setToDelete(v)} />
              </div>
            </td>
          </tr>
        ))}
      </Table>
      <Pagination current={page} total={totalPages} onChange={setPage} />

      {modal && (
        <VolForm
          initial={modal === 'create' ? null : modal}
          destinations={destinations}
          onClose={() => setModal(null)}
          onSaved={() => { setModal(null); load(); }}
        />
      )}
      {toDelete && (
        <ConfirmDialog
          message={`Supprimer le vol ${toDelete.numero_vol} ?`}
          onConfirm={handleDelete}
          onCancel={() => setToDelete(null)}
          loading={deleting}
        />
      )}
    </div>
  );
};

export default VolManagement;
