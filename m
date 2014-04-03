Return-Path: <axboe@kernel.dk>
Message-ID: <533D6DFD.9010107@kernel.dk>
Date: Thu, 03 Apr 2014 08:19:41 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio crash when using an env variable that is not set
References: <d1e49b99b2164d5d825c50e11bb349a9@DB4PR03MB572.eurprd03.prod.outlook.com>
In-Reply-To: <d1e49b99b2164d5d825c50e11bb349a9@DB4PR03MB572.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
Content-Transfer-Encoding: quoted-printable
To: =?ISO-8859-1?Q?S=E9bastien_Bouchex_Bellomi=E9?= <sbouchex@infovista.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 04/03/2014 05:16 AM, S=EF=BF=BDbastien Bouchex Bellomi=EF=BF=BD wrote:
> Hi,
>
> A crash on solaris & windows (at least) when using fio-2.1.6.1 :
>
> A simple profile that use a env variable : directory=3D${DIRECTORY}
>
> I'm starting fio without defining DIRECTORY and I'm getting a crash:
>
> The stack on solaris is :
>
> core 'core' of 4574:    ./fio ../fio_env.win
>   0000000100035348 set_name_idx (ffffffff7fffe970, 100231950, 0, 16c4e8, =
0, 1002319b0) + cc
>   0000000100021a70 add_file (ffffffff7b400000, ffffffff7fffee60, 0, 0, 10=
0071c30, ffffffff7fffe970) + 38
>   000000010000daf4 add_job.part.4 (7, 100236050, 0, ffffffff7ffff268, 1, =
0) + 11f0
>   000000010000f444 parse_jobs_ini (0, 0, 0, 1, 100236050, 1002276c0) + 77c
>   0000000100010db0 parse_options (5118, ffffffff7ffff968, 1, 0, 0, 10021e=
ef0) + 304
>   000000010006ff68 main (2, ffffffff7ffff968, ffffffff7ffff980, 100228338=
, 100000000, 2800) + 20
>   000000010000952c _start (0, 0, 0, 0, 0, 0) + 7c

Thanks, fixed:

http://git.kernel.dk/?p=3Dfio.git;a=3Dcommit;h=3Df75c69a1e26166b5c205c6d4c0=
a6a9412ee6cd86

--=20
Jens Axboe


