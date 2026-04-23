# Projekt pro funkcionální část FLP 2025/26

[URL](https://github.com/brenky7/flp2026haskell)

Pridané importy:

- Discovery.hs: doesDirectoryExist zo System.Directory
- Executor.hs: Permissions, doesFileExist, executable, getPermissions zo System.Directory

Pridané kvôli práci so systémovými adresármi. Iné som nič nepridával ani som nerobil zmeny v šablóne. Pred odovzdaním som iba nechal ormolu naformátovať projekt (podľa zadania) a to spravilo menšie úpravy aj v tvojom kóde. Zároveň som použil AI pre urobenie plánu práce a vysvetlenie pojmov na začiatku, viď export chatu v AI.md.

Zároveň ešte v git histórii nájdeš runTests.sh. Tento skript som spravil pre jednoduché testovanie zadaní z IPP s mojim kontajnerom, ale potom som zistil že IPP zadania sa kontajnerizujú tak som to zmazal, verím že automatické testovanie tam máš aj tak vyriešené..

## Bonus

Implementoval som bonusovú kontajnerizáciu s tromi stagmi podľa zadania.

Použitie:

```
#Build
docker build --target build   -t flp-fun:build .
docker build --target test    -t flp-fun:test .
docker build --target runtime -t flp-fun .

#Test
docker run --rm \
  -v "$PWD/example_sol_tests":/tests:ro \
  -v "$PWD/dummy-parser.py":/bin/parser:ro \
  -v "$PWD/dummy-interpreter.py":/bin/interp:ro \
  flp-fun -p /bin/parser -t /bin/interp /tests
```
