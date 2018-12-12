Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-eopbgr780135.outbound.protection.outlook.com ([40.107.78.135]:2624
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726245AbeLLNdu (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 12 Dec 2018 08:33:50 -0500
From: Mohan Mohan <mohan@ertino.com>
Subject: Re: err=84/file:io_u.c:2033, func=io_u_sync_complete, error=Invalid
 or incomplete multibyte or wide character
Date: Wed, 12 Dec 2018 13:33:47 +0000
Message-ID: <DM5PR19MB14027BC256E9CBF96389C1EDDBA70@DM5PR19MB1402.namprd19.prod.outlook.com>
References: <DM5PR19MB1402A8B7F86B55C8E10D72FADBA60@DM5PR19MB1402.namprd19.prod.outlook.com>,<CALjAwxjSL=0xv0U50WuOUwqGR35_qKfSO91HP=41nstAq6Jkng@mail.gmail.com>
In-Reply-To: <CALjAwxjSL=0xv0U50WuOUwqGR35_qKfSO91HP=41nstAq6Jkng@mail.gmail.com>
Content-Language: en-IN
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

Got it thanks

________________________________________
From: Sitsofe Wheeler <sitsofe@gmail.com>
Sent: 12 December 2018 02:27:11
To: Mohan Mohan
Cc: fio
Subject: Re: err=3D84/file:io_u.c:2033, func=3Dio_u_sync_complete, error=3D=
Invalid or incomplete multibyte or wide character

Hi,

On Tue, 11 Dec 2018 at 18:01, Mohan Mohan <mohan@ertino.com<mailto:mohan@er=
tino.com>> wrote:

Hi,

Is the error below is expected one for the read operation? I am not getting=
 any error for the write operation.

root@ertino-ThinkPad-T431s:/home/ertino--verify crc32c

^^^ It looks like you asked for verifying reads (although this line looks m=
angled - it's hard to tell without seeing the full job).

xspp: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T) 40=
96B-4096B, ioengine=3Dpsync, iodepth=3D1
fio-3.12-17-g0fcbc0
Starting 1 process
xspp: Laying out IO file (1 file / 10MiB)
verify: bad magic header 1950, wanted acca at file xspp.0.0 offset 630784, =
length 4096 (requested block: offset=3D630784, length=3D4096)

^^^ This is saying that the block read lacked the expected fio header.

fio: pid=3D32055, err=3D84/file:io_u.c:2033, func=3Dio_u_sync_complete, err=
or=3DInvalid or incomplete multibyte or wide character

xspp: (groupid=3D0, jobs=3D1): err=3D84 (file:io_u.c:2033, func=3Dio_u_sync=
_complete, error=3DInvalid or incomplete multibyte or wide character): pid=
=3D32055: Tue Dec 11 23:09:30 2018

I'm guessing you asked fio to do verifying reads (e.g. fio --name=3Dverifre=
ad --rw=3Dread --verify=3Dcrc32c --size=3D1M --filename=3Dfio.tmp) *before*=
 you wrote data with a verify header. Unless you have already written all o=
f the file that is being read back file with appropriate verification heade=
rs (i.e. you ran a write job first) then it's expected fio will complain ab=
out not being able to read the expected headers. A write job won't have thi=
s problem because it writes data (sometimes before trying to read it back).=
 See https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-verify=
 for details.

--
Sitsofe | http://sucs.org/~sits/

