Return-Path: <prvs=0411a83b4f=elliott@hpe.com>
From: "Elliott, Robert (Servers)" <elliott@hpe.com>
Subject: RE: [BUG] parse.c: val_too_large incorrectly handling overly large
 FIO_OPT_INT values
Date: Fri, 22 May 2020 18:27:30 +0000
Message-ID: <CS1PR8401MB123731B508F674F08ABE3FFBABB40@CS1PR8401MB1237.NAMPRD84.PROD.OUTLOOK.COM>
References: <1110AE83-BA4F-46FF-B9C7-662960EC0EAD@raithlin.com>
 <CS1PR8401MB1237EA8EA748EE36A0A77958ABA20@CS1PR8401MB1237.NAMPRD84.PROD.OUTLOOK.COM>
 <71EAE271-4053-4834-B391-8DA9BA5ABFF8@raithlin.com>
In-Reply-To: <71EAE271-4053-4834-B391-8DA9BA5ABFF8@raithlin.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
To: Stephen  Bates <sbates@raithlin.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, David Sloan <David.Sloan@eideticom.com>
List-ID: <fio@vger.kernel.org>

DQo+ID4gRnVuZGFtZW50YWxseSwgdGhpcyBhcmd1bWVudCBuZWVkcyB0byBzdXBwb3J0IGxhcmdl
ciB0aGFuDQo+ID4gICAgMzItYml0IHZhbHVlcy4gUGVyc2lzdGVudCBtZW1vcnkgZGV2aWNlcyBl
YXNpbHkgZXhjZWVkIHRoYXQNCj4gPiAgICBiYW5kd2lkdGggdG9vLg0KPiA+DQo+ID4gICAgT3Ro
ZXIgYXJndW1lbnRzIGxpa2UgInNpemUiIGFscmVhZHkgdGFrZSBsYXJnZSB2YWx1ZXMgaW50byBh
bg0KPiA+ICAgIHVuc2lnbmVkIGxvbmcgbG9uZy4gU28sIGp1c3QgY2hhbmdpbmcgdGhpcyBmb3Ig
InJhdGUiIGFuZA0KPiA+ICAgICJyYXRlX21pbiIgbWlnaHQgc3VmZmljZToNCj4gPiAgICAgICAg
ICAgICAgICAgICAgLnR5cGUgICA9IEZJT19PUFRfSU5ULA0KPiA+ICAgIHRvDQo+ID4gICAgICAg
ICAgICAgICAgICAgIC50eXBlICAgPSBGSU9fT1BUX1NUUl9WQUwsDQo+IA0KPiBZdXAgYnV0IHRo
ZXJlIGFyZSB0d28gaXNzdWVzIGhlcmU6DQo+IA0KPiAxLiAoVGhpcyBidWcgcmVwb3J0KSBUaGUg
cmFuZ2UgaGFuZGxpbmcgb2YgYWxsIEZJT19PUFRfSU5UIGFyZ3VtZW50cw0KPiBpcyBicm9rZW4u
DQo+IA0KPiAyLiByYXRlIChhbmQgbWluX3JhdGUpIHNob3VsZCBzdXBwb3J0IHZhbHVlcyBiaWdn
ZXIgdGhhbiA0Ry4NCj4gDQo+IEkgYW0gd29ya2luZyBvbiBhIFBSL3BhdGNoIGZvciBpdGVtIDIg
WzFdLiBMb29raW5nIGZvciBndWlkYW5jZSBvbg0KPiBpdGVtIDEuDQo+IA0KDQpTaG91bGQgYXQg
bGVhc3QgaXRlbSAyIGdvIGludG8gMy4yMD8NCg0K

