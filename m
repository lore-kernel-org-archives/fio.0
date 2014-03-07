Return-Path: <sbouchex@infovista.com>
From: =?iso-8859-1?Q?S=E9bastien_Bouchex_Bellomi=E9?= <sbouchex@infovista.com>
Subject: RE: json output issue on solaris sparc
Date: Fri, 7 Mar 2014 07:50:30 +0000
Message-ID: <3e371a215a394ca383f6c1206a09fa6e@DB4PR03MB572.eurprd03.prod.outlook.com>
References: <48976ca93fb54c4182ec7189ffc533d1@DB4PR03MB572.eurprd03.prod.outlook.com>
 <5318ECDA.3060502@kernel.dk>
In-Reply-To: <5318ECDA.3060502@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Return-Path: sbouchex@infovista.com
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi,

I'm using a 32 bit binary. The 64 bit binary is just crashing at startup (b=
us error)

Seb

-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]=20
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


