Return-Path: <mishagreen@gmail.com>
Return-Path: <mishagreen@gmail.com>
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: random_generator=lfsr overhead with more disks?
From: Michael Green <mishagreen@gmail.com>
In-Reply-To: <512d2421-2399-07db-9ddf-b6776614bae4@kernel.dk>
Date: Thu, 29 Mar 2018 00:28:37 -0700
Content-Transfer-Encoding: quoted-printable
Message-Id: <28277062-62B1-4138-83ED-23959DC9FEA8@gmail.com>
References: <9FD577EB-5F83-4AB3-9FBA-704094437C15@gmail.com>
 <BN3PR0401MB145797FEFD095957854800088FD70@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <512d2421-2399-07db-9ddf-b6776614bae4@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Furlong <jeff.furlong@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>


> On Mar 21, 2018, at 7:34 AM, Jens Axboe <axboe@kernel.dk> wrote:
>=20
> On 3/16/18 12:45 PM, Jeff Furlong wrote:
>> A few comments:
>>=20
>> -How does the cpu utilization look compared between the lfsr and
>> default tausworthe generators?  Is the cpu util actually higher on
>> lfsr?  If it is near saturated on 16 devices, then naturally
>> throughput would decrease.
>=20
> The LFSR generator is constant overhead, and it should not degrade as
> more jobs are using it. There's no shared state at all.

Actually it=E2=80=99s only one job.
=20
>=20
> If I were to guess, then the identical offsets of the jobs is probably =
a
> likely clue, since that is the only real difference between the two
> random generators. Are these 16 volumes all completely separate?
>=20

The 16 volumes are coming from the same E8 storage controller.  the =
volumes share the same RAID6 array and the data traffic is flowing =
through the same Ethernet infrastructure, 100Gb end to en.
=46rom E8 host driver perspective, there is no overhead for more volumes =
- 1 or 1000 it=E2=80=99s all the same.

Michael=

