Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:39847 "EHLO muon.cran.org.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751055AbcJFDQS (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 5 Oct 2016 23:16:18 -0400
Received: from muon.bluestop.org (localhost [127.0.0.1])
        by muon.cran.org.uk (Postfix) with ESMTP id B76E79427B
        for <fio@vger.kernel.org>; Thu,  6 Oct 2016 03:16:05 +0000 (UTC)
Received: from muon.cran.org.uk ([127.0.0.1])
        by muon.bluestop.org (muon.bluestop.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Ut5et66TnfOX for <fio@vger.kernel.org>;
        Thu,  6 Oct 2016 03:16:04 +0000 (UTC)
Received: from [10.50.3.126] (63-158-132-10.dia.static.qwest.net [63.158.132.10])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by muon.cran.org.uk (Postfix) with ESMTPSA
        for <fio@vger.kernel.org>; Thu,  6 Oct 2016 03:16:04 +0000 (UTC)
From: Bruce Cran <bruce@cran.org.uk>
Subject: [PATCH] windowsaio: fix completion thread affinitization
Message-ID: <c2e89b24-ef00-d840-0c4c-83e8bba4d114@cran.org.uk>
Date: Thu, 6 Oct 2016 03:16:04 +0000
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------CBB047457A982E2F1C5B1E91"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

This is a multi-part message in MIME format.
--------------CBB047457A982E2F1C5B1E91
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit



--------------CBB047457A982E2F1C5B1E91
Content-Type: text/plain; charset=UTF-8;
 name="0001-windowsaio-fix-completion-thread-affinitization.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-windowsaio-fix-completion-thread-affinitization.patch"

RnJvbSA1MjliNzcyNWE5MDI2ODY5NGFmMjRiN2YyNTc5ZmI2ODc5Y2UwMWFiIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBCcnVjZSBDcmFuIDxicnVjZS5jcmFuQHNhbmRpc2su
Y29tPgpEYXRlOiBUaHUsIDYgT2N0IDIwMTYgMDM6MTM6NTQgKzAwMDAKU3ViamVjdDogW1BB
VENIXSB3aW5kb3dzYWlvOiBmaXggY29tcGxldGlvbiB0aHJlYWQgYWZmaW5pdGl6YXRpb24K
CkFmZmluaXRpemUgdGhlIHdpbmRvd3NhaW8gY29tcGxldGlvbiB0aHJlYWRzIHRvIHRoZSBz
YW1lIENQVXMgYXMgdGhlCnN1Ym1pc3Npb24gdGhyZWFkcy4KLS0tCiBlbmdpbmVzL3dpbmRv
d3NhaW8uYyB8IDkgKysrKysrKy0tCiAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCsp
LCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2VuZ2luZXMvd2luZG93c2Fpby5jIGIv
ZW5naW5lcy93aW5kb3dzYWlvLmMKaW5kZXggMGUxNjRiNi4uZjVjYjA0OCAxMDA2NDQKLS0t
IGEvZW5naW5lcy93aW5kb3dzYWlvLmMKKysrIGIvZW5naW5lcy93aW5kb3dzYWlvLmMKQEAg
LTExMywxMCArMTEzLDE1IEBAIHN0YXRpYyBpbnQgZmlvX3dpbmRvd3NhaW9faW5pdChzdHJ1
Y3QgdGhyZWFkX2RhdGEgKnRkKQogCiAJCWlmICghcmMpCiAJCXsKKwkJCURXT1JEIHRocmVh
ZGlkOworCiAJCQljdHgtPmlvY3AgPSBoRmlsZTsKIAkJCWN0eC0+d2QgPSB3ZDsKLQkJCXdk
LT5pb3RocmVhZCA9IENyZWF0ZVRocmVhZChOVUxMLCAwLCBJb0NvbXBsZXRpb25Sb3V0aW5l
LCBjdHgsIDAsIE5VTEwpOwotCQkJaWYgKHdkLT5pb3RocmVhZCA9PSBOVUxMKQorCQkJd2Qt
PmlvdGhyZWFkID0gQ3JlYXRlVGhyZWFkKE5VTEwsIDAsIElvQ29tcGxldGlvblJvdXRpbmUs
IGN0eCwgMCwgJnRocmVhZGlkKTsKKworCQkJaWYgKHdkLT5pb3RocmVhZCAhPSBOVUxMKQor
CQkJCWZpb19zZXRhZmZpbml0eSh0aHJlYWRpZCwgdGQtPm8uY3B1bWFzayk7CisJCQllbHNl
CiAJCQkJbG9nX2Vycigid2luZG93c2FpbzogZmFpbGVkIHRvIGNyZWF0ZSBpbyBjb21wbGV0
aW9uIHRocmVhZFxuIik7CiAJCX0KIAotLSAKMi45LjMud2luZG93cy4yCgo=
--------------CBB047457A982E2F1C5B1E91--
