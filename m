Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Fri, 4 Sep 2015 22:18:10 +0300
Message-ID: <CANvN+enkXyJPKpsg00vOm6A3e25NYYmH1W_w5dO+vOeNvEBVVw@mail.gmail.com>
Subject: Wee nit in backend.c
Content-Type: multipart/alternative; boundary=f46d04462e6acd9127051ef0c33a
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--f46d04462e6acd9127051ef0c33a
Content-Type: text/plain; charset=UTF-8

diff --git a/backend.c b/backend.c
index 80bd361..fec423e 100644
--- a/backend.c
+++ b/backend.c
@@ -539,7 +539,7 @@ sync_done:
                        *ret = ret2;
                break;
        default:
-               assert(ret < 0);
+               assert(*ret < 0);
                td_verror(td, -(*ret), "td_io_queue");
                break;
        }

Regards,
Andrey

--f46d04462e6acd9127051ef0c33a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+ZGlmZiAtLWdpdCBhL2JhY2tlbmQuYyBiL2JhY2tlbmQuYzxicj5pbmRl
eCA4MGJkMzYxLi5mZWM0MjNlIDEwMDY0NDxicj4tLS0gYS9iYWNrZW5kLmM8YnI+KysrIGIvYmFj
a2VuZC5jPGJyPkBAIC01MzksNyArNTM5LDcgQEAgc3luY19kb25lOjxicj7CoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAqcmV0ID0gcmV0Mjs8YnI+wqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgYnJlYWs7PGJyPsKgIMKgIMKgIMKgIGRlZmF1bHQ6PGJyPi0gwqAgwqAgwqAgwqAgwqAg
wqAgwqAgYXNzZXJ0KHJldCAmbHQ7IDApOzxicj4rIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGFzc2Vy
dCgqcmV0ICZsdDsgMCk7PGJyPsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHRkX3ZlcnJvcih0ZCwg
LSgqcmV0KSwgJnF1b3Q7dGRfaW9fcXVldWUmcXVvdDspOzxicj7CoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCBicmVhazs8YnI+wqAgwqAgwqAgwqAgfTxicj48YnI+UmVnYXJkcyw8YnI+QW5kcmV5PC9k
aXY+DQo=
--f46d04462e6acd9127051ef0c33a--

