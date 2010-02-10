Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qy0-f190.google.com ([209.85.221.190]:37506 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab0BJHDP (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 10 Feb 2010 02:03:15 -0500
Received: by qyk28 with SMTP id 28so1130134qyk.25
        for <fio@vger.kernel.org>; Tue, 09 Feb 2010 23:03:14 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 9 Feb 2010 23:55:52 -0700
Message-ID: <98a233181002092255vcdd88f8x19345f098300e97a@mail.gmail.com>
Subject: Patch to fix FreeBSD support
From: Josh Aune <luken@omner.org>
Content-Type: multipart/mixed; boundary=0014851f1e2a732ee5047f39866e
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

--0014851f1e2a732ee5047f39866e
Content-Type: text/plain; charset=ISO-8859-1

Hi,

Attached is a patch against fio-1.36 that fixes a few build issues on
FreeBSD.  Tested with FreeBSD 8 and Linux Fedora 6.

Josh

--0014851f1e2a732ee5047f39866e
Content-Type: application/octet-stream; name="fio-1.36__FreeBSD8.patch"
Content-Disposition: attachment; filename="fio-1.36__FreeBSD8.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g5hrfgx50

SW5kZXg6IGZpby0xLjM2L2hlbHBlcnMuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBmaW8tMS4zNi5vcmlnL2hl
bHBlcnMuYwkyMDEwLTAyLTA5IDE0OjM3OjEzLjAwMDAwMDAwMCAtMDcwMAorKysgZmlvLTEuMzYv
aGVscGVycy5jCTIwMTAtMDItMDkgMTQ6Mzk6NTcuMDAwMDAwMDAwIC0wNzAwCkBAIC0xLDQgKzEs
NiBAQAotI2luY2x1ZGUgPG1hbGxvYy5oPgorI2lmbmRlZiBfX0ZyZWVCU0RfXworICAjaW5jbHVk
ZSA8bWFsbG9jLmg+CisjZW5kaWYKICNpbmNsdWRlIDxzdGRsaWIuaD4KICNpbmNsdWRlIDxlcnJu
by5oPgogI2luY2x1ZGUgPHN5cy9zb2NrZXQuaD4KQEAgLTYsNiArOCwxNyBAQAogCiAjaW5jbHVk
ZSAiY29tcGlsZXIvY29tcGlsZXIuaCIKIAorI2lmZGVmIF9fRnJlZUJTRF9fCisKKy8vIE5vIGZk
YXRhc3luYygpIGluIEZyZWVCU0QKKyNpbmNsdWRlIDx1bmlzdGQuaD4KK2ludCBfX3dlYWsgZmRh
dGFzeW5jKGludCBmZCkKK3sKKwlyZXR1cm4gZnN5bmMoZmQpOworfQorCisjZWxzZSAvKiBfX0Zy
ZWVCU0RfXyAqLworCiBpbnQgX193ZWFrIHBvc2l4X21lbWFsaWduKHZvaWQgKipwdHIsIHNpemVf
dCBhbGlnbiwgc2l6ZV90IHNpemUpCiB7CiAJKnB0ciA9IG1lbWFsaWduKGFsaWduLCBzaXplKTsK
QEAgLTE1LDYgKzI4LDggQEAKIAlyZXR1cm4gRU5PTUVNOwogfQogCisjZW5kaWYKKwogaW50IF9f
d2VhayBwb3NpeF9mYWxsb2NhdGUoaW50IGZkLCBvZmZfdCBvZmZzZXQsIG9mZl90IGxlbikKIHsK
IAlyZXR1cm4gMDsKSW5kZXg6IGZpby0xLjM2L2hlbHBlcnMuaAo9PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBmaW8t
MS4zNi5vcmlnL2hlbHBlcnMuaAkyMDEwLTAyLTA5IDE0OjM3OjEzLjAwMDAwMDAwMCAtMDcwMAor
KysgZmlvLTEuMzYvaGVscGVycy5oCTIwMTAtMDItMDkgMTQ6Mzg6MTAuMDAwMDAwMDAwIC0wNzAw
CkBAIC0zLDcgKzMsMTIgQEAKIAogc3RydWN0IGluX2FkZHI7CiAKKyNpZmRlZiBfX0ZyZWVCU0Rf
XworZXh0ZXJuIGludCBfX3dlYWsgZmRhdGFzeW5jKGludCBmZCk7CisjZWxzZSAvLyBfX0ZyZWVC
U0RfXwogZXh0ZXJuIGludCBfX3dlYWsgcG9zaXhfbWVtYWxpZ24odm9pZCAqKnB0ciwgc2l6ZV90
IGFsaWduLCBzaXplX3Qgc2l6ZSk7CisjZW5kaWYKKwogZXh0ZXJuIGludCBfX3dlYWsgcG9zaXhf
ZmFsbG9jYXRlKGludCBmZCwgb2ZmX3Qgb2Zmc2V0LCBvZmZfdCBsZW4pOwogZXh0ZXJuIGludCBf
X3dlYWsgaW5ldF9hdG9uKGNvbnN0IGNoYXIgKmNwLCBzdHJ1Y3QgaW5fYWRkciAqaW5wKTsKIAo=
--0014851f1e2a732ee5047f39866e--
--:
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html


