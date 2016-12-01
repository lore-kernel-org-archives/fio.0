Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bn3nam01on0085.outbound.protection.outlook.com ([104.47.33.85]:54959
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933593AbcLAR3X (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Dec 2016 12:29:23 -0500
From: Vincent Fu <Vincent.Fu@sandisk.com>
Subject: fio server code fix
Date: Thu, 1 Dec 2016 17:29:20 +0000
Message-ID: <BL2PR02MB1986D5E469BCE99E7753CF008C8F0@BL2PR02MB1986.namprd02.prod.outlook.com>
Content-Language: en-US
Content-Type: multipart/mixed;
        boundary="_002_BL2PR02MB1986D5E469BCE99E7753CF008C8F0BL2PR02MB1986namp_"
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>

--_002_BL2PR02MB1986D5E469BCE99E7753CF008C8F0BL2PR02MB1986namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Jens, I have been working on getting steadystate detection to work in
client/server mode and believe I found a bug in the server code. Please
see the attached patch.

Vincent


--
Vincent Fu
Software Dev Engr II
SanDisk, a Western Digital brand
Email: Vincent.Fu@SanDisk.com
Office: 801 987 7079

PLEASE NOTE: The information contained in this electronic mail message is i=
ntended only for the use of the designated recipient(s) named above. If the=
 reader of this message is not the intended recipient, you are hereby notif=
ied that you have received this message in error and that any review, disse=
mination, distribution, or copying of this message is strictly prohibited. =
If you have received this communication in error, please notify the sender =
by telephone or e-mail (as shown above) immediately and destroy any and all=
 copies of this message in your possession (whether hard copies or electron=
ically stored copies).

--_002_BL2PR02MB1986D5E469BCE99E7753CF008C8F0BL2PR02MB1986namp_
Content-Type: text/x-patch;
	name="0001-Fix-conversion-in-fio_server_send_ts.patch"
Content-Description: 0001-Fix-conversion-in-fio_server_send_ts.patch
Content-Disposition: attachment;
	filename="0001-Fix-conversion-in-fio_server_send_ts.patch"; size=956;
	creation-date="Thu, 01 Dec 2016 17:28:54 GMT";
	modification-date="Thu, 01 Dec 2016 17:28:54 GMT"
Content-Transfer-Encoding: base64

RnJvbSAwYmQ5MmU2MTBkYTlhMjVkNzE3MzMwMjVkYzc3YTVkYThiMDM3YzVmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBWaW5jZW50IEZ1IDxWaW5jZW50LkZ1QHNhbmRpc2suY29tPgpE
YXRlOiBUaHUsIDEgRGVjIDIwMTYgMTI6MjA6MDggLTA1MDAKU3ViamVjdDogW1BBVENIIDEvMV0g
Rml4IGNvbnZlcnNpb24gaW4gZmlvX3NlcnZlcl9zZW5kX3RzCgotLS0KIHNlcnZlci5jIHwgNCAr
Ky0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlm
ZiAtLWdpdCBhL3NlcnZlci5jIGIvc2VydmVyLmMKaW5kZXggYWIzZTdjZi4uMTcyY2NjMCAxMDA2
NDQKLS0tIGEvc2VydmVyLmMKKysrIGIvc2VydmVyLmMKQEAgLTE1NDEsOSArMTU0MSw5IEBAIHZv
aWQgZmlvX3NlcnZlcl9zZW5kX3RzKHN0cnVjdCB0aHJlYWRfc3RhdCAqdHMsIHN0cnVjdCBncm91
cF9ydW5fc3RhdHMgKnJzKQogCXAudHMubGF0ZW5jeV93aW5kb3cJPSBjcHVfdG9fbGU2NCh0cy0+
bGF0ZW5jeV93aW5kb3cpOwogCXAudHMubGF0ZW5jeV9wZXJjZW50aWxlLnUuaSA9IGNwdV90b19s
ZTY0KGZpb19kb3VibGVfdG9fdWludDY0KHRzLT5sYXRlbmN5X3BlcmNlbnRpbGUudS5mKSk7CiAK
LQlwLnRzLm5yX2Jsb2NrX2luZm9zCT0gbGU2NF90b19jcHUodHMtPm5yX2Jsb2NrX2luZm9zKTsK
KwlwLnRzLm5yX2Jsb2NrX2luZm9zCT0gY3B1X3RvX2xlNjQodHMtPm5yX2Jsb2NrX2luZm9zKTsK
IAlmb3IgKGkgPSAwOyBpIDwgcC50cy5ucl9ibG9ja19pbmZvczsgaSsrKQotCQlwLnRzLmJsb2Nr
X2luZm9zW2ldID0gbGUzMl90b19jcHUodHMtPmJsb2NrX2luZm9zW2ldKTsKKwkJcC50cy5ibG9j
a19pbmZvc1tpXSA9IGNwdV90b19sZTMyKHRzLT5ibG9ja19pbmZvc1tpXSk7CiAKIAljb252ZXJ0
X2dzKCZwLnJzLCBycyk7CiAKLS0gCjIuNy40IChBcHBsZSBHaXQtNjYpCgo=

--_002_BL2PR02MB1986D5E469BCE99E7753CF008C8F0BL2PR02MB1986namp_--
