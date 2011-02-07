Return-Path: <slpratt@austin.ibm.com>
MIME-Version: 1.0
From: Steven Pratt <slpratt@austin.ibm.com>
Date: Mon, 7 Feb 2011 13:51:56 -0700
Subject: Re: test definition help needed
Message-ID: <4D505B6C.8090905@austin.ibm.com>
References: <4D4C51B2.1090700@austin.ibm.com> <4D4F0C09.2010601@fusionio.com>
In-Reply-To: <4D4F0C09.2010601@fusionio.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 02/06/2011 03:00 PM, Jens Axboe wrote:
> On 2011-02-04 20:21, Steven Pratt wrote:
>> I am trying to create a job file that randomly select a file form an imp=
orted list and reads the entire file sequentially. Them moves to the next f=
ile. I also want multiple jobs(processe) running the same workload. I have =
this:
>>
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
>>
>> [job1]
>> opendir=3D/${FIO_MOUNT}/session1/small_file1
>> file_service_type=3Dsequential
>> numjobs=3D8
>>
>>
>>
>> I used file_service_type=3Dsequential because tought without it it would
>> only do a single read (block) from the file before switching to a
>> different file, which is not what I want. The issue with this test as
>> written is it seems like all the fio processes choose files in the
>> same order so I get way more cache hits than I want. I want this to be
>> more of a random file selection, but with reading whole file.  Any
>> advice?
> file_service_type=3Drandom:<largenum>
>
> should do what you need, I think. If you ensure that <largenum> is
> sufficiently large that the file will always be finished before you run
> out, then that should work.
Had thought of that, but seemed kind of hackish.  Any way gave it a shot an=
d it kind of worked.  It seemed to randomly select a file to operate on, ho=
wever fio eventually went into a tight spin loop and never exited. Traced t=
hat back to get_next_file_rand where apparently if you ever access every fi=
le you will never exit(get stuck in  "if (fio_file_done(f))  continue;" for=
ever).  So now I have 2 problems.  One is this infinite loop which is obvio=
usly not good. The second (which may help solve the first) is that I want t=
o randomly reuse files. I don't want a perfect no reuse case, and I can't f=
ind any way to get that to happen. If reuse were possible, this loop would =
not be a problem.  I guess for now I can just remove the continue and it wi=
ll do what I want and not loop.  Thoughts on a better solution?

Steve



