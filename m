Return-Path: <prvs=7314fd3da=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] backend: fix switch_ioscheduler()
Date: Wed, 14 Apr 2021 22:16:48 +0000
Message-ID: 
 <BL0PR04MB651492FFC4383B1F0EC7941EE74E9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210414111056.213360-1-damien.lemoal@wdc.com>
 <d7a15832-21a1-7d09-5592-236da1d398f9@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2021/04/14 23:23, Jens Axboe wrote:=0A=
> On 4/14/21 5:10 AM, Damien Le Moal wrote:=0A=
>> If the first file specified for a job is not a block device file, the=0A=
>> ioscheduler option cannot be used. Trying to use this option can cause a=
=0A=
>> crash as that file du (struct disk_util) field is NULL. Prevent such=0A=
>> crash and signal the error by testing the file type, allowing only files=
=0A=
>> with the type FIO_TYPE_BLOCK to proceed with switching the IO scheduler.=
=0A=
> =0A=
> I wonder if this shouldn't be a for_each_file() loop, and just skipping=
=0A=
> file types that aren't FIO_TYPE_BLOCK, moving the actual switching into=
=0A=
> a helper?=0A=
> =0A=
=0A=
Indeed, that would be more correct. Will send a v2.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

