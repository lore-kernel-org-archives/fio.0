Return-Path: <fio-owner@vger.kernel.org>
Received: from g9t1613g.houston.hpe.com ([15.241.32.99]:58408 "EHLO
        g9t1613g.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725752AbeKJGD6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 10 Nov 2018 01:03:58 -0500
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com [15.241.140.75])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g9t1613g.houston.hpe.com (Postfix) with ESMTPS id F370261668
        for <fio@vger.kernel.org>; Fri,  9 Nov 2018 20:21:47 +0000 (UTC)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: rand-read: increasing iodepth makes throughput drop
Date: Fri, 9 Nov 2018 20:21:21 +0000
Message-ID: <AT5PR8401MB116917F29EA34E175EAA2A08ABC60@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <09b20693-8e0c-2ca9-97b3-51674177f19c@willer.it>
 <AT5PR8401MB116955F32C7A59FB0494F505ABF70@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <a26c6cc6-3efe-cbf8-37c7-f52672179b79@willer.it>
 <MWHPR04MB03204694EB4A9074B9D5A4228FCD0@MWHPR04MB0320.namprd04.prod.outlook.com>
 <38550f9e-63ba-cfc4-d8eb-5314d0647fd9@willer.it>
 <CALjAwxh=CDGp6agq=7hisWvAJfGWKH9mpjQDq=FUb-VpJXS+6A@mail.gmail.com>
 <64b2647f-4644-c4ed-ee44-6f571d037e50@willer.it>
In-Reply-To: <64b2647f-4644-c4ed-ee44-6f571d037e50@willer.it>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 'Federico Motta' <federico@willer.it>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Jeff Furlong <jeff.furlong@wdc.com>, fio <fio@vger.kernel.org>, Paolo Valente <paolo.valente@linaro.org>, "mark.brown@linaro.org" <mark.brown@linaro.org>, "linus.walleij@linaro.org" <linus.walleij@linaro.org>, "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRmVkZXJpY28gTW90dGEg
W21haWx0bzpmZWRlcmljb0B3aWxsZXIuaXRdDQo+IFNlbnQ6IEZyaWRheSwgTm92ZW1iZXIgOSwg
MjAxOCAzOjMxIEFNDQo+IFRvOiBTaXRzb2ZlIFdoZWVsZXIgPHNpdHNvZmVAZ21haWwuY29tPg0K
PiBDYzogSmVmZiBGdXJsb25nIDxqZWZmLmZ1cmxvbmdAd2RjLmNvbT47IEVsbGlvdHQsIFJvYmVy
dCAoUGVyc2lzdGVudCBNZW1vcnkpIDxlbGxpb3R0QGhwZS5jb20+OyBmaW8NCj4gPGZpb0B2Z2Vy
Lmtlcm5lbC5vcmc+OyBQYW9sbyBWYWxlbnRlIDxwYW9sby52YWxlbnRlQGxpbmFyby5vcmc+OyBt
YXJrLmJyb3duQGxpbmFyby5vcmc7DQo+IGxpbnVzLndhbGxlaWpAbGluYXJvLm9yZzsgdWxmLmhh
bnNzb25AbGluYXJvLm9yZw0KPiBTdWJqZWN0OiBSZTogcmFuZC1yZWFkOiBpbmNyZWFzaW5nIGlv
ZGVwdGggbWFrZXMgdGhyb3VnaHB1dCBkcm9wDQo+ID4+IE9uIDEwLzMxLzE4IDM6MTkgUE0sIEZl
ZGVyaWNvIE1vdHRhIHdyb3RlOg0KPiA+PiAuLi4NCj4gPj4+IElzIGl0IHBvc3NpYmxlIHRvIGFz
ayBmaW8gYSBtZWFzdXJlIG9mICJob3cgbXVjaCBkZXZpY2UgaW50ZXJuYWwNCj4gPj4gcXVldWVz
IGFyZSBmaWxsZWQiPw0KPiA+Pj4gSWYgeWVzLCB3aXRoIHdoaWNoIG9wdGlvbihzKT8NCj4gPj4+
IElmIG5vdCwgZG8geW91IGtub3cgc29tZSBvdGhlciB0b29scyBvciBwcm9jZWR1cmVzIHdoaWNo
IGNhbiB0ZWxsIHVzIHRoYXQ/DQo+ID4+DQo+ID4+IERvZXMgc29tZWJvZHkgaGFzIGlkZWFzIGFi
b3V0IHRoYXQgXiAgPw0KPiA+DQo+ID4gLi4uSSB0aGluayBpb3N0YXQgcHJvZHVjZXMgc2ltaWxh
ciBvdXRwdXQgdG8gdGhhdCB0b28uLi4NCj4gPg0KPiANCj4gQWN0dWFsbHkgSSB3YXMgd29uZGVy
aW5nIGlmIGEgbW9yZSBkaXJlY3Qgb3IgbG93IGxldmVsIG1lYXN1cmUgZXhpc3RzLA0KPiBidXQg
c2luY2UgSSBkb24ndCBldmVuIGtub3cgaWYgdGhhdCBpcyBwb3NzaWJsZSBJIHRoaW5rIHRoZSBm
aW8gInV0aWwiDQo+IHBlcmNlbnRhZ2UgY291bGQgYmUgYSBnb29kIHRyYWRlLW9mZiBiZXR3ZWVu
ICJhIGxvdyBsZXZlbCBtZWFzdXJlIiBhbmQNCj4gIm5vIG1lYXN1cmUgYXZhaWxhYmxlIi4NCg0K
SW4gbGludXgsIGlvc3RhdCBwcm92aWRlcyBzb21lIHN0YXRpc3RpY3MsIGFuZCB0aGVyZSBhcmUg
bG90cyBvZiBtb3JlIGRldGFpbGVkDQpxdWV1aW5nIHN0YXRpc3RpY3MgaW4gc3lzZnMuIFNvbWUg
YXJlIHByb3ZpZGVkIGJ5IHRoZSBibG9jayBsYXllcjsgc29tZSBieSB0aGUNClNDU0kgbWlkbGF5
ZXIgKGZvciBTQ1NJIGRldmljZXMpOyBzb21lIGJ5IHRoZSBsb3ctbGV2ZWwgZHJpdmVyIChsaWtl
IGhwc2EpLg0KDQoNCiMgbnJfcmVxdWVzdHMsIHRoZSBibG9jayBsYXllciByZXF1ZXN0IHF1ZXVl
IGRlcHRoDQovc3lzL2Jsb2NrLyRkZXZpY2UvcXVldWUvbnJfcmVxdWVzdHMNCg0KIyBxdWV1ZV9k
ZXB0aCwgdGhlIFNDU0kgbWlkbGF5ZXIgcXVldWUgZGVwdGgNCi9zeXMvYmxvY2svJGRldmljZS9k
ZXZpY2UvcXVldWVfZGVwdGgNCg0KIyBjYW5fcXVldWUgc2V0cyB0aGUgaW5pdGlhbCByZXF1ZXN0
IHF1ZXVlIHNpemUNCi9zeXMvY2xhc3Mvc2NzaV9ob3N0LyRzY3NpX2hvc3QvY2FuX3F1ZXVlDQoN
CiMgY21kX3Blcl9sdW4gc2V0cyB0aGUgaW5pdGlhbCBxdWV1ZV9kZXB0aA0KL3N5cy9jbGFzcy9z
Y3NpX2hvc3QvJHNjc2lfaG9zdC9jbWRfcGVyX2x1bg0KDQojIGhvc3RfYnVzeSBpbmRpY2F0ZXMg
aG93IG1hbnkgY29tbWFuZHMgYXJlIHF1ZXVlZCBieSB0aGUgU0NTSSBsYXllcg0KL3N5cy9jbGFz
cy9zY3NpX2hvc3QvJHNjc2lfaG9zdC9ob3N0X2J1c3kNCg0KIyBob3N0X2Jsb2NrZWQgaW5kaWNh
dGVzIHRoZSBob3N0IGlzIGJsb2NraW5nIGFsbCBJT3MNCi9zeXMvY2xhc3Mvc2NzaV9ob3N0LyRz
Y3NpX2hvc3QvaG9zdF9ibG9ja2VkDQoNCiMgaHBzYSBpb2FjY2VsIGNvbW1hbmRzIG91dHN0YW5k
aW5nDQovc3lzL2Jsb2NrLyRkZXZpY2UvZGV2aWNlL2hwc2FfaW9hY2NlbF9jbWRzX291dA0KDQoj
IGhwc2EgcGh5c2ljYWwgZHJpdmUgcXVldWUgZGVwdGgNCi9zeXMvYmxvY2svJGRldmljZS9kZXZp
Y2UvaHBzYV9xdWV1ZV9kZXB0aA0KDQojIGhwc2EgY29tbWFuZHNfb3V0c3RhbmRpbmcgZnJvbSBz
dWJtaXNzaW9uIHRvIGNvbXBsZXRpb24NCi9zeXMvY2xhc3Mvc2NzaV9ob3N0LyRzY3NpX2hvc3Qv
Y29tbWFuZHNfb3V0c3RhbmRpbmcNCg0KVGhlcmUgYXJlIGEgYnVuY2ggb2YgYmxrLW1xIHN0YXRz
IHRvbywgc29tZSBvbmx5IHNob3duIGlmIGRlYnVnZnMgaXMgZW5hYmxlZC4NCg0K

