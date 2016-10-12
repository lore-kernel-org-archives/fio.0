Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:61727 "EHLO muon.cran.org.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752581AbcJLC27 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 11 Oct 2016 22:28:59 -0400
Received: from muon.bluestop.org (localhost [127.0.0.1])
        by muon.cran.org.uk (Postfix) with ESMTP id F28D08371E
        for <fio@vger.kernel.org>; Wed, 12 Oct 2016 02:28:57 +0000 (UTC)
Received: from muon.cran.org.uk ([127.0.0.1])
        by muon.bluestop.org (muon.bluestop.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id MPPYMQzFHdSR for <fio@vger.kernel.org>;
        Wed, 12 Oct 2016 02:28:57 +0000 (UTC)
Received: from [10.50.3.126] (63-158-132-10.dia.static.qwest.net [63.158.132.10])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by muon.cran.org.uk (Postfix) with ESMTPSA
        for <fio@vger.kernel.org>; Wed, 12 Oct 2016 02:28:57 +0000 (UTC)
From: Bruce Cran <bruce@cran.org.uk>
Subject: [PATCH] Implement nice() for Windows
Message-ID: <136b33f7-ebb8-ee58-b4aa-b301c6433102@cran.org.uk>
Date: Wed, 12 Oct 2016 02:28:56 +0000
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------1BF63D9E47AB690D72A118F1"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

This is a multi-part message in MIME format.
--------------1BF63D9E47AB690D72A118F1
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Setting "nice=-5" (i.e. "Above normal" priority) gives fio sufficient 
scheduling priority to keep the disk queues full. Otherwise, with more 
than 2 disks it can't keep up with SSDs.

-- 
Bruce


--------------1BF63D9E47AB690D72A118F1
Content-Type: text/plain; charset=UTF-8;
 name="0001-Implement-nice-for-Windows.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="0001-Implement-nice-for-Windows.patch"

RnJvbSBiMDhlOTg0ZGZhYWY0YjAxMDVjMjdiYjdmZTc0NGM0MDVkMGFiY2Q0IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBCcnVjZSBDcmFuIDxicnVjZS5jcmFuQGdtYWlsLmNv
bT4KRGF0ZTogV2VkLCAxMiBPY3QgMjAxNiAwMzoyMjo0NyArMDEwMApTdWJqZWN0OiBbUEFU
Q0hdIEltcGxlbWVudCBuaWNlKCkgZm9yIFdpbmRvd3MKCk1hcCB0aGUgZm9sbG93aW5nIHJh
bmdlcyBmb3IgdGhlICJuaWNlIiBvcHRpb246CgpMZXNzIHRoYW4gLTE1OiAgSGlnaAotMSB0
aHJvdWdoIC0xNTogQWJvdmUgbm9ybWFsCjA6ICAgICAgICAgICAgICBOb3JtYWwKMSB0aHJv
dWdoIDE1OiAgIEJlbG93IG5vcm1hbApNb3JlIHRoYW4gMTU6ICAgTG93L0lkbGUKLS0tCiBI
T1dUTyAgICAgICAgICAgICAgfCAgNCArKysrCiBvcy93aW5kb3dzL3Bvc2l4LmMgfCAxNyAr
KysrKysrKysrKysrLS0tLQogMiBmaWxlcyBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspLCA0
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL0hPV1RPIGIvSE9XVE8KaW5kZXggMDc0MTlh
MS4uY2YxMDI0YyAxMDA2NDQKLS0tIGEvSE9XVE8KKysrIGIvSE9XVE8KQEAgLTEwNjYsNiAr
MTA2NiwxMCBAQCByYW5kb21fZ2VuZXJhdG9yPXN0cglGaW8gc3VwcG9ydHMgdGhlIGZvbGxv
d2luZyBlbmdpbmVzIGZvciBnZW5lcmF0aW5nCiAKIG5pY2U9aW50CVJ1biB0aGUgam9iIHdp
dGggdGhlIGdpdmVuIG5pY2UgdmFsdWUuIFNlZSBtYW4gbmljZSgyKS4KIAorICAgICBPbiBX
aW5kb3dzLCB2YWx1ZXMgbGVzcyB0aGFuIC0xNSBzZXQgdGhlIHByb2Nlc3MgY2xhc3MgdG8g
IkhpZ2giOworICAgICAtMSB0aHJvdWdoIC0xNSBzZXQgIkFib3ZlIE5vcm1hbCI7IDEgdGhy
b3VnaCAxNSAiQmVsb3cgTm9ybWFsIjsKKyAgICAgYW5kIGFib3ZlIDE1ICJJZGxlIiBwcmlv
cml0eSBjbGFzcy4KKwogcHJpbz1pbnQJU2V0IHRoZSBpbyBwcmlvcml0eSB2YWx1ZSBvZiB0
aGlzIGpvYi4gTGludXggbGltaXRzIHVzIHRvCiAJCWEgcG9zaXRpdmUgdmFsdWUgYmV0d2Vl
biAwIGFuZCA3LCB3aXRoIDAgYmVpbmcgdGhlIGhpZ2hlc3QuCiAJCVNlZSBtYW4gaW9uaWNl
KDEpLiBSZWZlciB0byBhbiBhcHByb3ByaWF0ZSBtYW5wYWdlIGZvcgpkaWZmIC0tZ2l0IGEv
b3Mvd2luZG93cy9wb3NpeC5jIGIvb3Mvd2luZG93cy9wb3NpeC5jCmluZGV4IDMzODgxMjcu
LmJiZDkzZTkgMTAwNzU1Ci0tLSBhL29zL3dpbmRvd3MvcG9zaXguYworKysgYi9vcy93aW5k
b3dzL3Bvc2l4LmMKQEAgLTY0NywxMCArNjQ3LDE5IEBAIGludCBzZXRnaWQoZ2lkX3QgZ2lk
KQogCiBpbnQgbmljZShpbnQgaW5jcikKIHsKLQlpZiAoaW5jciAhPSAwKSB7Ci0JCWVycm5v
ID0gRUlOVkFMOwotCQlyZXR1cm4gLTE7Ci0JfQorCURXT1JEIHByaW9jbGFzcyA9IE5PUk1B
TF9QUklPUklUWV9DTEFTUzsKKwkKKwlpZiAoaW5jciA8IC0xNSkKKwkJcHJpb2NsYXNzID0g
SElHSF9QUklPUklUWV9DTEFTUzsKKwllbHNlIGlmIChpbmNyIDwgMCkKKwkJcHJpb2NsYXNz
ID0gQUJPVkVfTk9STUFMX1BSSU9SSVRZX0NMQVNTOworCWVsc2UgaWYgKGluY3IgPiAxNSkK
KwkJcHJpb2NsYXNzID0gSURMRV9QUklPUklUWV9DTEFTUzsKKwllbHNlIGlmIChpbmNyID4g
MCkKKwkJcHJpb2NsYXNzID0gQkVMT1dfTk9STUFMX1BSSU9SSVRZX0NMQVNTOworCQorCWlm
ICghU2V0UHJpb3JpdHlDbGFzcyhHZXRDdXJyZW50UHJvY2VzcygpLCBwcmlvY2xhc3MpKQor
CQlsb2dfZXJyKCJmaW86IFNldFByaW9yaXR5Q2xhc3MgZmFpbGVkXG4iKTsKIAogCXJldHVy
biAwOwogfQotLSAKMi45LjMud2luZG93cy4yCgo=
--------------1BF63D9E47AB690D72A118F1--
