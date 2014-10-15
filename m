Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([204.109.60.166]:35748 "EHLO
	muon.cran.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbaJOUGD (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 15 Oct 2014 16:06:03 -0400
Received: from [10.0.10.100] (c-67-182-239-81.hsd1.ut.comcast.net [67.182.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by muon.cran.org.uk (Postfix) with ESMTPSA id 4610D1D6444
	for <fio@vger.kernel.org>; Wed, 15 Oct 2014 14:06:01 -0600 (MDT)
Message-ID: <543ED3A5.1010806@cran.org.uk>
Date: Wed, 15 Oct 2014 14:05:57 -0600
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: [PATCH] BSD Yacc doesn't understand --no-lines, so use -l instead.
Content-Type: multipart/mixed;
 boundary="------------010503010408030307070107"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------010503010408030307070107
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

I've attached a patch which fixes building on FreeBSD when bison isn't 
installed. Both BSD and GNU Yacc understand "-l".

-- 
Bruce

--------------010503010408030307070107
Content-Type: text/plain; charset=windows-1252;
 name="fio-patch.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="fio-patch.diff"

RnJvbSA2MjIyYzZmYWYzODJlZjQwYmFkMDIyYTA2ZmEyYTc1M2NhZmMxNzExIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBCcnVjZSBDcmFuIDxicnVjZUBjcmFuLm9yZy51az4K
RGF0ZTogV2VkLCAxNSBPY3QgMjAxNCAxNDowMTozNCAtMDYwMApTdWJqZWN0OiBbUEFUQ0hd
IEJTRCBZYWNjIGRvZXNuJ3QgdW5kZXJzdGFuZCAtLW5vLWxpbmVzLCBzbyB1c2UgLWwgaW5z
dGVhZC4KCi0tLQogTWFrZWZpbGUgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRp
b24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9NYWtlZmlsZSBiL01ha2VmaWxl
CmluZGV4IDBmNzdkZjkuLjU1YTkzZmMgMTAwNjQ0Ci0tLSBhL01ha2VmaWxlCisrKyBiL01h
a2VmaWxlCkBAIC0yNzYsNyArMjc2LDcgQEAgeS50YWIubzogeS50YWIuYyB5LnRhYi5oCiAg
ICAgICAgJChRVUlFVF9DQykkKENDKSAtbyAkQCAkKENGTEFHUykgJChDUFBGTEFHUykgLWMg
JDwKCiB5LnRhYi5jOiBleHAvZXhwcmVzc2lvbi1wYXJzZXIueQotICAgICAgICQoUVVJRVRf
WUFDQykkKFlBQ0MpIC0tbm8tbGluZXMgLWQgLWIgeSBleHAvZXhwcmVzc2lvbi1wYXJzZXIu
eQorICAgICAgICQoUVVJRVRfWUFDQykkKFlBQ0MpIC1sIC1kIC1iIHkgZXhwL2V4cHJlc3Np
b24tcGFyc2VyLnkKCiB5LnRhYi5oOiB5LnRhYi5jCgotLQoyLjEuMAo=
--------------010503010408030307070107--
