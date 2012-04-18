Return-Path: <sureshdrajan@gmail.com>
MIME-Version: 1.0
In-Reply-To: <4F8D0E1A.2020004@kernel.dk>
References: <CAN8qX8bPefV2J1xtNVBZ36sEKE-Vg-te+_Kj__hDoJGEzLzW=A@mail.gmail.com>
	<4F899663.8050406@kernel.dk>
	<4F8997E9.6090206@kernel.dk>
	<CAN8qX8bNZ4VPFP1a09DdJSaVa2D0MZ0vqLqHF-S4hbdHwuJZcw@mail.gmail.com>
	<4F8D0E1A.2020004@kernel.dk>
Date: Wed, 18 Apr 2012 14:37:01 -0700
Message-ID: <CAN8qX8ZJXpKibjFfyG9ZBG=eXNwWtdm5X9FyRduKvCcyQx7RwA@mail.gmail.com>
Subject: Re: Running fio with offset Increment option
From: Suresh Dhanarajan <sureshdrajan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hi Jens,

Thanks for the patch.
I checked with the patch given you and found that the offset is
getting set to zero for every new job.

Suresh


On Mon, Apr 16, 2012 at 11:30 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 04/17/2012 01:15 AM, Suresh Dhanarajan wrote:
>> Hi Jens,
>>
>> I am facing issues while applying the patch,
>> Please find the details,
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> The patch for the file is ,
>>
>> --- a/fio.h
>> +++ b/fio.h
>> @@ -67,6 +67,7 @@ struct thread_data {
>> =A0 =A0 =A0 =A0char verror[FIO_VERROR_SIZE];
>> =A0 =A0 =A0 =A0pthread_t thread;
>> =A0 =A0 =A0 =A0unsigned int thread_number;
>> + =A0 =A0 =A0 unsigned int group_thread_number;
>> =A0 =A0 =A0 =A0unsigned int groupid;
>> =A0 =A0 =A0 =A0struct thread_stat ts;
>>
>> There is no such line in that file.
>>
>> $>grep 'unsigned int thread_number' fio.h
>> extern unsigned int thread_number;
>>
>> The line 67 does not have any related lines,
>>
>> 65 enum {
>> =A066 =A0 =A0 RW_SEQ_SEQ =A0=3D 0,
>> =A067 =A0 =A0 RW_SEQ_IDENT,
>> =A068 };
>>
>> Let me know how to proceed further.
>
> It was against the gfio branch. The line is there in fio.h, it's just
> further down and thread_number isn't unsigned :-)
>
> Here's a patch against the master branch, should apply against any
> recent version.
>
> diff --git a/filesetup.c b/filesetup.c
> index f3d3829..0fc0b41 100644
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
> index 6da22f0..d4fb907 100644
> --- a/fio.h
> +++ b/fio.h
> @@ -280,6 +280,7 @@ struct thread_data {
> =A0 =A0 =A0 =A0char verror[FIO_VERROR_SIZE];
> =A0 =A0 =A0 =A0pthread_t thread;
> =A0 =A0 =A0 =A0int thread_number;
> + =A0 =A0 =A0 unsigned int group_thread_number;
> =A0 =A0 =A0 =A0int groupid;
> =A0 =A0 =A0 =A0struct thread_stat ts;
>
> diff --git a/init.c b/init.c
> index 3865d09..465ffa9 100644
> --- a/init.c
> +++ b/init.c
> @@ -33,6 +33,7 @@ static int dump_cmdline;
> =A0static int def_timeout;
>
> =A0static struct thread_data def_thread;
> +static int group_thread_number;
> =A0struct thread_data *threads =3D NULL;
>
> =A0int exitall_on_terminate =3D 0;
> @@ -824,8 +825,10 @@ static int add_job(struct thread_data *td, const cha=
r *jobname, int job_add_num)
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

