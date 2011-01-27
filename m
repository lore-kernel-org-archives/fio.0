Return-Path: <bruce@cran.org.uk>
MIME-Version: 1.0
From: Bruce Cran <bruce@cran.org.uk>
Date: Thu, 27 Jan 2011 15:06:06 -0700
Subject: Re: Recent changes
Message-ID: <20110127220606.000076a4@unknown>
References: <20110125050003.F378B37A302@kernel.dk>
	<4D41DEEA.8040608@austin.ibm.com>
In-Reply-To: <4D41DEEA.8040608@austin.ibm.com>
Content-Language: en-US
Content-Type: multipart/mixed; boundary="_002_20110127220606000076a4unknown_"
To: Steven Pratt <slpratt@austin.ibm.com>
Cc: Jens Axboe <JAxboe@fusionio.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--_002_20110127220606000076a4unknown_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Jan 2011 15:08:58 -0600
Steven Pratt <slpratt@austin.ibm.com> wrote:

> Jens, the nested else ifeq statements in the main Makfile blow up on
> make versions prior to 3.81.  SLES10 still has 3.80.  Not a big deal
> for me, but I work with some folks for which this is over their
> heads.  Any chance we could revert back to a more compatible syntax?

Confirmed with make 3.75 on FreeBSD. The attached patch should fix it.

--=20
Bruce Cran

--_002_20110127220606000076a4unknown_
Content-Type: application/x-gzip; name="fio_Makefile.diff.gz"
Content-Description: fio_Makefile.diff.gz
Content-Disposition: attachment; filename="fio_Makefile.diff.gz"; size=545;
	creation-date="Thu, 27 Jan 2011 15:06:21 GMT";
	modification-date="Thu, 27 Jan 2011 15:06:21 GMT"
Content-Transfer-Encoding: base64

H4sICAjsQU0CAGZpb19NYWtlZmlsZS5kaWZmAMWU32/aMBDHn8lfcQ99AIXwa2xjD5NKIaBIaaia
VeukSVFILsGrZ2e2K9h/vwsFQkXoVmlSX5zL3fnu83UuTlmWgePkzEDcvY4fMGMcYXkwLSZS3ECa
vR8NR586nd5H7PX7CP1e78NwaDmOc7TPsm37eO/lJTiDQXswApse74ZADpbhL2heNO+C8bXbaoPP
xOOmZUGjgSJnAnV3ycQPTEwngUJJqkMuw+QSRbLqJBYA+N5VCPZncHhhVgrjlKyU06IMLTGTZdJk
5o/nT2kq/S3inyyxHOQaTwjCR7EIW5aNgg7DsuvDZclwcXc7ccuSGcsk8XG27GqjNBb0skJeoNJk
acljxUprL6mQmm0IjFzfj6XuMilSKWvUSqOUvUChS4eWyQOardKbm0rrNIrc+y9uEHqLIIyiM5Jn
CvEqnFaizyQ8l72TeCLsBfwt8+s+R4DmOdpp/I3Ixt59hVUTrB2SPdpuXHI0sjARlyJ/HWzKXyQ+
nQN/fDt3o5nnu+F2LIoiOTsP01itmajE1cf/x5mn/IAgyh7ti2ZGVwz9RUzkMPk2/+oF7X3jVkX0
j+nHgAesNe2Qa/33YXjq9QdHlZLKEwUAAA==

--_002_20110127220606000076a4unknown_--


