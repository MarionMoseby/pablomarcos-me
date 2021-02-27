import os

directory = r'./'
subdirs = [x[0] for x in os.walk('.')]
for dirname in subdirs:
    if dirname != "." :
        os.rename("./{}/index.md".replace("{}", dirname), "./{}/index.es.md".replace("{}", dirname))
