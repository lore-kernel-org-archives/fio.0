Return-Path: <prvs=393ca294f=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 8/9] zbd: support verification
Date: Mon, 11 May 2020 02:01:02 +0000
Message-ID: 
 <BY5PR04MB6900AE08D3F09859A221B884E7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200505175634.2517-1-adobriyan@gmail.com>
 <20200505175634.2517-8-adobriyan@gmail.com> <20200505175929.GA2719@avx2>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/05/06 2:59, Alexey Dobriyan wrote:=0A=
> On Tue, May 05, 2020 at 08:56:34PM +0300, Alexey Dobriyan wrote:=0A=
>> Verification is not supported in ZBD mode which is codified in this=0A=
>> assert:=0A=
>>=0A=
>> 	if (zb->reset_zone || zbd_zone_full(f, zb, min_bs)) {=0A=
>> 		assert(td->o.verify =3D=3D VERIFY_NONE);=0A=
> =0A=
> This is RFC for now, not for merging, there rest are.=0A=
=0A=
Then send it separately please.=0A=
=0A=
> =0A=
> And no, patches haven't been lost, 9/9 is debugging is usual...=0A=
=0A=
Then do not number the patches including it please.=0A=
=0A=
Your patch series is still missing a cover letter too.=0A=
=0A=
Thanks.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

