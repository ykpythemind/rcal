# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About

rcal はGoogleカレンダーと連携するタスク管理ツール。「r」から始まるイベントを作成すると、削除するまで自動で2時間後にリスケジュールされ続ける。

## Commands

```bash
bin/dev                    # 開発サーバ起動 (Puma + Tailwind watch)
bin/setup --skip-server    # 初期セットアップ
bin/rails test             # 全テスト実行
bin/rails test test/models/google_calendar_event_test.rb       # 単一ファイル
bin/rails test test/models/google_calendar_event_test.rb:10    # 単一テスト (行指定)
bin/rubocop                # Lint (rubocop-rails-omakase)
bin/ci                     # CI全体 (rubocop + brakeman + importmap audit + test + seed)
```

## Architecture

Rails 8.1 / Ruby 3.4.1 / SQLite / Kamal deploy

### Core Domain Flow

1. OmniAuth Google OAuth2 でログイン → `GoogleCallbacksController` でユーザー作成・トークン保存
2. ユーザーがカレンダーを選択 → `GoogleCalendars::SetupController` でWebhook登録 + 初回同期
3. Google Calendar からの push notification → `Webhook::CalendarEventsController` → `SyncGoogleCalendarEventsJob` で差分同期 (sync token使用)
4. Solid Queue の recurring task (`Scheduler.call`, 5分毎) → `RescheduleJob` で期限切れの「r」イベントを2時間後にリスケジュール

### Models

- `User` → `GoogleAccessToken` (1:1, OAuth tokens, auto-refresh)
- `User` → `GoogleCalendar` (1:N, webhook channel管理) → `GoogleCalendarEvent` (1:N)
- `GoogleCalendarEvent` → `GoogleCalendarEventReschedule` (1:N, リスケ履歴)
- `Notification` — トークン失効時の再認証通知

### Key Business Logic

- **リスケジュール規則** (`GoogleCalendarEvent#reschedule`): end_at + 2時間。深夜0-8時台は翌朝9時、23時台は翌日9時に移動
- **同期時の🔄付与**: 「r」で始まるイベントに初回同期時のみ🔄絵文字をタイトルに追加
- **暗号化**: メールアドレス (deterministic) とイベントsummary は Active Record Encryption で暗号化

### Background Jobs

- `SyncGoogleCalendarEventsJob` — Google Calendar差分同期
- `RescheduleJob` — 期限切れイベントのリスケジュール
- `RefreshCalendarWatchJob` — Webhook channel有効期限の更新 (期限30分前)

Solid Queue は Puma plugin として同一プロセスで動作 (`SOLID_QUEUE_IN_PUMA=true`)。

### Frontend

Tailwind CSS + Turbo Rails + Import Maps。Node.js不要。

### Development

ローカル開発時はngrokでwebhookをトンネルし、`HOST` 環境変数にホスト名を設定する。Google Cloud ConsoleでOAuth認証情報 (`GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`) の設定が必要。
