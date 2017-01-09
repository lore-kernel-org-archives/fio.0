Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:16488 "EHLO muon.cran.org.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752155AbdAIVu2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 9 Jan 2017 16:50:28 -0500
Received: from muon.bluestop.org (localhost [127.0.0.1])
        by muon.cran.org.uk (Postfix) with ESMTP id 0AA753860B
        for <fio@vger.kernel.org>; Mon,  9 Jan 2017 21:50:27 +0000 (UTC)
Received: from muon.cran.org.uk ([127.0.0.1])
        by muon.bluestop.org (muon.bluestop.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id B38QkZJCQ6bt for <fio@vger.kernel.org>;
        Mon,  9 Jan 2017 21:50:26 +0000 (UTC)
Received: from [10.50.2.188] (63-158-132-10.dia.static.qwest.net [63.158.132.10])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by muon.cran.org.uk (Postfix) with ESMTPSA
        for <fio@vger.kernel.org>; Mon,  9 Jan 2017 21:50:26 +0000 (UTC)
From: Rebecca Cran <rebecca@bluestop.org>
Subject: [PATCH] Support zlib in the Windows build (enables latency histogram
 logging)
Message-ID: <0416e3e3-c7da-637b-5c90-e0fc155e65cc@bluestop.org>
Date: Mon, 9 Jan 2017 21:50:28 +0000
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------81A07D2D77A79C6EAA83E3AD"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

This is a multi-part message in MIME format.
--------------81A07D2D77A79C6EAA83E3AD
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Add support for building with zlib in the Windows build: this enables 
the latency histogram logging feature.


--------------81A07D2D77A79C6EAA83E3AD
Content-Type: text/plain; charset=UTF-8;
 name="0001-Support-zlib-in-the-Windows-build-enabled-latency-hi.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-Support-zlib-in-the-Windows-build-enabled-latency-hi.pa";
 filename*1="tch"

RnJvbSAzYzg1NTVhNWNjZjNjZDQ4ODdkMDc2OTQ0YmY4OGY5Njc5YWI1MDNhIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBSZWJlY2NhIENyYW4gPGJydWNlLmNyYW5Ac2FuZGlz
ay5jb20+CkRhdGU6IE1vbiwgOSBKYW4gMjAxNyAyMTo0NTozOCArMDAwMApTdWJqZWN0OiBb
UEFUQ0hdIFN1cHBvcnQgemxpYiBpbiB0aGUgV2luZG93cyBidWlsZCAoZW5hYmxlZCBsYXRl
bmN5IGhpc3RvZ3JhbQogbG9nZ2luZykKCi0tLQogY29uZmlndXJlIHwgMTMgKysrKysrKysr
KysrLQogMSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkK
CmRpZmYgLS1naXQgYS9jb25maWd1cmUgYi9jb25maWd1cmUKaW5kZXggN2RlODhmOC4uODY2
ODQyYyAxMDA3NTUKLS0tIGEvY29uZmlndXJlCisrKyBiL2NvbmZpZ3VyZQpAQCAtMjgxLDgg
KzI4MSwxOCBAQCBDWUdXSU4qKQogICBpZiB0ZXN0IC16ICIkQ0MiIDsgdGhlbgogICAgIGlm
IHRlc3QgISAteiAiJGJ1aWxkXzMyYml0X3dpbiIgJiYgdGVzdCAiJGJ1aWxkXzMyYml0X3dp
biIgPSAieWVzIjsgdGhlbgogICAgICAgQ0M9Imk2ODYtdzY0LW1pbmd3MzItZ2NjIgorICAg
ICAgaWYgdGVzdCAtZSAiLi4vemxpYi9jb250cmliL3ZzdHVkaW8vdmMxNC94ODYvWmxpYlN0
YXRSZWxlYXNlV2l0aG91dEFzbS96bGlic3RhdC5saWIiOyB0aGVuCisgICAgICAgIGVjaG8g
IkJ1aWxkaW5nIHdpdGggemxpYiBzdXBwb3J0IgorICAgICAgICBvdXRwdXRfc3ltICJDT05G
SUdfWkxJQiIKKyAgICAgICAgZWNobyAiTElCUz0uLi96bGliL2NvbnRyaWIvdnN0dWRpby92
YzE0L3g4Ni9abGliU3RhdFJlbGVhc2VXaXRob3V0QXNtL3psaWJzdGF0LmxpYiIgPj4gJGNv
bmZpZ19ob3N0X21haworICAgICAgZmkKICAgICBlbHNlCiAgICAgICBDQz0ieDg2XzY0LXc2
NC1taW5ndzMyLWdjYyIKKyAgICAgIGlmIHRlc3QgLWUgIi4uL3psaWIvY29udHJpYi92c3R1
ZGlvL3ZjMTQveDY0L1psaWJTdGF0UmVsZWFzZVdpdGhvdXRBc20vemxpYnN0YXQubGliIjsg
dGhlbgorICAgICAgICBlY2hvICJCdWlsZGluZyB3aXRoIHpsaWIgc3VwcG9ydCIKKyAgICAg
ICAgb3V0cHV0X3N5bSAiQ09ORklHX1pMSUIiCisgICAgICAgIGVjaG8gIkxJQlM9Li4vemxp
Yi9jb250cmliL3ZzdHVkaW8vdmMxNC94NjQvWmxpYlN0YXRSZWxlYXNlV2l0aG91dEFzbS96
bGlic3RhdC5saWIiID4+ICRjb25maWdfaG9zdF9tYWsKKyAgICAgIGZpCiAgICAgZmkKICAg
ZmkKICAgb3V0cHV0X3N5bSAiQ09ORklHX0xJVFRMRV9FTkRJQU4iCkBAIC0zMDYsNyArMzE2
LDggQEAgQ1lHV0lOKikKICAgb3V0cHV0X3N5bSAiQ09ORklHX1RMU19USFJFQUQiCiAgIG91
dHB1dF9zeW0gIkNPTkZJR19JUFY2IgogICBlY2hvICJDQz0kQ0MiID4+ICRjb25maWdfaG9z
dF9tYWsKLSAgZWNobyAiQlVJTERfQ0ZMQUdTPSRDRkxBR1MgLWluY2x1ZGUgY29uZmlnLWhv
c3QuaCAtRF9HTlVfU09VUkNFIiA+PiAkY29uZmlnX2hvc3RfbWFrCisgIGVjaG8gIkJVSUxE
X0NGTEFHUz0kQ0ZMQUdTIC1JLi4vemxpYiAtaW5jbHVkZSBjb25maWctaG9zdC5oIC1EX0dO
VV9TT1VSQ0UiID4+ICRjb25maWdfaG9zdF9tYWsKKwogICBleGl0IDAKICAgOzsKIGVzYWMK
LS0gCjIuOS4zLndpbmRvd3MuMgoK
--------------81A07D2D77A79C6EAA83E3AD--
