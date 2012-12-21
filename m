Return-Path: <sbradshaw@micron.com>
From: "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>
Subject: RE: [PATCH] gettime: minimize integer division
Date: Fri, 21 Dec 2012 21:53:44 +0000
Message-ID: <80B89753B40C5141A3E2D53FE7A2A8A93003BE0D@NTXBOIMBX02.micron.com>
References: <50D26157.5020802@micron.com> <50D2C8FD.2070901@kernel.dk>
 <50D3487E.7000402@micron.com> <50D352D7.2090901@kernel.dk>
 <50D365AA.9080202@micron.com> <50D48139.30601@kernel.dk>
 <80B89753B40C5141A3E2D53FE7A2A8A93003BD3F@NTXBOIMBX02.micron.com>
 <50D4D4F9.5070606@kernel.dk>
In-Reply-To: <50D4D4F9.5070606@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

DQo+ID4gSU9QcyBsb29rIHRoZSBzYW1lIGluIG15IHN5bnRoZXRpYyB0ZXN0IGJ1dCBJJ20gbm90
IHN1cmUgdGhhdCdzIHJlbGV2YW50Ow0KPiA+IChpdCBwcm9iYWJseSBqdXN0IG5lZWRzIHNvbWUg
bW9yZSB0d2Vha2luZykuDQo+IA0KPiBJdCdkIHByb2JhYmx5IG5lZWQgMy00TSBJT1BTIGZyb20g
YSBzaW5nbGUgdGhyZWFkIHRvIGhhdmUgYSBiaWcgaW1wYWN0Lg0KPiBCdXQgcmVkdWNlZCBDUFUg
aXMgbGVmdG92ZXIgQ1BVIGZvciBkb2luZyBhY3R1YWwgSU8sIHNvIGFsd2F5cyBhIGdvb2QNCj4g
dGhpbmcuDQo+IA0KPiBBbmQganVzdCBhcyBpbXBvcnRhbnQsIGRpZCB0aGUgdGltaW5nIGxvb2sg
Y29ycmVjdD8NCg0KWWVzLCBubyBzcGlrZXMsIGxhdGVuY3kgYXZlcmFnZSBhbmQgc3RkLiBkZXYu
IGFzIGV4cGVjdGVkLg0KDQotU2FtDQoNCg==

