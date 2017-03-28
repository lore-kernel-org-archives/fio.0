Return-Path: <fio-owner@vger.kernel.org>
Received: from alln-iport-5.cisco.com ([173.37.142.92]:22121 "EHLO
        alln-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752509AbdC1SNc (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 28 Mar 2017 14:13:32 -0400
Received: from XCH-RTP-020.cisco.com (xch-rtp-020.cisco.com [64.101.220.160])
        by rcdn-core-10.cisco.com (8.14.5/8.14.5) with ESMTP id v2SI40XN002342
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL)
        for <fio@vger.kernel.org>; Tue, 28 Mar 2017 18:04:00 GMT
From: "Scott Forman (scforman)" <scforman@cisco.com>
Subject: How does FIO detect write errors when ioengine is libaio
Date: Tue, 28 Mar 2017 18:03:59 +0000
Message-ID: <020F9C88-1E06-4EC4-A83D-B7CAA1B54F37@cisco.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <CEC2B05CEDC11947B712E9A05867445E@emea.cisco.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

SGksDQoNCkkgYW0gdHJ5aW5nIHRvIGRldGVybWluZSBob3cgZmlvIGRldGVjdHMgd3JpdGUgZXJy
b3JzIHdoZW4gdGhlIGlvZW5naW5lIGlzIHNldCB0byBsaWJhaW8uDQoNCkZyb20gYSBjb2RlIGV4
YW1wbGUgb24gc3RhY2sgb3ZlcmZsb3cswqBsaW51eC1rZXJuZWwtYWlvLWZ1bmN0aW9uYWxpdHks
wqBpdCBhcHBlYXJzIHRoYXQgdGhleSBjYW4gYmUgZGV0ZWN0ZWQgYnkgZXhhbWluaW5nIHRoZSBl
dmVudHMgcmV0dXJuZWQgZnJvbSBpb19nZXRldmVudHMoKS4NCg0KQnV0IEkgZG8gbm90IHNlZSBh
bnkgY29kZSBpbiBsaWJhaW8uYyB0aGF0IGV4YW1pbmVzIHRoZSBldmVudHMgcmV0dXJuZWQgZnJv
bSBpb19nZXRldmVudHMoKS4NCg0KQ2FuIHlvdSB2ZXJpZnkgdGhhdCBmaW8gZG9lcyBjaGVjayBm
b3Igd3JpdGUgZXJyb3JzIGZvciBlbmdpbmUgbGliYWlvLCBhbmQgaWYgc28sIHdoZXJlIHRoYXQg
ZXJyb3IgY2hlY2tpbmcgaXMgZG9uZT8NCg0KVGhhbmtzIGluIGFkdmFuY2UhDQoNClNpbmNlcmVs
eSwNCg0KU2NvdHQgRm9ybWFuDQoNCg0KDQo=
