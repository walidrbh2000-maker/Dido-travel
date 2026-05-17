import React, { useState, useEffect, useCallback } from 'react';
import { Compass } from 'lucide-react';
import adminAPI from '../../services/adminAPI.js';
import {
  PageHeader,
  Table,
  Modal,
  Field,
  Input,
  Select,
  Textarea,
  EditBtn,
  DeleteBtn,
  ConfirmDialog,
  Badge,
  Pagination,
  ErrorBanner,
  SubmitBtn,
} from './shared.jsx';

// ── Langues disponibles ───────────────────────────────────────────────────────
const LANGUES_OPTIONS = [
  { code: 'fr', label: 'Français' },
  { code: 'en', label: 'English' },
  { code: 'ar', label: 'العربية' },
  { code: 'es', label: 'Español' },
  { code: 'de', label: 'Deutsch' },
  { code: 'it', label: 'Italiano' },
  { code: 'zh', label: '中文' },
  { code: 'pt', label: 'Português' },
];

const emptyGuide = {
  nom: '',
  destination_id: '',
  langues: [],
  experience_annees: 0,
  tarif_jour: '',
  description: '',
  image: '',
  disponible: true,
};

// ── Formulaire guide ──────────────────────────────────────────────────────────
const GuideForm = ({ initial, destinations, onClose, onSaved }) => {
  const [form, setForm] = useState(
    initial?.id
      ? {
          nom: initial.nom,
          destination_id: initial.destination_id,
          // langues peut arriver comme Array ou String selon le cache Laravel
          langues: Array.isArray(initial.langues)
            ? initial.langues
            : typeof initial.langues === 'string'
            ? JSON.parse(initial.langues)
            : [],
          experience_annees: initial.experience_annees ?? 0,
          tarif_jour: initial.tarif_jour,
          description: initial.description ?? '',
          image: initial.image ?? '',
          disponible: initial.disponible,
        }
      : emptyGuide
  );
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');

  const set = (k) => (e) =>
    setForm((p) => ({
      ...p,
      [k]:
        e.target.type === 'checkbox' ? e.target.checked : e.target.value,
    }));

  const toggleLangue = (lang) => {
    setForm((p) => ({
      ...p,
      langues: p.langues.includes(lang)
        ? p.langues.filter((l) => l !== lang)
        : [...p.langues, lang],
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (form.langues.length === 0) {
      setError('Sélectionnez au moins une langue.');
      return;
    }
    setSaving(true);
    setError('');
    try {
      const payload = {
        ...form,
        tarif_jour: parseFloat(form.tarif_jour),
        experience_annees: parseInt(form.experience_annees, 10),
        destination_id: parseInt(form.destination_id, 10),
      };
      if (initial?.id) {
        await adminAPI.updateGuide(initial.id, payload);
      } else {
        await adminAPI.createGuide(payload);
      }
      onSaved();
    } catch (err) {
      setError(err.message);
    } finally {
      setSaving(false);
    }
  };

  return (
    <Modal
      title={initial?.id ? `Modifier — ${initial.nom}` : 'Nouveau guide'}
      onClose={onClose}
    >
      <ErrorBanner message={error} />
      <form onSubmit={handleSubmit} className="space-y-4">
        {/* Nom + Destination */}
        <div className="grid grid-cols-2 gap-4">
          <Field label="Nom du guide" required>
            <Input
              value={form.nom}
              onChange={set('nom')}
              placeholder="Mohamed Benali"
              required
            />
          </Field>
          <Field label="Destination" required>
            <Select
              value={form.destination_id}
              onChange={set('destination_id')}
              required
            >
              <option value="">— Choisir —</option>
              {destinations.map((d) => (
                <option key={d.id} value={d.id}>
                  {d.name}
                </option>
              ))}
            </Select>
          </Field>
        </div>

        {/* Langues */}
        <Field label="Langues parlées" required>
          <div className="flex flex-wrap gap-2 mt-1">
            {LANGUES_OPTIONS.map(({ code, label }) => (
              <button
                key={code}
                type="button"
                onClick={() => toggleLangue(code)}
                className={`px-3 py-1.5 text-xs font-semibold rounded-lg border transition-all duration-150 ${
                  form.langues.includes(code)
                    ? 'bg-blue-600 text-white border-blue-600 shadow-sm shadow-blue-600/30'
                    : 'bg-slate-50 dark:bg-slate-800 text-slate-600 dark:text-slate-300 border-slate-200 dark:border-slate-700 hover:border-blue-400 dark:hover:border-blue-500'
                }`}
              >
                {code.toUpperCase()}
                <span className="ml-1 font-normal opacity-70">
                  {label}
                </span>
              </button>
            ))}
          </div>
          {form.langues.length === 0 && (
            <p className="text-xs text-red-400 mt-1.5">
              ⚠ Sélectionnez au moins une langue
            </p>
          )}
        </Field>

        {/* Expérience + Tarif */}
        <div className="grid grid-cols-2 gap-4">
          <Field label="Expérience (années)">
            <Input
              type="number"
              min="0"
              max="50"
              value={form.experience_annees}
              onChange={set('experience_annees')}
              placeholder="5"
            />
          </Field>
          <Field label="Tarif / jour (DZD)" required>
            <Input
              type="number"
              min="0"
              step="0.01"
              value={form.tarif_jour}
              onChange={set('tarif_jour')}
              placeholder="5000"
              required
            />
          </Field>
        </div>

        {/* Description */}
        <Field label="Description">
          <Textarea
            value={form.description}
            onChange={set('description')}
            placeholder="Présentation du guide, spécialités, zones couvertes…"
          />
        </Field>

        {/* Image URL */}
        <Field label="URL de la photo">
          <Input
            value={form.image}
            onChange={set('image')}
            placeholder="https://…"
          />
        </Field>

        {/* Disponible */}
        <label className="flex items-center gap-3 cursor-pointer select-none">
          <input
            type="checkbox"
            checked={!!form.disponible}
            onChange={set('disponible')}
            className="w-4 h-4 rounded text-blue-600 focus:ring-blue-500"
          />
          <span className="text-sm text-slate-700 dark:text-slate-300 font-medium">
            Guide disponible
          </span>
        </label>

        {/* Actions */}
        <div className="flex justify-end gap-3 pt-2">
          <button
            type="button"
            onClick={onClose}
            className="px-5 py-2.5 text-sm rounded-xl border border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800 transition"
          >
            Annuler
          </button>
          <SubmitBtn
            loading={saving}
            label={initial?.id ? 'Mettre à jour' : 'Créer le guide'}
          />
        </div>
      </form>
    </Modal>
  );
};

// ── Main component ────────────────────────────────────────────────────────────
const GuideManagement = () => {
  const [items, setItems] = useState([]);
  const [destinations, setDestinations] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [search, setSearch] = useState('');
  const [filterDisponible, setFilterDisponible] = useState('all');
  const [modal, setModal] = useState(null); // null | 'create' | guideObj
  const [toDelete, setToDelete] = useState(null);
  const [deleting, setDeleting] = useState(false);
  const [page, setPage] = useState(1);
  const PER = 15;

  const load = useCallback(async () => {
    setLoading(true);
    setError('');
    try {
      const [gRes, dRes] = await Promise.all([
        adminAPI.getGuides({ per_page: 100, disponible: undefined }),
        adminAPI.getDestinations({ per_page: 100 }),
      ]);
      setItems(gRes.data ?? gRes ?? []);
      setDestinations(dRes.data ?? dRes ?? []);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    load();
  }, [load]);

  // Filtrage local
  const filtered = items.filter((g) => {
    const matchSearch =
      g.nom?.toLowerCase().includes(search.toLowerCase()) ||
      g.destination?.name?.toLowerCase().includes(search.toLowerCase());
    const matchDispo =
      filterDisponible === 'all' ||
      (filterDisponible === 'yes' && g.disponible) ||
      (filterDisponible === 'no' && !g.disponible);
    return matchSearch && matchDispo;
  });

  const totalPages = Math.ceil(filtered.length / PER);
  const slice = filtered.slice((page - 1) * PER, page * PER);

  const handleDelete = async () => {
    setDeleting(true);
    try {
      await adminAPI.deleteGuide(toDelete.id);
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
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center gap-4 mb-6">
        <div className="flex-1">
          <h1 className="text-xl font-bold text-slate-800 dark:text-white">
            Gestion des Guides
          </h1>
          <p className="text-sm text-slate-500 dark:text-slate-400 mt-0.5">
            {filtered.length} guide(s)
          </p>
        </div>
        <div className="flex items-center gap-3 flex-wrap">
          {/* Filtre disponibilité */}
          <select
            value={filterDisponible}
            onChange={(e) => {
              setFilterDisponible(e.target.value);
              setPage(1);
            }}
            className="px-3 py-2 text-sm bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-700 rounded-xl text-slate-700 dark:text-slate-300 focus:outline-none focus:ring-2 focus:ring-blue-500 transition"
          >
            <option value="all">Tous les guides</option>
            <option value="yes">Disponibles</option>
            <option value="no">Indisponibles</option>
          </select>

          <PageHeader
            title=""
            onAdd={() => setModal('create')}
            addLabel="Nouveau guide"
            search={search}
            onSearch={(v) => {
              setSearch(v);
              setPage(1);
            }}
          />
        </div>
      </div>

      <ErrorBanner message={error} />

      <Table
        headers={[
          'Guide',
          'Destination',
          'Langues',
          'Expérience',
          'Tarif / jour',
          'Statut',
          'Actions',
        ]}
        loading={loading}
        empty="Aucun guide trouvé"
      >
        {slice.map((g) => {
          const langues = Array.isArray(g.langues)
            ? g.langues
            : typeof g.langues === 'string'
            ? JSON.parse(g.langues)
            : [];

          return (
            <tr
              key={g.id}
              className="hover:bg-slate-50 dark:hover:bg-slate-800/50 transition"
            >
              {/* Nom */}
              <td className="px-5 py-3.5">
                <div className="flex items-center gap-2.5">
                  <div className="w-9 h-9 rounded-xl bg-gradient-to-br from-amber-400 to-orange-500 flex items-center justify-center flex-shrink-0">
                    <Compass className="w-4 h-4 text-white" />
                  </div>
                  <div>
                    <p className="font-semibold text-slate-800 dark:text-white text-sm">
                      {g.nom}
                    </p>
                    {g.image && (
                      <p className="text-xs text-slate-400 truncate max-w-[120px]">
                        Photo disponible
                      </p>
                    )}
                  </div>
                </div>
              </td>

              {/* Destination */}
              <td className="px-5 py-3.5 text-slate-600 dark:text-slate-300 text-sm">
                {g.destination?.name ?? '—'}
              </td>

              {/* Langues */}
              <td className="px-5 py-3.5">
                <div className="flex flex-wrap gap-1 max-w-[120px]">
                  {langues.length > 0 ? (
                    langues.map((l) => (
                      <span
                        key={l}
                        className="px-2 py-0.5 text-xs font-bold bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-400 rounded-md"
                      >
                        {l.toUpperCase()}
                      </span>
                    ))
                  ) : (
                    <span className="text-slate-400 text-xs">—</span>
                  )}
                </div>
              </td>

              {/* Expérience */}
              <td className="px-5 py-3.5 text-slate-600 dark:text-slate-400 text-sm">
                {g.experience_annees > 0
                  ? `${g.experience_annees} an${g.experience_annees > 1 ? 's' : ''}`
                  : '< 1 an'}
              </td>

              {/* Tarif */}
              <td className="px-5 py-3.5 font-semibold text-slate-800 dark:text-white text-sm whitespace-nowrap">
                {Number(g.tarif_jour).toLocaleString('fr-DZ')} DZD
              </td>

              {/* Statut */}
              <td className="px-5 py-3.5">
                <Badge color={g.disponible ? 'green' : 'red'}>
                  {g.disponible ? 'Disponible' : 'Indisponible'}
                </Badge>
              </td>

              {/* Actions */}
              <td className="px-5 py-3.5">
                <div className="flex items-center gap-1.5">
                  <EditBtn onClick={() => setModal(g)} />
                  <DeleteBtn onClick={() => setToDelete(g)} />
                </div>
              </td>
            </tr>
          );
        })}
      </Table>

      <Pagination current={page} total={totalPages} onChange={setPage} />

      {/* Modal formulaire */}
      {modal && (
        <GuideForm
          initial={modal === 'create' ? null : modal}
          destinations={destinations}
          onClose={() => setModal(null)}
          onSaved={() => {
            setModal(null);
            load();
          }}
        />
      )}

      {/* Dialog confirmation suppression */}
      {toDelete && (
        <ConfirmDialog
          message={`Supprimer le guide « ${toDelete.nom} » ? Cette action est irréversible.`}
          onConfirm={handleDelete}
          onCancel={() => setToDelete(null)}
          loading={deleting}
        />
      )}
    </div>
  );
};

export default GuideManagement;
