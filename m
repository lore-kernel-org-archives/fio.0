Return-Path: <gschoenberger@thomas-krenn.com>
MIME-Version: 1.0
From: =?iso-8859-15?Q?Georg_Sch=F6nberger?= <gschoenberger@thomas-krenn.com>
Date: Wed, 2 May 2012 05:51:33 -0600
Subject: Re: Tell fio to only lay out files
Message-ID: <4FA11FC5.4030202@thomas-krenn.com>
References: <4FA0FB19.6010506@thomas-krenn.com> <4FA10E08.70009@fusionio.com>
In-Reply-To: <4FA10E08.70009@fusionio.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Thanks for your fast patch, I really appreciate that :-)
The create_only option now helps me to start with a consistent cache
state for every test run.

Georg

Am 2012-05-02 12:35, schrieb Jens Axboe:
> On 05/02/2012 11:15 AM, Georg Sch=F6nberger wrote:
>> Hello Everyone,
>>
>> is it possible to tell fio to only lay out the data files and not carry
>> out any tests?
>> The thing is that I need to sync my Flashcache device after laying out
>> the files and before starting the read tests. Therefore it would be
>> helpful if I could do the following:
>> -Start fio and tell him to only lay out data files
>> -Sync my cache
>> -Start fio again with the previous layed out files and do the tests
> That's not a bad idea. The below patch will add a create_only option. If
> set, fio will exit after file creation is completed.
>
>> Another option would be the parameter "filename", which tells fio to use
>> that file. But what if I am using multiple processes, can I specify a
>> file on command line for each process?
> You could do that as well, but it requires you to know how fio names
> its files for the jobs. Which isn't tricky, it's basically:
>
>         name.threadno.fileno
>
> So if you have
>
> [foo]
> numjobs=3D4
>
> as the first entry, you'll have foo.0.[1-4] as the file names. But the
> setup only option is cleaner and then you don't have to document and
> stick to the file naming :-)
>
> diff --git a/filesetup.c b/filesetup.c
> index f3d3829..a1ad026 100644
> --- a/filesetup.c
> +++ b/filesetup.c
> @@ -665,7 +665,7 @@ int setup_files(struct thread_data *td)
>  	dprint(FD_FILE, "setup files\n");
> =20
>  	if (td->o.read_iolog_file)
> -		return 0;
> +		goto done;
> =20
>  	/*
>  	 * if ioengine defines a setup() method, it's responsible for
> @@ -816,6 +816,11 @@ int setup_files(struct thread_data *td)
>  	 */
>  	if (!td->o.read_iolog_file)
>  		td->total_io_size =3D td->o.size * td->o.loops;
> +
> +done:
> +	if (td->o.create_only)
> +		td->done =3D 1;
> +
>  	return 0;
>  err_offset:
>  	log_err("%s: you need to specify valid offset=3D\n", td->o.name);
> diff --git a/fio.h b/fio.h
> index 6da22f0..f2a5a1f 100644
> --- a/fio.h
> +++ b/fio.h
> @@ -125,6 +125,7 @@ struct thread_options {
>  	unsigned int create_serialize;
>  	unsigned int create_fsync;
>  	unsigned int create_on_open;
> +	unsigned int create_only;
>  	unsigned int end_fsync;
>  	unsigned int pre_read;
>  	unsigned int sync_io;
> diff --git a/options.c b/options.c
> index f8927ee..28a228c 100644
> --- a/options.c
> +++ b/options.c
> @@ -1885,6 +1885,13 @@ static struct fio_option options[FIO_MAX_OPTS] =3D=
 {
>  		.def	=3D "0",
>  	},
>  	{
> +		.name	=3D "create_only",
> +		.type	=3D FIO_OPT_BOOL,
> +		.off1	=3D td_var_offset(create_only),
> +		.help	=3D "Only perform file creation phase",
> +		.def	=3D "0",
> +	},
> +	{
>  		.name	=3D "pre_read",
>  		.type	=3D FIO_OPT_BOOL,
>  		.off1	=3D td_var_offset(pre_read),
>

