Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB145779591A475B584914D73D8FB50@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <2bbf3bdf-e11b-2f58-a222-1e284b7d0cee@kernel.dk>
 <CALjAwxizNpBTAWLR4eTixM0QfgLrkvEEJzWmi_88_k_KKp5dUg@mail.gmail.com>
 <336d0c1b-2382-1037-2eac-e34b78242340@kernel.dk> <BN3PR0401MB1457526C9EAFA64BE7FEA14D8FB50@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CALjAwxgO5jadJwG6mxNhsnxqLyfU4QiDvCEYwAd8zj8BZF5yNA@mail.gmail.com> <BN3PR0401MB145779591A475B584914D73D8FB50@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 8 Aug 2017 00:16:22 +0100
Message-ID: <CALjAwxjQx1pGGRL3-FzHPMoHNkhnL395k3ZsmYNnGyV7H7v5JQ@mail.gmail.com>
Subject: Re: Pending fio 3.0 release
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Rebecca Cran <rebecca@bluestop.org>, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

Hmm you might be in the case where you managed to arrange for two in
flight writes to go down to the exact same region so you no longer know
what the data at that point is. If so, you would also need something
like the serialize_overlap patch (343) and you would have to set that
option to 1. Alternatively you could restrict the iodepth to 1 (no
patches required but it has an obvious drawback).

On 8 August 2017 at 00:09, Jeff Furlong <jeff.furlong@wdc.com> wrote:
> OK, sounds like 345 and 359 are the ones desired.
>
> I did have overwrite=3D1 in my original test, but tried to remove as many=
 non-essential parameters as possible.  But I just added it back:
>
> # fio --name=3DDI_Stress --ioengine=3Dlibaio --direct=3D1 --rw=3Drandwrit=
e --norandommap --randrepeat=3D0 --iodepth=3D16 --size=3D100% --numjobs=3D1=
 --bs=3D2048k --filename=3D/dev/nvme1n1 --output=3DDI_Stress --verify=3Dcrc=
32c-intel --verify_fatal=3D1 --verify_dump=3D1 --verify_backlog=3D32768 --o=
verwrite=3D1
> crc32c: verify failed at file /dev/nvme1n1 offset 2013628727296, length 2=
097152]
>        Expected CRC: a6dbc3dc
>        Received CRC: dfa3362b
>        received data dumped as nvme1n1.2013628727296.received
>        expected data dumped as nvme1n1.2013628727296.expected
>
> Regards,
> Jeff
>
> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Monday, August 7, 2017 3:25 PM
> To: Jeff Furlong <jeff.furlong@wdc.com>
> Cc: Jens Axboe <axboe@kernel.dk>; fio@vger.kernel.org; Rebecca Cran <rebe=
cca@bluestop.org>; Tomohiro Kusumi <tkusumi@tuxera.com>
> Subject: Re: Pending fio 3.0 release
>
> On 7 August 2017 at 23:02, Jeff Furlong <jeff.furlong@wdc.com> wrote:
>> Are the 3 serialize changes (pull requests  343/345/359) controversial o=
r not complete?  I hit the same issue in April with a similar workload:
>
> A fair question Jeff.
>
> If memory serves https://github.com/axboe/fio/pull/343 ("Add serialize_ov=
erlap option") is controversial because it took a heavy handed with potenti=
ally high overhead due to checking every I/O against every other inflight I=
/O to determine if it should flush to avoid generating two in-flight I/Os t=
hat cover overlapping regions. To use it you had to set an explicit option =
(which defaulted to off) and did the job though...
>
> https://github.com/axboe/fio/pull/345 is hopefully uncontroversial as it =
just removes an optimisation that could turn off overlap checking when it r=
eally needed for jobs that can write the same region twice and would otherw=
ise lead to spurious mismatches at verification time.
>
> https://github.com/axboe/fio/pull/359 narrowed the window that was creati=
ng a double free situation when two overlapping inflight writes occurred. I=
t's imperfect but it made the problem I was seeing go away even if I can th=
eorise it won't prevent the problem in every case.
>
>>
>> # fio --name=3DDI_Stress --ioengine=3Dlibaio --direct=3D1 --rw=3Drandwri=
te
>> --norandommap --randrepeat=3D0 --iodepth=3D16 --size=3D100% --numjobs=3D=
1
>> --bs=3D2048k --filename=3D/dev/nvme1n1 --output=3DDI_Stress
>> --verify=3Dcrc32c-intel --verify_fatal=3D1 --verify_dump=3D1
>> --verify_backlog=3D32768
>>
>> I tried again now with fio 2.99 and reproduced after a few minutes:
>>
>> verify: bad header numberio 4531, wanted 4532 at file /dev/nvme1n1 offse=
t 2643506233344, length 2097152
>>        hdr_fail data dumped as nvme1n1.2643506233344.hdr_fail
>>
>> So any large block random write seems to be at risk (larger the block, h=
igher the risk).  If there are other parameters I should be setting to avoi=
d the issue, please let me know.  Thanks.
>
> If you set --overwrite=3D1 does the problem you're seeing go away? If so =
it sounds like you're hitting https://github.com/axboe/fio/issues/335
> ...
>
> --
> Sitsofe | http://sucs.org/~sits/
> Western Digital Corporation (and its subsidiaries) E-mail Confidentiality=
 Notice & Disclaimer:
>
> This e-mail and any files transmitted with it may contain confidential or=
 legally privileged information of WDC and/or its affiliates, and are inten=
ded solely for the use of the individual or entity to which they are addres=
sed. If you are not the intended recipient, any disclosure, copying, distri=
bution or any action taken or omitted to be taken in reliance on it, is pro=
hibited. If you have received this e-mail in error, please notify the sende=
r immediately and delete the e-mail in its entirety from your system.



--=20
Sitsofe | http://sucs.org/~sits/

