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
```{http}
https://api.dataforsyningen.dk/afstemningsomraader/reverse?x=888039.1715&y=6126756.211&srid=25832
```
Dokumentation kan findes på [https://dawadocs.dataforsyningen.dk/dok/api/afstemningsomr%C3%A5de#reverse](https://dawadocs.dataforsyningen.dk/dok/api/afstemningsomr%C3%A5de#reverse)

