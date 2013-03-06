Return-Path: <fio-owner@vger.kernel.org>
Received: from onlyone.friendlyhosting.spb.ru ([46.4.40.135]:32408 "EHLO
	onlyone.friendlyhosting.spb.ru" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757481Ab3CFPQL (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 6 Mar 2013 10:16:11 -0500
Received: from lion.home.serebryakov.spb.ru (unknown [IPv6:2001:470:923f:1:9421:367:9d7d:512b])
	(Authenticated sender: lev@serebryakov.spb.ru)
	by onlyone.friendlyhosting.spb.ru (Postfix) with ESMTPA id 7F41E4AC57
	for <fio@vger.kernel.org>; Wed,  6 Mar 2013 19:08:21 +0400 (MSK)
Date: Wed, 6 Mar 2013 19:08:19 +0400
From: Lev Serebryakov <lev@serebryakov.spb.ru>
Message-ID: <1404460263.20130306190819@serebryakov.spb.ru>
Subject: fio-2.0.14 crashes with "Assertion failed: (data->fail_ok), function axmap_set_fn, file lib/axmap.c, line 233."
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="----------04F1A00031084D02F"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

------------04F1A00031084D02F
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello, Fio.

  FreeBSD 9.1-STABLE, dual-core machine with 6GiB of physical RAM, job
 file with 8 jobs with filesize=3D1G-2G (attached).

   fio --latency-log --bandwidth-log torrent-like.fio

 crashes after file layout:

file-1: (g=3D0): rw=3Drandrw, bs=3D64-64/128K-128K/128K-128K, ioengine=3Dps=
ync, iodepth=3D1
file-2: (g=3D0): rw=3Drandrw, bs=3D64-64/128K-128K/128K-128K, ioengine=3Dps=
ync, iodepth=3D1
file-3: (g=3D0): rw=3Drandrw, bs=3D64-64/128K-128K/128K-128K, ioengine=3Dps=
ync, iodepth=3D1
file-4: (g=3D0): rw=3Drandrw, bs=3D64-64/128K-128K/128K-128K, ioengine=3Dps=
ync, iodepth=3D1
file-5: (g=3D0): rw=3Drandrw, bs=3D64-64/128K-128K/128K-128K, ioengine=3Dps=
ync, iodepth=3D1
file-6: (g=3D0): rw=3Drandrw, bs=3D64-64/128K-128K/128K-128K, ioengine=3Dps=
ync, iodepth=3D1
file-7: (g=3D0): rw=3Drandrw, bs=3D64-64/128K-128K/128K-128K, ioengine=3Dps=
ync, iodepth=3D1
file-8: (g=3D0): rw=3Drandrw, bs=3D64-64/128K-128K/128K-128K, ioengine=3Dps=
ync, iodepth=3D1
fio-2.0.14
Starting 8 threads
file-1: Laying out IO file(s) (1 file(s) / 1910MB)
file-2: Laying out IO file(s) (1 file(s) / 1910MB)
file-3: Laying out IO file(s) (1 file(s) / 1910MB)
file-4: Laying out IO file(s) (1 file(s) / 1910MB)
file-5: Laying out IO file(s) (1 file(s) / 1910MB)
file-6: Laying out IO file(s) (1 file(s) / 1910MB)
file-7: Laying out IO file(s) (1 file(s) / 1910MB)
file-8: Laying out IO file(s) (1 file(s) / 1910MB)
Assertion failed: (data->fail_ok), function axmap_set_fn, file lib/axmap.c,=
 line 233.
=D0=90=D0=B2=D0=B0=D1=80=D0=B8=D0=B9=D0=BD=D0=BE=D0=B5 =D0=B7=D0=B0=D0=B2=
=D0=B5=D1=80=D1=88=D0=B5=D0=BD=D0=B8=D0=B5(core dumped)


--=20
// Black Lion AKA Lev Serebryakov <lev@serebryakov.spb.ru>
------------04F1A00031084D02F
Content-Type: application/octet-stream;
 name="torrent-like.fio"
Content-transfer-encoding: base64
Content-Disposition: attachment;
 filename="torrent-like.fio"

W2dsb2JhbF0KZGVzY3JpcHRpb249UmFuZG9tIFIvVyB3aXRoIDI1Ojc1IFI6VywgNjRLIGJs
b2NrcyBhbmQgbWFueSB0aHJlYWRzIG9uIGJpZyBmaWxlcwpyZWFkd3JpdGU9cmFuZHJ3OjEK
cndfc2VxdWVuY2VyPWlkZW50aWNhbApmYWxsb2NhdGU9bm9uZQpmYWR2aXNlX2hpbnQ9MApi
bG9ja3NpemU9NjRLLTEyOEsKYmxvY2tzaXplX3VuYWxpZ25lZD0wCm5yZmlsZXM9MQppb2Vu
Z2luZT1wc3luYwpmc3luYz0wCm92ZXJ3cml0ZT0xCmZzeW5jX29uX2Nsb3NlPTEKbm9yYW5k
b21tYXA9MAp0aHJlYWQKc2l6ZT00RwoKW2ZpbGUtMV0KbmFtZT1maWxlLTEKZmlsZXNpemU9
MUctNEcKCltmaWxlLTJdCm5hbWU9ZmlsZS0yCmZpbGVzaXplPTFHLTRHCgpbZmlsZS0zXQpu
YW1lPWZpbGUtMwpmaWxlc2l6ZT0xRy00RwoKW2ZpbGUtNF0KbmFtZT1maWxlLTQKZmlsZXNp
emU9MUctNEcKCltmaWxlLTVdCm5hbWU9ZmlsZS01CmZpbGVzaXplPTFHLTRHCgpbZmlsZS02
XQpuYW1lPWZpbGUtNgpmaWxlc2l6ZT0xRy00RwoKW2ZpbGUtN10KbmFtZT1maWxlLTcKZmls
ZXNpemU9MUctNEcKCltmaWxlLThdCm5hbWU9ZmlsZS04CmZpbGVzaXplPTFHLTRHCgo=
------------04F1A00031084D02F--

