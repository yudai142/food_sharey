# render.com × Neon.tech 最終設定ガイド

## 🔴 現在のエラー

```
ERROR: channel binding required but not supported by server's authentication request
```

**原因:** Neon.tech の最新認証（SCRAM-SHA-256 with channel binding）と pg gem の互換性問題

**解決策:** DATABASE_URL に `channel binding disable` オプションを追加

---

## ✅ 実施済み本対応

1. ✅ pg gem を 1.4.6 にアップデート
2. ✅ config/database.yml を修正
3. ✅ Dockerfile に libpq インストール済み

---

## 🚀 render.com で実施する設定（最重要）

### ステップ1: Neon.tech で Connection String を取得

https://console.neon.tech → Connection String をコピー

**例:**
```
postgresql://neon_user:password@ep-xxx-region.neon.tech/food_diary_production
```

### ステップ2: Connection String にオプションを追加

**最初の形式:**
```
postgresql://neon_user:password@ep-xxx-region.neon.tech/food_diary_production?sslmode=require&options=--scram-channel-binding%3Ddisable
```

**パラメータ解説:**
- `sslmode=require` - SSL 必須
- `options=--scram-channel-binding%3Ddisable` - チャネルバインディング無効化
  - `%3D` は URL エンコードされた `=` です

### ステップ3: render.com で環境変数を設定

**Dashboard → Select Web Service → Settings → Environment**

| 環境変数名 | 値 | 説明 |
|-----------|-----|------|
| `DATABASE_URL` | `postgresql://neon_user:password@ep-xxx-region.neon.tech/food_diary_production?sslmode=require&options=--scram-channel-binding%3Ddisable` | **このフォーマットで設定** |
| `PGOPTIONS` | `--scram-channel-binding=disable` | PostgreSQL オプション（代替案） |
| `SECRET_KEY_BASE` | `<bundle exec rails secret の出力>` | ランダム文字列 |
| `RAILS_ENV` | `production` | 固定 |
| `NODE_ENV` | `production` | 固定 |

**どちらか一つ選んでください:**

#### 方法A: DATABASE_URL に含める（推奨）
```
postgresql://user:pass@host/db?sslmode=require&options=--scram-channel-binding%3Ddisable
```

#### 方法B: 別環境変数で指定
```
DATABASE_URL=postgresql://user:pass@host/db?sslmode=require
PGOPTIONS=--scram-channel-binding=disable
```

---

## 🔍 Neon.tech Connection String のチェック

render.com に設定する前に、以下を確認：

- [ ] `postgresql://` で始まるか
- [ ] ユーザー名 (コロンの前) を含むか
- [ ] パスワード (コロンの後ろ) を含むか
- [ ] データベース名が `food_diary_production` か
- [ ] **`?sslmode=require&options=--scram-channel-binding%3Ddisable` を含むか** ⚠️

---

## 📝 Connection String 例

### ❌ 間違い

```
postgresql://user:pass@ep-xxx.neon.tech/food_diary_production
```

### ✅ 正しい形式（推奨）

```
postgresql://user:pass@ep-xxx.neon.tech/food_diary_production?sslmode=require&options=--scram-channel-binding%3Ddisable
```

---

## SECRET_KEY_BASE の生成

ローカルで実行：

```bash
cd /Users/yudai/Desktop/food_sharey
bundle exec rails secret
```

**出力例:**
```
a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z
```

このランダム値を render.com の `SECRET_KEY_BASE` に設定

---

## 🔄 デプロイフロー

```bash
# ローカルで最新コミット
git add .
git commit -m "Configure Neon.tech with channel binding disable"
git push origin main

# render.com 自動デプロイ実行
# 1. Docker ビルド
# 2. rails db:create
# 3. rails db:migrate
# 4. Puma 起動
```

---

## ✔️ デプロイ后の確認

render.com Logs を確認：

### ✅ 成功時
```
Creating database if not exists...
Database 'food_diary_production' already exists
Running database migrations...
(migration messages)
Puma starting in single mode...
* Listening on http://0.0.0.0:10000
```

### ❌ 失敗時のチェック
```
channel binding required...
→ DATABASE_URL の sslmode と channel binding オプションを确認
```

---

## 🆘 トラブルシューティング

### Q: "channel binding required" エラーが続く

```
A: render.com の DATABASE_URL に以下が含まれているか確認：
   - ?sslmode=require
   - &options=--scram-channel-binding%3Ddisable
   
   全体のフォーマット：
   postgresql://user:pass@host/db?sslmode=require&options=--scram-channel-binding%3Ddisable
```

### Q: "could not find your database"

```
A: Neon.tech で food_diary_production データベースが作成されているか確認
```

### Q: パスワードに特殊文字がある

```
A: URL エンコード必須：
   @ → %40
   : → %3A
   ? → %3F
   # → %23
   
   例: pass@word123 → pass%40word123
```

---

## 📌 最重要ポイント

1. **DATABASE_URL は環境変数で管理** - ソースコードに記述しない
2. **`?sslmode=require&options=--scram-channel-binding%3Ddisable` 必須** - このオプションなしではNeon.techに接続不可
3. **SECRET_KEY_BASE はランダム値** - `bundle exec rails secret` で毎回異なる値
4. **Gemfile.lock をコミット** - render.com が指定されたバージョンを使用

---

## 次のアクション

1. ✅ Gemfile と config/database.yml 修正完了
2. → **Neon.tech で Connection String を確認**
3. → **Connection String にオプションを追加**
4. → **render.com で4つの環境変数を設定**
5. → **Git push してデプロイ待機**
6. → **Logs を確認して成功を確認**

