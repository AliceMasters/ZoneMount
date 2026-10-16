import json,sys
p="tools/curated.json"
c=json.load(open(p,encoding="utf8"))
upd=json.loads(sys.stdin.read())
c.update({str(k):v for k,v in upd.items()})
json.dump(c,open(p,"w",encoding="utf8"),indent=0,ensure_ascii=False)
print("curated entries:",len(c))
