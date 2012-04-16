Return-Path: <sureshdrajan@gmail.com>
MIME-Version: 1.0
In-Reply-To: <4F8997E9.6090206@kernel.dk>
References: <CAN8qX8bPefV2J1xtNVBZ36sEKE-Vg-te+_Kj__hDoJGEzLzW=A@mail.gmail.com>
	<4F899663.8050406@kernel.dk>
	<4F8997E9.6090206@kernel.dk>
Date: Mon, 16 Apr 2012 16:15:43 -0700
Message-ID: <CAN8qX8bNZ4VPFP1a09DdJSaVa2D0MZ0vqLqHF-S4hbdHwuJZcw@mail.gmail.com>
Subject: Re: Running fio with offset Increment option
From: Suresh Dhanarajan <sureshdrajan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hi Jens,

I am facing issues while applying the patch,
Please find the details,
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
The patch for the file is ,

--- a/fio.h
+++ b/fio.h
@@ -67,6 +67,7 @@ struct thread_data {
       char verror[FIO_VERROR_SIZE];
       pthread_t thread;
       unsigned int thread_number;
+       unsigned int group_thread_number;
       unsigned int groupid;
       struct thread_stat ts;

There is no such line in that file.

$>grep 'unsigned int thread_number' fio.h
extern unsigned int thread_number;

The line 67 does not have any related lines,

65 enum {
 66     RW_SEQ_SEQ  =3D 0,
 67     RW_SEQ_IDENT,
 68 };

Let me know how to proceed further.

Thanks,
Suresh.D

On Sat, Apr 14, 2012 at 8:29 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2012-04-14 17:23, Jens Axboe wrote:
>> On 2012-04-14 01:48, Suresh Dhanarajan wrote:
>>> Hi,
>>>
>>> I wanted to use the "offset increment option" and =A0"numjobs" so that =
i
>>> can split the work load between ten jobs and reduce the run time.
>>> But what i am seeing is that the offset counter is not getting reset
>>> when the first job in the jobfile is completed.(is it that the offset
>>> is global for the job file and not for the Jobs inside the jobfile?)
>>> So =A0my read starts from the last offset set by the writes.
>>>
>>> here is my job file,
>>>
>>> [global]
>>> bs=3D64k
>>> direct=3D1
>>> numjobs=3D10
>>> size=3D1m
>>> group_reporting
>>>
>>> [write-phase]
>>> offset_increment=3D1m
>>> filename=3D/dev/sdb
>>> rw=3Dwrite
>>> write_iolog=3Dverfywrite2
>>>
>>> [read-phase]
>>> stonewall
>>> offset_increment=3D1m
>>> filename=3D/dev/sdb
>>> rw=3Dread
>>> write_iolog=3Dverfyread2
>>>
>>> I tried using the offset=3D0 option in the read phase job but now every
>>> time the read happens from zeroth offsite.
>>> Now the offset increment option is not getting honored.
>>>
>>> [write-phase]
>>> offset_increment=3D1m
>>> filename=3D/dev/sdb
>>> rw=3Dwrite
>>> write_iolog=3Dverfywrite2
>>>
>>> [read-phase]
>>> stonewall
>>> offset=3D0
>>> offset_increment=3D1m
>>> filename=3D/dev/sdb
>>> rw=3Dread
>>> write_iolog=3Dverfyread2
>>>
>>> I tried the same case with verify option.
>>> the behavior is same.
>>>
>>> Is there any way that i can reset the offset counters once the job is c=
ompleted?
>>
>> Right now there isn't, but it does make sense to reset the counter
>> across stonewalls. At the moment, it'll just increment for each job.
>> Internally, fio sets up all the jobs, even across stonewalls, when it
>> starts up. It just starts some of them later on, depending on those
>> parameters. It does seem most useful to have it reset across a hard
>> barrier though, I can definitely change it to do that.
>>
>> Let me brew up a patch later today that you can test.
>
> Had a few minutes now, didn't expect that. Can you try this? Do a make
> clean first.
>
> diff --git a/filesetup.c b/filesetup.c
> index 166ace8..bad5bed 100644
> --- a/filesetup.c
> +++ b/filesetup.c
> @@ -714,7 +714,7 @@ int setup_files(struct thread_data *td)
> =A0 =A0 =A0 =A0need_extend =3D 0;
> =A0 =A0 =A0 =A0for_each_file(td, f, i) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0f->file_offset =3D td->o.start_offset +
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (td->thread_number - 1) * t=
d->o.offset_increment;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (td->group_thread_number - =
1) * td->o.offset_increment;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!td->o.file_size_low) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> diff --git a/fio.h b/fio.h
> index 95d9d77..05a5572 100644
> --- a/fio.h
> +++ b/fio.h
> @@ -67,6 +67,7 @@ struct thread_data {
> =A0 =A0 =A0 =A0char verror[FIO_VERROR_SIZE];
> =A0 =A0 =A0 =A0pthread_t thread;
> =A0 =A0 =A0 =A0unsigned int thread_number;
> + =A0 =A0 =A0 unsigned int group_thread_number;
> =A0 =A0 =A0 =A0unsigned int groupid;
> =A0 =A0 =A0 =A0struct thread_stat ts;
>
> diff --git a/init.c b/init.c
> index 7422628..46571ee 100644
> --- a/init.c
> +++ b/init.c
> @@ -35,6 +35,7 @@ static int dump_cmdline;
> =A0static int def_timeout;
>
> =A0static struct thread_data def_thread;
> +static int group_thread_number;
> =A0struct thread_data *threads =3D NULL;
>
> =A0int exitall_on_terminate =3D 0;
> @@ -829,8 +830,10 @@ static int add_job(struct thread_data *td, const cha=
r *jobname, int job_add_num,
> =A0 =A0 =A0 =A0if ((td->o.stonewall || td->o.new_group) && prev_group_job=
s) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0prev_group_jobs =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0groupid++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 group_thread_number =3D 0;
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 td->group_thread_number =3D ++group_thread_number;
> =A0 =A0 =A0 =A0td->groupid =3D groupid;
> =A0 =A0 =A0 =A0prev_group_jobs++;
>
>
> --
> Jens Axboe
>

