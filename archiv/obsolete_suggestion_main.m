%-----------------------CONSTANTS----------------------
timestep = 5; % Festgelegter Zeitschritt
step = 1; % Aktueller Schritt
timesteps = 1000; % Nummer an Zeitschritten die durchgeführt werden sollen.

% Vorab:
% Nach meiner Vorstellung brauchen die Customer noch Variablen wie:
% - Spawntime
% - Despawntime (Spawntime + Übergebene Lifetime)
% Welche man entweder beim Erstellen übergeben kann zB CU1 = Cu(100,50) oder zufällig generieren lassen kann CU2 = CU().
% Dann erstellt man am besten !direkt!  2 Customer-Listen (CU_SPAWNS und CU_DESPAWNS), welche sortiert nach 
% je einmal Spawntime und Despawntime sind. 
% Die Listen sollten jetzt angepasst werden

%---------------------MAIN FUNCTION--------------------
% Achtung es liegt NUR Pseudo-Code vor!

%--------Initialisierung der benötigten Objekte--------
% Erstellen einer Map zB karte = map()
% Erstellen von einer festgelegten Anzahl Customers.
% -> Generieren und sortieren der oben genannten Listen.
% Erstellen der gewollten Basisstationen.
% Erstellung von NUTZBAREN Listen:
% -> Zunächst werden die Spawn und Despawnzeiten auf den nächsthöhsten
%    timestep gerundet. zB Spawntime 134 wird zu 135. Dabei müssen Werte
%    wie zB 150 jedoch gleichbleiben.
% -> Anschließend wird eine Matrix erstellt. Diese ist [timesteps][2] groß
%    und speichert in Spalte 1 die Spawns und in Spalte 2 die Despawns von
%    Customern. In den Zeilen stehen Namen. Beispiel:
%    In Zeile 84 steht in Spalte 1 nichts und in Spalte 2 CU5.
%    Das bedeutet es wird KEIN neuer Customer erstellt jedoch wird CU5 von
%    der Map entfernt. Es müssen also irgendwie die 2 zuvor erstellten
%    Listen in eine solche Matrix überführt werden. Die vorherigen Listen
%    bleiben jedoch bestehen weil in der Matrix nur der Name jeweils
%    gespeichert wird.

%----------------------SIMULATION----------------------
% mache ich später / die Tage weiter
% jedoch sind die oben genannten Listen so gedacht:
% Am Ende jeder Schleife wird "step" um eins erhöht.
% Am Anfang jedes Schleifenschrittes wird dann mithilfe eines Zugriffes auf
% die Matrix überprüft ob neue Customer erstellt werden müssen oder nicht.
% Beispiel: if matrix[step][1] ungleich "" muss in der CU_SPAWNS Liste nach
% einem CU mit dem Namen der eben dort steht gesucht werden und darauf hin
% erstellt werden.