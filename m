Return-Path: <jinpu.wang@profitbricks.com>
MIME-Version: 1.0
In-Reply-To: <57563A8A.2020904@kernel.dk>
References: <CAMGffEkGs5imFNH6T7uU07fDp_UX+RdbY-n2c8FrdzqmipLi3w@mail.gmail.com>
 <57563A8A.2020904@kernel.dk>
From: Jinpu Wang <jinpu.wang@profitbricks.com>
Date: Tue, 7 Jun 2016 09:54:25 +0200
Message-ID: <CAMGffE=T2WkfW1awiwGpNbQAajB1Ky1uibbVWTbC8H0sv+HShg@mail.gmail.com>
Subject: Re: fio hang (sleep forever) after first job with ramp_time?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Tue, Jun 7, 2016 at 5:07 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 06/06/2016 06:44 AM, Jinpu Wang wrote:
>>
>> Hi all,
>>
>> We run into fio hang (sleep forever) all the time with latest fio (fio
>> --version
>> fio-2.11-12-g82e6)
>>
>> Kernel 4.4.5 on Debian Jessie
>> Configuration:
>> cat test.ini
>> [global]
>> ioengine=3Dlibaio
>> direct=3D1
>> time_based=3D1
>>
>> # runtime options
>> runtime=3D5
>> ramp_time=3D5
>> filename=3D/dev/ram0
>> [job1]
>> blocksize=3D32k
>>
>> [job2]
>> blocksize=3D128k
>> stonewall
>>
>> Fio process is sleep in:
>> cat /proc/9891/stack
>> [<ffffffff810ba469>] hrtimer_nanosleep+0xc9/0x1b0
>> [<ffffffff810ba5a7>] SyS_nanosleep+0x57/0x70
>> [<ffffffff81810757>] entry_SYSCALL_64_fastpath+0x12/0x6a
>> [<ffffffffffffffff>] 0xffffffffffffffff
>
>
> For the edification of people on the list, this fix was committed:
>
> http://git.kernel.dk/cgit/fio/commit/?id=3D356014ff351c6eb69339652650af5f=
6af72e5c22
>
> --
> Jens Axboe
>
Thanks Jens,

It did fix the bug!


--=20
Mit freundlichen Gr=C3=BC=C3=9Fen,
Best Regards,

Jack Wang

Linux Kernel Developer Storage
ProfitBricks GmbH  The IaaS-Company.

