########## Ausgabe des Logos im Home-Tab
output$image1 <- renderImage({
  
      list(src = "Logo.png", height = 700, width = 1200,
      filetype = "image/jpeg"
      )
}, deleteFile = FALSE)


########## Ausgabe des Info bei klick auf About PAS im Home-Tab

output$aboutPAS<-renderUI({
'Prognose und Planung: Mit dem PwC Predictor immer einen Schritt voraus 

  In einem zunehmend globalisierten und digitalisierten Wirtschaftsumfeld wird es immer schwieriger, zu planen oder Entscheidungen zu treffen, wenn sich relevante Informationen häufig ändern. Einerseits spielen in global-vernetzten Wertschöpfungsketten immer mehr (interdependente) Einflussgrößen eine Rolle, andererseits erschwert die hohe Informationsgeschwindigkeit die relevanten Daten herauszufiltern. Aus diesem Grund haben Tobias Flath (PwC Risk Consulting) und Dr. Frauke Schleer-van Gellecom (PwC Economics) den PwC Predictor entwickelt, welcher die wesentlichen Treiber von Plangrößen herausfiltert, analysiert, die Plangrößer anhand der Treiber prognostiziert und so eine fundiertere Planung ermöglicht. 
  
  Steigende Unsicherheit aufgrund von Globalisierung und Digitalisierung
  "Viele Unternehmen befinden sich mittlerweile in der Situation hoher Planungsunsicherheit, da auf international vernetzten Märkten immer mehr Faktoren Ihre Planung beeinflussen" weiß Tobias Flath als international und langjährig erfahrener Berater. Zum Verdeutlichen wählt er ein Beispiel, welches Kunden als Herausforderung geschildert haben: "Das Einkaufsverhalten vieler Unternehmen wird zunehmend globaler, um Kosten zu sparen. Allerdings erhöht sich dadurch das Risiko von Kostenschwankungen, weil Kosten nun von zusätzlichen Faktoren wie Wechselkursen, Transportkosten und Lohnkostenentwicklung abhängig sind. Als Folge verringert sich die Planungssicherheit". Besonders problematisch ist dabei, dass die große Anzahl von möglichen Einflussfaktoren der Kosten, die Identifikation der relevanten und signifikanten Treiber erschwert, hebt Flath hervor.  Ein weiteres Beispiel wird von Dr. Schleer-van Gellecom angeführt: "Die Finanzkrise hat bei vielen Unternehmen zu starken Umsatzeinbußen und zu einer großen Verunsicherung geführt. Der globale Einbruch des Absatzes wurde häufig unterschätzt und nicht rechtzeitig erkannt. Die verzögerte Reaktion auf den Markteinbruch verursachte einen übermäßigen Lagerbestand und folglich zusätzliche Kosten."
  Das Ziel: Identifikation der relevanten Treiber
  "Unser Ziel muss also sein, die relevanten Treiber - inklusive ihrer Auswirkungen auf die Plangröße - zu identifizieren und auf ihren genauen Einfluss hin zu untersuchen. Dadurch können wir die Treiber in die Unternehmensplanung einbeziehen, um damit wieder mehr Sicherheit für Planung, Entscheidungen und Unternehmenssteuerung zu generieren". Flath und Schleer-van Gellecom realisierten dieses Ziel mit der Entwicklung des PwC Predictors, der darauf ausgelegt ist, die Wirkungszusammenhänge einer großen Menge an Treibern auf eine definierte Plangröße (z.B. geplanter Absatz, Einkaufspreise) zu untersuchen und die relevanten Treiber herauszufiltern. Besonders wichtig sei dabei die Möglichkeit, die Faktoren dahingehend zu analysieren, ob deren Entwicklung zeitgleich mit der Plangröße verläuft, oder - im besten Fall - eine Vorlaufzeit existiert, es sich also um echte Frühindikatoren handelt. "Mit dem Wissen, welche Treiber unsere Plangrößen wie und mit welchen zeitlichem Vorlauf beeinflussen, können wir Entwicklung erkennen und gewinnen so mehr Planungssicherheit und wertvolle Handlungsspielräume", betont Flath. "Der Einkaufsabteilung eines Unternehmens können wir jetzt also zeigen, wie und mit welchem Zeitversatz sich bspw. ein ändernder Wechselkurs auf die Kosten auswirkt". 
  
  Überführung der Treiber in ein Erklärungsmodell
  Der Planungshorizont bleibe allerdings noch begrenzt, so Flath, weswegen er sich mit einer Expertin für Prognosen, Dr. Frauke Schleer-van Gellecom, zusammenschloss, um den PwC Predictor zu entwickeln. Sie ist überzeugt: "Das Ergebnis der Analyse der verschiedenen Treiber durch den PwC Predictor kann man sehr gut z.B. in ein multiples oder simultanes Erklärungsmodell überführen, welches auch Zusammenhänge zwischen den einzelnen Treibern berücksichtigt". So ist es möglich, für jede Plangröße ein eigenes Modell zu entwickeln, welches seine Aussage bei neuer Datenlage entsprechend anpasst. "Durch das revolvierende Vergleichen und Verbessern des Erklärungsmodells mit neuen Daten kann einerseits die Aussagekraft des Modells überprüft und andererseits Veränderungen der Treiber analysieren und in das Modell integrieren werden", erläutert Dr. Schleer-van Gellecom.
  
  Forecasting der Treiber und Planwerte
  "Über die erwartete Entwicklung der einzelnen Treiber bzw. Frühindikatoren lässt sich nun die jeweilige Plangröße über den Zeitversatz hinaus in die Zukunft prognostizieren und somit den Planungshorizont auf Basis fundierter Informationen erweitern und untermauern", erklärt Dr. Schleer-van Gellecom. "Die Entwicklung der Treiber ermitteln wir durch verschiedene simultane Prognoseverfahren. Diese Werte verwenden wir anschließend in dem jeweiligen Erklärungsmodell". Das Ergebnis ist eine fundierte Prognose der Plangröße in die Zukunft anhand ihrer relevanten Treiber, die einen objektiven Rahmen für planerische und strategische Entscheidungen geben, so Dr. Schleer-van Gellecom. 
  PwC Predictor: Die Informationsflut als Vorteil
  "Der PwC Predictor nutzt die Informationsflut, die uns eine effiziente Planung und Entscheidung erschwert, indem der Predictor daraus einen Informationsvorteil generiert. Damit können  wir fundierter in die Zukunft schauen, auf neudeutsch "predictive analytics" genannt" so Flath. Egal ob Rohstoffpreise, sich verändernde Kaufgewohnheiten, die allgemeine Konjunktur, unternehmenspezifische Daten, oder der Leitzins, all diese Einflussfaktoren können auf ihre Zusammenhänge hin untersucht und in die Planung - z.B. der Absatzmenge - einbezogen werden", ergänzt Dr. Schleer-van Gellecom.
  Prognose in Bandbreiten: Mehrwert durch objektivere Ergebnisse
  Ganz nach der 2012 von "Deutschland - Land der Ideen" ausgezeichneten Korridorbudgetierung werden die Ergebnisse nicht in Punktwerten, sondern in Bandbreiten (Korridoren) angegeben, um eine realitätsnähere Planung zu ermöglichen. "Die Implikation dahinter ist klar: Eine Plangröße als einen Punktwert zu prognostizieren, der sich höchstwahrscheinlich nicht realisieren wird, generiert kaum Mehrwert. Viel interessanter ist doch, innerhalb welcher Spanne sich der Wert wahrscheinlich befinden wird und wie diese verteilt ist", erläutert Flath. 
  
  
  "Mithilfe der, in der Bandbreite angegebenen, eingeplanten Unsicherheit einerseits und dem Wissen aus der Prognose andererseits lassen sich nun fundiertere und bessere - der tatsächlichen Situation angepassten - Entscheidungen treffen". 
  
  Platzierung unter
  http://www.pwc.de/de/risk.html
  http://www.pwc.de/de/business-analytics.html
  http://www.pwc.de/de/offentliche-unternehmen/economics-advisory.html 
  
  mit Links zu:
  http://www.pwc.de/de/offentliche-unternehmen/interview-zu-fruehwarnsystemen.html
  http://www.pwc.de/korridorbudgetierung'
  
})


