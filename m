Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.thomas-krenn.com ([217.7.54.186]:41250 "EHLO
	mail.thomas-krenn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab2FKHYl (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 11 Jun 2012 03:24:41 -0400
Received: from iris.tks.local (iris.tks.local [192.168.10.63])
	by mail.thomas-krenn.com (Postfix) with ESMTP id EC518BE114
	for <fio@vger.kernel.org>; Mon, 11 Jun 2012 09:24:39 +0200 (CEST)
Received: from localhost (ate.tks.local [192.168.10.78])
	by iris.tks.local (Postfix) with ESMTP id 9E5B93FD93
	for <fio@vger.kernel.org>; Mon, 11 Jun 2012 09:24:39 +0200 (CEST)
Received: from mail.thomas-krenn.com ([127.0.0.1])
	by localhost (ate.TKS.local [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oa+0GtbrY-yG for <fio@vger.kernel.org>;
	Mon, 11 Jun 2012 09:24:30 +0200 (CEST)
Received: from [10.1.102.103] (unknown [91.223.201.22])
	by mail.thomas-krenn.com (Postfix) with ESMTPSA
	for <fio@vger.kernel.org>; Mon, 11 Jun 2012 09:24:30 +0200 (CEST)
Message-ID: <4FD59D2D.3000503@thomas-krenn.com>
Date: Mon, 11 Jun 2012 09:24:29 +0200
From: =?ISO-8859-15?Q?Georg_Sch=F6nberger?= 
	<gschoenberger@thomas-krenn.com>
MIME-Version: 1.0
Subject: Re: Error running Fio SSD example
References: <4FC8942A.6090805@thomas-krenn.com> <4FD1F462.4070404@fusionio.com> <4FD23443.6020705@thomas-krenn.com> <4FD24807.8080700@fusionio.com>
In-Reply-To: <4FD24807.8080700@fusionio.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Am 2012-06-08 20:44, schrieb Jens Axboe:
> On 2012-06-08 19:20, Georg Sch=EF=BF=BDnberger wrote:
>> Am 2012-06-08 14:47, schrieb Jens Axboe:
>>> On 06/01/2012 12:06 PM, Georg Sch=EF=BF=BDnberger wrote:
>>>> Hello again,
>>>>
>>>> I am having some troubles with running the fio example "ssd-test". I
>>>> changed the global section to decrease the size:
>>>> [global]
>>>> bs=3D4k
>>>> ioengine=3Dlibaio
>>>> iodepth=3D4
>>>> size=3D100M
>>>> direct=3D1
>>>> runtime=3D60
>>>> filename=3Dssd.test.file
>>>>
>>>> If I am running Fio I get the following error:
>>>> ----------------------------------------
>>>> fio.git/examples$ fio ssd-test
>>>> seq-read: (g=3D0): rw=3Dread, bs=3D4K-4K/4K-4K, ioengine=3Dlibaio, iod=
epth=3D4
>>>> rand-read: (g=3D1): rw=3Drandread, bs=3D4K-4K/4K-4K, ioengine=3Dlibaio=
, iodepth=3D4
>>>> seq-write: (g=3D2): rw=3Dwrite, bs=3D4K-4K/4K-4K, ioengine=3Dlibaio, i=
odepth=3D4
>>>> rand-write: (g=3D3): rw=3Drandwrite, bs=3D4K-4K/4K-4K, ioengine=3Dliba=
io, iodepth=3D4
>>>> fio-2.0.8
>>>> Starting 4 processes
>>>> fio: pid=3D17997, err=3D22/file:filesetup.c:529, func=3Dopen(ssd.test.=
file),
>>>> error=3DInvalid argument
>>>> fio: pid=3D17998, err=3D22/file:filesetup.c:529, func=3Dopen(ssd.test.=
file),
>>>> error=3DInvalid argument
>>>> fio: pid=3D17999, err=3D22/file:filesetup.c:529, func=3Dopen(ssd.test.=
file),
>>>> error=3DInvalid argument
>>>> fio: pid=3D18000, err=3D22/file:filesetup.c:529, func=3Dopen(ssd.test.=
file),
>>>> error=3DInvalid argument
>>> Looks like the file system hosting the test file does not support
>>> O_DIRECT.
>>>
>> The file system is ext4.
>> Kernel Version 3.2.0-24-generic
> And you aren't running the job file in some other location? ext4 would
> definitely work. Please do:
>
> # strace -o strace.out -f fio ssd-test
>
> and send me strace.out (gzip'ed). Also include a pwd from where you are
> running it, and output of the 'mount' command.
>
Here is the solution to my problem (answered from Jens Axboe):
/ecryptfs does not support O_DIRECT IO. So that was the explanation for
the problem./

Also a patch so that FIO gives some further information now:
/Sure, I think it'd be a good idea if fio also complains that this is
the likely explanation. Fio does this if the first IO errors, but it
doesn't catch cases where O_DIRECT simply isn't supported. Can you try
this patch, see if it complains as it should?/

The patch has already been tested and commited (also from Jens):
diff --git a/filesetup.c b/filesetup.c
index a1ad026..b1f73f7 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -526,6 +526,11 @@ open_again:
=20
         snprintf(buf, sizeof(buf) - 1, "open(%s)", f->file_name);
=20
+        if (__e =3D=3D EINVAL && (flags & OS_O_DIRECT)) {
+            log_err("fio: looks like your file system does not " \
+                "support direct=3D1/buffered=3D0\n");
+        }
+
         td_verror(td, __e, buf);
     }
