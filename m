Return-Path: <sbouchex@infovista.com>
From: =?iso-8859-1?Q?S=E9bastien_Bouchex_Bellomi=E9?= <sbouchex@infovista.com>
Subject: RE: json output issue on solaris sparc
Date: Tue, 11 Mar 2014 14:39:45 +0000
Message-ID: <5462368f49b44fcda98c00c97314435c@DB4PR03MB572.eurprd03.prod.outlook.com>
References: <48976ca93fb54c4182ec7189ffc533d1@DB4PR03MB572.eurprd03.prod.outlook.com>
 <5318ECDA.3060502@kernel.dk>
 <3e371a215a394ca383f6c1206a09fa6e@DB4PR03MB572.eurprd03.prod.outlook.com>
In-Reply-To: <3e371a215a394ca383f6c1206a09fa6e@DB4PR03MB572.eurprd03.prod.outlook.com>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_5462368f49b44fcda98c00c97314435cDB4PR03MB572eurprd03pro_"
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--_002_5462368f49b44fcda98c00c97314435cDB4PR03MB572eurprd03pro_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi,

OK, the issue was related to the alignment issue between the thread_options=
 structure and its "packed" version : The lexxx_to_cpu macros are incorrect=
ly casting the pointers and that causes an bus error.
I have fixed the issue by avoid casting the pointers and calling directly t=
he "swap" method.

I have also included a fixed on the thread_options structure regarding the =
ddir_seq_add variable : Its length was incorrect.

Attached, you will find a patch that's fixed both.

The 32 bit version is still not working on json but since the 64 bit versio=
n is working fine, I will not probably work on it.

Seb

-----Original Message-----
From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behal=
f Of S=E9bastien Bouchex Bellomi=E9
Sent: vendredi 7 mars 2014 08:51
To: Jens Axboe; fio@vger.kernel.org
Subject: RE: json output issue on solaris sparc

Hi,

I'm using a 32 bit binary. The 64 bit binary is just crashing at startup (b=
us error)

Seb

-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]
Sent: jeudi 6 mars 2014 22:47
To: S=E9bastien Bouchex Bellomi=E9; fio@vger.kernel.org
Subject: Re: json output issue on solaris sparc

On 03/04/2014 03:19 AM, S=E9bastien Bouchex Bellomi=E9 wrote:
> Hello,
>
> I'm trying fio on solaris sparc and I'm having an strange issue : io_byte=
s, bw, iops, runtime values are 0 when json output is enabled but contains =
valid values when using text (or terse) output format.
> I have tested on solaris x64 and everything is fine.

That's pretty weird... I lost my last SPARC box about 4 years ago, so I hav=
e nothing to test on. I wonder if it's an alignment thing. Is fio a 32-bit =
or 64-bit application?

--
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe fio" in the body =
of a message to majordomo@vger.kernel.org More majordomo info at  http://vg=
er.kernel.org/majordomo-info.html

--_002_5462368f49b44fcda98c00c97314435cDB4PR03MB572eurprd03pro_
Content-Type: application/octet-stream;
	name="Fixed-Solaric-sparc-alignement-issue.patch"
Content-Description: Fixed-Solaric-sparc-alignement-issue.patch
Content-Disposition: attachment;
	filename="Fixed-Solaric-sparc-alignement-issue.patch"; size=1269;
	creation-date="Tue, 11 Mar 2014 14:33:03 GMT";
	modification-date="Tue, 11 Mar 2014 14:33:03 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL29zL29zLmggYi9vcy9vcy5oCmluZGV4IDdmOTJkMWIuLjJmMmQwNjkgMTAw
NjQ0Ci0tLSBhL29zL29zLmgKKysrIGIvb3Mvb3MuaApAQCAtMjAxLDI4ICsyMDEsMjIgQEAKICNl
bmRpZiAvKiBGSU9fSEFWRV9CWVRFT1JERVJfRlVOQ1MgKi8KIAogI2RlZmluZSBsZTE2X3RvX2Nw
dSh2YWwpICh7CQkJXAotCXVpbnQxNl90ICpfX3ZhbCA9ICYodmFsKTsJCVwKLQlfX2xlMTZfdG9f
Y3B1KCpfX3ZhbCk7CQkJXAorCV9fbGUxNl90b19jcHUodmFsKTsJCQlcCiB9KQogI2RlZmluZSBs
ZTMyX3RvX2NwdSh2YWwpICh7CQkJXAotCXVpbnQzMl90ICpfX3ZhbCA9ICYodmFsKTsJCVwKLQlf
X2xlMzJfdG9fY3B1KCpfX3ZhbCk7CQkJXAorCV9fbGUzMl90b19jcHUodmFsKTsJCQlcCiB9KQog
I2RlZmluZSBsZTY0X3RvX2NwdSh2YWwpICh7CQkJXAotCXVpbnQ2NF90ICpfX3ZhbCA9ICYodmFs
KTsJCVwKLQlfX2xlNjRfdG9fY3B1KCpfX3ZhbCk7CQkJXAorCV9fbGU2NF90b19jcHUodmFsKTsJ
CQkJXAogfSkKICNkZWZpbmUgY3B1X3RvX2xlMTYodmFsKSAoewkJCVwKLQl1aW50MTZfdCAqX192
YWwgPSAmKHZhbCk7CQlcCi0JX19jcHVfdG9fbGUxNigqX192YWwpOwkJCVwKKwlfX2NwdV90b19s
ZTE2KHZhbCk7CQkJXAogfSkKICNkZWZpbmUgY3B1X3RvX2xlMzIodmFsKSAoewkJCVwKLQl1aW50
MzJfdCAqX192YWwgPSAmKHZhbCk7CQlcCi0JX19jcHVfdG9fbGUzMigqX192YWwpOwkJCVwKKwlf
X2NwdV90b19sZTMyKHZhbCk7CQkJXAogfSkKICNkZWZpbmUgY3B1X3RvX2xlNjQodmFsKSAoewkJ
CVwKLQl1aW50NjRfdCAqX192YWwgPSAmKHZhbCk7CQlcCi0JX19jcHVfdG9fbGU2NCgqX192YWwp
OwkJCVwKKwlfX2NwdV90b19sZTY0KHZhbCk7CQkJXAogfSkKIAogI2lmbmRlZiBGSU9fSEFWRV9C
TEtUUkFDRQpkaWZmIC0tZ2l0IGEvdGhyZWFkX29wdGlvbnMuaCBiL3RocmVhZF9vcHRpb25zLmgK
aW5kZXggNGVhNmViZC4uYmFjZDg2YiAxMDA2NDQKLS0tIGEvdGhyZWFkX29wdGlvbnMuaAorKysg
Yi90aHJlYWRfb3B0aW9ucy5oCkBAIC00NSw3ICs0NSw3IEBACiAJdW5zaWduZWQgaW50IGtiX2Jh
c2U7CiAJdW5zaWduZWQgaW50IHVuaXRfYmFzZTsKIAl1bnNpZ25lZCBpbnQgZGRpcl9zZXFfbnI7
Ci0JbG9uZyBkZGlyX3NlcV9hZGQ7CisJbG9uZyBsb25nIGRkaXJfc2VxX2FkZDsKIAl1bnNpZ25l
ZCBpbnQgaW9kZXB0aDsKIAl1bnNpZ25lZCBpbnQgaW9kZXB0aF9sb3c7CiAJdW5zaWduZWQgaW50
IGlvZGVwdGhfYmF0Y2g7

--_002_5462368f49b44fcda98c00c97314435cDB4PR03MB572eurprd03pro_--

