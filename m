Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout.micron.com ([137.201.242.129]:42577 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbbBMXRs (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 13 Feb 2015 18:17:48 -0500
Received: from mail.micron.com (ntxboicas01.micron.com [137.201.84.60])
	by mailout.micron.com (8.14.4/8.14.6) with ESMTP id t1DNHkwT008461
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=FAIL)
	for <fio@vger.kernel.org>; Fri, 13 Feb 2015 16:17:46 -0700
From: "Justin Eno (jeno)" <jeno@micron.com>
Subject: [RFC] [PATCH] Allow random overwrite workloads to write io_limit
Date: Fri, 13 Feb 2015 23:17:45 +0000
Message-ID: <5A8251503902B84E89CE171AD126BCFB2DE5C431@NTXBOIMBX01.micron.com>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_5A8251503902B84E89CE171AD126BCFB2DE5C431NTXBOIMBX01micr_"
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

--_002_5A8251503902B84E89CE171AD126BCFB2DE5C431NTXBOIMBX01micr_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

For a (random) overwrite workload, 'size' amount of access doesn't correspo=
nd to
each byte on the target having been touched, so setting size as the limit b=
etween
write- and verify-phases doesn't really apply.  The attached patch proposes=
 to
instead use io_limit as the limit if it's set.

io_limit < size is already handled by subsequent logic.  This patch just al=
lows
for io_limit > size.

Thanks,
Justin

--_002_5A8251503902B84E89CE171AD126BCFB2DE5C431NTXBOIMBX01micr_
Content-Type: application/octet-stream; name="io_limit.patch"
Content-Description: io_limit.patch
Content-Disposition: attachment; filename="io_limit.patch"; size=1661;
	creation-date="Fri, 13 Feb 2015 22:53:36 GMT";
	modification-date="Fri, 13 Feb 2015 22:53:36 GMT"
Content-Transfer-Encoding: base64

RnJvbSA5NTBjNGQwYjZjODAwYmVlZGIyZTRhZmIyN2JiN2FlNWQwNGMyODQ4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKdXN0aW4gRW5vIDxqZW5vQG1pY3Jvbi5jb20+CkRhdGU6IFRo
dSwgMjkgSmFuIDIwMTUgMTI6Mjc6NTggLTA4MDAKU3ViamVjdDogW1BBVENIXSBBbGxvdyByYW5k
b20gb3ZlcndyaXRlIHdvcmtsb2FkcyB0byB3cml0ZSBpb19saW1pdAoKTGltaXRpbmcgdGhlIHdy
aXRlIHBoYXNlIG9mIChyYW5kb20pIG92ZXJ3cml0ZSB3b3JrbG9hZHMgdG8gJ3NpemUnCmJlZm9y
ZSB0aGUgdmVyaWZ5IHBoYXNlIGRvZXNuJ3QgbWFrZSBzZW5zZSwgc28gYWxsb3cgdGhlbSB0byB3
cml0ZQp1cCB0byBpb19saW1pdC4gIFRoaXMgYmV0dGVyIG1hdGNoZXMgdmVyaWZ5X29ubHkgYmVo
YXZpb3IsIGFuZAphbGxvd3MgdGhlIFt2ZXJpZnktam9iXSBiZWxvdyB0byBzdWNjZWVkOgoKW2ds
b2JhbF0KdGhyZWFkPTEKZGlyZWN0PTEKaW9lbmdpbmU9c3luYwp2ZXJpZnk9bWV0YQpicz0xawpv
ZmZzZXQ9MApzaXplPTVNCmlvX2xpbWl0PTZNCm5vcmFuZG9tbWFwPTEKdmVyaWZ5X2ZhdGFsPTEK
cmFuZHNlZWQ9NDIKClt3cml0ZS1qb2JdCmZpbGVuYW1lPWRhdGFmaWxlLnRtcApydz1yYW5kd3Jp
dGUKZG9fdmVyaWZ5PTAKClt2ZXJpZnktam9iXQpzdG9uZXdhbGwKY3JlYXRlX3NlcmlhbGl6ZT0w
CmZpbGVuYW1lPWRhdGFmaWxlLnRtcApydz1yYW5kd3JpdGUKZG9fdmVyaWZ5PTEKdmVyaWZ5X29u
bHk9MQoKU2lnbmVkLW9mZi1ieTogSnVzdGluIEVubyA8amVub0BtaWNyb24uY29tPgotLS0KIGJh
Y2tlbmQuYyB8ICAgIDggKysrKysrKy0KIDEgZmlsZXMgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCsp
LCAxIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2JhY2tlbmQuYyBiL2JhY2tlbmQuYwppbmRl
eCA3ZWM4ZDJhLi4wZjRiN2MwIDEwMDY0NAotLS0gYS9iYWNrZW5kLmMKKysrIGIvYmFja2VuZC5j
CkBAIC03MjQsMTIgKzcyNCwxOCBAQCBzdGF0aWMgdWludDY0X3QgZG9faW8oc3RydWN0IHRocmVh
ZF9kYXRhICp0ZCkKIAogCWxhdF90YXJnZXRfaW5pdCh0ZCk7CiAKKwl0b3RhbF9ieXRlcyA9IHRk
LT5vLnNpemU7CisJLyoKKwkqIEFsbG93IHJhbmRvbSBvdmVyd3JpdGUgd29ya2xvYWRzIHRvIHdy
aXRlIHVwIHRvIGlvX2xpbWl0CisJKiBiZWZvcmUgc3RhcnRpbmcgdmVyaWZpY2F0aW9uIHBoYXNl
IGFzICdzaXplJyBkb2Vzbid0IGFwcGx5LgorCSovCisJaWYgKHRkX3dyaXRlKHRkKSAmJiB0ZF9y
YW5kb20odGQpICYmIHRkLT5vLm5vcmFuZG9tbWFwKQorCQl0b3RhbF9ieXRlcyA9IG1heCh0b3Rh
bF9ieXRlcywgKHVpbnQ2NF90KSB0ZC0+by5pb19saW1pdCk7CiAJLyoKIAkgKiBJZiB2ZXJpZnlf
YmFja2xvZyBpcyBlbmFibGVkLCB3ZSdsbCBydW4gdGhlIHZlcmlmeSBpbiB0aGlzCiAJICogaGFu
ZGxlciBhcyB3ZWxsLiBGb3IgdGhhdCBjYXNlLCB3ZSBtYXkgbmVlZCB1cCB0byB0d2ljZSB0aGUK
IAkgKiBhbW91bnQgb2YgYnl0ZXMuCiAJICovCi0JdG90YWxfYnl0ZXMgPSB0ZC0+by5zaXplOwog
CWlmICh0ZC0+by52ZXJpZnkgIT0gVkVSSUZZX05PTkUgJiYKIAkgICAodGRfd3JpdGUodGQpICYm
IHRkLT5vLnZlcmlmeV9iYWNrbG9nKSkKIAkJdG90YWxfYnl0ZXMgKz0gdGQtPm8uc2l6ZTsKLS0g
CjEuNy4xCgo=

--_002_5A8251503902B84E89CE171AD126BCFB2DE5C431NTXBOIMBX01micr_--
