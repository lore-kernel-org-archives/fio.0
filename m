Return-Path: <axboe@kernel.dk>
Message-ID: <53208C60.8090708@kernel.dk>
Date: Wed, 12 Mar 2014 10:33:36 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: ioengine=sync issue on Windows
References: <8a71414766f34cfe98805c5dd2e94d2e@DB4PR03MB572.eurprd03.prod.outlook.com>
In-Reply-To: <8a71414766f34cfe98805c5dd2e94d2e@DB4PR03MB572.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
Content-Transfer-Encoding: quoted-printable
To: =?ISO-8859-1?Q?S=E9bastien_Bouchex_Bellomi=E9?= <sbouchex@infovista.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, bcran@fusionio.com
List-ID: <fio@vger.kernel.org>

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
> random_read: (g=3D0): rw=3Drandread, bs=3D32K-32K/32K-32K/32K-32K, ioengi=
ne=3Dsync, iodepth=3D1
> fio-2.1.6-1-gd004a
> Starting 1 thread
> fio: pid=3D5144, err=3D5/file:backend.c:768, func=3Dfull resid, error=3DI=
nput/output error
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

--=20
Jens Axboe


