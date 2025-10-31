# 📦 InvySync

InvySync is een cross-platform inventarisbeheerplatform, met een focus op zowel mobiele als embedded toepassingen. Het combineert een Flutter-app voor iOS en Android met ondersteunende systemen voor data-analyse, automatisering en integratie met externe hardware (zoals Raspberry Pi).

## ✨ Doel

InvySync is ontworpen om een eenvoudige, betrouwbare en uitbreidbare oplossing te bieden voor het beheren van voorraden, met een duidelijke en logische structuur.

## 🔑 Kernfunctionaliteit

- **Voorraadbeheer**: Voeg producten toe, beheer hoeveelheden en houd wijzigingen in de inventaris nauwkeurig bij.
- **Cross-Platform Mobiel**: Gebouwd met Flutter voor native ervaringen op iOS en Android.
- **Hardware-Integratie**: Voorbereid op koppelingen met externe hardware (zoals Raspberry Pi) voor geautomatiseerde of fysieke inventarisoplossingen.
- **API-Koppelingen**: Klaar voor integratie met externe API-endpoints voor datasynchronisatie en -uitwisseling.

## 🧱 Multi-Component Structuur

Dit project hanteert een overzichtelijke componentstructuur:

| Component              | Beschrijving                                                                 |
|------------------------|------------------------------------------------------------------------------|
| `app/`                 | De hoofdmap voor de Flutter mobiele applicatie (iOS/Android).                |
| `test/`                | Locatie voor alle testbestanden en -scripts (Unit, Widget en Integratie).    |
| `lib/`                 | Gedeelde bibliotheken en code die door meerdere onderdelen van het platform gebruikt kunnen worden. |
| Configuratiebestanden  | Belangrijke configuratie zoals `pubspec.yaml`, `CMakeLists`, en build scripts. |

## 🛠 Installatie (Voor Ontwikkelaars)

### Vereisten

Zorg ervoor dat de volgende tools zijn geïnstalleerd en geconfigureerd:
- Flutter SDK (Versie 3.x of hoger aanbevolen)
- Dart SDK
- Een code-editor (bijv. VS Code of Android Studio) met de Flutter/Dart-plugins
- Gekoppelde Android- of iOS-emulator/fysiek apparaat

### Stappen

1. **Kloon de Repository**

```bash
git clone https://github.com/Mats-dev/InvySync.git
cd invysync/app
```

2. **Haal Afhankelijkheden Op**

```bash
flutter pub get
```

3. **Voer de App Uit**

```bash
flutter run
```

> (Optioneel: Voor Raspberry Pi-integratie, zie de documentatie in de `hardware/` map.)

## 🚀 Gebruik

### Basisinventarisbeheer

- **Login/Registratie**: Start de app en log in op uw InvySync-account.
- **Product Toevoegen**: Ga naar het tabblad "Inventaris" en gebruik de + knop om een nieuw product aan de voorraad toe te voegen (naam, SKU, initiële hoeveelheid).
- **Voorraad Updaten**: Selecteer een product en gebruik de +/- knoppen om de hoeveelheid snel aan te passen. Alle wijzigingen worden automatisch bijgehouden in het logboek.

### Embedded Koppeling

Voor geavanceerd gebruik met embedded hardware:
- Zorg ervoor dat de Raspberry Pi-service (of andere embedded client) draait en verbonden is met hetzelfde netwerk.
- Configureer de API-endpoint in de instellingen van de mobiele app.
- De app zal nu real-time voorraadupdates ontvangen van de geautomatiseerde systemen.

## 🤝 Bijdragen

Bijdragen zijn welkom! Raadpleeg `CONTRIBUTING.md` (wordt later toegevoegd) voor richtlijnen over het indienen van pull-requests.
