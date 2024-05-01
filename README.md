# Bachelor

Her vil jeg arbejde på min bachelor

## Mulige modeller

- Fixed effects over tid og sted
- Forudsagt sandsynlighed i "normal" OLS

### Potentielle kontroller

- Vindmøller afstand
  - Som numerisk
  - Som dikotom
- Lokalmiljøets indflydelse
  - Vindmøller opsat i samarbejde med lokalsamfundet
  - Vindmøller som testcenter
- Vindmølle opsat ved udkanten af kommunen (indenfor x km af grænsen)

## Solceller

Solceller kan tænkes at have samme effekt som vindmøller da de optager en stor del land - Dog larmer de ikke så meget som vindmøller

## Datamuligheder
Gemte søgninger fra valgdatabasen:
[KV 2021 m. alle befolkningsstatistikker](https://valgdatabase.dst.dk/data?query=49e36503-88a5-4229-8267-ec59cd6e91e8-4)
[KV 2021 Indkomst og ejerforhold](https://valgdatabase.dst.dk/data?query=4d80cb84-f23e-4a4f-acea-e8e4906e5cdd-4)

### Danmarks Adressers Web API
Dataforsyningen har en api (gemt i postman), hvor man kan lave reverse lookup til valgstedet med et givet sæt af x-y koordinater
- For at bruge koordinater fra excelark skal der bruges `&srid=25832` efter koordinaterne
- Eksempel på GET-request for en mølle i Østermarie

```
https://api.dataforsyningen.dk/afstemningsomraader/reverse?x=888039.1715&y=6126756.211&srid=25832
```
Dokumentation kan findes på [https://dawadocs.dataforsyningen.dk/dok/api/afstemningsomr%C3%A5de#reverse](https://dawadocs.dataforsyningen.dk/dok/api/afstemningsomr%C3%A5de#reverse)

### Kobling til dataset fra valgdatabasen
I respons fra DAWA er der både adresse og navn på afstemningsstedet. Regner med, at der kan matches på navnet. Ellers findes også koordinater i samme format som de er bedt om. Ellers findes også afstemningsstedets nummer og kommunens kode i api-respons. Disse to kan sættes sammen og udgør det afstemingssted-id der er i datasettet fra valgdatabasen.

## Lokalplaner - Beslutninger om vindmøller
[Plandata.dk Søgeliste](https://kort.plandata.dk/searchlist/#/search/0400,0530,0153,0810,0411,0155,0240,0210,0607,0147,0813,0320,0250,0190,0430,0157,0710,0159,0161,0253,0270,0376,0563,0510,0260,0766,0217,0163,0657,0219,0860,0316,0661,0561,0615,0183,0849,0326,0756,0440,0621,0101,0259,0223,0482,0350,0665,0360,0173,0825,0846,0410,0773,0707,0169,0480,0450,0370,0760,0840,0329,0265,0230,0175,0730,0741,0740,0746,0779,0306,0330,0269,0340,0336,0671,0461,0479,0706,0540,0787,0550,0185,0187,0573,0575,0630,0727,0820,0167,0151,0580,0390,0492,0851,0751,0420,0201,0791,0165/20/V/2002-01-01/2024-04-15/81)


## Balancetest
- Ikke-observerede kovariater mellem stemmesteder
- Balance på gennemsnit
	- måske fordeling

## Ideer til variable
- Treatment ved tidligere valg
	- hvor mange valg er det siden der er treatment?
	- Forsøg på at opfange den tidligere treatment effekt
		- Hvad gør L Stokes?

# Vejledning
## Første vejledning
Spørgsmål og undringer:
- sdf
Andre noter:
- Holde ting simpelt er vigtigt.
- Borgmesteren som dep var
- Arbejde i grunddataene.
- Omfordeling af goderne (og omkostningerne)
	- Margalit
Fokus på basismodellen
- Interessant med kompenserende elementer

apsr coal


## Ideer til variable
- Treatment ved tidligere valg
	- hvor mange valg er det siden der er treatment?
	- Forsøg på at opfange den tidligere treatment effekt
		- Hvad gør L Stokes?