Return-Path: <sbouchex@infovista.com>
From: =?iso-8859-1?Q?S=E9bastien_Bouchex_Bellomi=E9?= <sbouchex@infovista.com>
Subject: RE: Bug with "multi directory support" on windows
Date: Wed, 12 Mar 2014 16:39:33 +0000
Message-ID: <53aec4da21c24553af5648e726474b17@DB4PR03MB572.eurprd03.prod.outlook.com>
References: <e54fd34a63624f1ca306d3a6970272ac@DB4PR03MB572.eurprd03.prod.outlook.com>
 <53208C3D.8000500@kernel.dk>
In-Reply-To: <53208C3D.8000500@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi,

Escaping the directory worked : C\:\temp\fio\read

Documentation update ?

Seb

-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]=20
Sent: mercredi 12 mars 2014 17:33
To: S=E9bastien Bouchex Bellomi=E9; fio@vger.kernel.org
Subject: Re: Bug with "multi directory support" on windows

On 03/12/2014 09:38 AM, S=E9bastien Bouchex Bellomi=E9 wrote:
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
> Of course ! The : separator of the multi directory support feature=20
> does not filter the Windows drive letter

You might need to escape the ':' so it's c\:\Program Files and so forth.=20
I'll have to double check if that is done correctly for directory, fio does=
 do it for filename.

--
Jens Axboe


