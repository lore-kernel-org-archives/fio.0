Return-Path: <fio-owner@vger.kernel.org>
Received: from alln-iport-4.cisco.com ([173.37.142.91]:30527 "EHLO
        alln-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751425AbeEDRVB (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 4 May 2018 13:21:01 -0400
Received: from XCH-RTP-016.cisco.com (xch-rtp-016.cisco.com [64.101.220.156])
        by rcdn-core-10.cisco.com (8.14.5/8.14.5) with ESMTP id w44HBXVV011702
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL)
        for <fio@vger.kernel.org>; Fri, 4 May 2018 17:11:33 GMT
From: "Scott Forman (scforman)" <scforman@cisco.com>
Subject: Can buffer passed to io_prep_pwrite/io_submit be reused before
 io_getevents is called?
Date: Fri, 4 May 2018 17:11:32 +0000
Message-ID: <50E2CC01-D24A-49D0-9FCD-047AE98E1F51@cisco.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE01355A8977D946815699A9F34EF287@emea.cisco.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

SGksDQoNCkkgaGF2ZSBhbiBhcHBsaWNhdGlvbiB3aGVyZSBJIHdpbGwgY2FsbCBpb19wcmVwX3B3
cml0ZSBhbmQgaW9fc3VibWl0IGluIGEgbG9vcCwgZWFjaCB0aW1lIHBhc3NpbmcgdGhlIHNhbWUg
YnVmZmVyIHRvIGlvX3ByZXBfcHdyaXRlLCBidXQgd2l0aCBkaWZmZXJlbnQgY29udGVudHMuDQoN
ClRoZW4gYWZ0ZXIgYSBjZXJ0YWluIG51bWJlciBvZiBsb29wcywgSSB3aWxsIGNhbGwgaW9fZ2V0
ZXZlbnRzIGJlZm9yZSBnb2luZyBvbiB0byB0aGUgbmV4dCBmaWxlLiAgDQoNCklzIHRoaXMgc2Fm
ZSB0byBkbywgb3IgaXMgdGhlcmUgYSByYWNlIGNvbmRpdGlvbiBiZXR3ZWVuIHRoZSBidWZmZXIg
YmVpbmcgd3JpdHRlbiB0byBmaWxlIGFuZCBiZWluZyByZXVzZWQgZm9yIHRoZSBuZXh0IGNhbGwg
dG8gaW9fcHJlcF9wd3JpdGU/DQoNCkJlbG93IGlzIHNvbWUgY29kZSB0byBpbGx1c3RyYXRlIG15
IHF1ZXN0aW9uIChhYnNlbnQgYW55IGVycm9yIGhhbmRsaW5nKS4NCg0KVGhhbmtzIGZvciBhbnkg
aW5wdXQgeW91IGNhbiBwcm92aWRlLg0KDQpTY290dA0KDQppbnQgbWFpbigpIHsNCglzdHJ1Y3Qg
aW9jYiBpb2NiOw0KCXN0cnVjdCBpb2NiICogaW9jYnNbMV07DQoJaW9jYnNbMF0gPSAmaW9jYjsN
CgkNCglpbnQgZmQgPSBvcGVuKCIvdG1wL3Rlc3QiLCBPX1dST05MWSB8IE9fQ1JFQVQpOw0KDQoJ
aW9fY29udGV4dF90IGN0eDsNCgltZW1zZXQoJmN0eCwgMCwgc2l6ZW9mKGN0eCkpOw0KCWlvX3Nl
dHVwKDEwLCAmY3R4KTsNCg0KCWNoYXIgbXNnIFsxMjhdOw0KICAgICAgICAgIGludCBsb29wQ250
ID0gMDsNCglpbnQgZmlsZU9mZnNldCA9IDA7DQoJDQogICAgICAJZm9yICg7IGxvb3BDbnQgPCAx
MDsgKytsb29wQ250KSB7DQoJCWludCBsZW4gPSBzbnByaW50Zihtc2csIHNpemVvZihtc2cpLCAi
bWVzc2FnZSBudW1iZXIgJWRcbiIsIGxvb3BDbnQpOw0KCQkNCgkJaW9fcHJlcF9wd3JpdGUoJmlv
Y2IsIGZkLCAodm9pZCAqKW1zZywgbGVuLCBmaWxlT2Zmc2V0KTsNCgkJZmlsZU9mZnNldCArPSBs
ZW47DQoJCQkNCgkJaW9fc3VibWl0KGN0eCwgMSwgaW9jYnMpOw0KCX0NCg0KCXN0cnVjdCBpb19l
dmVudCBldmVudHNbMTBdOw0KCWlvX2dldGV2ZW50cyhjdHgsIDEwLCAxMCwgZXZlbnRzLCBOVUxM
KTsNCgljbG9zZShmZCk7DQoJaW9fZGVzdHJveShjdHgpOw0KDQoJcmV0dXJuIDA7DQp9DQoNCg==
