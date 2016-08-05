Return-Path: <mrturtledev@gmail.com>
MIME-Version: 1.0
In-Reply-To: <b67f4217-97f3-f9f9-46a1-92c9b43ba9b9@kernel.dk>
References: <CAG6KGPRQf7Mii35T1drhL=u0mZB8PQEeOMnmuBFWSNgBy4E31A@mail.gmail.com>
 <48aea5d8-12a5-58ca-9008-913e13bc7a8d@kernel.dk> <CAG6KGPSthqs28GTQYSnFGcs_XzQWdALQ8knUS7ook2-_wurcmw@mail.gmail.com>
 <4ac1a598-480e-bfa6-3704-929c909be5da@kernel.dk> <b67f4217-97f3-f9f9-46a1-92c9b43ba9b9@kernel.dk>
From: Martin Dev <mrturtledev@gmail.com>
Date: Fri, 5 Aug 2016 08:31:43 +0100
Message-ID: <CAG6KGPSukQwdmfcJiE7CSHZf4hYV4niHm2QQcM1tyE=kBHBtzw@mail.gmail.com>
Subject: Re: Unlink after each loop in job
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hey Jens,

I applied your patch, but it doesn't unlink the file as it continues
at the !fio_file_open(f) in unlink_files(), run for 2 loops

Clear State: 0
Clear State: 1
Doing unlink
Starting file loop
File is not open!

I assume it's OK to flip it and check if the file is open then
continue (so not to unlink files that are potentially still in use)

I'll update the readme/docs and fio.1 as suggested.



On Thu, Aug 4, 2016 at 6:02 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 08/04/2016 09:50 AM, Jens Axboe wrote:
>>
>> On 08/04/2016 02:42 AM, Martin Dev wrote:
>>>
>>> Ok so I cleaned up the code a bit (I found fio_each_file), but I don't
>>> know the usual protocol for this kind of thing. I forked FIO on github
>>> and made some changes, which can be seen here
>>> https://github.com/axboe/fio/compare/master...mrturtledev:master
>>>
>>> This produces the desired functionality, but as you can see from the
>>> comments I don't know how to handle errors in the context of FIO (or
>>> in C in general). Here is a quick validation showing the deletion
>>> after each loop
>>> tester@--------:/usr/src/git$ cat fio/testfile
>>> [global]
>>> ioengine=libaio
>>> bs=4k
>>> size=200m
>>> verify=meta
>>> direct=1
>>> directory=/tmp/
>>> filename=ssd.test.file
>>>
>>> [seq-write]
>>> rw=write
>>> unlink_each_loop=1
>>> do_verify=1
>>> loops=2
>>>
>>> tester@--------:/usr/src/git/fio$ ./fio testfile
>>>
>>> tester@---------:/tmp$ inotifywait -m -e delete -e create -e access /tmp/
>>> Setting up watches.
>>> Watches established.
>>> /tmp/ CREATE ssd.test.file
>>> /tmp/ DELETE ssd.test.file
>>> /tmp/ CREATE ssd.test.file
>>> /tmp/ DELETE ssd.test.file
>>>
>>> Thanks for the help
>>
>>
>> It looks pretty close. You need to call td_io_unlink_file(td, f) instead
>> of using unlink() directly, as some IO engines don't have normal regular
>> local files. Additionally, you want to check for f->filetype ==
>> FIO_TYPE_FILE as well before doing unlink.
>>
>> Error handling should be fixed up, as you noted. I can do that for you.
>> The options part looks fine, however you also need to update fio.1 and
>> HOWTO to add these new options. On top of that, you can to modify the
>> thread_options_pack structure as well, and add the conversion of this
>> option to cconv.c, otherwise it won't work for networked clients. And
>> since that structure is modified, server.h FIO_SERVER_VER needs to be
>> incremented as we know have a differently sized structure we pass.
>>
>> If you modify the documentation, I can take care of the rest of the
>> options work mentioned above.
>
>
> On top of your patch, below should take care of most of it.
>
>
> diff --git a/backend.c b/backend.c
> index cd58af97472e..5074654525b8 100644
> --- a/backend.c
> +++ b/backend.c
> @@ -574,19 +574,24 @@ static inline bool io_in_polling(struct thread_data
> *td)
>  /*
>   * Unlinks files from thread data fio_file structure
>   */
> -static void do_unlink(struct thread_data *td)
> +static int unlink_files(struct thread_data *td)
>  {
>         struct fio_file *f;
>         unsigned int i;
> +       int ret = 0;
>
>         for_each_file(td, f, i) {
> -
>                 if (!fio_file_open(f))
>                         continue;
> +               if (f->filetype != FIO_TYPE_FILE)
> +                       continue;
>
> -               // Don't know how FIO propagates errors through the
> framework
> -               int ret = unlink(f->file_name);
> +               ret = td_io_unlink_file(td, f);
> +               if (ret)
> +                       break;
>         }
> +
> +       return ret;
>  }
>  /*
>   * The main verify engine. Runs over the writes we previously submitted,
> @@ -1683,9 +1688,13 @@ static void *thread_main(void *data)
>                 fio_gettime(&td->start, NULL);
>                 memcpy(&td->tv_cache, &td->start, sizeof(td->start));
>
> -               if (clear_state)
> +               if (clear_state) {
>                         clear_io_state(td, 0);
>
> +                       if (o->unlink_each_loop)
> +                               unlink_files(td);
> +               }
> +
>                 prune_io_piece_log(td);
>
>                 if (td->o.verify_only && (td_write(td) || td_rw(td)))
> @@ -1730,13 +1739,8 @@ static void *thread_main(void *data)
>
>                 if (!o->do_verify ||
>                     o->verify == VERIFY_NONE ||
> -                   (td->io_ops->flags & FIO_UNIDIR)) {
> -
> -                       if (o->unlink_each_loop)
> -                               do_unlink(td);
> -
> +                   (td->io_ops->flags & FIO_UNIDIR))
>                         continue;
> -               }
>
>                 clear_io_state(td, 0);
>
> @@ -1744,8 +1748,6 @@ static void *thread_main(void *data)
>
>                 do_verify(td, verify_bytes);
>
> -               if (o->unlink_each_loop)
> -                       do_unlink(td);
>                 /*
>                  * See comment further up for why this is done here.
>                  */
> diff --git a/cconv.c b/cconv.c
> index ac826a3038c9..5aeced76ee82 100644
> --- a/cconv.c
> +++ b/cconv.c
> @@ -172,6 +172,7 @@ void convert_thread_options_to_cpu(struct thread_options
> *o,
>         o->verify_batch = le32_to_cpu(top->verify_batch);
>         o->use_thread = le32_to_cpu(top->use_thread);
>         o->unlink = le32_to_cpu(top->unlink);
> +       o->unlink_each_loop = le32_to_cpu(top->unlink_each_loop);
>         o->do_disk_util = le32_to_cpu(top->do_disk_util);
>         o->override_sync = le32_to_cpu(top->override_sync);
>         o->rand_repeatable = le32_to_cpu(top->rand_repeatable);
> @@ -362,6 +363,7 @@ void convert_thread_options_to_net(struct
> thread_options_pack *top,
>         top->verify_batch = cpu_to_le32(o->verify_batch);
>         top->use_thread = cpu_to_le32(o->use_thread);
>         top->unlink = cpu_to_le32(o->unlink);
> +       top->unlink_each_loop = cpu_to_le32(o->unlink_each_loop);
>         top->do_disk_util = cpu_to_le32(o->do_disk_util);
>         top->override_sync = cpu_to_le32(o->override_sync);
>         top->rand_repeatable = cpu_to_le32(o->rand_repeatable);
> diff --git a/server.h b/server.h
> index 79c751de2388..c17c3bb571ae 100644
> --- a/server.h
> +++ b/server.h
> @@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
>  };
>
>  enum {
> -       FIO_SERVER_VER                  = 54,
> +       FIO_SERVER_VER                  = 55,
>
>         FIO_SERVER_MAX_FRAGMENT_PDU     = 1024,
>         FIO_SERVER_MAX_CMD_MB           = 2048,
> diff --git a/thread_options.h b/thread_options.h
> index 28817c87f56f..53173dfebe13 100644
> --- a/thread_options.h
> +++ b/thread_options.h
> @@ -376,6 +376,7 @@ struct thread_options_pack {
>         uint32_t verify_state_save;
>         uint32_t use_thread;
>         uint32_t unlink;
> +       uint32_t unlink_each_loop;
>         uint32_t do_disk_util;
>         uint32_t override_sync;
>         uint32_t rand_repeatable;
> @@ -392,7 +393,6 @@ struct thread_options_pack {
>         uint32_t bs_unaligned;
>         uint32_t fsync_on_close;
>         uint32_t bs_is_seq_rand;
> -       uint32_t pad1;
>
>         uint32_t random_distribution;
>         uint32_t exitall_error;
>
> --
> Jens Axboe
>

