#!/usr/bin/env python3
import re

# ファイルを読む
with open('food_diary_production_postgres_dbeaver.sql', 'r') as f:
    content = f.read()

# テーブルごとのセクション抽出
tables = {}
lines = content.split('\n')
current_table = None
current_lines = []

for line in lines:
    match = re.match(r'DROP TABLE IF EXISTS "([^"]+)" CASCADE;', line)
    if match:
        # 前のテーブルを保存
        if current_table:
            tables[current_table] = current_lines
        current_table = match.group(1)
        current_lines = [line]
    else:
        current_lines.append(line)

# 最後のテーブルを保存
if current_table:
    tables[current_table] = current_lines

# テーブルの順序を定義
table_order = [
    'ar_internal_metadata',
    'schema_migrations',
    'users',
    'eatdates',
    'mymenus',
    'foods',
    'eatdate_likes',
    'mymenu_likes'
]

# 修正ファイルを作成
with open('food_diary_production_postgres_dbeaver_fixed.sql', 'w') as f:
    for table_name in table_order:
        if table_name in tables:
            for line in tables[table_name]:
                f.write(line + '\n')
            f.write('\n')

print("修正完了！テーブル順序:")
for i, table_name in enumerate(table_order, 1):
    status = "✓ 含まれています" if table_name in tables else "✗ 見つかりません"
    print(f"{i}. {table_name} {status}")
