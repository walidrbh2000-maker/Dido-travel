<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ticket - {{ $reservation->reference }}</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Helvetica', sans-serif; color: #333; }
        .ticket {
            max-width: 800px;
            margin: 20px auto;
            border: 2px solid #1a56db;
            border-radius: 12px;
            overflow: hidden;
        }
        .header {
            background: linear-gradient(135deg, #1a56db, #3b82f6);
            color: white;
            padding: 24px 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header h1 { font-size: 24px; }
        .header .ref { font-size: 14px; opacity: 0.9; }
        .body { padding: 32px; }
        .section { margin-bottom: 24px; }
        .section-title {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #6b7280;
            margin-bottom: 8px;
        }
        .grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }
        .field-label { font-size: 12px; color: #9ca3af; }
        .field-value { font-size: 16px; font-weight: 600; color: #111827; }
        .divider {
            border: none;
            border-top: 1px dashed #d1d5db;
            margin: 20px 0;
        }
        .flight-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 0;
        }
        .flight-route { text-align: center; }
        .flight-route .city { font-size: 20px; font-weight: 700; }
        .flight-route .time { font-size: 14px; color: #6b7280; }
        .flight-arrow { font-size: 24px; color: #1a56db; }
        .footer {
            background: #f9fafb;
            padding: 16px 32px;
            text-align: center;
            font-size: 12px;
            color: #9ca3af;
        }
    </style>
</head>
<body>
    <div class="ticket">
        <div class="header">
            <div>
                <h1>TravelApp</h1>
                <div class="ref">Billet de réservation</div>
            </div>
            <div style="text-align: right;">
                <div style="font-size: 18px; font-weight: 700;">{{ $reservation->reference }}</div>
                <div class="ref">{{ $reservation->created_at->format('d/m/Y') }}</div>
            </div>
        </div>

        <div class="body">
            <div class="section">
                <div class="section-title">Passager</div>
                <div class="field-value">{{ $reservation->user->name }}</div>
                <div class="field-label">{{ $reservation->user->email }}</div>
            </div>

            <hr class="divider">

            <div class="section">
                <div class="section-title">Vol</div>
                <div class="flight-info">
                    <div class="flight-route">
                        <div class="city">{{ $reservation->vol->destination->name }}</div>
                        <div class="time">{{ $reservation->vol->date_depart->format('H:i') }}</div>
                    </div>
                    <div class="flight-arrow">&#9992;</div>
                    <div class="flight-route">
                        <div class="city">{{ $reservation->vol->destination->country }}</div>
                        <div class="time">{{ $reservation->vol->date_arrivee->format('H:i') }}</div>
                    </div>
                </div>
                <div class="grid">
                    <div>
                        <div class="field-label">Compagnie</div>
                        <div class="field-value">{{ $reservation->vol->compagnie }}</div>
                    </div>
                    <div>
                        <div class="field-label">N° de vol</div>
                        <div class="field-value">{{ $reservation->vol->numero_vol }}</div>
                    </div>
                    <div>
                        <div class="field-label">Date</div>
                        <div class="field-value">{{ $reservation->vol->date_depart->format('d M Y') }}</div>
                    </div>
                    <div>
                        <div class="field-label">Classe</div>
                        <div class="field-value">{{ ucfirst($reservation->vol->classe) }}</div>
                    </div>
                </div>
            </div>

            @if($reservation->hotel)
            <hr class="divider">
            <div class="section">
                <div class="section-title">Hébergement</div>
                <div class="grid">
                    <div>
                        <div class="field-label">Hôtel</div>
                        <div class="field-value">{{ $reservation->hotel->nom }}</div>
                    </div>
                    <div>
                        <div class="field-label">Étoiles</div>
                        <div class="field-value">{{ str_repeat('★', $reservation->hotel->etoiles) }}</div>
                    </div>
                    <div>
                        <div class="field-label">Du</div>
                        <div class="field-value">{{ $reservation->date_debut->format('d M Y') }}</div>
                    </div>
                    <div>
                        <div class="field-label">Au</div>
                        <div class="field-value">{{ $reservation->date_fin->format('d M Y') }}</div>
                    </div>
                </div>
            </div>
            @endif

            <hr class="divider">

            <div class="section">
                <div class="grid">
                    <div>
                        <div class="field-label">Nombre de personnes</div>
                        <div class="field-value">{{ $reservation->nombre_personnes }}</div>
                    </div>
                    <div>
                        <div class="field-label">Prix total</div>
                        <div class="field-value" style="color: #1a56db; font-size: 20px;">{{ number_format($reservation->prix_total, 2) }} €</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="footer">
            TravelApp — Billet généré le {{ now()->format('d/m/Y à H:i') }} — Statut : {{ ucfirst($reservation->statut) }}
        </div>
    </div>
</body>
</html>
