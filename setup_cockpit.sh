#!/bin/bash

# rootユーザーで実行されているか確認
if [ "$EUID" -ne 0 ]; then
  echo "このスクリプトはrootユーザーで実行してください。" >&2
  exit 1
fi

echo "Cockpitのインストールを開始します..."

# Cockpitのインストール
echo "1. dnf install cockpit -y"
dnf install cockpit -y
if [ $? -ne 0 ]; then
  echo "dnf install cockpit に失敗しました。" >&2
  exit 1
fi

# Cockpitサービスの有効化と起動
echo "2. systemctl enable --now cockpit.socket"
systemctl enable --now cockpit.socket
if [ $? -ne 0 ]; then
  echo "systemctl enable --now cockpit.socket に失敗しました。" >&2
  exit 1
fi

# ファイアウォール設定の追加
echo "3. firewall-cmd --permanent --add-service=cockpit"
firewall-cmd --permanent --add-service=cockpit
if [ $? -ne 0 ]; then
  echo "ファイアウォール設定の追加に失敗しました。" >&2
  exit 1
fi

# ファイアウォール設定のリロード
echo "4. firewall-cmd --reload"
firewall-cmd --reload
if [ $? -ne 0 ]; then
  echo "ファイアウォール設定のリロードに失敗しました。" >&2
  exit 1
fi

echo "Cockpitのインストールと設定が完了しました！"