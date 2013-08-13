Return-Path: <jiahua@gmail.com>
MIME-Version: 1.0
Reply-To: jiahua@gmail.com
In-Reply-To: <20130809185145.GA6629@kernel.dk>
References: <CA+S_sg4sVwquhtxLpmjQQXiNOBya+6vF0mSbyWZG_Q1YtbPPCA@mail.gmail.com>
	<CA+S_sg4ROD-+qdBKz9VMwMcOn4OrpOTBh9sF=gQEbfT54HZCXw@mail.gmail.com>
	<52040589.2050803@kernel.dk>
	<CA+S_sg79AHmGPHZC9A4=z=1i7LjXuxQh2mY5FcCdiKE_JqVURg@mail.gmail.com>
	<20130809185145.GA6629@kernel.dk>
Date: Mon, 12 Aug 2013 22:23:16 -0700
Message-ID: <CA+S_sg5i9d1E30sigK_O0E_nfsyiPf2s7Bkq3HLtQg3iYQqV0A@mail.gmail.com>
Subject: Re: How to control the number of random I/O's acrossing the whole file/device?
From: Jiahua <jiahua@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

It works. Thank you very much!

On Fri, Aug 9, 2013 at 11:51 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On Fri, Aug 09 2013, Jiahua wrote:
>> I have a 1TB disk and try to do a fixed number, say 1000, random 4KB
>> I/O's cross the whole disk. If I use size=4MB, I can only touch the
>> first 4MB range of the disk instead of the whole disk range. If I set
>> size as 1TB, it will do much more than 1000 I/O's and run too long. As
>> for time_based, it is not ideal since I cannot control the I/O number
>> precisely.
>
> Ah, I see what you mean. Try and patch the below in, then set
> number_ios=1000 and see if it does what you want.
>
> diff --git a/cconv.c b/cconv.c
> index 8e7c69e..21e3a51 100644
> --- a/cconv.c
> +++ b/cconv.c
> @@ -146,6 +146,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
>         o->zone_skip = le64_to_cpu(top->zone_skip);
>         o->lockmem = le64_to_cpu(top->lockmem);
>         o->offset_increment = le64_to_cpu(top->offset_increment);
> +       o->number_ios = le64_to_cpu(top->number_ios);
>
>         o->overwrite = le32_to_cpu(top->overwrite);
>         o->bw_avg_time = le32_to_cpu(top->bw_avg_time);
> @@ -394,6 +395,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
>         top->start_offset = __cpu_to_le64(o->start_offset);
>         top->trim_backlog = __cpu_to_le64(o->trim_backlog);
>         top->offset_increment = __cpu_to_le64(o->offset_increment);
> +       top->number_ios = __cpu_to_le64(o->number_ios);
>
>         for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++)
>                 top->percentile_list[i].u.i = __cpu_to_le64(fio_double_to_uint64(o->percentile_list[i].u.f));
> diff --git a/io_u.c b/io_u.c
> index a35aafd..c50a17d 100644
> --- a/io_u.c
> +++ b/io_u.c
> @@ -1413,6 +1413,9 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
>                 add_bw_sample(td, idx, bytes, &icd->time);
>
>         add_iops_sample(td, idx, bytes, &icd->time);
> +
> +       if (td->o.number_ios && !--td->o.number_ios)
> +               td->done = 1;
>  }
>
>  static long long usec_for_io(struct thread_data *td, enum fio_ddir ddir)
> diff --git a/options.c b/options.c
> index 1816d0b..caf89d3 100644
> --- a/options.c
> +++ b/options.c
> @@ -1483,6 +1483,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
>                 .group  = FIO_OPT_G_INVALID,
>         },
>         {
> +               .name   = "number_ios",
> +               .lname  = "Number of IOs to perform",
> +               .type   = FIO_OPT_STR_VAL,
> +               .off1   = td_var_offset(number_ios),
> +               .help   = "Force job completion of this number of IOs",
> +               .def    = "0",
> +               .category = FIO_OPT_C_IO,
> +               .group  = FIO_OPT_G_INVALID,
> +       },
> +       {
>                 .name   = "bs",
>                 .lname  = "Block size",
>                 .alias  = "blocksize",
> diff --git a/thread_options.h b/thread_options.h
> index eaafaee..3f345c5 100644
> --- a/thread_options.h
> +++ b/thread_options.h
> @@ -236,6 +236,7 @@ struct thread_options {
>         unsigned int flow_sleep;
>
>         unsigned long long offset_increment;
> +       unsigned long long number_ios;
>
>         unsigned int sync_file_range;
>  };
> @@ -440,6 +441,7 @@ struct thread_options_pack {
>         uint32_t flow_sleep;
>
>         uint64_t offset_increment;
> +       uint64_t number_ios;
>
>         uint32_t sync_file_range;
>  } __attribute__((packed));
>
> --
> Jens Axboe
>

