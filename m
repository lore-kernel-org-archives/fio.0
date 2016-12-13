Return-Path: <Vincent.Fu@sandisk.com>
From: Vincent Fu <Vincent.Fu@sandisk.com>
Subject: [PATCH] use type double in creating floating point JSON values
Date: Tue, 13 Dec 2016 20:55:23 +0000
Message-ID: <BL2PR02MB19863CD9980E3B05246402678C9B0@BL2PR02MB1986.namprd02.prod.outlook.com>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_BL2PR02MB19863CD9980E3B05246402678C9B0BL2PR02MB1986namp_"
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--_002_BL2PR02MB19863CD9980E3B05246402678C9B0BL2PR02MB1986namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

struct json_value uses a double to store floating point values. Have
json_create_value_float also take a double (instead of a float) as an
argument.


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

--_002_BL2PR02MB19863CD9980E3B05246402678C9B0BL2PR02MB1986namp_
Content-Type: text/x-patch;
	name="0001-use-type-double-in-creating-floating-point-JSON-valu.patch"
Content-Description: 0001-use-type-double-in-creating-floating-point-JSON-valu.patch
Content-Disposition: attachment;
	filename="0001-use-type-double-in-creating-floating-point-JSON-valu.patch";
	size=856; creation-date="Tue, 13 Dec 2016 20:55:23 GMT";
	modification-date="Tue, 13 Dec 2016 20:55:23 GMT"
Content-Transfer-Encoding: base64

RnJvbSBlMjBlODkzNTBjNzIyODRhMGRkNzhlZWQxYmNkYzRiZDZmMDE5YzAwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBWaW5jZW50IEZ1IDxWaW5jZW50LkZ1QHNhbmRpc2suY29tPgpE
YXRlOiBUdWUsIDEzIERlYyAyMDE2IDE1OjQwOjQ2IC0wNTAwClN1YmplY3Q6IFtQQVRDSF0gdXNl
IHR5cGUgZG91YmxlIGluIGNyZWF0aW5nIGZsb2F0aW5nIHBvaW50IEpTT04gdmFsdWVzCgpzdHJ1
Y3QganNvbl92YWx1ZSB1c2VzIGEgZG91YmxlIHRvIHN0b3JlIGZsb2F0aW5nIHBvaW50IHZhbHVl
cy4gSGF2ZSBqc29uX2NyZWF0ZV92YWx1ZV9mbG9hdCBhbHNvIHRha2UgYSBkb3VibGUgKGluc3Rl
YWQgb2YgYSBmbG9hdCkgYXMgYW4gYXJndW1lbnQuCi0tLQoganNvbi5jIHwgMiArLQogMSBmaWxl
IGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvanNv
bi5jIGIvanNvbi5jCmluZGV4IDE5MGZhOWUuLmUwMjI3ZWMgMTAwNjQ0Ci0tLSBhL2pzb24uYwor
KysgYi9qc29uLmMKQEAgLTQwLDcgKzQwLDcgQEAgc3RhdGljIHN0cnVjdCBqc29uX3ZhbHVlICpq
c29uX2NyZWF0ZV92YWx1ZV9pbnQobG9uZyBsb25nIG51bWJlcikKIAlyZXR1cm4gdmFsdWU7CiB9
CiAKLXN0YXRpYyBzdHJ1Y3QganNvbl92YWx1ZSAqanNvbl9jcmVhdGVfdmFsdWVfZmxvYXQoZmxv
YXQgbnVtYmVyKQorc3RhdGljIHN0cnVjdCBqc29uX3ZhbHVlICpqc29uX2NyZWF0ZV92YWx1ZV9m
bG9hdChkb3VibGUgbnVtYmVyKQogewogCXN0cnVjdCBqc29uX3ZhbHVlICp2YWx1ZSA9IG1hbGxv
YyhzaXplb2Yoc3RydWN0IGpzb25fdmFsdWUpKTsKIAotLSAKMi43LjQgKEFwcGxlIEdpdC02NikK
Cg==

--_002_BL2PR02MB19863CD9980E3B05246402678C9B0BL2PR02MB1986namp_--

