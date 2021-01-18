Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <cover.1610946213.git.glqinhongwei@gmail.com> <6a2b8fd087204119730d1d35bc3130aae177e5b6.1610946213.git.glqinhongwei@gmail.com>
 <CAKvRR0T=dv=tajcBjUD2Wtc6tqmE_=aPUd-2bKhUirF_CQTimA@mail.gmail.com>
In-Reply-To: <CAKvRR0T=dv=tajcBjUD2Wtc6tqmE_=aPUd-2bKhUirF_CQTimA@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 18 Jan 2021 13:00:47 +0000
Message-ID: <CALjAwxjHFeFQUorBOg6f5cSuhvDfMsRwSpiCREcMJ1QCTxdtYg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] Add a new parameter.
Content-Type: text/plain; charset="UTF-8"
To: Hongwei Qin <glqinhongwei@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc: fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Mon, 18 Jan 2021 at 09:18, Hongwei Qin <glqinhongwei@gmail.com> wrote:
>
> The reason I use uint64 is that using u32 or u8
> causes alignment issues and the compilation check
> will fail.
> I currently don't know how to address it.
> Any idea?

Hongwei,
Usually the best approach is to introduce some padding (e.g. as in
https://github.com/axboe/fio/commit/8b38f40138047975ea7a59b9ce06681ffdd2c31d
). Could you also check client/server mode still works?

Jens,
As we've changed FIO_SERVER_VER since the last release (see
a87c90fd72823d5438d724e5a57ced8d1f7bed3f ) should we skip changing it
again for this change?

>
> Best,
> Hongwei
>
>
> On Mon, Jan 18, 2021 at 1:20 PM Hongwei Qin <glqinhongwei@gmail.com> wrote:
> >
> > This patch adds a new parameter thinktime_blocks_type to control
> > the behavior of thinktime_blocks. It can be either `complete`
> > or `issue`.
> > If it is `complete` (default), fio triggers thinktime when
> > thinktime_blocks number of blocks are **completed**.
> > If it is `issue`, fio triggers thinktime when thinktime_blocks
> > number of blocks are **issued**
> >
> > Tests:
> > jobfile1:
> > ```
> > [global]
> > thread
> > kb_base=1000
> > direct=1
> > size=1GiB
> > group_reporting
> > io_size=96KiB
> > ioengine=libaio
> > iodepth=8
> > bs=4096
> > filename=/dev/qblkdev
> > rw=randwrite
> >
> > [fio_randwrite]
> > thinktime=2s
> > thinktime_blocks=4
> > ```
> >
> > jobfile2:
> > ```
> > [global]
> > thread
> > kb_base=1000
> > direct=1
> > size=1GiB
> > group_reporting
> > io_size=96KiB
> > ioengine=libaio
> > iodepth=8
> > bs=4096
> > filename=/dev/qblkdev
> > rw=randwrite
> >
> > [fio_randwrite]
> > thinktime=2s
> > thinktime_blocks=4
> > thinktime_blocks_type=issue
> > ```
> >
> > Results:
> > Current HEAD:
> > fio jobfile1:
> >         write: IOPS=5, BW=24.6kB/s (24.0KiB/s)(98.3kB/4002msec); 0 zone resets
> >
> >         - issue 11 requests
> >         - sleep 2s
> >         - issue 8 requests
> >         - sleep 2s
> >         - issue 5 requests
> >         - finish
> >
> > This patch:
> > fio jobfile1:
> >         write: IOPS=5, BW=24.6kB/s (24.0KiB/s)(98.3kB/4001msec); 0 zone resets
> >
> >         - issue 11 requests
> >         - sleep 2s
> >         - issue 8 requests
> >         - sleep 2s
> >         - issue 5 requests
> >         - finish
> >
> > fio jobfile2:
> >         write: IOPS=1, BW=8191B/s (8191B/s)(98.3kB/12001msec); 0 zone resets
> >
> >         - issue 4 requests
> >         - sleep 2s
> >         ***
> >         - issue 4 requests
> >         - sleep 2s
> >         - finish
> >
> > Signed-off-by: Hongwei Qin <glqinhongwei@gmail.com>
> > ---
> >  HOWTO            |  7 +++++++
> >  backend.c        | 16 +++++++++++-----
> >  cconv.c          |  2 ++
> >  engines/cpu.c    |  1 +
> >  fio.h            |  5 +++++
> >  options.c        | 22 ++++++++++++++++++++++
> >  thread_options.h |  2 ++
> >  7 files changed, 50 insertions(+), 5 deletions(-)
> >
> > diff --git a/HOWTO b/HOWTO
> > index 372f268..803bef4 100644
> > --- a/HOWTO
> > +++ b/HOWTO
> > @@ -2562,6 +2562,13 @@ I/O rate
> >         before we have to complete it and do our :option:`thinktime`. In other words, this
> >         setting effectively caps the queue depth if the latter is larger.
> >
> > +.. option:: thinktime_blocks_type=str
> > +
> > +       This option controls how thinktime_blocks triggers. The default is
> > +       `complete`, which triggers thinktime when fio completes thinktime_blocks
> > +       blocks. If this is set to `issue`, then the trigger happens at the
> > +       issue side.
> > +
> >  .. option:: rate=int[,int][,int]
> >
> >         Cap the bandwidth used by this job. The number is in bytes/sec, the normal
> > diff --git a/backend.c b/backend.c
> > index e20a2e0..874e193 100644
> > --- a/backend.c
> > +++ b/backend.c
> > @@ -864,8 +864,8 @@ static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir)
> >         uint64_t total;
> >         int left;
> >
> > -       b = ddir_rw_sum(td->io_blocks);
> > -       if (b % td->o.thinktime_blocks)
> > +       b = ddir_rw_sum(td->thinktime_blocks_counter);
> > +       if (b % td->o.thinktime_blocks || !b)
> >                 return;
> >
> >         io_u_quiesce(td);
> > @@ -1076,6 +1076,10 @@ reap:
> >                 }
> >                 if (ret < 0)
> >                         break;
> > +
> > +               if (ddir_rw(ddir) && td->o.thinktime)
> > +                       handle_thinktime(td, ddir);
> > +
> >                 if (!ddir_rw_sum(td->bytes_done) &&
> >                     !td_ioengine_flagged(td, FIO_NOIO))
> >                         continue;
> > @@ -1090,9 +1094,6 @@ reap:
> >                 }
> >                 if (!in_ramp_time(td) && td->o.latency_target)
> >                         lat_target_check(td);
> > -
> > -               if (ddir_rw(ddir) && td->o.thinktime)
> > -                       handle_thinktime(td, ddir);
> >         }
> >
> >         check_update_rusage(td);
> > @@ -1744,6 +1745,11 @@ static void *thread_main(void *data)
> >         if (rate_submit_init(td, sk_out))
> >                 goto err;
> >
> > +       if (td->o.thinktime_blocks_type == THINKTIME_BLOCKS_TYPE_COMPLETE)
> > +               td->thinktime_blocks_counter = td->io_blocks;
> > +       else
> > +               td->thinktime_blocks_counter = td->io_issues;
> > +
> >         set_epoch_time(td, o->log_unix_epoch);
> >         fio_getrusage(&td->ru_start);
> >         memcpy(&td->bw_sample_time, &td->epoch, sizeof(td->epoch));
> > diff --git a/cconv.c b/cconv.c
> > index 62c2fc2..0d47f9c 100644
> > --- a/cconv.c
> > +++ b/cconv.c
> > @@ -210,6 +210,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
> >         o->thinktime = le32_to_cpu(top->thinktime);
> >         o->thinktime_spin = le32_to_cpu(top->thinktime_spin);
> >         o->thinktime_blocks = le32_to_cpu(top->thinktime_blocks);
> > +       o->thinktime_blocks_type = le64_to_cpu(top->thinktime_blocks_type);
> >         o->fsync_blocks = le32_to_cpu(top->fsync_blocks);
> >         o->fdatasync_blocks = le32_to_cpu(top->fdatasync_blocks);
> >         o->barrier_blocks = le32_to_cpu(top->barrier_blocks);
> > @@ -431,6 +432,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
> >         top->thinktime = cpu_to_le32(o->thinktime);
> >         top->thinktime_spin = cpu_to_le32(o->thinktime_spin);
> >         top->thinktime_blocks = cpu_to_le32(o->thinktime_blocks);
> > +       top->thinktime_blocks_type = __cpu_to_le64(o->thinktime_blocks_type);
> >         top->fsync_blocks = cpu_to_le32(o->fsync_blocks);
> >         top->fdatasync_blocks = cpu_to_le32(o->fdatasync_blocks);
> >         top->barrier_blocks = cpu_to_le32(o->barrier_blocks);
> > diff --git a/engines/cpu.c b/engines/cpu.c
> > index ccbfe00..ce74dbc 100644
> > --- a/engines/cpu.c
> > +++ b/engines/cpu.c
> > @@ -268,6 +268,7 @@ static int fio_cpuio_init(struct thread_data *td)
> >          * set thinktime_sleep and thinktime_spin appropriately
> >          */
> >         o->thinktime_blocks = 1;
> > +       o->thinktime_blocks_type = THINKTIME_BLOCKS_TYPE_COMPLETE;
> >         o->thinktime_spin = 0;
> >         o->thinktime = ((unsigned long long) co->cpucycle *
> >                                 (100 - co->cpuload)) / co->cpuload;
> > diff --git a/fio.h b/fio.h
> > index ee582a7..ae6ac76 100644
> > --- a/fio.h
> > +++ b/fio.h
> > @@ -149,6 +149,9 @@ enum {
> >
> >         RATE_PROCESS_LINEAR = 0,
> >         RATE_PROCESS_POISSON = 1,
> > +
> > +       THINKTIME_BLOCKS_TYPE_COMPLETE = 0,
> > +       THINKTIME_BLOCKS_TYPE_ISSUE = 1,
> >  };
> >
> >  enum {
> > @@ -355,6 +358,8 @@ struct thread_data {
> >         struct fio_sem *sem;
> >         uint64_t bytes_done[DDIR_RWDIR_CNT];
> >
> > +       uint64_t *thinktime_blocks_counter;
> > +
> >         /*
> >          * State for random io, a bitmap of blocks done vs not done
> >          */
> > diff --git a/options.c b/options.c
> > index 955bf95..2898850 100644
> > --- a/options.c
> > +++ b/options.c
> > @@ -3609,6 +3609,28 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
> >                 .group  = FIO_OPT_G_THINKTIME,
> >         },
> >         {
> > +               .name   = "thinktime_blocks_type",
> > +               .lname  = "Thinktime blocks type",
> > +               .type   = FIO_OPT_STR,
> > +               .off1   = offsetof(struct thread_options, thinktime_blocks_type),
> > +               .help   = "How thinktime_blocks takes effect",
> > +               .def    = "complete",
> > +               .category = FIO_OPT_C_IO,
> > +               .group  = FIO_OPT_G_THINKTIME,
> > +               .posval = {
> > +                         { .ival = "complete",
> > +                           .oval = THINKTIME_BLOCKS_TYPE_COMPLETE,
> > +                           .help = "Thinktime_blocks takes effect at the completion side",
> > +                         },
> > +                         {
> > +                           .ival = "issue",
> > +                           .oval = THINKTIME_BLOCKS_TYPE_ISSUE,
> > +                           .help = "Thinktime_blocks takes effect at the issue side",
> > +                         },
> > +               },
> > +               .parent = "thinktime",
> > +       },
> > +       {
> >                 .name   = "rate",
> >                 .lname  = "I/O rate",
> >                 .type   = FIO_OPT_ULL,
> > diff --git a/thread_options.h b/thread_options.h
> > index 0a03343..0bd7452 100644
> > --- a/thread_options.h
> > +++ b/thread_options.h
> > @@ -177,6 +177,7 @@ struct thread_options {
> >         unsigned int thinktime;
> >         unsigned int thinktime_spin;
> >         unsigned int thinktime_blocks;
> > +       unsigned int thinktime_blocks_type;
> >         unsigned int fsync_blocks;
> >         unsigned int fdatasync_blocks;
> >         unsigned int barrier_blocks;
> > @@ -479,6 +480,7 @@ struct thread_options_pack {
> >         uint32_t thinktime;
> >         uint32_t thinktime_spin;
> >         uint32_t thinktime_blocks;
> > +       uint64_t thinktime_blocks_type;
> >         uint32_t fsync_blocks;
> >         uint32_t fdatasync_blocks;
> >         uint32_t barrier_blocks;
> > --
> > 1.8.3.1
> >



-- 
Sitsofe

