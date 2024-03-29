########## Ausgabe des Logos im Home-Tab
output$image1 <- renderImage({
  
      list(src = "Logo.png", height = 700, width = 1200,
      filetype = "image/jpeg"
      )
}, deleteFile = FALSE)


########## Ausgabe des Info bei klick auf About PAS im Home-Tab

output$aboutPAS<-renderUI({
'Prognose und Planung: Mit dem PwC Predictor immer einen Schritt voraus 

  In einem zunehmend globalisierten und digitalisierten Wirtschaftsumfeld wird es immer schwieriger, zu planen oder Entscheidungen zu treffen, wenn sich relevante Informationen h�ufig �ndern. Einerseits spielen in global-vernetzten Wertsch�pfungsketten immer mehr (interdependente) Einflussgr��en eine Rolle, andererseits erschwert die hohe Informationsgeschwindigkeit die relevanten Daten herauszufiltern. Aus diesem Grund haben Tobias Flath (PwC Risk Consulting) und Dr. Frauke Schleer-van Gellecom (PwC Economics) den PwC Predictor entwickelt, welcher die wesentlichen Treiber von Plangr��en herausfiltert, analysiert, die Plangr��er anhand der Treiber prognostiziert und so eine fundiertere Planung erm�glicht. 
  
  Steigende Unsicherheit aufgrund von Globalisierung und Digitalisierung
  "Viele Unternehmen befinden sich mittlerweile in der Situation hoher Planungsunsicherheit, da auf international vernetzten M�rkten immer mehr Faktoren Ihre Planung beeinflussen" wei� Tobias Flath als international und langj�hrig erfahrener Berater. Zum Verdeutlichen w�hlt er ein Beispiel, welches Kunden als Herausforderung geschildert haben: "Das Einkaufsverhalten vieler Unternehmen wird zunehmend globaler, um Kosten zu sparen. Allerdings erh�ht sich dadurch das Risiko von Kostenschwankungen, weil Kosten nun von zus�tzlichen Faktoren wie Wechselkursen, Transportkosten und Lohnkostenentwicklung abh�ngig sind. Als Folge verringert sich die Planungssicherheit". Besonders problematisch ist dabei, dass die gro�e Anzahl von m�glichen Einflussfaktoren der Kosten, die Identifikation der relevanten und signifikanten Treiber erschwert, hebt Flath hervor.  Ein weiteres Beispiel wird von Dr. Schleer-van Gellecom angef�hrt: "Die Finanzkrise hat bei vielen Unternehmen zu starken Umsatzeinbu�en und zu einer gro�en Verunsicherung gef�hrt. Der globale Einbruch des Absatzes wurde h�ufig untersch�tzt und nicht rechtzeitig erkannt. Die verz�gerte Reaktion auf den Markteinbruch verursachte einen �berm��igen Lagerbestand und folglich zus�tzliche Kosten."
  Das Ziel: Identifikation der relevanten Treiber
  "Unser Ziel muss also sein, die relevanten Treiber - inklusive ihrer Auswirkungen auf die Plangr��e - zu identifizieren und auf ihren genauen Einfluss hin zu untersuchen. Dadurch k�nnen wir die Treiber in die Unternehmensplanung einbeziehen, um damit wieder mehr Sicherheit f�r Planung, Entscheidungen und Unternehmenssteuerung zu generieren". Flath und Schleer-van Gellecom realisierten dieses Ziel mit der Entwicklung des PwC Predictors, der darauf ausgelegt ist, die Wirkungszusammenh�nge einer gro�en Menge an Treibern auf eine definierte Plangr��e (z.B. geplanter Absatz, Einkaufspreise) zu untersuchen und die relevanten Treiber herauszufiltern. Besonders wichtig sei dabei die M�glichkeit, die Faktoren dahingehend zu analysieren, ob deren Entwicklung zeitgleich mit der Plangr��e verl�uft, oder - im besten Fall - eine Vorlaufzeit existiert, es sich also um echte Fr�hindikatoren handelt. "Mit dem Wissen, welche Treiber unsere Plangr��en wie und mit welchen zeitlichem Vorlauf beeinflussen, k�nnen wir Entwicklung erkennen und gewinnen so mehr Planungssicherheit und wertvolle Handlungsspielr�ume", betont Flath. "Der Einkaufsabteilung eines Unternehmens k�nnen wir jetzt also zeigen, wie und mit welchem Zeitversatz sich bspw. ein �ndernder Wechselkurs auf die Kosten auswirkt". 
  
  �berf�hrung der Treiber in ein Erkl�rungsmodell
  Der Planungshorizont bleibe allerdings noch begrenzt, so Flath, weswegen er sich mit einer Expertin f�r Prognosen, Dr. Frauke Schleer-van Gellecom, zusammenschloss, um den PwC Predictor zu entwickeln. Sie ist �berzeugt: "Das Ergebnis der Analyse der verschiedenen Treiber durch den PwC Predictor kann man sehr gut z.B. in ein multiples oder simultanes Erkl�rungsmodell �berf�hren, welches auch Zusammenh�nge zwischen den einzelnen Treibern ber�cksichtigt". So ist es m�glich, f�r jede Plangr��e ein eigenes Modell zu entwickeln, welches seine Aussage bei neuer Datenlage entsprechend anpasst. "Durch das revolvierende Vergleichen und Verbessern des Erkl�rungsmodells mit neuen Daten kann einerseits die Aussagekraft des Modells �berpr�ft und andererseits Ver�nderungen der Treiber analysieren und in das Modell integrieren werden", erl�utert Dr. Schleer-van Gellecom.
  
  Forecasting der Treiber und Planwerte
  "�ber die erwartete Entwicklung der einzelnen Treiber bzw. Fr�hindikatoren l�sst sich nun die jeweilige Plangr��e �ber den Zeitversatz hinaus in die Zukunft prognostizieren und somit den Planungshorizont auf Basis fundierter Informationen erweitern und untermauern", erkl�rt Dr. Schleer-van Gellecom. "Die Entwicklung der Treiber ermitteln wir durch verschiedene simultane Prognoseverfahren. Diese Werte verwenden wir anschlie�end in dem jeweiligen Erkl�rungsmodell". Das Ergebnis ist eine fundierte Prognose der Plangr��e in die Zukunft anhand ihrer relevanten Treiber, die einen objektiven Rahmen f�r planerische und strategische Entscheidungen geben, so Dr. Schleer-van Gellecom. 
  PwC Predictor: Die Informationsflut als Vorteil
  "Der PwC Predictor nutzt die Informationsflut, die uns eine effiziente Planung und Entscheidung erschwert, indem der Predictor daraus einen Informationsvorteil generiert. Damit k�nnen  wir fundierter in die Zukunft schauen, auf neudeutsch "predictive analytics" genannt" so Flath. Egal ob Rohstoffpreise, sich ver�ndernde Kaufgewohnheiten, die allgemeine Konjunktur, unternehmenspezifische Daten, oder der Leitzins, all diese Einflussfaktoren k�nnen auf ihre Zusammenh�nge hin untersucht und in die Planung - z.B. der Absatzmenge - einbezogen werden", erg�nzt Dr. Schleer-van Gellecom.
  Prognose in Bandbreiten: Mehrwert durch objektivere Ergebnisse
  Ganz nach der 2012 von "Deutschland - Land der Ideen" ausgezeichneten Korridorbudgetierung werden die Ergebnisse nicht in Punktwerten, sondern in Bandbreiten (Korridoren) angegeben, um eine realit�tsn�here Planung zu erm�glichen. "Die Implikation dahinter ist klar: Eine Plangr��e als einen Punktwert zu prognostizieren, der sich h�chstwahrscheinlich nicht realisieren wird, generiert kaum Mehrwert. Viel interessanter ist doch, innerhalb welcher Spanne sich der Wert wahrscheinlich befinden wird und wie diese verteilt ist", erl�utert Flath. 
  
  
  "Mithilfe der, in der Bandbreite angegebenen, eingeplanten Unsicherheit einerseits und dem Wissen aus der Prognose andererseits lassen sich nun fundiertere und bessere - der tats�chlichen Situation angepassten - Entscheidungen treffen". 
  
  Platzierung unter
  http://www.pwc.de/de/risk.html
  http://www.pwc.de/de/business-analytics.html
  http://www.pwc.de/de/offentliche-unternehmen/economics-advisory.html 
  
  mit Links zu:
  http://www.pwc.de/de/offentliche-unternehmen/interview-zu-fruehwarnsystemen.html
  http://www.pwc.de/korridorbudgetierung'
  
})


