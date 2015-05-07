Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([204.109.60.166]:29950 "EHLO
	muon.cran.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbbEGDbV (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 6 May 2015 23:31:21 -0400
Received: from muon.bluestop.org (localhost [127.0.0.1])
	by muon.cran.org.uk (Postfix) with ESMTP id 09D1D1FD709
	for <fio@vger.kernel.org>; Wed,  6 May 2015 21:31:21 -0600 (MDT)
Received: from muon.cran.org.uk ([127.0.0.1])
	by muon.bluestop.org (muon.bluestop.org [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id F1x35EsHhwhV for <fio@vger.kernel.org>;
	Wed,  6 May 2015 21:31:20 -0600 (MDT)
Received: from [10.50.3.54] (63-158-132-10.dia.static.qwest.net [63.158.132.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by muon.cran.org.uk (Postfix) with ESMTPSA
	for <fio@vger.kernel.org>; Wed,  6 May 2015 21:31:20 -0600 (MDT)
Message-ID: <554ADC87.2070605@cran.org.uk>
Date: Wed, 06 May 2015 21:31:19 -0600
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: [PATCH] Add Windows ctime_r implementation and empty ioctl.h header
Content-Type: multipart/mixed;
 boundary="------------030601040808050307040200"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------030601040808050307040200
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

I've attached a patch that adds ctime_r to the Windows build and an 
empty ioctl.h header that the build appears to need now.   There are 
linker errors after building the fio binary - I guess the other programs 
need the Windows posix.c linked in?  I'm not sure how the 
configure/build system works now, so I wasn't able to update it.

-- 
Bruce

--------------030601040808050307040200
Content-Type: text/plain; charset=windows-1252;
 name="0001-Add-Windows-ctime_r-implementation-and-add-empty-ioc.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-Add-Windows-ctime_r-implementation-and-add-empty-ioc.pa";
 filename*1="tch"

RnJvbSBjYTg2OTNiYjVhZjIzZmMwMTMzZmEzMjY3ZjhkMGNjNWM4ZDI1NjAwIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBCcnVjZSBDcmFuIDxicnVjZS5jcmFuQGdtYWlsLmNv
bT4KRGF0ZTogV2VkLCA2IE1heSAyMDE1IDE2OjMwOjQ2IC0wNjAwClN1YmplY3Q6IFtQQVRD
SF0gQWRkIFdpbmRvd3MgY3RpbWVfciBpbXBsZW1lbnRhdGlvbiBhbmQgYWRkIGVtcHR5IGlv
Y3RsLmgKIGhlYWRlcgoKc3RhdC5jIG5vdyB1c2VzIGN0aW1lX3IoKSwgc28gYWRkIGFuIGlt
cGxlbWVudGF0aW9uIGZvciBXaW5kb3dzLgpJdCdzIGV4cGVjdGVkIHRoYXQgaW9jdGwuaCBl
eGlzdHMgb24gZWFjaCBwbGF0Zm9ybSwgZXZlbiBpZiBpdCdzCm5vdCB1c2VkOiBhZGQgYW4g
ZW1wdHkgZmlsZSBvbiBXaW5kb3dzLgotLS0KIG9zL3dpbmRvd3MvcG9zaXguYyAgICAgICAg
ICAgICAgICAgICB8IDI0ICsrKysrKysrKysrKysrKysrKysrKysrKwogb3Mvd2luZG93cy9w
b3NpeC9pbmNsdWRlL3N5cy9pb2N0bC5oIHwgIDcgKysrKysrKwogMiBmaWxlcyBjaGFuZ2Vk
LCAzMSBpbnNlcnRpb25zKCspCiBjcmVhdGUgbW9kZSAxMDA2NDQgb3Mvd2luZG93cy9wb3Np
eC9pbmNsdWRlL3N5cy9pb2N0bC5oCgpkaWZmIC0tZ2l0IGEvb3Mvd2luZG93cy9wb3NpeC5j
IGIvb3Mvd2luZG93cy9wb3NpeC5jCmluZGV4IGQyMzhjNjQuLjQxZmM0ODAgMTAwNzU1Ci0t
LSBhL29zL3dpbmRvd3MvcG9zaXguYworKysgYi9vcy93aW5kb3dzL3Bvc2l4LmMKQEAgLTIy
OSw2ICsyMjksMzAgQEAgY2hhciAqZGxlcnJvcih2b2lkKQogCXJldHVybiBkbF9lcnJvcjsK
IH0KIAorLyogQ29waWVkIGZyb20gaHR0cDovL2Jsb2dzLm1zZG4uY29tL2Ivam9zaHBvbGV5
L2FyY2hpdmUvMjAwNy8xMi8xOS9kYXRlLXRpbWUtZm9ybWF0cy1hbmQtY29udmVyc2lvbnMu
YXNweCAqLwordm9pZCBUaW1lX3RUb1N5c3RlbVRpbWUodGltZV90IGRvc1RpbWUsIFNZU1RF
TVRJTUUgKnN5c3RlbVRpbWUpCit7CisgICAgTEFSR0VfSU5URUdFUiBqYW4xOTcwRlQ7Cisg
ICAgTEFSR0VfSU5URUdFUiB1dGNGVDsKKyAgICBqYW4xOTcwRlQuUXVhZFBhcnQgPSAxMTY0
NDQ3MzYwMDAwMDAwMDBMTDsgLy8gamFudWFyeSAxc3QgMTk3MAorICAgIHV0Y0ZULlF1YWRQ
YXJ0ID0gKCh1bnNpZ25lZCBfX2ludDY0KWRvc1RpbWUpICogMTAwMDAwMDAgKyBqYW4xOTcw
RlQuUXVhZFBhcnQ7CisKKyAgICBGaWxlVGltZVRvU3lzdGVtVGltZSgoRklMRVRJTUUqKSZ1
dGNGVCwgc3lzdGVtVGltZSk7Cit9CisKK2NoYXIqIGN0aW1lX3IoY29uc3QgdGltZV90ICp0
LCBjaGFyICpidWYpCit7CisgICAgU1lTVEVNVElNRSBzeXN0aW1lOworICAgIGNvbnN0IGNo
YXIgKiBjb25zdCBkYXlPZldlZWtbXSA9IHsgIk1vbiIsICJUdWUiLCAiV2VkIiwgIlRodSIs
ICJGcmkiLCAiU2F0IiwgIlN1biIgfTsKKyAgICBjb25zdCBjaGFyICogY29uc3QgbW9udGhP
ZlllYXJbXSA9IHsgIkphbiIsICJGZWIiLCAiTWFyIiwgIkFwciIsICJNYXkiLCAiSnVuIiwg
Ikp1bCIsICJBdWciLCAiU2VwIiwgIk9jdCIsICJOb3YiLCAiRGVjIiB9OworCisgICAgVGlt
ZV90VG9TeXN0ZW1UaW1lKCp0LCAmc3lzdGltZSk7CisgICAgLyogV2UgZG9uJ3Qga25vdyBo
b3cgbG9uZyBgYnVmYCBpcywgYnV0IGFzc3VtZSBpdCdzIHJvdW5kZWQgdXAgZnJvbSB0aGUg
bWluaW11bSBvZiAyNSB0byAzMiAqLworICAgIFN0cmluZ0NjaFByaW50ZkEoYnVmLCAzMiwg
IiVzICVzICVkICUwMmQ6JTAyZDolMDJkICUwNGQiLCBkYXlPZldlZWtbc3lzdGltZS53RGF5
T2ZXZWVrIC0gMV0sIG1vbnRoT2ZZZWFyW3N5c3RpbWUud01vbnRoIC0gMV0sCisJCQkJCQkJ
CQkJIHN5c3RpbWUud0RheSwgc3lzdGltZS53SG91ciwgc3lzdGltZS53TWludXRlLCBzeXN0
aW1lLndTZWNvbmQsIHN5c3RpbWUud1llYXIpOworICAgIHJldHVybiBidWY7Cit9CisKIGlu
dCBnZXR0aW1lb2ZkYXkoc3RydWN0IHRpbWV2YWwgKnJlc3RyaWN0IHRwLCB2b2lkICpyZXN0
cmljdCB0enApCiB7CiAJRklMRVRJTUUgZmlsZVRpbWU7CmRpZmYgLS1naXQgYS9vcy93aW5k
b3dzL3Bvc2l4L2luY2x1ZGUvc3lzL2lvY3RsLmggYi9vcy93aW5kb3dzL3Bvc2l4L2luY2x1
ZGUvc3lzL2lvY3RsLmgKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMC4uYTQy
MjQ3ZAotLS0gL2Rldi9udWxsCisrKyBiL29zL3dpbmRvd3MvcG9zaXgvaW5jbHVkZS9zeXMv
aW9jdGwuaApAQCAtMCwwICsxLDcgQEAKKyNpZm5kZWYgSU9DVExfSAorI2RlZmluZSBJT0NU
TF9ICisKKy8qIFRoaXMgZmlsZSBpcyBlbXB0eSBzaW5jZSBpdCBvbmx5IG5lZWRzIHRvIGV4
aXN0IG9uIFdpbmRvd3MKKyAgIGJ1dCBpc24ndCBvdGhlcndpc2UgdXNlZCAqLworCisjZW5k
aWYgLyogSU9DVExfSCAqLwpcIE5vIG5ld2xpbmUgYXQgZW5kIG9mIGZpbGUKLS0gCjEuOS41
Lm1zeXNnaXQuMQoK
--------------030601040808050307040200--
