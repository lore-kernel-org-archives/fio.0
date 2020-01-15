Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <CAA6um5PoJSafFa6Xa9ZeZqXUyXPA5b2fGNWA=+OoRVhkkXgogg@mail.gmail.com>
 <7b667f2f-dbe9-7ff1-72f4-d41d0994e21d@kernel.dk>
In-Reply-To: <7b667f2f-dbe9-7ff1-72f4-d41d0994e21d@kernel.dk>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 15 Jan 2020 23:47:29 +0000
Message-ID: <CALjAwxi-W2-5Xg=3mBMakfmeTJ7KjnQC=L0DrsESQAEY45Y3rw@mail.gmail.com>
Subject: Re: FIO verify bad header question
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Michael Chichik <michael.c@excelero.com>
Cc: Matan Ramrazker <matan@excelero.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hi,

On Wed, 15 Jan 2020 at 15:32, Jens Axboe <axboe@kernel.dk> wrote:
>
> Please use the fio list for this, CC'ed.
>
> On 1/15/20 8:28 AM, Michael Chichik wrote:
> >
> > */usr/bin/fio --time_based --runtime=3D1d --ioengine=3Dlibaio --iodepth=
=3D32 --rw=3Drandrw --bs=3D24k --direct=3D0 --io_size=3D60G --numjobs=3D10 =
--size=3D1G --rwmixread=3D0 --verify=3Dmd5 --verify_fatal=3D1 --output-form=
at=3Djson --output=3D4_randrw_0_10_32_libaio_xfs_1G.json --directory /mnt/t=
est-vol-23206-36 --name host1_test-vol-23206-36

^^^numjobs=3D10 will mean all the jobs are working inside the same
region. Because you're using randrw it's likely each job will write
blocks in a different sequence to other jobs.

> > *
> > FIO failed with the following error:
> > *
> > *
> > *verify: bad header rand_seed 1089408830752521594, wanted 7280637923435=
198810 at file /mnt/test-vol-23206-36/filename offset 776945664, length 245=
76

This means job 2 can interfere with the writes of job 1 so when job
one comes to do a verify it can't find the blocks written by itself
(because it may find job 2's data). If you're going to use numjobs I'd
strongly look into use offset_increment
(https://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-offset-inc=
rement
) and size (https://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg=
-size
) to ensure each job is working within a different region to any other
job.


> > *
> >
> > but when we compare the block level data is consistent.
> >
> > what is the meaning of the Error? does it really indicate data corrupti=
on?

It means the data a given job had written isn't there and if no one
else has interfered with the data that usually means corruption (but
in this case other jobs may be interfering). Also using randrw with
verify makes things complicated because are you expecting it to verify
data it might try to read in the first pass which that job has never
written?

--
Sitsofe | http://sucs.org/~sits/

