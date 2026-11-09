#!/usr/bin/env python3
"""Buat database BrewPoint + data menu sintetis. Password TIDAK ditulis di repo:
dibaca dari env BREW_OWNER_PW / BREW_KASIR_PW, atau dibuat acak dan dicetak SEKALI.
Pakai: BREW_DB=/srv/cc-m03/data/brewpoint.db python3 db/init_db.py"""
import os, sqlite3, secrets, pathlib
from werkzeug.security import generate_password_hash

DB = os.environ.get("BREW_DB", "data/brewpoint.db")
SCHEMA = pathlib.Path(__file__).with_name("schema.sql").read_text()
pathlib.Path(DB).parent.mkdir(parents=True, exist_ok=True)

con = sqlite3.connect(DB)
con.execute("PRAGMA journal_mode=WAL")          # persisten di file DB
con.executescript(SCHEMA)
menu = [("Espresso",18000,50),("Americano",20000,50),("Latte",26000,40),
        ("Cappuccino",26000,40),("Es Kopi Susu",22000,60),("Croissant",24000,20)]  # data sintetis
con.executemany("INSERT OR IGNORE INTO menu_items(name,price_rp,stock) VALUES (?,?,?)", menu)
for user, role, env in (("pemilik","pemilik","BREW_OWNER_PW"),("kasir1","kasir","BREW_KASIR_PW")):
    if con.execute("SELECT 1 FROM users WHERE username=?", (user,)).fetchone(): continue
    pw = os.environ.get(env) or secrets.token_urlsafe(12)
    if not os.environ.get(env): print(f"[SEKALI] password {user}: {pw}")
    con.execute("INSERT INTO users(username,password_hash,role) VALUES (?,?,?)",
                (user, generate_password_hash(pw), role))
con.commit(); con.close()
os.chmod(DB, 0o600)
print("OK:", DB)
