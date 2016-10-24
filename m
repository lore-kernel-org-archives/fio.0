Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:62202 "EHLO muon.cran.org.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965410AbcJXSLm (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 24 Oct 2016 14:11:42 -0400
Received: from muon.bluestop.org (localhost [127.0.0.1])
        by muon.cran.org.uk (Postfix) with ESMTP id 506095ABC7
        for <fio@vger.kernel.org>; Mon, 24 Oct 2016 18:11:41 +0000 (UTC)
Received: from muon.cran.org.uk ([127.0.0.1])
        by muon.bluestop.org (muon.bluestop.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id tBN2bc1VRmO2 for <fio@vger.kernel.org>;
        Mon, 24 Oct 2016 18:11:40 +0000 (UTC)
Received: from [10.0.1.172] (unknown [207.108.170.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by muon.cran.org.uk (Postfix) with ESMTPSA
        for <fio@vger.kernel.org>; Mon, 24 Oct 2016 18:11:40 +0000 (UTC)
From: Bruce Cran <bruce@cran.org.uk>
Subject: [PATCH] Use the POSIX `EDEADLK` instead of the Linux `EDEADLOCK`
Message-ID: <33f1d961-5db0-e998-2998-0fac11041e85@cran.org.uk>
Date: Mon, 24 Oct 2016 12:11:39 -0600
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------ED6F93CE945C1BAC518C7CC2"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

This is a multi-part message in MIME format.
--------------ED6F93CE945C1BAC518C7CC2
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit



--------------ED6F93CE945C1BAC518C7CC2
Content-Type: text/plain; charset=UTF-8;
 name="0001-Use-the-POSIX-EDEADLK-instead-of-the-Linux-EDEADLOCK.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-Use-the-POSIX-EDEADLK-instead-of-the-Linux-EDEADLOCK.pa";
 filename*1="tch"

RnJvbSAyOTBjNmE0ZWE1ZjU5MjljMDdmYzNmZWVjY2E1MDMwNzRmZmEzNWViIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBCcnVjZSBDcmFuIDxCcnVjZS5DcmFuQHNhbmRpc2su
Y29tPgpEYXRlOiBNb24sIDI0IE9jdCAyMDE2IDEyOjA4OjQwIC0wNjAwClN1YmplY3Q6IFtQ
QVRDSF0gVXNlIHRoZSBQT1NJWCBgRURFQURMS2AgaW5zdGVhZCBvZiB0aGUgTGludXggYEVE
RUFETE9DS2AKCi0tLQogYmFja2VuZC5jIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvYmFja2VuZC5jIGIvYmFj
a2VuZC5jCmluZGV4IGYwOTI3YWIuLmVkNGYxZjAgMTAwNjQ0Ci0tLSBhL2JhY2tlbmQuYwor
KysgYi9iYWNrZW5kLmMKQEAgLTE3NDgsNyArMTc0OCw3IEBAIHN0YXRpYyB2b2lkICp0aHJl
YWRfbWFpbih2b2lkICpkYXRhKQogCQkJdXNsZWVwKDEwMDApOwogCQkJaWYgKGRlYWRsb2Nr
X2xvb3BfY250KysgPiA1MDAwKSB7CiAJCQkJbG9nX2VycigiZmlvIHNlZW1zIHRvIGJlIHN0
dWNrIGdyYWJiaW5nIHN0YXRfbXV0ZXgsIGZvcmNpYmx5IGV4aXRpbmdcbiIpOwotCQkJCXRk
LT5lcnJvciA9IEVERUFETE9DSzsKKwkJCQl0ZC0+ZXJyb3IgPSBFREVBRExLOwogCQkJCWdv
dG8gZXJyOwogCQkJfQogCQl9IHdoaWxlICgxKTsKLS0gCjIuMTAuMQoK
--------------ED6F93CE945C1BAC518C7CC2--
