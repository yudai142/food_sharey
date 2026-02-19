# render.com × Neon.tech PostgreSQL 接続設定チェックリスト

## 🔴 現在のエラー状況

```
ERROR:  connection is insecure (try using `sslmode=require`)
```

**原因:** render.com の環境変数 `DATABASE_URL` に `?sslmode=require` が**含まれていない**

---

## ✅ 実施済み修正

### 1️⃣ pg gem をアップデート ✓

```ruby
# Gemfile
gem 'pg', '~> 1.4.0'  # Ruby 2.7 compatible
```

**Gemfile.lock も更新済み**: pg 1.4.6 がインストール完了

### 2️⃣ config/database.yml 設定済み ✓

```yaml
production:
  url: <%= ENV['DATABASE_URL'] %>
```

---

## 🚀 **render.com で実施すべき手順（重要）**

### ステップ1: Neon.tech で Connection String を取得

1. https://console.neon.tech にログイン
2. プロジェクトを開く
3. **Connection** → **Connection string** をコピー

**Neon.tech の接続文字列例:**
```
postgresql://user:password@ep-xxx-region.region.neon.tech/food_diary_production
```

### ステップ2: Connection String を修正して `sslmode=require` を追加

**重要：末尾に `?sslmode=require` を追加**

```
postgresql://user:password@ep-xxx-region.region.neon.tech/food_diary_production?sslmode=require
```

### ステップ3: render.com 環境変数を設定

**Dashboard → Select Your Web Service → Environment**

以下を設定：

| 環境変数名 | 値 | 説明 |
|-----------|-----|------|
| `DATABASE_URL` | `postgresql://user:password@ep-xxx-region.region.neon.tech/food_diary_production?sslmode=require` | **末尾の `?sslmode=require` 必須** |
| `SECRET_KEY_BASE` | `12345abc...` (長いランダム文字列) | `bundle exec rails secret` で生成 |
| `RAILS_ENV` | `production` | 固定値 |
| `NODE_ENV` | `production` | 固定値 |

### ステップ4: SECRET_KEY_BASE を生成

ローカルで実行：
```bash
cd /Users/yudai/Desktop/food_sharey
bundle exec rails secret
```

**出力例:**
```
f3a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z
```

このランダムな値を render.com の `SECRET_KEY_BASE` に設定

---

## 🔍 **DATABASE_URL チェックリスト**

設定する前に以下を確認してください：

- [ ] `postgresql://` で始まっているか
- [ ] Neon.tech のユーザー名が含まれているか
- [ ] Neon.tech のパスワードが含まれているか
- [ ] データベース名が `food_diary_production` か
- [ ] **末尾に `?sslmode=require` が含まれているか** ✅ **これが最重要！**

**❌ 間違った形式:**
```
postgresql://user:password@ep-xxx-region.region.neon.tech/food_diary_production
```

**✅ 正しい形式:**
```
postgresql://user:password@ep-xxx-region.region.neon.tech/food_diary_production?sslmode=require
```

---

## 📝 Neon.tech のパスワードに特殊文字がある場合

パスワードに `@`, `:`, `?`, `#` などの特殊文字がある場合、**URL エンコード**が必要です。

**例:**
- `@` → `%40`
- `:` → `%3A`
- `?` → `%3F`
- `#` → `%23`

Python で URL エンコード：
```python
from urllib.parse import quote
password = "your_password@#123"
encoded = quote(password, safe='')
print(encoded)  # your_password%40%23123
```

---

## 🔄 デプロイフロー

1. ✅ Gemfile を修正（pg 1.4.0）
2. ✅ Gemfile.lock を更新
3. → **Git コミット & Push**
   ```bash
   git add Gemfile Gemfile.lock
   git commit -m "Update pg gem to 1.4.6 for Neon.tech compatibility"
   git push origin main
   ```
4. → **render.com で環境変数を設定**（上記のステップ3）
5. → **render.com が自動デプロイを実行**
   - Docker イメージをビルド
   - `rails db:create` を実行
   - `rails db:migrate` を実行
   - Puma サーバーを起動

---

## ✔️ デプロイ後の確認

render.com の **Logs** タブで以下を確認：

✅ データベース作成成功
```
Creating database if not exists...
Database 'food_diary_production' already exists
```

✅ マイグレーション成功
```
Running database migrations...
== (日時) ...
== (migration 完了メッセージ)
```

✅ Puma 起動成功
```
Puma starting in single mode...
*  Listening on http://0.0.0.0:PORT
```

---

## 🆘 トラブルシューティング

### Q: "connection is insecure" エラーが出たまま

```
A: DATABASE_URL の末尾に ?sslmode=require がないか確認してください
   - render.com の Settings → Environment で確認
   - DATABASE_URL 全体をコピーして確認
```

### Q: "could not find your database" エラー

```
A: 以下を確認：
   1. データベース名が food_diary_production か
   2. Neon.tech でデータベースが作成されているか
   3. パスワードが正しいか
```

### Q: "authentication failed" エラー

```
A: Neon.tech のユーザー名とパスワードを確認：
   - Neon.tech console で "Connection details" を再確認
   - パスワードに特殊文字がある場合は URL エンコード必須
```

---

## 📌 重要なポイント

1. **DATABASE_URL は環境変数で指定** - Gemfile, config/database.yml には記述しない
2. **`?sslmode=require` は必須** - Neon.tech との SSL 接続に必要
3. **SECRET_KEY_BASE はランダム値** - `bundle exec rails secret` で毎回異なる値が出力される
4. **Gemfile.lock をコミット必須** - render.com が提供されたバージョンを使用

---

## 次のアクション

1. Neon.tech で Connection String（`?sslmode=require` 付き）を取得
2. render.com で上記3つの環境変数を設定
3. Git push して自動デプロイを待つ
4. render.com Logs で確認
