### poly-bs-website
*The documentation following below is in german language only, because it is a website for a local polyamory meetup in the city of Brunswick, Germany.*

# Website für den Polyamorie-Stammtisch Braunschweig
Auf dieser Website werden Informationen über den Braunschweiger Polyamorie-Stammtisch veröffentlicht.
Aktuell ist die Seite online unter [http://poly-bs.de](http://poly-bs.de) erreichbar.

Ich bin nicht die Veranstalterin des Stammtischs, aber habe mich bereit erklärt, die Website zu verwalten. Für den Fall, dass jemand anderes diese Aufgabe übernimmt, dokumentiere ich hier die Vorgehensweise, um die Website zu aktualisieren und zu veröffentlichen.

## Systemvoraussetzungen

Die Website wird mit [nanoc](https://nanoc.ws/) generiert. Wer die Seite bearbeiten möchte, muss also **nanoc installiert** haben.
Um die Website zu veröffentlichen, muss außerdem ein **Zugang auf den Server** (z.B. per SSH-Key) vorhanden sein, auf dem die Website liegt. Für einen neuen Server muss ggf. der Pfad in der Datei *nanoc.yaml* angepasst werden. Zugang und genauere Infos zum aktuellen Server und der Domain bekommt ihr ggf. von unserem Server-Admin **Christian** (beim Stammtisch fragen).

## Vorgehensweise zum Veröffentlichen von Änderungen

Die Änderungen müssen zuerst lokal gespeichert und getestet werden. Wenn die entsprechenden Dateien (siehe folgende Abschnitte) geändert und gespeichert sind, öffnet dazu im Hauptorder der Seite (dort, wo auch das .git-repo liegt) ein Terminal und führt den Befehl `nanoc` aus.

In einem weiteren Terminal kann mit `nanoc view` eine Vorschau gestartet werden, die dann im Webbrowser unter *localhost:3000* sichtbar ist, so lange bis der Vorschau-Prozess beendet wird.  
Diese Vorschau wird auch aktualisiert, wenn Dateien verändert wurden und ihr erneut `nanoc` ausführt - auch ohne die Vorschau zu beenden und neu zu starten.

Wenn ihr mit allen Änderungen zufrieden seid, dann kann die aktualisierte Website mit `nanoc deploy` auf den Server hochgeladen werden. 

## Website-Struktur

Das Layout der Seite ist im Format [slim](http://slim-lang.com/) definiert - vor allem in den Dateien *layouts/default.slim* und *content/index.slim*.
Der eigentliche Inhalt ist, bis auf die Startseite, in [Markdown](https://markdown.de/) geschrieben. Für jede weitere Seite (also z.B. Blogposts, Info-Seiten wie z.B. FAQ, und jeweils eine Ankündigungsseite für jede Stammtisch-Veranstaltung) liegt ein eigenes Unter-Verzeichnis im Ordner *content* mit einer eigenen *index.md*-Datei und ggf. weiteren Dateien, die nur für diese Seite nötig sind, also z.B. Bildern. Der Name des Ordners taucht dann in der fertigen Website als Teil der URL auf, also z.B. *http://poly-bs.de/kontakt/* für den Ordner *content/kontakt/*.

Auf der Startseite werden automatisch die drei nächsten Termine (von Zeitpunkt der letzten Aktualisierung aus gesehen) und die drei neusten Blogposts jeweils in einer kleinen Vorschau-Box angezeigt.

### Neuen Stammtischtermin und/oder Blogpost anlegen

Um einen neuen Termin anzulegen, ist es am einfachsten, zuerst den Ordner eines vergangenen Termins zu kopieren und den Namen entsprechend anzupassen. Dann im angepassten Ordner die Datei *index.md* bearbeiten, so dass die Daten für den neuen Termin passend sind. Aktuell können bei Termin-Seiten und Blogposts folgende Infos im Header-Bereich angegeben werden:

Attribut-Name | Beispiel | Beschreibung
------------- | -------- | ------------
title | "Polyamorie Stammtisch im Oktober 2020" | Titel für die Seite
subtitle | Unser monatliches Treffen für alternative Beziehungsformen | Untertitel für die Seite
tags | Veranstaltung, Stammtisch | Themen-Stichwörter, werden für Blogposts in der Vorschaubox angezeigt
published | 2020-10-25 | Datum, an dem diese Seite erstellt/veröffentlicht wurde
news | false | gibt an, ob es sich (auch) um einen Blogpost handelt (*true* für ja)
nometa | true | gibt an, ob die Meta-Informationen (*published* und *tags*) unter der Titelzeile ausgeblendet werden sollen
eventdate | 2020-10-28 | (Nur für Termine) das Datum für die Terminvorschau-Box
eventname | "Polyamorie-Stammtisch Oktober 2020" | (Nur für Termine) der Name der Veranstaltung für die Terminvorschau-Box
eventtype | "Online-Stammtisch" | (Nur für Termine) Zusätzliche Zeile für die Art des Termins
eventdetail | "ab 19:00 Uhr" | (Nur für Termine) Weitere Infos für die Terminvorschau-Box, z.B. Uhrzeit und/oder Ort
facebook | false | (Nur für Termine) Link zu einer Facebook-Veranstaltung für diesen Termin, oder *false* wenn es keine gibt
twitter | https://twitter.com/poly_bs/status/1320446535117770754 | (Nur für Termine) Link zu einem Tweet über diesen Termin, oder *false* wenn es keinen gibt
thumbnail | flyer.jpg | (Nur für Blogposts) Pfad zu einem Bild, das in der Vorschaubox angezeigt werden soll

Eine Seite kann auch gleichzeitig Blogpost (*news: true*) und Terminankündigung (*eventdate* etc. sind angegeben) sein, dann taucht sie als Vorschaubox im jeweiligen Format sowohl auf der Übersicht der Termine (so lange der Termin in der Zukunft liegt) als auch auf der Blog-Übersicht (dauerhaft) auf. Das ist vor allem für besondere Veranstaltungen wie z.B. Lesungen, Infostände o.ä. interessant, auf die ihr zusätzlich im Blog hinweisen wollt.

Unterhalb des Header-Bereichs in der jeweiligen *index.md*-Datei folgt dann der Beschreibungstext mit allen weiteren Infos, und es können Bilder eingebunden werden, etc.

Falls es sich um eine Veranstaltung handelt, wird automatisch ein Absatz mit einem Link zur Kontakt-Seite (sowie ggf. Links zu Facebook und/oder Twitter) eingebunden, der in der Layout-Datei definiert ist.
