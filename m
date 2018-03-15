Return-Path: <fio-owner@vger.kernel.org>
Received: from g2t1383g.austin.hpe.com ([15.233.16.89]:2353 "EHLO
        g2t1383g.austin.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752404AbeCOWa3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 15 Mar 2018 18:30:29 -0400
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com [15.241.140.78])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g2t1383g.austin.hpe.com (Postfix) with ESMTPS id 94F686B2
        for <fio@vger.kernel.org>; Thu, 15 Mar 2018 22:30:28 +0000 (UTC)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: Patch to add read and write fua bit options to the SG engine
Date: Thu, 15 Mar 2018 22:30:26 +0000
Message-ID: <AT5PR8401MB1169378D6DAA99831B7DF71BABD00@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <CY1PR0401MB1116B5FBEFE751DAE8A07A3C81D00@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxhS++UF+LG166gR_tQNBsJHa-pTUJfHck_FjcN8DUtY2g@mail.gmail.com>
 <CY1PR0401MB1116D03152A52BDA269387E981D00@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxjGYvjEFR3q3oE-cm1i1Fat43GOQiAgF359Lm7M85oewg@mail.gmail.com>
 <CY1PR0401MB1116804A4E4840C9BABFFCC581D00@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CY1PR0401MB11168BF1B52E80B34DAF778E81D00@CY1PR0401MB1116.namprd04.prod.outlook.com>
In-Reply-To: <CY1PR0401MB11168BF1B52E80B34DAF778E81D00@CY1PR0401MB1116.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Kris Davis <Kris.Davis@wdc.com>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogZmlvLW93bmVyQHZnZXIu
a2VybmVsLm9yZyBbbWFpbHRvOmZpby1vd25lckB2Z2VyLmtlcm5lbC5vcmddIE9uDQo+IEJlaGFs
ZiBPZiBLcmlzIERhdmlzDQo+IFNlbnQ6IFRodXJzZGF5LCBNYXJjaCAxNSwgMjAxOCAzOjM4IFBN
DQo+IFN1YmplY3Q6IFJFOiBQYXRjaCB0byBhZGQgcmVhZCBhbmQgd3JpdGUgZnVhIGJpdCBvcHRp
b25zIHRvIHRoZSBTRyBlbmdpbmUNCj4gDQo+IEEgcXVlc3Rpb24gLSBob3cgaXMgdGhlIG1hbiBw
YWdlIGV4cGVjdGVkIHRvIGJlIGhhbmRsZWQgKG1hbnVhbGx5DQo+IHVwZGF0ZWQpPyAgSSBzYXcg
dGhhdCBydW5uaW5nICJtYWtlIC1DIGRvYyBtYW4iIHdvdWxkIGdlbmVyYXRlIGEgbWFuIHBhZ2Us
DQo+IHdoaWNoIGluY2x1ZGVkIGNoYW5nZXMgZnJvbSB0aGUgSE9XVE8uICBIb3dldmVyLCBldmVu
IGlmIEkgYnVpbGQgdGhhdA0KPiBkb2Mvb3V0cHV0L21hbi9maW8uMSBmaWxlIGZyb20gYSBtYXN0
ZXIgbGV2ZWwgaW1hZ2UsIGl0IGRvZXMgdG8gYXBwZWFyIHRvDQo+IGVxdWFsIHdoYXQgaXMgaW4g
ImZpby4xIiBhdCB0aGUgcm9vdCBkaXJlY3RvcnkuICBJJ3ZlIG5ldmVyIG1hbnVhbGx5DQo+IHdy
aXR0ZW4gYSBtYW4gcGFnZSBiZWZvcmUsIHNvIEkgbWlnaHQgZ3Vlc3MgdGhhdCBpdCBkZXBlbmRz
IG9uIHRoZSB0b29sDQo+IGltYWdlcyBvbiB3aGF0ZXZlciBtYWNoaW5lIGlzIHVzZWQgdG8gYnVp
bGQgdGhlIG1hbiBwYWdlLg0KPiANCj4gQW55d2F5IC0gd2hhdCdzIHRoZSByaWdodCB3YXkgdG8g
aGFuZGxlIHRoZSBtYW4gcGFnZXMNCj4gLS0gbWFudWFsbHkgZWRpdCBhbmQgaW5jbHVkZSBpbiBw
YXRjaD8NCj4gLS0gYnVpbGQgdmlhIG1ha2UsIGNvcHkgdG8gdGhlIHJvb3QgZGlyLCBhbmQgdGhl
biBpbmNsdWRlIGluIHBhdGNoPw0KPiAtLSBzb21ldGhpbmcgZWxzZT8NCg0KZmlvLjEgaXMgdGhl
ICJzb3VyY2UgY29kZS4iICBNYW51YWxseSBlZGl0IGl0IGFuZCBoYW5kY29kZSB0aGUgYW5jaWVu
dCANCnRyb2ZmIGZvcm1hdHRpbmcuDQoNClBhdGNoIGY4MGRiYThkMmZjMzA1MmEgYWRkZWQgYXV0
b21hdGljIGdlbmVyYXRpb24gb2YgYW4gZmlvLjEgZnJvbQ0KUkVBRE1FIGFuZCBIT1dUTywgYnV0
IEkgZG9uJ3QgdGhpbmsgYW55b25lIHVzZXMgdGhhdCBvdXRwdXQuICBJdA0KcmVxdWlyZXMgbW9y
ZSBwYWNrYWdlcyB0byBiZSBwcmVzZW50IChzb21ldGhpbmcgY2FsbGVkIHNwaGlueCBhbmQgd2hv
DQprbm93cyB3aGF0IGVsc2UpLiAgVGhlcmUgaGF2ZSBiZWVuIG92ZXIgNzAgZGlyZWN0IHBhdGNo
ZXMgdG8gZmlvLjEgDQpzaW5jZSB0aGVuLCBpZ25vcmluZyB0aGF0IGF1dG8tZ2VuZXJhdGVkIHZl
cnNpb24uDQoNCkhPV1RPIGFuZCB0aGUgbWFucGFnZSBhcmUgYWx3YXlzIGZhbGxpbmcgb3V0IG9m
IHN5bmMsIHNvIGl0J2QgYmUgbmljZQ0KaWYgd2Ugb25seSBoYWQgb25lIGF1dGhvcml0YXRpdmUg
c291cmNlIGZpbGUuDQoNCg0KLS0tDQpSb2JlcnQgRWxsaW90dCwgSFBFIFBlcnNpc3RlbnQgTWVt
b3J5DQoNCg0K
