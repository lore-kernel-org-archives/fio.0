Return-Path: <fio-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:45431 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337AbaCLSC0 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 12 Mar 2014 14:02:26 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 86C497C06C3
	for <fio@vger.kernel.org>; Wed, 12 Mar 2014 12:02:25 -0600 (MDT)
From: Bruce Cran <BCran@fusionio.com>
Subject: RE: ioengine=sync issue on Windows
Date: Wed, 12 Mar 2014 18:02:22 +0000
Message-ID: <07a59dd29eae446f83d85387bff2a130@BLUPR04MB467.namprd04.prod.outlook.com>
References: <8a71414766f34cfe98805c5dd2e94d2e@DB4PR03MB572.eurprd03.prod.outlook.com>
 <53208C60.8090708@kernel.dk> 
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, =?iso-8859-1?Q?S=E9bastien_Bouchex_Bellomi=E9?= <sbouchex@infovista.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

It turns out this is unrelated, but in stat.c the following change should p=
robably be made:

-#define FIO_STATUS_FILE                "/tmp/fio-dump-status"
+#define FIO_STATUS_FILE                "fio-dump-status"

--=20
Bruce

-----Original Message-----
From: Bruce Cran=20
Sent: Wednesday, March 12, 2014 11:49 AM
To: 'Jens Axboe'; S=EF=BF=BDbastien Bouchex Bellomi=EF=BF=BD; fio@vger.kern=
el.org
Subject: RE: ioengine=3Dsync issue on Windows

It looks like it's trying to access %TEMP%\tmp for some reason.

--
Bruce

-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]
Sent: Wednesday, March 12, 2014 10:34 AM
To: S=EF=BF=BDbastien Bouchex Bellomi=EF=BF=BD; fio@vger.kernel.org; Bruce =
Cran
Subject: Re: ioengine=3Dsync issue on Windows

On 03/12/2014 09:41 AM, S=EF=BF=BDbastien Bouchex Bellomi=EF=BF=BD wrote:
> Hi,
>
> The "sync" engine does not seem to work correctly on Windows :
>
> My profile is :
>
> [global]
> thread
> ioengine=3Dsync
>
> [random_read]
> rw=3Drandread
> size=3D1024m
> directory=3Dread
> bs=3D32k
>
> fio 2.1.6.1 output contains " err=3D 5 (file:backend.c:768, func=3Dfull r=
esid, error=3DInput/output error)"
>
> [...]
> C:\Program Files\fio>fio.exe H:\fio\fio.win
> random_read: (g=3D0): rw=3Drandread, bs=3D32K-32K/32K-32K/32K-32K,=20
> ioengine=3Dsync, iodepth=3D1 fio-2.1.6-1-gd004a Starting 1 thread
> fio: pid=3D5144, err=3D5/file:backend.c:768, func=3Dfull resid,=20
> error=3DInput/output error
>
> random_read: (groupid=3D0, jobs=3D1): err=3D 5 (file:backend.c:768, func=
=3Dfull resid, error=3DInput/output error): pid=3D5144: Wed Mar 12 16:36:45=
 2014
>    cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D0, majf=3D0, minf=3D0
>    IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=
=3D0.0%, >=3D64=3D0.0%
>       submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 6=
4=3D0.0%, >=3D64=3D0.0%
>       complete  : 0=3D50.0%, 4=3D50.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 6=
4=3D0.0%, >=3D64=3D0.0%
>       issued    : total=3Dr=3D2/w=3D0/d=3D0, short=3Dr=3D1/w=3D0/d=3D0
>       latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1
>
> Run status group 0 (all jobs):
> [...]

Bruce, do you know why that is?

--
Jens Axboe


This e-mail (and any attachments) is confidential and may be privileged.  A=
ny unauthorized use, copying, disclosure or dissemination of this communica=
tion is prohibited.  If you are not the intended recipient,  please notify =
the sender immediately and delete all copies of the message and its attachm=
ents.
