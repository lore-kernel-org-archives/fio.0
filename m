Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CY1PR0401MB1116D03152A52BDA269387E981D00@CY1PR0401MB1116.namprd04.prod.outlook.com>
References: <CY1PR0401MB1116B5FBEFE751DAE8A07A3C81D00@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxhS++UF+LG166gR_tQNBsJHa-pTUJfHck_FjcN8DUtY2g@mail.gmail.com> <CY1PR0401MB1116D03152A52BDA269387E981D00@CY1PR0401MB1116.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 15 Mar 2018 16:19:56 +0000
Message-ID: <CALjAwxjGYvjEFR3q3oE-cm1i1Fat43GOQiAgF359Lm7M85oewg@mail.gmail.com>
Subject: Re: Patch to add read and write fua bit options to the SG engine
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Kris Davis <Kris.Davis@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 15 March 2018 at 14:52, Kris Davis <Kris.Davis@wdc.com> wrote:
> We definitely do need separate control between read and write fua, and on=
ly the read and write scsi commands actually support a fua bit.  Also, I do=
n't think the sg engine can actually be considered general purpose, as it r=
eally only supports the read/write/sync operations currently.
>
> I also think overloading the meaning of the "direct" option would set a b=
ad precedent - even though it's not used by the sg engine.  The "direct" bi=
t changes behavior of the kernel or driver, but fua bit is a device operati=
on.

OK fair enough. Could you update the man page too and could you list
what the default is for those options in the HOWTO and man page?
Beyond that the rest LGTM.

--=20
Sitsofe | http://sucs.org/~sits/

