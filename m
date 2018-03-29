Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <28277062-62B1-4138-83ED-23959DC9FEA8@gmail.com>
References: <9FD577EB-5F83-4AB3-9FBA-704094437C15@gmail.com>
 <BN3PR0401MB145797FEFD095957854800088FD70@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <512d2421-2399-07db-9ddf-b6776614bae4@kernel.dk> <28277062-62B1-4138-83ED-23959DC9FEA8@gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 29 Mar 2018 09:50:31 +0100
Message-ID: <CALjAwxhu4gwNRMaShw0BOhND8THbCYx=u7bd7JxF+Df167mXuA@mail.gmail.com>
Subject: Re: random_generator=lfsr overhead with more disks?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Michael Green <mishagreen@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Furlong <jeff.furlong@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 29 March 2018 at 08:28, Michael Green <mishagreen@gmail.com> wrote:
>
>> On Mar 21, 2018, at 7:34 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 3/16/18 12:45 PM, Jeff Furlong wrote:
>>> A few comments:
>>>
>>> -How does the cpu utilization look compared between the lfsr and
>>> default tausworthe generators?  Is the cpu util actually higher on
>>> lfsr?  If it is near saturated on 16 devices, then naturally
>>> throughput would decrease.
>>
>> The LFSR generator is constant overhead, and it should not degrade as
>> more jobs are using it. There's no shared state at all.
>
> Actually it=E2=80=99s only one job.

In this case we mean "fio jobs" (rather than fio invocations). From
the line in one of your other emails:

fio --name=3Dglobal --thread=3D1 --direct=3D1 --group_reporting=3D1 --name=
=3DPT7
--rw=3Drandrw --rwmixread=3D100 --iodepth=3D40 --numjobs=3D8 --bs=3D4096
--runtime=3D120 --filename=3D'/dev/e8b0:/dev/e8b1:/dev/e8b2:/dev/e8b3:/dev/=
e8b4:/dev/e8b5:/dev/e8b6:/dev/e8b7:/dev/e8b8:/dev/e8b9:/dev/e8b10:/dev/e8b1=
1:/dev/e8b12:/dev/e8b13:/dev/e8b14:/dev/e8b15'
--ioengine=3Dlibaio --random_generator=3Dlfsr

You have  --numjobs=3D8
(http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-numjobs
) there so you are spawning 8 fio internal jobs which all work on
those same files simultaneously.
--=20
Sitsofe | http://sucs.org/~sits/

