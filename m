Return-Path: <prvs=504bbfe5c=Aravind.Ramesh@wdc.com>
From: Aravind Ramesh <Aravind.Ramesh@wdc.com>
Subject: RE: [PATCH] zbd: don't read past the WP on a read only workload with
 verify
Date: Sun, 30 Aug 2020 06:14:25 +0000
Message-ID: 
 <BY5PR04MB6995B1B3B6874868E9910C028C500@BY5PR04MB6995.namprd04.prod.outlook.com>
References: <20200813150148.14655-1-niklas.cassel@wdc.com>
 <MN2PR04MB595192579EC087B4C9EAECE1E1550@MN2PR04MB5951.namprd04.prod.outlook.com>
 <0fc74fa5-69e8-7675-84bd-526a7ca11227@kernel.dk>
In-Reply-To: <0fc74fa5-69e8-7675-84bd-526a7ca11227@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBr
ZXJuZWwuZGs+DQo+IFNlbnQ6IFRodXJzZGF5LCBBdWd1c3QgMjcsIDIwMjAgMTE6NTggUE0NCj4g
VG86IERtaXRyeSBGb21pY2hldiA8RG1pdHJ5LkZvbWljaGV2QHdkYy5jb20+OyBmaW9Admdlci5r
ZXJuZWwub3JnDQo+IENjOiBEYW1pZW4gTGUgTW9hbCA8RGFtaWVuLkxlTW9hbEB3ZGMuY29tPjsg
TmlrbGFzIENhc3NlbA0KPiA8TmlrbGFzLkNhc3NlbEB3ZGMuY29tPjsgQXJhdmluZCBSYW1lc2gg
PEFyYXZpbmQuUmFtZXNoQHdkYy5jb20+Ow0KPiBTaGluaWNoaXJvIEthd2FzYWtpIDxzaGluaWNo
aXJvLmthd2FzYWtpQHdkYy5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIHpiZDogZG9uJ3Qg
cmVhZCBwYXN0IHRoZSBXUCBvbiBhIHJlYWQgb25seSB3b3JrbG9hZCB3aXRoDQo+IHZlcmlmeQ0K
PiANCj4gT24gOC8yNy8yMCAxMjowOSBQTSwgRG1pdHJ5IEZvbWljaGV2IHdyb3RlOg0KPiA+ICsg
SmVucy4uLiBhbmQgcGluZyBmb3IgdGhpcyBwYXRjaCwgSSBiZWxpZXZlIGl0IGhhcyB0d28gcmV2
aWV3cyBieSBub3cuDQo+IA0KPiBZZXAgc29ycnkgYWJvdXQgdGhhdCwgSSBtaXNzZWQgaXQuIEFw
cGxpZWQsIHRoYW5rcyENCj4gDQpUaGFua3MgSmVucy4NCkFyYXZpbmQNCj4gLS0NCj4gSmVucyBB
eGJvZQ0KDQo=

