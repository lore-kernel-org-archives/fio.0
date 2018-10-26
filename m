Return-Path: <fio-owner@vger.kernel.org>
Received: from g9t1613g.houston.hpe.com ([15.241.32.99]:17236 "EHLO
        g9t1613g.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbeJ0HJT (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 27 Oct 2018 03:09:19 -0400
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g9t1613g.houston.hpe.com (Postfix) with ESMTPS id BF69260C47
        for <fio@vger.kernel.org>; Fri, 26 Oct 2018 22:30:29 +0000 (UTC)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: fio on vmware esxi
Date: Fri, 26 Oct 2018 22:30:26 +0000
Message-ID: <AT5PR8401MB11690CF299A451394CCC5640ABF00@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <001001d460c6$8c44b090$a4ce11b0$@integritech.solutions>
 <BC19FF62-2BD8-4F83-9BFB-8D271F5D7101@emc.com>
 <AE78B431-F6A6-4796-BB7E-1FE45E328D74@integritech.solutions>
 <0DE2B6A6-1AFB-4FAD-BD99-53136B45BCD8@emc.com>
 <CALjAwxjazAUEip=nea=7K8LVRBRwq6c0h9FheeCVvh372ZvaKw@mail.gmail.com>
 <6E7254E9-4B9B-4208-9392-2ABD43FE36A4@emc.com>
 <555423228.215547.1540355274473@email.1and1.com>
 <CALjAwxi5T_p5JTpRfazPcV1KoeKNm0CnO9ffBKAtCBCAMhA5=w@mail.gmail.com>
 <C7097D32-CB26-49DF-BA3C-A52EAA5A361F@integritech.solutions>
 <D36925B2-A77A-47AD-BDD6-4A45558DC32E@emc.com>
 <2234B3B7-5680-4238-A48C-BED3EA5EA733@integritech.solutions>
 <000601d46d77$201945d0$604bd170$@integritech.solutions>
In-Reply-To: <000601d46d77$201945d0$604bd170$@integritech.solutions>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "'eliezer@integritech.solutions'" <eliezer@integritech.solutions>, "'Beierl, Mark'" <Mark.Beierl@dell.com>
Cc: 'Sitsofe Wheeler' <sitsofe@gmail.com>, 'fio' <fio@vger.kernel.org>

DQo+IEkgcnVuIEZJTyB3aXRoIHRoZSBmb2xsb3dpbmcgcGFyYW1ldGVycyBhbmQgdXNlZCB0aGUg
ZGlmZmVyZW50IGVuZ2luZXMgSSBsaXN0ZWQgYWJvdmU6DQo+IC0tcmFuZHJlcGVhdD0xDQo+IC0t
aW9lbmdpbmU9cG9zaXhhaW8NCj4gLS1kaXJlY3Q9MQ0KPiAtLXN5bmM9MQ0KPiAtLW5hbWU9bXl0
ZXN0DQo+IC0tZmlsZW5hbWU9bXl0ZXN0ZmlsZS5maW8NCj4gIC0tb3ZlcndyaXRlPTENCj4gLS1p
b2RlcHRoPTY0DQo+IC0tc2l6ZT0xMDBNQg0KPiAtLXJlYWR3cml0ZT1yYW5kcncNCj4gLS1yd21p
eHJlYWQ9NTANCj4gLS1yd21peHdyaXRlPTUwDQo+ICAtLWJzPTE2aw0KPiANCi4uLg0KPiAtaW9l
bmdpbmU9cHN5bmMgb24gYSAxMDAwIElPUFMgUGVyZiBzdG9yYWdlOjo6ICAgICByZWFkPTE3NyB3
cml0ZT0xODUgSU9QUw0KPiAtaW9lbmdpbmU9cHZzeW5jIG9uIGEgMTAwMCBJT1BTIFBlcmYgc3Rv
cmFnZTo6OiAgICByZWFkPTE3NiB3cml0ZT0xODQgSU9QUw0KPiAtaW9lbmdpbmU9c3luYyBvbiBh
IDEwMDAgSU9QUyBQZXJmIHN0b3JhZ2U6OjogICAgICByZWFkPTE0NSB3cml0ZT0xNTIgSU9QUw0K
PiAtaW9lbmdpbmU9cG9zaXhhaW8gb24gYSAxMDAwIElPUFMgUGVyZiBzdG9yYWdlOjo6ICByZWFk
PTUyOCB3cml0ZT01NTEgSU9QUyoNCj4gDQo+IEJhc2VkIG9uIHRoZSBGSU8gcmVzdWx0cyBJIHBv
c3RlZCBhYm92ZSwgSSd2ZSBjb25jbHVkZWQgdGhhdCB0aGUgc3VpdGFibGUgRklPIGVuZ2luZSBm
b3IgQmxvY2sgU3RvcmFnZQ0KPiBpcyAicG9zaXhhaW8iOyBhbmQgZm9yIE5GUyBpdCBjYW4gYmUg
cHN5bmMgb3IgcHZzeW5jIG9yIHN5bmMuDQo+IElmIEkgdXNlIHRoZSBGSU8gZW5naW5lICJwb3Np
eGFpbyIgb24gVk13YXJlIHRvIHRlc3QgYmxvY2sgc3RvcmFnZSwgSSdtIHNlZWluZyB0aGUgZXhw
ZWN0ZWQgSU9QUy4NCj4gSG93ZXZlciwgaWYgSSB1c2UgdGhlIHNhbWUgRklPIGVuZ2luZSAoInBv
c2l4YWlvIikgdG8gdGVzdCBORlMsIEknbSBOT1Qgc2VlaW5nIHRoZSBleHBlY3RlZCBJT1BTLiAg
SSdkDQo+IGhhdmUgdG8gdXNlIGVpdGhlciBwc3luYywgb3IgcHZzeW5jLCBvciBzeW5jIHRvIHNl
ZSB0aGUgSU9QUyBJJ20gZXhwZWN0aW5nLg0KPiAgIFRoZXNlIHRlc3RzIGFyZSBvbiB0aGUgc2Ft
ZSBiYXJlbWV0YWwgc2VydmVyIHJ1bm5pbmcgdGhlIHZlcnNpb24gb2YgVk1XYXJlIEkgcG9zdGVk
IGFib3ZlLg0KPiANCj4gQ2FuIHNvbWVvbmUgcGxlYXNlIHNoZWQgc29tZSBsaWdodCBvbiB3aHkg
RklPIHJlc3VsdHMgaXMgc2tld2VkIHdoZW4gInBvc2l4YWlvIiBlbmdpbmUgaXMgdXNlZCB0byB0
ZXN0DQo+IGFuIE5GUyBzdG9yYWdlPyAgIFRoZSBzYW1lIGdvZXMgd2l0aCBpb2VuZ2luZXMgcHN5
bmMvcHZzeW5jL3N5bmMgc2tld3MgSU9QUyAgcmVzdWx0cyBvbiBhIGJsb2NrDQo+IHN0b3JhZ2Ug
ZGV2aWNlPw0KDQpORlMgbWlnaHQgaW50cm9kdWNlIGFsbCBzb3J0cyBvZiBwcm9ibGVtcy4gIEZv
ciB0aGUgYmxvY2sgZGV2aWNlIGNhc2VzLi4uDQoNClN5bmNocm9ub3VzIGVuZ2luZXMgbGlrZSBz
eW5jIGRvIG5vdCBob25vciB0aGUgaW9kZXB0aDsgeW91IG5lZWQgdG8gdXNlDQpqb2JzPSB0byBn
ZXQgbXVsdGlwbGUgY29uY3VycmVudCBJT3MuICBwb3NpeGFpbyBpcyBhbiAgYXN5bmNocm9ub3Vz
IGVuZ2luZSwgDQpzbyBpdCBpcyBob25vcmluZyB5b3VyIGlvZGVwdGggKGl0IHNwYXducyB0aHJl
YWRzIGZvciB5b3UpLg0KDQpBbHNvLCBpZiB5b3VyIHN0b3JhZ2UgZGV2aWNlcyBkbyBhbnkgc29y
dCBvZiBidWZmZXJpbmcgYW5kIGNhY2hpbmcsIHRoZQ0KdGlueSAxMDAgTWlCIHNpemUgaXMgbGlr
ZWx5IHRvIHJlc3VsdCBpbiBsb3RzIG9mIGNhY2hlIGhpdHMsIGRpc3RvcnRpbmcNCnRoZSByZXN1
bHRzLg0KDQotLS0NClJvYmVydCBFbGxpb3R0LCBIUEUgUGVyc2lzdGVudCBNZW1vcnkNCg0KDQo=

