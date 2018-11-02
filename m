Return-Path: <prvs=837a2b642=jeff.furlong@wdc.com>
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: RE: [PATCH v2] fix windows cpu count
Date: Fri, 2 Nov 2018 17:49:55 +0000
Message-ID: 
 <MWHPR04MB0320BE1571FFF5497958BD6F8FCF0@MWHPR04MB0320.namprd04.prod.outlook.com>
References: 
 <MWHPR04MB03200B2DD2F07C83B09550C48FCF0@MWHPR04MB0320.namprd04.prod.outlook.com>
 <20181102172019.GA1660@kernel.dk>
In-Reply-To: <20181102172019.GA1660@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Sorry about the mixup, seems my email client had some updates and is stuck =
in quoted printable.  I'll try to resolve.

Regards,
Jeff

-----Original Message-----
From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behal=
f Of Jens Axboe
Sent: Friday, November 2, 2018 10:20 AM
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: fio <fio@vger.kernel.org>
Subject: Re: [PATCH v2] fix windows cpu count

On Fri, Nov 02 2018, Jeff Furlong wrote:
> This patch resolves c479640d6208236744f0562b1e79535eec290e2b where the=20
> CPU count returns max possible supported CPUs, and instead returns=20
> current active CPUs.

This is still broken, long lines broken up, =3D turned to =3D3D, etc. I've =
fixed it up manually and applied it, please double check:

http://git.kernel.dk/cgit/fio/commit/?id=3D290c64f219cd22cf67a94b6c5ba74a30=
0ddc2ed3

Note for future patches - if a patch fixes some other patch, the way to ind=
icate that is how I did it:

Fixes: c479640d6208 ("Merge branch 'proc_group' of https://github.com/sitso=
fe/fio")

But even this one isn't fully correct, since it's a merge commit, it should=
 have been the individual patch in that merge.

--
Jens Axboe


