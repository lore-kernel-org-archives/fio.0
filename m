Return-Path: <prvs=76534e0b4=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: Zoned block device regression test 11
Date: Wed, 22 Aug 2018 19:55:09 +0000
Message-ID: 
 <BN3PR0401MB164028E7CE6A192B010F4E49E7300@BN3PR0401MB1640.namprd04.prod.outlook.com>
References: <a6d3d008-3a44-9d42-2c0c-b26ca9d92d3a@acm.org>
 <CY4PR21MB07732B0B200EAB77AAB4F737DC300@CY4PR21MB0773.namprd21.prod.outlook.com>
 <CY4PR21MB07731302C97CFA7EF56BBA1CDC300@CY4PR21MB0773.namprd21.prod.outlook.com>
 <8907fd89-a0ba-39c4-35a0-a267e24a57f6@kernel.dk>
 <CY4PR21MB0773D0F69E91EA2BD4B34FAFDC300@CY4PR21MB0773.namprd21.prod.outlook.com>
 <1918a5c7-d8a1-e19f-e71f-2ad376e0f95b@acm.org>
 <CY4PR21MB0773B46B04D9FCFF10F898DFDC300@CY4PR21MB0773.namprd21.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>, Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Michael,=0A=
=0A=
On 2018/08/22 12:05, Michael Kelley (EOSG) wrote:=0A=
> One more question:  What's the preferred source for the zbc_* commands?=
=0A=
> I built from https://github.com/hgst/libzbc, but get this runtime failure=
:=0A=
> =0A=
> root@MHKfio2:~# zbc_report_zones /dev/nullb0=0A=
> Device /dev/nullb0:=0A=
>     Vendor ID: FAKE HGST HM libzbc=0A=
>     Emulated zoned block device interface, Host-managed zone model=0A=
=0A=
The above line says "emulated" which means that libzbc detected a regular b=
lock=0A=
device and went into emulation mode. This means that your null_blk setup is=
 not=0A=
supporting zoned mode or nullb0 was not created as a zoned device.=0A=
You can easily check if the nullb device created is zoned or not: just look=
 into=0A=
/sys/block/nullb0/queue/zoned. It should say "host-managed". In your case, =
the=0A=
content is probably "none".=0A=
=0A=
>     2097152 512-bytes sectors=0A=
>     262144 logical blocks of 4096 B=0A=
>     262144 physical blocks of 4096 B=0A=
>     1.074 GB capacity=0A=
>     Read commands are restricted=0A=
>     Maximum number of open sequential write required zones: 32=0A=
> zbc_report_nr_zones at 0, ro 0x00 failed -6=0A=
> =0A=
> Michael=0A=
> =0A=
=0A=
On another note, you can also use the sysutils blkzone command to do the sa=
me:=0A=
blkzone report /dev/nullb0 will five you the zone list.=0A=
=0A=
Best regards.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

