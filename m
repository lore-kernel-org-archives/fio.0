Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bl2nam02on0092.outbound.protection.outlook.com ([104.47.38.92]:45339
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750858AbdAYQXD (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 25 Jan 2017 11:23:03 -0500
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: 4x lower IOPS: Linux MD vs indiv. devices - why?
Date: Wed, 25 Jan 2017 16:23:01 +0000
Message-ID: <DF4PR84MB0169A885870EDAED7BDB0C23AB740@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
References: <90865544-f790-513c-97df-7e6a6af20ca8@gmail.com>
 <CANvN+en2ihATNgrbgzwNXAK87wNh+6jXHinmg2-VmHon31AJzA@mail.gmail.com>
 <061acabe-dbd0-ae07-cd69-772eccd15b21@gmail.com>
 <CANvN+em0cjWRnQWccdORKFEJk0OSeQOrZq+XE6kzPmqMPB--4g@mail.gmail.com>
 <49ef9d71-8e52-26e4-76f7-ea03fb331a38@gmail.com>
 <CALjAwxjmW-NgWEcH7+nKNN8U_oUxFoYa23dui9wM6WDqiShWhw@mail.gmail.com>
 <15418080-0bf6-ab40-c05f-69a3fb3d9cc3@gmail.com>
 <CALjAwxhsvfH0-D=4U6nkjFg109Z1ZgVRsOx37X+Lb-EqTf_jOA@mail.gmail.com>
 <6b2cacaf-2946-6046-51c2-b909c6ee0784@gmail.com>
 <CANvN+emLjb9idri9r42V3W9ia6v0EDGdJYFfhzq6rAuzGWec8Q@mail.gmail.com>
 <CANvN+emJBzMeUmjBw5PBSZc66LmjG8-Pz+39dBeL5GseMCdo6g@mail.gmail.com>
 <fca1cdb1-aa66-b21f-d1a0-029ba895d3f2@gmail.com>
 <CANvN+emQ0AYPgT0e6KMKphDTZAY=cW6FyroLw=smReHGpd-=TA@mail.gmail.com>
 <a0dc59e7-9c81-ab5d-45b6-d1d252179837@gmail.com>
 <CANvN+e=qsexdU6Pp4kKQXy-jQKixZhR-WWLQb=713NNAA0ziVg@mail.gmail.com>
 <68e44114-5d14-a714-09a6-d80358d10118@gmail.com>
In-Reply-To: <68e44114-5d14-a714-09a6-d80358d10118@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tobias Oberstein <tobias.oberstein@gmail.com>, Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogZmlvLW93bmVyQHZnZXIu
a2VybmVsLm9yZyBbbWFpbHRvOmZpby1vd25lckB2Z2VyLmtlcm5lbC5vcmddIE9uDQo+IEJlaGFs
ZiBPZiBUb2JpYXMgT2JlcnN0ZWluDQo+IFNlbnQ6IFR1ZXNkYXksIEphbnVhcnkgMjQsIDIwMTcg
NDo1MiBQTQ0KPiBUbzogQW5kcmV5IEt1em1pbiA8YW5kcmV5LnYua3V6bWluQGdtYWlsLmNvbT4N
Cj4gQ2M6IGZpb0B2Z2VyLmtlcm5lbC5vcmc7IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4N
Cj4gU3ViamVjdDogUmU6IDR4IGxvd2VyIElPUFM6IExpbnV4IE1EIHZzIGluZGl2LiBkZXZpY2Vz
IC0gd2h5Pw0KPiANCj4gSG93ZXZlciwgZHVyaW5nIG15IHRlc3RzLCBJIGdldCB0aGlzIGluIGtl
cm5lbCBsb2c6DQo+IA0KPiBbNDU5MzQ2LjE1NTU2NF0gTk1JIHdhdGNoZG9nOiBCVUc6IHNvZnQg
bG9ja3VwIC0gQ1BVIzQ2IHN0dWNrIGZvcg0KPiAyMnMhDQo+IFtzd2FwcGVyLzQ2OjBdDQo+IFs0
NjEwNDAuNTMwOTU5XSBOTUkgd2F0Y2hkb2c6IEJVRzogc29mdCBsb2NrdXAgLSBDUFUjMjYgc3R1
Y2sgZm9yDQo+IDIycyENCj4gW3N3YXBwZXIvMjY6MF0NCj4gWzQ2MTA0NC4yNzkwODFdIE5NSSB3
YXRjaGRvZzogQlVHOiBzb2Z0IGxvY2t1cCAtIENQVSMyMyBzdHVjayBmb3INCj4gMjJzIQ0KPiBb
c3dhcHBlci8yMzowXQ0KPiANCj4gSSB3aWxkIGd1ZXNzOiB0aGVzZSBsb2NrdXBzIGFyZSBhY3R1
YWxseSBkZWFkbG9ja3MuIEFJTyBzZWVtcyB0byBiZQ0KPiB0cmlja3kgZm9yIHRoZSBrZXJuZWwg
dG9vLg0KPiANCg0KUHJvYmFibHkgbm90IGRlYWRsb2Nrcy4gIE9uZSBlYXN5IHRvIHdheSB0cmln
Z2VyIHRob3NlIGlzIHRvIHN1Ym1pdA0KSU9zIG9uIG9uZSBzZXQgb2YgQ1BVcyBhbmQgZXhwZWN0
IGEgZGlmZmVyZW50IHNldCBvZiBDUFVzIHRvIGhhbmRsZQ0KdGhlIGludGVycnVwdHMgYW5kIGNv
bXBsZXRpb25zLiAgVGhlIGxhdHRlciBDUFVzIGNhbiBlYXNpbHkgYmVjb21lDQpvdmVyd2hlbG1l
ZC4gIFRoZSBiZXN0IHJlbWVkeSBJJ3ZlIGZvdW5kIGlzIHRvIHJlcXVpcmUgQ1BVcyB0byBoYW5k
bGUNCnRoZWlyIG93biBJT3MsIHdoaWNoIHNlbGYtdGhyb3R0bGVzIHRoZW0gZnJvbSBzdWJtaXR0
aW5nIG1vcmUgSU9zDQp0aGFuIHRoZXkgY2FuIGhhbmRsZS4NCg0KVGhlIHN0b3JhZ2UgZGV2aWNl
IGRyaXZlciBuZWVkcyB0byBzZXQgdXAgaXRzIGhhcmR3YXJlIGludGVycnVwdHMNCnRoYXQgd2F5
LiAgVGhlbiwgcnFfYWZmaW5pdHk9MiBlbnN1cmVzIHRoZSBibG9jayBsYXllciBjb21wbGV0aW9u
cw0KYXJlIGhhbmRsZWQgb24gdGhlIHN1Ym1pdHRpbmcgQ1BVLg0KDQpZb3UgY2FuIGFkZCB0aGlz
IHRvIHRoZSBrZXJuZWwgY29tbWFuZCBsaW5lIChlLmcuLCBpbiANCi9ib290L2dydWIvZ3J1Yi5j
b25mKSB0byBzcXVlbGNoIHRob3NlIGNoZWNrczoNCglub3NvZnRsb2NrdXANCg0KVGhvc2UgcHJp
bnRzIHRoZW1zZWx2ZXMgY2FuIGluZHVjZSBtb3JlIHNvZnQgbG9ja3VwcyBpZiB5b3UgaGF2ZSBh
DQpsaXZlIHNlcmlhbCBwb3J0LCBiZWNhdXNlIHByaW50aW5nIHRvIHRoZSBzZXJpYWwgcG9ydCBp
cyBzbG93DQphbmQgYmxvY2tpbmcuDQoNCg==
