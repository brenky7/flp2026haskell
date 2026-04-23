# FLP projekt

Created: 03/04/2026, 13:02:57
Last Updated: 03/04/2026, 13:02:57

---

### User

v prilohe je zadanie projektu ktory musim urobit. precital som si to a mam par doplnujucich otazok aby som sa v tom lepsie zorientoval:

1. jazyk SOL26, co to je? ako to vyzer? na co sa to pouziva?
2. Preco je za kontajnerizaciu bonusovy bod? obecne kontajnery pouzivam, a nevidim v tom problem, predpokladam ale, ze v tom bude nejaky hacik, kedze je to za bonus.
3. Cabal - aku presne rolu tuna hra? viem ze to je nejaky package manager pre haskell, ale inak nic…
4. ORMOLU, co to je? vyvyjam vo VSCode a pouzivam haskell-language-server, ale ako si to skontrolujem, ci to naozaj pouziva to ormolu?
5. format Haddock na dokumentaciu, ako to vyzera?

okrem toho mi prosim vypracuj zhrnutie zadania toho, co treba vykonat - vsetky poziadavky, predpoklady a tak v markdown formate. dalej mi este prosim priprav plan organizacie prace od pripravy repozitaru az po balenie hotoveho zipu na odovzdanie presne podla zadania

[Zadání_projektu_FLP_2025_2026_04-01-16-50.pdf](https://upoevdcxa3.ufs.sh/f/IN4OjmY4wMHBtWHJxxXtaFvpN32dj2oJSbgT9BGYh5dRtiTqRzh4pycGEVYPSS02l)

---

### Assistant (gpt-5.4)

Jasné — toto sú presne dobré otázky na začiatok. Nižšie ti to rozoberiem po bodoch a potom pridám:

1. stručné, ale kompletné zhrnutie zadania v Markdowne,
2. praktický plán práce od prípravy repozitára až po ZIP na odovzdanie.

Poznámka k AI:

- To, že sa ma teraz pýtaš na vysvetlenie zadania, je podľa zadania povolené použitie AI.
- Ale keďže zadanie vyžaduje transparentnosť, toto použitie by si mal uviesť v `AI.md`.
- A ešte dôležitejšie: nepouži môj text priamo ako odovzdávané `README.md` alebo dokumentáciu v kóde, lebo zadanie explicitne zakazuje generovať dokumentáciu pomocou AI. Toto ber ako tvoje pracovné poznámky.

---

# 1. Čo je SOL26

SOL26 je školský jazyk používaný v predmete IPP.

## Na čo slúži

Nie je to reálny produkčný jazyk ako Python alebo Java.
Je to didaktický jazyk, na ktorom sa študenti učia:

- návrh jazyka,
- parsovanie,
- reprezentáciu programu,
- interpretáciu,
- prácu s návratovými kódmi a vstupom/výstupom.

## Ako vyzerá

Zo zadania vidíš ukážku:

```text
class Main : Object {
run [ | ]
}
```

Teda syntakticky to vyzerá ako jednoduchý objektovo orientovaný jazyk:

- triedy,
- dedenie,
- metódy,
- imperatívne správanie.

Presnú syntax a sémantiku však ty pre tento projekt v podstate nepotrebuješ detailne poznať.

## Čo potrebuješ vedieť ty

Pre tvoj testovací nástroj je SOL26 v zásade:

- textový vstup pre parser/prekladač,
- ktorý sa zmení na XML AST,
- a to sa potom vykoná interpretom.

Ty nemusíš implementovať jazyk SOL26.
Ty implementuješ nástroj, ktorý testuje cudzie implementácie parsera a interpreta.

---

# 2. Prečo je kontajnerizácia len bonus

Máš správny pocit: samotný Docker/Podman nemusí byť ťažký.
Bonusový bod je tam skôr preto, že to nie je jadro zadania.

## Hlavný cieľ projektu je

- funkcionálne programovanie v Haskelli,
- práca s efektmi,
- spustiteľná aplikácia,
- property testing,
- spracovanie vstupov/výstupov a procesov.

Kontajnerizácia je skôr:

- extra engineering skill,
- reproducibilita,
- deployment,
- izolované build prostredie.

## Kde môže byť “háčik”

Nie v tom, že by Docker bol sám o sebe extrémne ťažký, ale v tom, že treba spraviť to presne podľa zadania:

- viacstupňový build,
- stage `build`,
- stage `runtime`,
- stage `test`,
- runtime image má byť odľahčený,
- test stage má spúšťať property testy,
- kompatibilita s Docker aj Podman,
- platforma x86_64.

## Praktický dôvod, prečo je to bonus

Lebo je to:

- užitočné,
- ale nie nevyhnutné na splnenie hlavného cieľa predmetu.

Inými slovami: vieš spraviť plnohodnotné riešenie bez kontajnera.

---

# 3. Akú rolu hrá Cabal

Cabal v Haskelli nie je len package manager.
V tomto projekte hrá naraz viac rolí:

## 3.1 Build tool

Pomocou Cabalu projekt:

- preložíš,
- spustíš,
- otestuješ.

Typické príkazy:

```bash
cabal build
cabal test
cabal run
```

## 3.2 Správa závislostí

V `.cabal` súbore máš definované:

- aké knižnice projekt používa,
- aké verzie / balíčky treba,
- čo patrí do knižnice, executable a testov.

## 3.3 Definícia projektu

Cabal súbor hovorí:

- čo je library,
- čo je executable,
- čo je test suite,
- ktoré moduly sa kde používajú,
- aké GHC options sa majú zapnúť.

## 3.4 Pre tento projekt konkrétne

Zadanie hovorí, že máš použiť pripravenú šablónu projektu.
Čiže Cabal tu zabezpečuje aj to, že:

- zachováš danú štruktúru,
- vieš spúšťať `cabal test`,
- vieš spúšťať výsledný nástroj cez `cabal run ...`.

Takže áno, package manager je len časť toho.
Pre teba je Cabal hlavne build/test/project orchestration nástroj.

---

# 4. Čo je Ormolu a ako zistiť, či ho používa VS Code + HLS

## Čo je Ormolu

Ormolu je automatický formatter pre Haskell.
Jeho úloha je:

- naformátovať kód do jednotného štýlu.

Zadanie ho vyžaduje povinne.

## Prečo je to dôležité

Nie je to len kozmetika:

- udržiava konzistentný štýl,
- znižuje chaos v kóde,
- učiteľ očakáva práve tento formatter.

## Ako skontrolovať VS Code

Najistejšie je nastaviť to explicitne v `settings.json`:

```json
{
  "haskell.formattingProvider": "ormolu",
  "[haskell]": {
    "editor.formatOnSave": true
  }
}
```

## Kde to pozrieš

Vo VS Code:

- otvor Settings
- hľadaj `Haskell Formatting Provider`
- over, že je tam `ormolu`

alebo priamo v `settings.json`.

## Ako si overiť, že to funguje

1. otvor `.hs` súbor
2. daj “Format Document”
3. ak sa kód upraví do ormolu štýlu, formatter funguje

## Ešte bezpečnejší prístup

Nespoliehaj sa len na “default”.
Explicitne nastav `ormolu`.

Ak chceš, vieš mať aj samostatný príkazový nástroj:

```bash
ormolu --version
```

ale pre samotné formátovanie cez HLS nie je vždy nutné riešiť to manuálne, ak je HLS správne nastavený.

---

# 5. Ako vyzerá Haddock dokumentácia

Haddock je štandardný spôsob dokumentácie v Haskelli.

## Najbežnejší tvar

Komentár nad definíciou:

```haskell
-- | Parses a single .test file and returns either a parse error
-- or a structured test definition.
parseTestFile :: FilePath -> Text -> Either ParseError TestDefinition
parseTestFile path contents = ...
```

## Viacriadkový blok

```haskell
{-|
Loads all tests from a directory.

Returns successfully parsed tests together with information
about files that could not be parsed.
-}
loadTests :: FilePath -> IO LoadResult
loadTests dir = ...
```

## Komentovanie polí v recorde

```haskell
data TestDefinition = TestDefinition
  { testName :: Text
  -- ^ Name of the test derived from the file name.
  , testCategory :: Text
  -- ^ Category of the test. Mandatory in the .test file.
  }
```

## Čo sa od teba v praxi čaká

Nemusíš písať romány.
Stačí, aby bolo rýchlo jasné:

- čo funkcia robí,
- aké má vstupy,
- aký má výstup,
- prípadne dôležité správanie / špeciálny prípad.

---

# Plán organizácie práce od repozitára po ZIP

Opäť: toto ber ako pracovný plán, nie odovzdávanú dokumentáciu.

## Fáza 0 — administratívny štart

### Cieľ

Mať čisté prostredie a istotu, že rozumieš zadaniu.

### Kroky

- prečítať celé zadanie ešte raz od začiatku do konca,
- poznačiť si:
  - povinné časti,
  - bonusy,
  - zakázané veci,
  - termíny,
- uvedomiť si, že toto použitie AI treba uviesť v `AI.md`.

---

## Fáza 1 — príprava repozitára

### Cieľ

Vytvoriť si vlastný repozitár správnym spôsobom.

### Kroky

1. stiahnuť šablónu projektu,
2. vytvoriť si vlastný súkromný repozitár,
3. nastaviť `origin` na svoj repozitár,
4. spraviť prvý commit bez zmien,
5. overiť, že repozitár je pushnutý.

### Poznámka

Neskôr:

- buď repozitár zverejníš,
- alebo pozveš `@iondryas` read-only.

---

## Fáza 2 — kontrola toolchainu

### Cieľ

Mať správne verzie a funkčné nástroje.

### Skontrolovať

```bash
ghc --version
cabal --version
cabal exec ghc -- --version
```

### Overiť

- GHC je `9.6.7`,
- Cabal funguje,
- VS Code + HLS funguje,
- formatter je nastavený na Ormolu.

### Vo VS Code explicitne nastaviť

```json
{
  "haskell.formattingProvider": "ormolu",
  "[haskell]": {
    "editor.formatOnSave": true
  }
}
```

---

## Fáza 3 — rozbehanie šablóny bez zmien

### Cieľ

Najprv pochopiť existujúci projekt, nie hneď kódovať.

### Kroky

```bash
cabal build
cabal test
```

### Urobiť

- pozrieť štruktúru `src/`, `app/`, `test/`,
- nájsť všetky komentáre `FLP:`,
- prečítať si dátové typy pre JSON report,
- zistiť, ktoré funkcie sú rozpracované / prázdne.

### Výstup tejto fázy

- vieš, čo už šablóna rieši,
- vieš, čo konkrétne máš doplniť.

---

## Fáza 4 — návrh riešenia na papieri

### Cieľ

Ujasniť si tok dát skôr, než začneš implementovať.

### Navrhni si moduly / vrstvy

Napríklad takto:

- načítanie súborov testov,
- parser `.test` formátu,
- reprezentácia testu,
- filtrovanie testov,
- určenie typu testu,
- spúšťanie parsera,
- spúšťanie interpreta,
- porovnanie výstupu cez `diff`,
- skladanie výsledku testu,
- agregácia bodov a štatistík,
- CLI parsing,
- zápis JSON reportu.

### Dôležitá rada

Začni od “vnútorných” pure častí a až potom rieš IO.

---

## Fáza 5 — implementácia parsera testov

### Cieľ

Vedieť spoľahlivo načítať `.test` súbory.

### Kroky

- nájsť `.test` súbory v adresári,
- prípadne rekurzívne,
- načítať obsah,
- parse-nuť hlavičku a telo testu,
- odvodiť názov testu zo súboru,
- spracovať opakovateľné polia,
- validovať povinné položky,
- rozumne reprezentovať parse chyby.

### Otestovať

- korektný test,
- chýbajúca kategória,
- chýbajúca bodová váha,
- viac `!I!`,
- viac tagov,
- ľubovoľné poradie položiek,
- prázdny popis,
- prítomnosť / neprítomnosť `.in` a `.out`.

---

## Fáza 6 — určenie typu testu a filtrovanie

### Cieľ

Vedieť rozhodnúť:

- čo sa má spustiť,
- a ktoré testy sa vôbec majú vykonať.

### Implementovať

- inferenciu typu testu:
  - compile-only,
  - interpret-only,
  - compile+interpret,
- include / exclude logiku,
- filtre podľa mena, kategórie, tagov,
- trimovanie whitespace okolo filtra,
- `--ic`, `--it`, `--ec`, `--et`.

### Bonus neskôr

- `-g` + regex.

---

## Fáza 7 — spúšťanie externých procesov

### Cieľ

Bezpečne spúšťať parser, interpret a `diff`.

### Implementovať

- spustenie parsera:
  - SOL26 na `stdin`,
  - zachytiť `stdout`, `stderr`, návratový kód,
- spustenie interpreta:
  - dočasný XML súbor pre `--source`,
  - prípadne `.in` ako `--input`,
  - zachytiť `stdout`, `stderr`, návratový kód,
- spustenie `diff`:
  - len ak existuje `.out` a interpret skončil s `0`.

### Dôležité správanie

- ak parser / interpret binárka neexistuje alebo sa nedá spustiť:
  - test sa označí ako nespustiteľný,
  - tester ako celok nemá spadnúť,
  - výsledok má byť v report-e.

---

## Fáza 8 — skladanie výsledkov a reportu

### Cieľ

Dostať sa z “individuálnych behov” k finálnemu JSON.

### Implementovať

- reprezentáciu výsledku jedného testu,
- body za úspešné testy,
- sumarizáciu po kategóriách,
- celkové štatistiky,
- histogram úspešnosti kategórií po 10 %.

### Dôležité

Drž sa presne dátových typov zo šablóny.

---

## Fáza 9 — CLI rozhranie

### Cieľ

Spraviť nástroj použiteľný podľa špecifikácie.

### Implementovať

- pozičný argument s cestou k testom,
- `-p` / `--parser`,
- `-t` / `--interpreter`,
- `-r` / `--recursive`,
- `-o` / `--output`,
- `--dry-run`,
- `-h` / `--help`,
- všetky filtre.

### Otestovať návratové kódy programu

- neexistujúci adresár -> `1`
- chýbajúci parser / interpret, ak je potrebný a nie je `dry-run` -> `2`
- inak -> `0`

---

## Fáza 10 — priebežné testovanie

### Cieľ

Nečakať so všetkým až na koniec.

### Priebežne spúšťať

```bash
cabal build
cabal test
```

### Overovať aj ručne

- `--help`
- `--dry-run`
- testy bez `.in`
- testy bez `.out`
- testy len s XML
- testy len pre parser
- mix include/exclude filtrov
- neexistujúca binárka parsera / interpreta
- zápis reportu na `stdout`
- zápis reportu do súboru

---

## Fáza 11 — kvalita kódu

### Cieľ

Dostať riešenie do stavu vhodného na odovzdanie.

### Checklist

- žiadne warningy pri `-Wall`,
- kód je naformátovaný Ormolu,
- `cabal test` prejde,
- každá vlastná funkcia má komentár,
- zložitejšie výrazy sú okomentované,
- pomocné `FLP:` komentáre zo šablóny odstránené, ak už netreba.

### Odporúčané

Ak máš `hlint`, spusti ho tiež.

---

## Fáza 12 — povinné sprievodné súbory

### Cieľ

Mať všetko, čo treba k odovzdaniu.

### Pripraviť

- `README.md`
  - napíš sám,
  - stručne,
  - bez AI generovania textu,
- `AI.md`
  - uveď použitie AI,
  - workflow,
  - čo si sa pýtal,
  - ako si AI používal,
- dôkazy o AI použití:
  - export,
  - screenshoty,
  - odkazy.

### Keďže si použil AI už teraz

Do `AI.md` si poznač napríklad:

- vysvetlenie zadania,
- objasnenie pojmov interpret / kompilátor / AST / Cabal / Ormolu / Haddock,
- pomoc s pracovným plánom.

---

## Fáza 13 — finálna kontrola projektu

### Obsah projektu má typicky byť

- `src/`
- `app/`
- `.cabal`
- `README.md`
- prípadne `test/`
- `AI.md`
- dôkazy o AI použití
- prípadne `Containerfile`

### Nesmie tam byť

- `.git/`
- `.github/`
- `.vscode/`
- `dist-newstyle/`
- `.DS_Store`
- `__MACOSX`
- binárky
- `.o`, `.hi`, `.exe`, build artefakty
- iné skryté adresáre

---

## Fáza 14 — príprava čistého adresára na ZIP

### Najbezpečnejší postup

Nevytváraj ZIP priamo z repozitára.
Radšej si priprav čistý export adresár.

### Príklad

Z koreňa projektu:

```bash
mkdir -p ../flp-submit
rsync -av --delete \
  --exclude='.git' \
  --exclude='.github' \
  --exclude='.vscode' \
  --exclude='dist-newstyle' \
  --exclude='__MACOSX' \
  --exclude='.DS_Store' \
  --exclude='*.o' \
  --exclude='*.hi' \
  --exclude='*.exe' \
  --exclude='*.prof' \
  --exclude='*.eventlog' \
  ./ ../flp-submit/
```

Potom skontroluj obsah `../flp-submit`.

### Vytvorenie ZIP tak, aby boli súbory priamo v koreni archívu

```bash
cd ../flp-submit
zip -r ../projekt.zip .
```

Toto je dôležité:

- v ZIP-e nemá byť vnorený extra nadradený adresár,
- v koreni majú byť rovno súbory projektu.

---

## Fáza 15 — finálne overenie ZIPu

### Skontrolovať

- ZIP sa dá rozbaliť,
- v koreni sú správne súbory,
- nie sú tam skryté adresáre,
- nie sú tam build artefakty,
- je tam `README.md`,
- je tam `AI.md`, ak si použil AI,
- projekt sa po rozbalení dá buildiť.

### Ideálne posledný test

Rozbaliť ZIP do čistého adresára a skúsiť:

```bash
cabal build
cabal test
```

Ak funguje tam, je veľká šanca, že bude fungovať aj pri hodnotení.

---

# Krátke odporúčanie na poradie implementácie

Ak chceš najpraktickejšie poradie, išiel by som takto:

1. rozbehať šablónu,
2. prečítať dátové typy reportu,
3. implementovať parser `.test`,
4. implementovať načítanie testov z adresára,
5. implementovať filtre,
6. implementovať spúšťanie parsera,
7. implementovať spúšťanie interpreta,
8. implementovať `diff`,
9. implementovať skladanie reportu,
10. implementovať CLI a výstup do JSON,
11. doladiť rohy a nespustiteľné prípady,
12. komentáre, formátovanie, README, AI.md, ZIP.

---

Ak chceš, v ďalšom kroku ti môžem pripraviť ešte:

1. návrh architektúry modulov pre tento projekt v Haskelli,
2. checklist edge-caseov, ktoré sa oplatí pokryť,
3. alebo konkrétny “implementation roadmap” priamo podľa typických súborov zo šablóny.
