# PowerGain-GUI-Powershell

==================================================

ENGLISH

PowerGain-GUI
A PowerShell GUI for mp3gain.exe, created with help from ChatGPT.

I created this GUI because my copy of MP3Gain GUI stopped working, even after I downloaded it again. This is the result of that effort, with help from ChatGPT.

Tested with mp3gain.exe, version 1.5.0.2 (source [sourceforge - MP3GAIN](https://sourceforge.net/projects/mp3gain/))

PowerGain-GUI lets you:
- Add individual or multiple MP3 files, or scan a folder and its subfolders; remove selected files or clear the list.
- Analyze tracks and albums; apply track or album gain; undo gain changes; apply constant or per-channel gain; measure maximum amplitude; and check, delete, or recalculate MP3Gain tags.
- Analyze or apply album gain one folder at a time. This option is enabled by default. When files are selected, all MP3s already listed from folders containing selected files are included. With no selection, all listed files are grouped by folder. Uncheck the option to treat the selection—or the entire list when nothing is selected—as one album.
- Set a target volume from 75 to 95 dB; the default is 89 dB. Clipping prevention is enabled by default for track and album gain.
- View per-file results: estimated volume, track and album gain, maximum amplitude, MP3 gain steps, predicted clipping risk after track gain, and file status. The clipping column does not indicate clipping already present in the file.
- Follow operations in the progress bar and file-status column. Cancel a running operation while keeping the interface responsive. Raw “bytes written” progress messages are omitted from the log.
- Find mp3gain.exe beside the script or on PATH, display its version in the window title, and select it manually if it cannot be found. Use "MP3Gain Help" button to select mp3gain.exe. 
- Choose APE or ID3v2 gain tags and configure advanced options, including timestamp preservation, quiet mode, MPEG-2 Layer III handling, gain wrapping, and additional dB or MP3-step adjustments.
- Switch the interface between French and English. File-changing operations require confirmation.
- Settings saved in a settings.ini file.

Analysis option: Track Analysis passes -e to skip album analysis; Album Analysis calculates album results. MP3Gain 1.5.2 documents -e for this purpose in its source code. If the log says “I don’t recognize option -e”, check the executable path and version shown at startup.


==================================================

FRANÇAIS

PowerGain-GUI
Une interface graphique PowerShell pour mp3gain.exe, créée avec l’aide de ChatGPT.

J’ai créé cette interface parce que ma version de MP3Gain GUI ne fonctionnait plus, même après l’avoir retéléchargée. Voici le résultat de ce travail réalisé avec l’aide de ChatGPT.

Testé avec mp3gain.exe, en version 1.5.0.2 (source [sourceforge - MP3GAIN](https://sourceforge.net/projects/mp3gain/)).

PowerGain-GUI permet de :
- Ajouter un ou plusieurs fichiers MP3, ou parcourir un dossier et ses sous-dossiers ; retirer les fichiers sélectionnés ou vider la liste.
- Analyser les pistes et les albums ; appliquer un gain piste ou album ; annuler des changements de gain ; appliquer un gain constant ou par canal ; mesurer l’amplitude maximale ; vérifier, supprimer ou recalculer les tags MP3Gain.
- Analyser ou appliquer le gain album dossier par dossier. Cette option est activée par défaut. Si des fichiers sont sélectionnés, tous les MP3 déjà présents dans la liste et situés dans les dossiers contenant ces fichiers sont inclus. Sans sélection, tous les fichiers listés sont regroupés par dossier. Décochez l’option pour traiter la sélection — ou toute la liste si rien n’est sélectionné — comme un seul album.
- Régler le volume cible entre 75 et 95 dB ; la valeur par défaut est 89 dB. La prévention de l’écrêtage est activée par défaut pour les gains piste et album.
- Consulter les résultats par fichier : volume estimé, gains piste et album, amplitude maximale, pas de gain MP3, risque d’écrêtage prévu après le gain piste et état du fichier. La colonne d’écrêtage n’indique pas un écrêtage déjà présent dans le fichier.
- Suivre les opérations dans la barre de progression et la colonne d’état. Annuler une opération en cours sans bloquer l’interface. Les messages bruts « bytes written » sont masqués dans le journal.
- Trouver mp3gain.exe dans le dossier du script ou dans le PATH, afficher sa version dans le titre de la fenêtre et le sélectionner manuellement s’il est introuvable. Utilisez le bouton "MP3Gain Help" pour choisir mp3gain.exe.
- Choisir le format des tags de gain APE ou ID3v2 et configurer les options avancées : préservation de la date du fichier, mode silencieux, traitement MPEG-2 Layer III, bouclage du gain et corrections supplémentaires en dB ou en pas MP3.
- Choisir l’interface en français ou en anglais. Les opérations qui modifient les fichiers demandent une confirmation.
- Réglages enregistrés dans un fichier "settings.ini".

Option d’analyse : l’analyse piste transmet -e pour ignorer l’analyse album ; l’analyse album calcule les résultats de l’album. Le code source de MP3Gain 1.5.2 documente -e à cette fin. Code source Si le journal indique « I don’t recognize option -e », vérifiez le chemin et la version de l’exécutable détecté au démarrage.


==================================================

Screenshots 

<img width="1186" height="813" alt="image" src="https://github.com/user-attachments/assets/c41f6fd0-4c81-4745-b022-8e8eb444d43b" />


