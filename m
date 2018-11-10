Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46699 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728836AbeKJTNY (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 10 Nov 2018 14:13:24 -0500
Received: by mail-wr1-f66.google.com with SMTP id 74-v6so4254808wrb.13
        for <fio@vger.kernel.org>; Sat, 10 Nov 2018 01:29:04 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.0 \(3445.100.39\))
Subject: Re: rand-read: increasing iodepth makes throughput drop
From: Paolo Valente <paolo.valente@linaro.org>
In-Reply-To: <AT5PR8401MB116917F29EA34E175EAA2A08ABC60@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
Date: Sat, 10 Nov 2018 10:29:01 +0100
Content-Transfer-Encoding: quoted-printable
Message-Id: <1C747D7B-996D-4E5A-9194-872F604F03B9@linaro.org>
References: <09b20693-8e0c-2ca9-97b3-51674177f19c@willer.it>
 <AT5PR8401MB116955F32C7A59FB0494F505ABF70@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <a26c6cc6-3efe-cbf8-37c7-f52672179b79@willer.it>
 <MWHPR04MB03204694EB4A9074B9D5A4228FCD0@MWHPR04MB0320.namprd04.prod.outlook.com>
 <38550f9e-63ba-cfc4-d8eb-5314d0647fd9@willer.it>
 <CALjAwxh=CDGp6agq=7hisWvAJfGWKH9mpjQDq=FUb-VpJXS+6A@mail.gmail.com>
 <64b2647f-4644-c4ed-ee44-6f571d037e50@willer.it>
 <AT5PR8401MB116917F29EA34E175EAA2A08ABC60@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: Federico Motta <federico@willer.it>, Sitsofe Wheeler <sitsofe@gmail.com>, Jeff Furlong <jeff.furlong@wdc.com>, fio <fio@vger.kernel.org>, "mark.brown@linaro.org" <mark.brown@linaro.org>, "linus.walleij@linaro.org" <linus.walleij@linaro.org>, "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>



> Il giorno 9 nov 2018, alle ore 21:21, Elliott, Robert (Persistent =
Memory) <elliott@hpe.com> ha scritto:
>=20
>=20
>=20
>> -----Original Message-----
>> From: Federico Motta [mailto:federico@willer.it]
>> Sent: Friday, November 9, 2018 3:31 AM
>> To: Sitsofe Wheeler <sitsofe@gmail.com>
>> Cc: Jeff Furlong <jeff.furlong@wdc.com>; Elliott, Robert (Persistent =
Memory) <elliott@hpe.com>; fio
>> <fio@vger.kernel.org>; Paolo Valente <paolo.valente@linaro.org>; =
mark.brown@linaro.org;
>> linus.walleij@linaro.org; ulf.hansson@linaro.org
>> Subject: Re: rand-read: increasing iodepth makes throughput drop
>>>> On 10/31/18 3:19 PM, Federico Motta wrote:
>>>> ...
>>>>> Is it possible to ask fio a measure of "how much device internal
>>>> queues are filled"?
>>>>> If yes, with which option(s)?
>>>>> If not, do you know some other tools or procedures which can tell =
us that?
>>>>=20
>>>> Does somebody has ideas about that ^  ?
>>>=20
>>> ...I think iostat produces similar output to that too...
>>>=20
>>=20
>> Actually I was wondering if a more direct or low level measure =
exists,
>> but since I don't even know if that is possible I think the fio =
"util"
>> percentage could be a good trade-off between "a low level measure" =
and
>> "no measure available".
>=20
> In linux, iostat provides some statistics, and there are lots of more =
detailed
> queuing statistics in sysfs. Some are provided by the block layer; =
some by the
> SCSI midlayer (for SCSI devices); some by the low-level driver (like =
hpsa).
>=20
>=20
> # nr_requests, the block layer request queue depth
> /sys/block/$device/queue/nr_requests
>=20
> # queue_depth, the SCSI midlayer queue depth
> /sys/block/$device/device/queue_depth
>=20
> # can_queue sets the initial request queue size
> /sys/class/scsi_host/$scsi_host/can_queue
>=20
> # cmd_per_lun sets the initial queue_depth
> /sys/class/scsi_host/$scsi_host/cmd_per_lun
>=20
> # host_busy indicates how many commands are queued by the SCSI layer
> /sys/class/scsi_host/$scsi_host/host_busy
>=20

Thank you very much, this seems exactly the kind of information we
need.  AFAYK, are there also per-queue info in case of NVMe devices?

Thanks,
Paolo

> # host_blocked indicates the host is blocking all IOs
> /sys/class/scsi_host/$scsi_host/host_blocked
>=20
> # hpsa ioaccel commands outstanding
> /sys/block/$device/device/hpsa_ioaccel_cmds_out
>=20
> # hpsa physical drive queue depth
> /sys/block/$device/device/hpsa_queue_depth
>=20
> # hpsa commands_outstanding from submission to completion
> /sys/class/scsi_host/$scsi_host/commands_outstanding
>=20
> There are a bunch of blk-mq stats too, some only shown if debugfs is =
enabled.
>=20


