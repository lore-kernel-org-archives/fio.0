Return-Path: <prvs=802d9959d=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] zbd: Restore check_swd()
Date: Fri, 28 Sep 2018 04:04:28 +0000
Message-ID: 
 <BN3PR0401MB1640312E62830C451665E507E7EC0@BN3PR0401MB1640.namprd04.prod.outlook.com>
References: <20180927021648.28313-1-damien.lemoal@wdc.com>
 <40ca898f-febc-b403-74ec-f7df39c0bb7f@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

Jens,=0A=
=0A=
On 2018/09/28 12:53, Jens Axboe wrote:=0A=
> On 9/26/18 8:16 PM, Damien Le Moal wrote:=0A=
>> As check_swd() is useful for debugging, revert its removal done with=0A=
>> commit d60be7d51cbb ("zbd: Remove unused function and variable").=0A=
> =0A=
> The problem with dead code is that it's often forgotten when=0A=
> other changes are made, and then it doesn't even compile or=0A=
> work anymore.=0A=
> =0A=
> I'd be happier if this was dependent on some debug static=0A=
> bool instead, ala:=0A=
> =0A=
> static bool zbd_debug;=0A=
> =0A=
> And then have check_swd() do=0A=
> =0A=
> if (!zbd_debug)=0A=
>     return;=0A=
> =0A=
> instead of hiding everything behind an #if 0.=0A=
=0A=
OK. No problem. I will update and send a v2.=0A=
=0A=
(and another patch to fix the incorrect comments signaled by Bart)=0A=
=0A=
Thanks !=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

