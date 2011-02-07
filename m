Return-Path: <jmoyer@redhat.com>
MIME-Version: 1.0
From: Jeff Moyer <jmoyer@redhat.com>
Date: Mon, 7 Feb 2011 07:35:53 -0700
Subject: Re: test definition help needed
Message-ID: <x49oc6n9ak6.fsf@segfault.boston.devel.redhat.com>
References: <4D4C51B2.1090700@austin.ibm.com> <4D4F0C09.2010601@fusionio.com>
In-Reply-To: <4D4F0C09.2010601@fusionio.com> (Jens Axboe's message of "Sun,
 6	Feb 2011 22:00:57 +0100")
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>
Cc: Steven Pratt <slpratt@austin.ibm.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Jens Axboe <jaxboe@fusionio.com> writes:

> On 2011-02-04 20:21, Steven Pratt wrote:
>> I am trying to create a job file that randomly select a file form an imp=
orted list and reads the entire file sequentially. Them moves to the next f=
ile. I also want multiple jobs(processe) running the same workload. I have =
this:
>>=20
>> [global]
>> bs=3D4k
>> time_based=3D1
>> runtime=3D15m
>> iodepth=3D4
>> rw=3Dread
>> ioengine=3Dlibaio
>> time_based=3D1
>> ramp_time=3D600s
>> norandommap
>>=20
>> [job1]
>> opendir=3D/${FIO_MOUNT}/session1/small_file1
>> file_service_type=3Dsequential
>> numjobs=3D8
>>=20
>>=20
>>=20
>> I used file_service_type=3Dsequential because tought without it it would
>> only do a single read (block) from the file before switching to a
>> different file, which is not what I want. The issue with this test as
>> written is it seems like all the fio processes choose files in the
>> same order so I get way more cache hits than I want. I want this to be
>> more of a random file selection, but with reading whole file.  Any
>> advice?
>
> file_service_type=3Drandom:<largenum>
>
> should do what you need, I think. If you ensure that <largenum> is
> sufficiently large that the file will always be finished before you run
> out, then that should work.

Also note that with ioengine=3Dlibaio, you'll also want to specify direct
io (otherwise io_submit will block until the I/O is complete).  If you
really want buffered, then you need to choose a different io engine.

Cheers,
Jeff

