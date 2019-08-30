Return-Path: <prvs=138d395aa=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] zbd: Fix job zone size initialization
Date: Fri, 30 Aug 2019 02:01:06 +0000
Message-ID: 
 <BYAPR04MB5816A4F3B82D4E27BAA4DCACE7BD0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190830014503.32691-1-damien.lemoal@wdc.com>
 <2915e04d-7e42-46d7-f29a-597cc9046b4c@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2019/08/30 10:52, Jens Axboe wrote:=0A=
> On 8/29/19 7:45 PM, Damien Le Moal wrote:=0A=
>> For a job accessing a zoned block device, the zone size is automatically=
=0A=
>> initialized to the device zone size. However, since zone information for=
=0A=
>> a zoned block device is parsed once only for the first job=0A=
>> initialization of a multi job workload, only the first job has its=0A=
>> zonesize option intialized, causing problem if the zoneskip option is=0A=
>> also used (assert exit).=0A=
>>=0A=
>> Fix this by always initializing a job zonesize option using the job=0A=
>> file zbd information when verifying the job ZBD related sizes and=0A=
>> offsets.=0A=
> =0A=
> Applied, thanks.=0A=
> =0A=
=0A=
Jens,=0A=
=0A=
Thanks. But I just realized that the check is incomplete. If each job speci=
fies=0A=
"zonesize=3DX" instead of not specifying a zone size and relying on the aut=
omatic=0A=
initialization from the device zone size, then "X =3D=3D device zone size" =
must be=0A=
checked too.=0A=
=0A=
Sending an additional patch for this. My apologies for the churn.=0A=
=0A=
Thank you.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

