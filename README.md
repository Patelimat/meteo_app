# Application de Météo

Cette application permet d'afficher la météo actuelle ainsi que des prévisions horaires en fonction des coordonnées (latitude et longitude) entrées. Vous pouvez également sélectionner un intervalle de temps pour raffiner la récupération des données horaires.

## Installation

1. **Cloner le dépôt :**
   ```sh
   git clone https://github.com/Patelimat/meteo_app.git
   cd meteo_app
   ```

2. **Installer les dépendances Flutter :**
   ```sh
   flutter pub get
   ```

3. **Exécuter l'application :**

   ```sh
   flutter run -d chrome
   ```

## Utilisation de l'application

- **Coordonnées :**  
  Saisissez la latitude et la longitude dans les champs prévus. Par défaut, certaines coordonnées (ex. Paris) sont renseignées.  
  Cliquez sur le bouton "Obtenir la météo" pour récupérer les données depuis l'API.

- **Sélection de l'intervalle de temps :**  
  Utilisez le widget de sélection d'intervalle pour définir une date de début et une datede fin (avec, pour la date de début, une limite imposée à 1 jours avant la date actuelle et 1 jour après la date actuelle).  

- **Affichage :**  
  La page affiche en haut la température actuelle, suivie des détails (température ressentie, humidité, vent, précipitations et couverture nuageuse) et en dessous, les données horaires sont mises en forme  de façon responsives.

## Dépendances utilisées et raisons de ces choix

- **Flutter & Dart :**  
  Choisis pour leur rapidité de développement et la possibilité de créer une application multiplateforme (mobile, web).

- **http :**  
  Utilisé pour effectuer des requêtes réseau vers l'API [Open-Meteo](https://open-meteo.com) afin de récupérer les données météorologiques au format JSON.

- **intl :**  
  Nécessaire pour le formatage des dates en français (exemple : `dd MMMM yyyy, HH:mm`). Cela permet de présenter les dates de façon localisée et conviviale.

- **Widgets personnalisés (TimeInterval, Detailweather, HourlyDetail, Coordinates) :**  
  La modularisation du code en widgets permet une meilleure réutilisabilité et une maintenance facilitée. Chaque widget est spécialisé dans une partie de l’interface (par exemple la gestion des dates, l’affichage des détails météo, etc.).