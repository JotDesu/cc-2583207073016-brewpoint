-- BrewPoint: skema SQLite (M05). Harga dalam rupiah bulat (INTEGER), tanpa pecahan.
-- Jalankan: sqlite3 data/brewpoint.db < db/schema.sql   (aman diulang: IF NOT EXISTS)
PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS users (
  id            INTEGER PRIMARY KEY,
  username      TEXT    NOT NULL UNIQUE,
  password_hash TEXT    NOT NULL,
  role          TEXT    NOT NULL CHECK (role IN ('kasir','pemilik')),
  is_active     INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0,1)),
  created_at    TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);

CREATE TABLE IF NOT EXISTS menu_items (
  id         INTEGER PRIMARY KEY,
  name       TEXT    NOT NULL UNIQUE,
  price_rp   INTEGER NOT NULL CHECK (price_rp >= 0),
  stock      INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),   -- stok tidak boleh negatif
  is_active  INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0,1)),
  updated_at TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);

CREATE TABLE IF NOT EXISTS orders (
  id              INTEGER PRIMARY KEY,
  idempotency_key TEXT    NOT NULL UNIQUE,                    -- cegah submit ganda
  cashier_id      INTEGER NOT NULL REFERENCES users(id),
  status          TEXT    NOT NULL DEFAULT 'paid' CHECK (status IN ('paid','void','refund')),
  total_rp        INTEGER NOT NULL CHECK (total_rp >= 0),
  created_at      TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);

CREATE TABLE IF NOT EXISTS order_items (
  id           INTEGER PRIMARY KEY,
  order_id     INTEGER NOT NULL REFERENCES orders(id),
  menu_item_id INTEGER NOT NULL REFERENCES menu_items(id),
  qty          INTEGER NOT NULL CHECK (qty > 0),
  unit_price_rp INTEGER NOT NULL CHECK (unit_price_rp >= 0)   -- harga disalin saat transaksi (harga historis)
);

CREATE TABLE IF NOT EXISTS audit_log (
  id         INTEGER PRIMARY KEY,
  actor_id   INTEGER REFERENCES users(id),
  action     TEXT NOT NULL,          -- mis. price_change, void, refund, stock_adjust, login_fail
  entity     TEXT NOT NULL,
  entity_id  INTEGER,
  detail     TEXT,                   -- JSON: nilai lama/baru
  created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);

CREATE INDEX IF NOT EXISTS idx_orders_created  ON orders(created_at);
CREATE INDEX IF NOT EXISTS idx_items_order     ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_audit_created   ON audit_log(created_at);

-- Baris transaksi tidak boleh diubah/dihapus (harga historis aman); koreksi lewat void/refund + audit.
CREATE TRIGGER IF NOT EXISTS trg_items_no_update BEFORE UPDATE ON order_items
BEGIN SELECT RAISE(ABORT,'order_items immutable'); END;
CREATE TRIGGER IF NOT EXISTS trg_items_no_delete BEFORE DELETE ON order_items
BEGIN SELECT RAISE(ABORT,'order_items immutable'); END;
-- Audit tidak boleh diubah/dihapus.
CREATE TRIGGER IF NOT EXISTS trg_audit_no_update BEFORE UPDATE ON audit_log
BEGIN SELECT RAISE(ABORT,'audit_log immutable'); END;
CREATE TRIGGER IF NOT EXISTS trg_audit_no_delete BEFORE DELETE ON audit_log
BEGIN SELECT RAISE(ABORT,'audit_log immutable'); END;
