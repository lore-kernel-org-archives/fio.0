Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:48281 "EHLO muon.cran.org.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936454AbcISD3J (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 18 Sep 2016 23:29:09 -0400
Received: from muon.bluestop.org (localhost [127.0.0.1])
        by muon.cran.org.uk (Postfix) with ESMTP id 89A9C8935C
        for <fio@vger.kernel.org>; Mon, 19 Sep 2016 03:29:07 +0000 (UTC)
Received: from muon.cran.org.uk ([127.0.0.1])
        by muon.bluestop.org (muon.bluestop.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id pSHWeRn1g1j7 for <fio@vger.kernel.org>;
        Mon, 19 Sep 2016 03:29:06 +0000 (UTC)
Received: from [10.50.3.126] (63-158-132-10.dia.static.qwest.net [63.158.132.10])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by muon.cran.org.uk (Postfix) with ESMTPSA
        for <fio@vger.kernel.org>; Mon, 19 Sep 2016 03:29:06 +0000 (UTC)
From: Bruce Cran <bruce@cran.org.uk>
Subject: Patches to fix Time_tToSystemTime and stat.c time_buf being
 uninitialized
Message-ID: <591b8426-6486-3c70-8a99-25948146f2f3@cran.org.uk>
Date: Mon, 19 Sep 2016 03:29:06 +0000
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------716F830A9F375030D1752870"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

This is a multi-part message in MIME format.
--------------716F830A9F375030D1752870
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

I've attached a couple of patches contributed by Josh Sinykin.

-- 
Bruce


--------------716F830A9F375030D1752870
Content-Type: text/plain; charset=UTF-8;
 name="0001-Fix-garbage-characters-in-json-output-caused-by-time.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-Fix-garbage-characters-in-json-output-caused-by-time.pa";
 filename*1="tch"

RnJvbSAyMjgzYjg0M2Y0OTUxM2MzMjUxZTkwZGJmNTMwOTYyYWY3MGU1YzYyIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKb3NoIFNpbnlraW4gPGpvc2guc2lueWtpbkBicm9h
ZGNvbS5jb20+CkRhdGU6IE1vbiwgMTkgU2VwIDIwMTYgMDQ6MjU6MDIgKzAxMDAKU3ViamVj
dDogW1BBVENIXSBGaXggZ2FyYmFnZSBjaGFyYWN0ZXJzIGluIGpzb24gb3V0cHV0IGNhdXNl
ZCBieSB0aW1lX2J1ZgogYmVpbmcgdW5pbml0aWFsaXplZAoKLS0tCiBzdGF0LmMgfCAyICsr
CiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvc3RhdC5j
IGIvc3RhdC5jCmluZGV4IDc0YzI2ODYuLmM5MTQ4YWQgMTAwNjQ0Ci0tLSBhL3N0YXQuYwor
KysgYi9zdGF0LmMKQEAgLTY2OSw2ICs2NjksOCBAQCBzdGF0aWMgdm9pZCBzaG93X3RocmVh
ZF9zdGF0dXNfbm9ybWFsKHN0cnVjdCB0aHJlYWRfc3RhdCAqdHMsCiAKIAlpZiAoIWRkaXJf
cndfc3VtKHRzLT5pb19ieXRlcykgJiYgIWRkaXJfcndfc3VtKHRzLT50b3RhbF9pb191KSkK
IAkJcmV0dXJuOworCQkKKwltZW1zZXQodGltZV9idWYsIDAsIHNpemVvZih0aW1lX2J1Zikp
OwogCiAJdGltZSgmdGltZV9wKTsKIAlvc19jdGltZV9yKChjb25zdCB0aW1lX3QgKikgJnRp
bWVfcCwgdGltZV9idWYsIHNpemVvZih0aW1lX2J1ZikpOwotLSAKMi45LjMud2luZG93cy4y
Cgo=
--------------716F830A9F375030D1752870
Content-Type: text/plain; charset=UTF-8;
 name="0001-Windows-fix-Time_tToSystemTime-function-to-be-64-bit.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-Windows-fix-Time_tToSystemTime-function-to-be-64-bit.pa";
 filename*1="tch"

RnJvbSBmMTZlNGJhODY3NTM4MzlmOTA3ZWNlY2NlNzY4NGQ2MGU4ZTNlMmNhIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKb3NoIFNpbnlraW4gPGpvc2guc2lueWtpbkBicm9h
ZGNvbS5jb20+CkRhdGU6IE1vbiwgMTkgU2VwIDIwMTYgMDQ6MTc6MzAgKzAxMDAKU3ViamVj
dDogW1BBVENIXSBXaW5kb3dzOiBmaXggVGltZV90VG9TeXN0ZW1UaW1lIGZ1bmN0aW9uIHRv
IGJlIDY0LWJpdAogY29tcGxpYW50CgpVc2UgTE9OR0xPTkcgaW5zdGVhZCBvZiBMQVJHRV9J
TlRFR0VSIHRvIGF2b2lkIHByb2JsZW1zIG9uIDY0LWJpdApzeXN0ZW1zIGNhdXNpbmcgYSBj
cmFzaC4KLS0tCiBvcy93aW5kb3dzL3Bvc2l4LmMgfCAxMCArKysrKystLS0tCiAxIGZpbGUg
Y2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L29zL3dpbmRvd3MvcG9zaXguYyBiL29zL3dpbmRvd3MvcG9zaXguYwppbmRleCBmZDNkOWFi
Li41ODMwZTRjIDEwMDc1NQotLS0gYS9vcy93aW5kb3dzL3Bvc2l4LmMKKysrIGIvb3Mvd2lu
ZG93cy9wb3NpeC5jCkBAIC0yMzIsMTAgKzIzMiwxMiBAQCBjaGFyICpkbGVycm9yKHZvaWQp
CiAvKiBDb3BpZWQgZnJvbSBodHRwOi8vYmxvZ3MubXNkbi5jb20vYi9qb3NocG9sZXkvYXJj
aGl2ZS8yMDA3LzEyLzE5L2RhdGUtdGltZS1mb3JtYXRzLWFuZC1jb252ZXJzaW9ucy5hc3B4
ICovCiB2b2lkIFRpbWVfdFRvU3lzdGVtVGltZSh0aW1lX3QgZG9zVGltZSwgU1lTVEVNVElN
RSAqc3lzdGVtVGltZSkKIHsKLSAgICBMQVJHRV9JTlRFR0VSIGphbjE5NzBGVDsKLSAgICBM
QVJHRV9JTlRFR0VSIHV0Y0ZUOwotICAgIGphbjE5NzBGVC5RdWFkUGFydCA9IDExNjQ0NDcz
NjAwMDAwMDAwMExMOyAvLyBqYW51YXJ5IDFzdCAxOTcwCi0gICAgdXRjRlQuUXVhZFBhcnQg
PSAoKHVuc2lnbmVkIF9faW50NjQpZG9zVGltZSkgKiAxMDAwMDAwMCArIGphbjE5NzBGVC5R
dWFkUGFydDsKKyAgICBGSUxFVElNRSB1dGNGVDsKKyAgICBMT05HTE9ORyBqYW4xOTcwOwor
CisgICAgamFuMTk3MCA9IEludDMyeDMyVG82NChkb3NUaW1lLCAxMDAwMDAwMCkgKyAxMTY0
NDQ3MzYwMDAwMDAwMDA7CisgICAgdXRjRlQuZHdMb3dEYXRlVGltZSA9IChEV09SRClqYW4x
OTcwOworICAgIHV0Y0ZULmR3SGlnaERhdGVUaW1lID0gamFuMTk3MCA+PiAzMjsKIAogICAg
IEZpbGVUaW1lVG9TeXN0ZW1UaW1lKChGSUxFVElNRSopJnV0Y0ZULCBzeXN0ZW1UaW1lKTsK
IH0KLS0gCjIuOS4zLndpbmRvd3MuMgoK
--------------716F830A9F375030D1752870--
