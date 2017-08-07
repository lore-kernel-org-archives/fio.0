Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB1457526C9EAFA64BE7FEA14D8FB50@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <2bbf3bdf-e11b-2f58-a222-1e284b7d0cee@kernel.dk>
 <CALjAwxizNpBTAWLR4eTixM0QfgLrkvEEJzWmi_88_k_KKp5dUg@mail.gmail.com>
 <336d0c1b-2382-1037-2eac-e34b78242340@kernel.dk> <BN3PR0401MB1457526C9EAFA64BE7FEA14D8FB50@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 7 Aug 2017 23:25:28 +0100
Message-ID: <CALjAwxgO5jadJwG6mxNhsnxqLyfU4QiDvCEYwAd8zj8BZF5yNA@mail.gmail.com>
Subject: Re: Pending fio 3.0 release
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Rebecca Cran <rebecca@bluestop.org>, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 7 August 2017 at 23:02, Jeff Furlong <jeff.furlong@wdc.com> wrote:
> Are the 3 serialize changes (pull requests  343/345/359) controversial or=
 not complete?  I hit the same issue in April with a similar workload:

A fair question Jeff.

If memory serves https://github.com/axboe/fio/pull/343 ("Add
serialize_overlap option") is controversial because it took a heavy
handed with potentially high overhead due to checking every I/O
against every other inflight I/O to determine if it should flush to
avoid generating two in-flight I/Os that cover overlapping regions. To
use it you had to set an explicit option (which defaulted to off) and
did the job though...

https://github.com/axboe/fio/pull/345 is hopefully uncontroversial as
it just removes an optimisation that could turn off overlap checking
when it really needed for jobs that can write the same region twice
and would otherwise lead to spurious mismatches at verification time.

https://github.com/axboe/fio/pull/359 narrowed the window that was
creating a double free situation when two overlapping inflight writes
occurred. It's imperfect but it made the problem I was seeing go away
even if I can theorise it won't prevent the problem in every case.

>
> # fio --name=3DDI_Stress --ioengine=3Dlibaio --direct=3D1 --rw=3Drandwrit=
e --norandommap --randrepeat=3D0 --iodepth=3D16 --size=3D100% --numjobs=3D1=
 --bs=3D2048k --filename=3D/dev/nvme1n1 --output=3DDI_Stress --verify=3Dcrc=
32c-intel --verify_fatal=3D1 --verify_dump=3D1 --verify_backlog=3D32768
>
> I tried again now with fio 2.99 and reproduced after a few minutes:
>
> verify: bad header numberio 4531, wanted 4532 at file /dev/nvme1n1 offset=
 2643506233344, length 2097152
>        hdr_fail data dumped as nvme1n1.2643506233344.hdr_fail
>
> So any large block random write seems to be at risk (larger the block, hi=
gher the risk).  If there are other parameters I should be setting to avoid=
 the issue, please let me know.  Thanks.

If you set --overwrite=3D1 does the problem you're seeing go away? If so
it sounds like you're hitting https://github.com/axboe/fio/issues/335
...

--=20
Sitsofe | http://sucs.org/~sits/

