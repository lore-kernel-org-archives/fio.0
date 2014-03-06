Return-Path: <axboe@kernel.dk>
Message-ID: <5318ECDA.3060502@kernel.dk>
Date: Thu, 06 Mar 2014 14:47:06 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: json output issue on solaris sparc
References: <48976ca93fb54c4182ec7189ffc533d1@DB4PR03MB572.eurprd03.prod.outlook.com>
In-Reply-To: <48976ca93fb54c4182ec7189ffc533d1@DB4PR03MB572.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
Content-Transfer-Encoding: quoted-printable
To: =?ISO-8859-1?Q?S=E9bastien_Bouchex_Bellomi=E9?= <sbouchex@infovista.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 03/04/2014 03:19 AM, S=EF=BF=BDbastien Bouchex Bellomi=EF=BF=BD wrote:
> Hello,
>
> I'm trying fio on solaris sparc and I'm having an strange issue : io_byte=
s, bw, iops, runtime values are 0 when json output is enabled but contains =
valid values when using text (or terse) output format.
> I have tested on solaris x64 and everything is fine.

That's pretty weird... I lost my last SPARC box about 4 years ago, so I=20
have nothing to test on. I wonder if it's an alignment thing. Is fio a=20
32-bit or 64-bit application?

--=20
Jens Axboe


