Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.32.201]:56914 "EHLO mail.cs.umn.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932446AbcASCqj convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 18 Jan 2016 21:46:39 -0500
Received: from localhost (enchanter.cs.umn.edu [160.94.22.228])
	by mail.cs.umn.edu (Postfix) with ESMTP id A8B8B3DC5C3
	for <fio@vger.kernel.org>; Mon, 18 Jan 2016 20:46:38 -0600 (CST)
Received: from mail.cs.umn.edu ([128.101.32.201])
	by localhost (enchanter.cs.umn.edu [160.94.22.228]) (amavisd-new, port 10024)
	with ESMTP id PrrmJQFwgAw0 for <fio@vger.kernel.org>;
	Mon, 18 Jan 2016 20:46:37 -0600 (CST)
Received: from mail-io0-f181.google.com (mail-io0-f181.google.com [209.85.223.181])
	by mail.cs.umn.edu (Postfix) with ESMTPSA id 2916D3DC5C0
	for <fio@vger.kernel.org>; Mon, 18 Jan 2016 20:46:37 -0600 (CST)
Received: by mail-io0-f181.google.com with SMTP id 1so520438942ion.1
        for <fio@vger.kernel.org>; Mon, 18 Jan 2016 18:46:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <VI1PR05MB1343CA9499CC6AB3B7A0D2C0B1C10@VI1PR05MB1343.eurprd05.prod.outlook.com>
References: <VI1PR05MB13437814C9CD31D2CECE7398B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <56840F80.4060903@kernel.dk> <VI1PR05MB13435F5190D9D9A17C59315BB1FD0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5684A8F1.6010105@kernel.dk> <VI1PR05MB13439C4033DED096900CDF30B1FE0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <CANvN+ekwjftjYq=8KFiefRAFmUvZF1qpJ9Y6ohFBdMHH6TEAQg@mail.gmail.com>
 <VI1PR05MB13433A1D09C1C60B66E2ABBFB1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <CANvN+e=X09zp=HRme4Wwad2_HhmNkOQkL8zXGWozuVWCm+NMYg@mail.gmail.com>
 <VI1PR05MB1343810AF909BB41065666C9B1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <CANvN+e=cxWLEnu3Ve7RQKTh4TQubWMzkt0fkZ_AyKbNPAt21QQ@mail.gmail.com>
 <VI1PR05MB13430232A50B8818A220B23DB1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <CANvN+emwcrcVpuGsHBuNiw28WDKyyuNQvVd7G3QJFuy5siXqYw@mail.gmail.com>
 <VI1PR05MB13431DA43361FC9F4F55FC95B1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <VI1PR05MB1343E7E335FA4E27991FD523B1C00@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <9419CB2F-E2A7-453F-A5CE-88533306BC00@nellans.org> <VI1PR05MB13439667BBEE922D9955F58EB1C10@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <CAB-428m2HJBUPdtYsCKtxfYPuscV1i=ucCvCAPh4ShqWPNmTXw@mail.gmail.com> <VI1PR05MB1343CA9499CC6AB3B7A0D2C0B1C10@VI1PR05MB1343.eurprd05.prod.outlook.com>
From: Alireza Haghdoost <alireza@cs.umn.edu>
Date: Mon, 18 Jan 2016 20:45:56 -0600
Message-ID: <CAB-428mjbZBqngsHrvXs-Q3kNhOqXswe=84pLZX8uCFXLgHoyA@mail.gmail.com>
Subject: Re: How to stress a 8Gbps card to get 500 000 IOPS or 1600 MB/s
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Thierry BERTAUD <tbertaud@conforama.fr>
Cc: David Nellans <david@nellans.org>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Increase your iodepth as I said earlier. You may ask your storage
provider why read and writes behave like this. You can also increase
numjob to push more IO with more fio process/threads.

On Mon, Jan 18, 2016 at 7:34 PM, Thierry BERTAUD <tbertaud@conforama.fr> wrote:
> Alireza,
>
>
> I use 2 hba (fscsi1 -> fabric1, fscsi2 -> fabric2). Each fabric is connect
> to 3 nodes.
>
>
> # lspath | grep hdisk6
> Enabled hdisk6  fscsi1
> Enabled hdisk6  fscsi1
> Enabled hdisk6  fscsi3
> Enabled hdisk6  fscsi3
> Enabled hdisk6  fscsi1
> Enabled hdisk6  fscsi3
> #
>
> With :
>
> # cat randwrite.fio
> [global]
> thread
> numjobs=1
> iodepth=1
> group_reporting
> bs=256k
> norandommap=1
> refill_buffers
> direct=1
> ioengine=posixaio
> runtime=300
> time_based
> filename=/dev/hdisk6
> log_avg_msec=1000
> [randread_32_256]
> rw=randread
> numjobs=32
> iodepth=256
> stonewall
> #
> IOPS: 23 000
>
> Bandwith: 85 Mo/s
>
> Latency: 0.5 ms
>
>
> but with this one:
>
> # cat randwrite.fio
> [global]
> thread
> numjobs=1
> iodepth=1
> group_reporting
> bs=4k
> norandommap=1
> refill_buffers
> direct=1
> ioengine=posixaio
> runtime=300
> time_based
> filename=/dev/hdisk6
> log_avg_msec=1000
> [randread_64_64]
> rw=randread
> numjobs=64
> iodepth=64
> stonewall
> #
> IOPS: 10 000
>
> Bandwith: 40 MB/S
>
> Latency: 1.5 ms
>
>
> but write seems better than read:
>
> # cat randwrite.fio
> [global]
> thread
> numjobs=1
> iodepth=1
> group_reporting
> bs=4k
> norandommap=1
> refill_buffers
> direct=1
> ioengine=posixaio
> runtime=300
> time_based
> filename=/dev/hdisk6
> log_avg_msec=1000
> [randwrite_64_64]
> rw=randwrite
> numjobs=64
> iodepth=64
> stonewall
> #
> IOPS: 42 000
>
> Bandwith: 163 MB/S
>
> latency: 0.2 ms
>
>
> I don't understand why for last test randwrite is better than randread.
>
> I'm lost and don't undertand how to stress the LUN.
>
>
> Regards,
> Thierry
>
>
> ________________________________
> De : Alireza Haghdoost <alireza@cs.umn.edu>
> Envoyé : mardi 19 janvier 2016 02:06
> À : Thierry BERTAUD
> Cc : David Nellans; fio@vger.kernel.org
>
> Objet : Re: How to stress a 8Gbps card to get 500 000 IOPS or 1600 MB/s
>
> I would assume you have a loop-back HBA since you are not going to get Max
> Bandwidth with "Unknown" storage device in the back-end.
> Your best bet is with large transfer size like:
> bs=256k
>
> and high queue depth:
> iodepth=256
>
> Make sure your HBA queue depth is not limited.
>
> Do the math again, you cannot get 1600 MB/s with a 8Gbps fiber in theory.
>
> --Alireza
>
> On Mon, Jan 18, 2016 at 6:29 PM, Thierry BERTAUD <tbertaud@conforama.fr>
> wrote:
>>
>> David,
>>
>> Sorry for typo.
>> I paste and not copy the configuration file.
>>
>> # cat randwrite.fio
>> [global]
>> thread
>> numjobs=1
>> iodepth=1
>> group_reporting
>> bs=4k
>> norandommap=1
>> refill_buffers
>> direct=1
>> ioengine=posixaio
>> runtime=300
>> time_based
>> filename=/dev/hdisk6
>> log_avg_msec=1000
>> [randwrite_64_64]
>> rw=randwrite
>> numjobs=64
>> iodepth=64
>> stonewall
>> #
>>
>>
>> Cordialement,
>> Thierry Bertaud
>> Tel: 01 60 95 51 41
>>
>> PS: Merci de mettre en copie pour toute demande système, le groupe
>> dsisystunix@conforama.fr
>>
>> ________________________________________
>> De : David Nellans <david@nellans.org>
>> Envoyé : mardi 19 janvier 2016 01:15
>> À : Thierry BERTAUD
>> Cc : fio@vger.kernel.org
>> Objet : Re: How to stress a 8Gbps card to get 500 000 IOPS or 1600 MB/s
>>
>> you have two typos in your config that will likely result in less than
>> sufficient iodepth to hit 500k IOPS. check if those are in your actual
>> config or not...
>>
>> > On Jan 18, 2016, at 5:58 PM, Thierry BERTAUD <tbertaud@conforama.fr>
>> > wrote:
>> >
>> > Hello fio team,
>> >
>> > I tryed to stress my 8 Gbps hba with fio wit a lot of case:
>> > I know that the hba card is capable of 500 000 IOPS or get data rate
>> > neat that 8 Gbps (1600 MB/sec).
>> > i tried to change block size, iodepth, numjobs, iodepth but idon't have
>> > good resulut. (42000 IOPS and throughput 162 MB/s).
>> >
>> > Below fio conf:
>> > [global]
>> > thread
>> > numjobs=1
>> > iodepth=1
>> > group_reporting
>> > bs=4k
>> > norandommap=1
>> > refill_buffers
>> > direct=1
>> > ioengine=posixaio
>> > runtime=300
>> > time_based
>> > filename=/dev/hdisk6
>> > log_avg_msec=1000
>> > [randwrite_64_64]
>> > rw=randwrite
>> > numjobs=64
>> > ioepth=64
>> > stonewal
>> >
>> >
>> >
>> > Regards,
>> > Thierry--
>> > To unsubscribe from this list: send the line "unsubscribe fio" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
