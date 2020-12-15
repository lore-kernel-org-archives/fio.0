Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:62464 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725846AbgLOXvR (ORCPT
        <rfc822;fio@vger.kernel.org>); Tue, 15 Dec 2020 18:51:17 -0500
From: "Elliott, Robert (Servers)" <elliott@hpe.com>
Subject: RE: Using `direct=1` parameter in disk vs filesystem tests
Date: Tue, 15 Dec 2020 23:50:31 +0000
Message-ID: <TU4PR8401MB1055869265B1F3151AEA60DBABC60@TU4PR8401MB1055.NAMPRD84.PROD.OUTLOOK.COM>
References: <492E6063-8BAE-413B-9BD4-087E37525135@phas.ubc.ca>
In-Reply-To: <492E6063-8BAE-413B-9BD4-087E37525135@phas.ubc.ca>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: Davor Cubranic <davor@phas.ubc.ca>, "fio@vger.kernel.org" <fio@vger.kernel.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGF2b3IgQ3VicmFuaWMg
PGRhdm9yQHBoYXMudWJjLmNhPg0KPiBTZW50OiBUdWVzZGF5LCBEZWNlbWJlciAxNSwgMjAyMCA0
OjExIFBNDQo+IFRvOiBmaW9Admdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFVzaW5nIGBkaXJl
Y3Q9MWAgcGFyYW1ldGVyIGluIGRpc2sgdnMgZmlsZXN5c3RlbSB0ZXN0cw0KPiANCj4gSSBoYXZl
IGEgdXNhZ2UgcXVlc3Rpb246IGluIHRlc3RpbmcgdGhlIHdyaXRlIHNwZWVkIG9mIGEgcmF3IGRp
c2sNCj4gZHJpdmUsIEkgc2F3IOKAnHJhbmR3cml0ZeKAnSBhY2hpZXZlIGJhbmR3aWR0aCBpZGVu
dGljYWwgdG8g4oCcd3JpdGXigJ0gZXZlbg0KPiB3aXRoIHNtYWxsIGJsb2NrIHNpemVzLCBhdCBs
ZWFzdCB1bnRpbCBJIGFkZGVkIGAtLWRpcmVjdD0xYCBvcHRpb24NCj4gKGAtLWZzeW5jX29uX2Ns
b3NlPTFgIGRpZCBub3QgbWFrZSBhbnkgZGlmZmVyZW5jZSkuIERvZXMgdGhhdCBtZWFuDQo+IHRo
YXQgdGhpcyBvcHRpb24gaXMgcHJldHR5IG11Y2ggcmVxdWlyZWQgZm9yIHRlc3RpbmcgcmF3IGRp
c2tzPw0KPiAoU3BlY2lmaWMgY29tbWFuZCBsaW5lIEkgdXNlZDogImZpbyAtLWZpbGVuYW1lPS9k
ZXYvc2RiIC0tDQo+IG5hbWU9cmF3ZGlzayAtLXJ3PXJhbmR3cml0ZSAtLWJzPTRrIC0tc2l6ZT0y
NTZnIC0tcnVudGltZT02MCAtLQ0KPiBkaXJlY3Q9MeKAnS4pDQo+IA0KPiBGb3IgcmVhbGlzdGlj
IHRlc3Rpbmcgb2Ygd3JpdGVzIHRvIGEgKmZpbGVzeXN0ZW0qIHdoZXJlIG91cg0KPiBhcHBsaWNh
dGlvbnMgd29u4oCZdCBnbyBiZXlvbmQgcmVndWxhciBQT1NJWCBvcGVuL3dyaXRlL2Nsb3NlIEFQ
SSwgSQ0KPiBhc3N1bWUgSSBkb27igJl0IG5lZWQgdG8gc2V0IHRoZSBgZGlyZWN0YCBwYXJhbWV0
ZXI/DQoNCldpdGhvdXQgZGlyZWN0PTEsIElPcyBnbyB0aHJvdWdoIHRoZSBMaW51eCBwYWdlIGNh
Y2hlLCBzbyB5b3UNCm1pZ2h0IGp1c3QgYmUgdGVzdGluZyB5b3VyIG1lbW9yeSBzcGVlZCwgbm90
IHRoZSBzdG9yYWdlIHN1YnN5c3RlbS4NCg0KWW91IGRpZG4ndCBkZXNjcmliZSB5b3VyIHN5c3Rl
bSwgYnV0IHNlcnZlcnMgY2FuIGVhc2lseSBoYXZlIDM4NCBHaUINCm9mIG1lbW9yeSBub3dhZGF5
cy4gQSAyNTYgR2lCIHdvcmtsb2FkIGZpdHMgZW50aXJlbHkgaW4gdGhlIHBhZ2UgY2FjaGUNCmlu
IHN1Y2ggYSBzeXN0ZW0uDQoNCg0KDQo=

