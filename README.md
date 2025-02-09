# rcal

https://rcal.ykpythemind.com/

- `rcal` はGoogleカレンダーと連携するタスク管理ツールです。
- `r` から始まるイベントを作ると、そのイベントを削除するまで延期され続けます。
- リマインダーアプリなどを使い分けることができない人間にどうぞ

## Setup

```
bin/setup --skip-server
```

## Development

```
bin/dev
```

### ngrok

```
ngrok http 3000

export HOST=xxx.ngrok.io
```

ngrokを用いてwebhookをローカルのサーバに到達できるようにする。HOST環境変数に払い出されたホスト名を設定しておく

### 認証情報

- Google Cloud Console -> APIとサービス -> Oauth同意画面
  - auth/calendar , openid, email, profileをscopeに追加
- 認証情報
  - 種類：Webアプリケーションで作成
  - 承認済みのリダイレクトURI
    - https://{HOST}/auth/google_oauth2/callback を設定
  - 払い出したClient情報をもとに GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRETを環境変数に設定

### Environment Variables

- GOOGLE_CLIENT_ID
- GOOGLE_CLIENT_SECRET
- HOST
- KAMAL_REGISTRY_PASSWORD (for production deploy)
- RAILS_MASTER_KEY (for production deploy)
