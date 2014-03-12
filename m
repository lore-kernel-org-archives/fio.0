Return-Path: <axboe@kernel.dk>
Message-ID: <53208C3D.8000500@kernel.dk>
Date: Wed, 12 Mar 2014 10:33:01 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Bug with "multi directory support" on windows
References: <e54fd34a63624f1ca306d3a6970272ac@DB4PR03MB572.eurprd03.prod.outlook.com>
In-Reply-To: <e54fd34a63624f1ca306d3a6970272ac@DB4PR03MB572.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
Content-Transfer-Encoding: quoted-printable
To: =?ISO-8859-1?Q?S=E9bastien_Bouchex_Bellomi=E9?= <sbouchex@infovista.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 03/12/2014 09:38 AM, S=EF=BF=BDbastien Bouchex Bellomi=EF=BF=BD wrote:
> Hi,
>
> A nice bug on Windows :
>
> My profile is :
>
> [global]
> thread
>
> [random_read]
> rw=3Drandread
> size=3D1024m
> directory=3Dc:\temp\fio\read
> bs=3D32k
>
> fio start looks like :
> C:\Program Files\fio>fio.exe H:\fio\fio.win
> fio: c is not a directory
> fio: failed parsing directory=3Dc:\temp\fio\read
> fio: job random_read dropped
> fio: file:options.c:875, func=3Dlstat, error=3DNo such file or directory
>
> Of course ! The : separator of the multi directory support feature does n=
ot filter the Windows drive letter

You might need to escape the ':' so it's c\:\Program Files and so forth.=20
I'll have to double check if that is done correctly for directory, fio=20
does do it for filename.

--=20
Jens Axboe


