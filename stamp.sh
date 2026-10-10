#!/bin/sh
# Setzt die sichtbare Fassung auf den aktuellen Zeitpunkt (Wien).
STAND=$(TZ=Europe/Vienna date '+%-d.%-m. %H:%M')
python3 -I - "$STAND" <<'PY'
import re,sys
st=sys.argv[1]; p='index.html'; s=open(p,encoding='utf-8').read()
s=re.sub(r"el\('ver'\)\.textContent='Fassung [^']*';",
         "el('ver').textContent='Fassung "+st+"';", s, count=1)
open(p,'w',encoding='utf-8').write(s)
print('Fassung', st)
PY
