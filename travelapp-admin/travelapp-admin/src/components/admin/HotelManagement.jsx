import React, { useState, useEffect, useCallback } from 'react';
import { Hotel, Star } from 'lucide-react';
import adminAPI from '../../services/adminAPI.js';
import {
  PageHeader, Table, Modal, Field, Input, Select, Textarea,
  EditBtn, DeleteBtn, ConfirmDialog, Badge, Pagination,
  ErrorBanner, SubmitBtn,
} from './shared.jsx';

const emptyHotel = {
  nom: '', destination_id: '', etoiles: 3, prix_nuit: '',
  adresse: '', description: '', amenities: '', disponible: true,
};

// ── Form ──────────────────────────────────────────────────────────────────────
const HotelForm = ({ initial, destinations, onClose, onSaved }) => {
  const [form, setForm] = useState(
    initial?.id
      ? {
          nom: initial.nom, destination_id: initial.destination_id,
          etoiles: initial.etoiles, prix_nuit: initial.prix_nuit,
          adresse: initial.adresse, description: initial.description ?? '',
          amenities: initial.amenities ?? '', disponible: initial.disponible,
        }
      : emptyHotel
  );
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');

  const set = (k) => (e) =>
    setForm((p) => ({ ...p, [k]: e.target.type === 'checkbox' ? e.target.checked : e.target.value }));

  const handleSubmit = async (e) => {
    e.preventDefault();
    setSaving(true);
    setError('');
    try {
      const payload = {
        ...form,
        prix_nuit: parseFloat(form.prix_nuit),
        etoiles: parseInt(form.etoiles),
        destination_id: parseInt(form.destination_id),
      };
      if (initial?.id) {
        await adminAPI.updateHotel(initial.id, payload);
      } else {
        await adminAPI.createHotel(payload);
      }
      onSaved();
    } catch (err) {
      setError(err.message);
    } finally {
      setSaving(false);
    }
  };

  return (
    <Modal title={initial?.id ? `Modifier ${initial.nom}` : 'Nouvel hôtel'} onClose={onClose}>
      <ErrorBanner message={error} />
      <form onSubmit={handleSubmit} className="space-y-4">
        <div className="grid grid-cols-2 gap-4">
          <Field label="Nom de l'hôtel" required>
            <Input value={form.nom} onChange={set('nom')} placeholder="Sofitel Alger" required />
          </Field>
          <Field label="Destination" required>
            <Select value={form.destination_id} onChange={set('destination_id')} required>
              <option value="">— Choisir —</option>
              {destinations.map((d) => (
                <option key={d.id} value={d.id}>{d.name}</option>
              ))}
            </Select>
          </Field>
        </div>
        <div className="grid grid-cols-2 gap-4">
          <Field label="Étoiles" required>
            <Select value={form.etoiles} onChange={set('etoiles')}>
              {[1,2,3,4,5].map((n) => <option key={n} value={n}>{n} étoile{n > 1 ? 's' : ''}</option>)}
            </Select>
          </Field>
          <Field label="Prix/nuit (DZD)" required>
            <Input type="number" min="0" step="0.01" value={form.prix_nuit} onChange={set('prix_nuit')} placeholder="8000" required />
          </Field>
        </div>
        <Field label="Adresse" required>
          <Input value={form.adresse} onChange={set('adresse')} placeholder="12 Rue Didouche Mourad, Alger" required />
        </Field>
        <Field label="Description">
          <Textarea value={form.description} onChange={set('description')} placeholder="Description de l'hôtel…" />
        </Field>
        <Field label="Équipements (séparés par virgule)" hint="Ex: WiFi,Piscine,Restaurant,Spa">
          <Input value={form.amenities} onChange={set('amenities')} placeholder="WiFi,Piscine,Restaurant" />
        </Field>
        <label className="flex items-center gap-3 cursor-pointer">
          <input
            type="checkbox"
            checked={!!form.disponible}
            onChange={set('disponible')}
            className="w-4 h-4 rounded text-blue-600"
          />
          <span className="text-sm text-slate-700 dark:text-slate-300 font-medium">Disponible</span>
        </label>
        <div className="flex justify-end gap-3 pt-2">
          <button type="button" onClick={onClose} className="px-5 py-2.5 text-sm rounded-xl border border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800 transition">Annuler</button>
          <SubmitBtn loading={saving} label={initial?.id ? 'Mettre à jour' : 'Créer'} />
        </div>
      </form>
    </Modal>
  );
};

// ── Stars display ─────────────────────────────────────────────────────────────
const Stars = ({ count }) => (
  <span className="flex items-center gap-0.5 text-amber-400">
    {Array.from({ length: Number(count) }).map((_, i) => (
      <Star key={i} className="w-3 h-3 fill-current" />
    ))}
  </span>
);

// ── Main ──────────────────────────────────────────────────────────────────────
const HotelManagement = () => {
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
      const [hRes, dRes] = await Promise.all([
        adminAPI.getHotels({ per_page: 100 }),
        adminAPI.getDestinations({ per_page: 100 }),
      ]);
      setItems(hRes.data ?? hRes ?? []);
      setDestinations(dRes.data ?? dRes ?? []);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { load(); }, [load]);

  const filtered = items.filter(
    (h) =>
      h.nom?.toLowerCase().includes(search.toLowerCase()) ||
      h.destination?.name?.toLowerCase().includes(search.toLowerCase())
  );
  const totalPages = Math.ceil(filtered.length / PER);
  const slice = filtered.slice((page - 1) * PER, page * PER);

  const handleDelete = async () => {
    setDeleting(true);
    try {
      await adminAPI.deleteHotel(toDelete.id);
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
        title="Gestion des Hôtels"
        subtitle={`${filtered.length} hôtel(s)`}
        onAdd={() => setModal('create')}
        addLabel="Nouvel hôtel"
        search={search}
        onSearch={(v) => { setSearch(v); setPage(1); }}
      />
      <ErrorBanner message={error} />
      <Table
        headers={['Hôtel', 'Destination', 'Étoiles', 'Prix/nuit', 'Équipements', 'Statut', 'Actions']}
        loading={loading}
        empty="Aucun hôtel"
      >
        {slice.map((h) => (
          <tr key={h.id} className="hover:bg-slate-50 dark:hover:bg-slate-800/50 transition">
            <td className="px-5 py-3.5">
              <div className="flex items-center gap-2">
                <Hotel className="w-4 h-4 text-violet-500 flex-shrink-0" />
                <p className="font-medium text-slate-800 dark:text-white text-sm">{h.nom}</p>
              </div>
            </td>
            <td className="px-5 py-3.5 text-slate-600 dark:text-slate-300 text-sm">
              {h.destination?.name ?? '—'}
            </td>
            <td className="px-5 py-3.5"><Stars count={h.etoiles} /></td>
            <td className="px-5 py-3.5 font-semibold text-slate-800 dark:text-white text-sm">
              {Number(h.prix_nuit).toLocaleString('fr-DZ')} DZD
            </td>
            <td className="px-5 py-3.5 text-slate-500 dark:text-slate-400 text-xs max-w-xs truncate">
              {h.amenities ?? '—'}
            </td>
            <td className="px-5 py-3.5">
              <Badge color={h.disponible ? 'green' : 'red'}>
                {h.disponible ? 'Disponible' : 'Indisponible'}
              </Badge>
            </td>
            <td className="px-5 py-3.5">
              <div className="flex items-center gap-1.5">
                <EditBtn onClick={() => setModal(h)} />
                <DeleteBtn onClick={() => setToDelete(h)} />
              </div>
            </td>
          </tr>
        ))}
      </Table>
      <Pagination current={page} total={totalPages} onChange={setPage} />

      {modal && (
        <HotelForm
          initial={modal === 'create' ? null : modal}
          destinations={destinations}
          onClose={() => setModal(null)}
          onSaved={() => { setModal(null); load(); }}
        />
      )}
      {toDelete && (
        <ConfirmDialog
          message={`Supprimer l'hôtel « ${toDelete.nom} » ?`}
          onConfirm={handleDelete}
          onCancel={() => setToDelete(null)}
          loading={deleting}
        />
      )}
    </div>
  );
};

export default HotelManagement;
