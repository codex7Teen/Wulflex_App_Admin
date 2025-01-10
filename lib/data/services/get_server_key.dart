import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  Future<String> getServerKeyToken() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "wulflex",
          "private_key_id": "1834e52b2c80d1c75f1127e6809c1bf47d496006",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCUx3JBQgb+u2zu\n1GolaQB/+xgjOd5GjTL1Sl+qfO5uZZq4Xmad/2xSJ93taE9Jd8JOYXKkpdpdU07h\nZZX0/hzegW7WiZ4aeBbiiuequKTq7fW8FWbYVa2nNKzI4uzXrTRwjO72qEiajvUh\ndhb3JzNgqt9jx25tCoBArG/R1IsDNWbXAsEL9oD3l2nAG1x5mZDprKDSlZVixFRj\nkbpiE23zXGYLW1T/VXdOIyHY6jCYA0S2EY2+J5VDJLjumEuFM6b9vTwoohl1xRb+\nwJvXuqP31Wsza8E7p1E5CVqw9O+lKkaCc7Ocd+ONcuyrD4Bl0lS+K1BDFWXCom6b\nTR5si0qfAgMBAAECggEALdOTN1OZqPvdLWFjQpupqkIS6MLJ2uxiHljmx7JMlNea\nBSEatZ735ARgoOBIz8XiJVdxwxJNBQMEoHu0aW6eQNEYbV+dQeTsk6IagqT2M2DR\nmLn04DzfzMl2UThIoJQ6u1JFxtcF6gmPqttfboh2FFf9kBPdSRv7bjBPDxBLM1TW\n2oU01UWSB959Nas6SifKmtA6ad1SMhJ4AKzHtsAATXJExWjw/QwI+ARny2swe56U\nmHYiyauRbkj3ohYNJd/EMRyi6HMQDBcZIa38gt8sV9fd2xnenmi8XKl0VhvqJxH0\njUvxCuviW+3oZJjcmzWnU96KhFilE0ppnJDq/NpSlQKBgQDEC0lYTEZngooSJL8H\nmg0XoC0dqurMvWdJHZ2QJuVBbMR6m1qgEUVQl0SxxcWHQHT989ycUkcrkcvRAvAC\nZUPUtDZ9NCxF6B5qhouN8PzL+rLKWSQjBoJ3UpTWgdo5KFa/OihhTDra+4GIhmMh\nLBrRfrj2MkH1J9NQQlSVA7KyswKBgQDCR65iXsGXDtfmfXU58E5+q07jPKvkhZMX\nuZNy9ejzMTgTHC4aMzxAdSW5aMBjYRd1W25YA0eIfgNMgu3frVBff/2Cm5ZELY2m\nWnrQbAsawGs0E06DmqaEv/zGfVw18hYuoKKkyndKM1IxdErcBoyPJJ0g97UrZrms\nygWZKCcOZQKBgGSDKOKlkL9HVYUB5BOAr0+6pwb795BrV4ZMMdmTp50IqB/4gNlq\noXA1bln6/VBgAtulaSmYoba79JS//dAsnT9z+i/tTPm2jcmuG+T1dpcafQpz86wl\njUSiSX9Fal49yWQX7FYeYFqf8oTN6gs68rEQWMKZd+m6toQCzhzsnXUzAoGBAKTr\nlpP43htuRUZq/6U0Yl3S7D+oFD8ESO5d4VY4fAxdnr1SMayaC66oA2MWEiMKm5BL\nEitydTnfxssfZfB3vn+jNb+2dePgS5uIuTLOVMrbxuVI8mBzWqHcHCce6bT9kWj5\ngbekC4mYcVB76MRIZu9oZF5FCK0UIdAVGpV96VGlAoGBAKCwQBBzJ7HXKz903noU\nzODchufugWkt6z0Ty/Q3bIM8L+aoMkpipfWte4buX6ai2Ir0/7tfCaPRwkIOmOZ/\njp5A5szrvMrEHu1jLj3QzZ4rwKg3jMR9K45r6+MWAGEFvCPhjgxV7vrU962uDsd5\ndJ1X2jt729Crhnu4PElcYpnf\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-zoa3s@wulflex.iam.gserviceaccount.com",
          "client_id": "109187672136304485637",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-zoa3s%40wulflex.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        scopes);
    final accessServerKey = client.credentials.accessToken.data;
    return accessServerKey;
  }
}