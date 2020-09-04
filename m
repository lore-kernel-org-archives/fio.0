Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <20200903165402.GA78826@localhost.localdomain>
In-Reply-To: <20200903165402.GA78826@localhost.localdomain>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 4 Sep 2020 07:24:55 +0100
Message-ID: <CALjAwxhqaRPUGjyUapVM=cOqGTQSBb_wvSNQKe=k+eNGW6dL3w@mail.gmail.com>
Subject: Re: [PATCH] fio: support io_size=N% (N <= 100)
Content-Type: text/plain; charset="UTF-8"
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Thu, 3 Sep 2020 at 17:55, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>
> Parse "io_size=N%".
>
> Semantics is "multiply whatever size= calculations result in".
>
> Example #1:
>
>         size=50%
>         io_size=50%
>
> will do 25% of a file.
>
> Example #2:
>
>         size=1G
>         io_size=50%
>
> will do 512M I/O.
>
> As side effect, fix a bug with essentially infinite loop if both size=N%
> and io_size=M% are given: io_size is set to 2^64-... in this case (a lot!).
>
> Note: only values under 100% work currently.
> Going for io_size=150% requires resetting workload generator state
> which is whole separate endeavour.

It might be worth adding some error output if someone does go for more
more than 100% otherwise people will think
https://github.com/axboe/fio/issues/419 has been fixed...

>
> Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
> ---
>
>  cconv.c          |    2 ++
>  filesetup.c      |   11 ++++++++++-
>  options.c        |   17 +++++++++++++++++
>  server.h         |    2 +-
>  thread_options.h |    4 ++++
>  5 files changed, 34 insertions(+), 2 deletions(-)
>
> --- a/cconv.c
> +++ b/cconv.c
> @@ -102,6 +102,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
>         o->size = le64_to_cpu(top->size);
>         o->io_size = le64_to_cpu(top->io_size);
>         o->size_percent = le32_to_cpu(top->size_percent);
> +       o->io_size_percent = le32_to_cpu(top->io_size_percent);
>         o->fill_device = le32_to_cpu(top->fill_device);
>         o->file_append = le32_to_cpu(top->file_append);
>         o->file_size_low = le64_to_cpu(top->file_size_low);
> @@ -367,6 +368,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
>         top->iodepth_batch_complete_max = cpu_to_le32(o->iodepth_batch_complete_max);
>         top->serialize_overlap = cpu_to_le32(o->serialize_overlap);
>         top->size_percent = cpu_to_le32(o->size_percent);
> +       top->io_size_percent = cpu_to_le32(o->io_size_percent);
>         top->fill_device = cpu_to_le32(o->fill_device);
>         top->file_append = cpu_to_le32(o->file_append);
>         top->ratecycle = cpu_to_le32(o->ratecycle);
> --- a/filesetup.c
> +++ b/filesetup.c
> @@ -1139,6 +1139,8 @@ int setup_files(struct thread_data *td)
>                 if (f->io_size == -1ULL)
>                         total_size = -1ULL;
>                 else {
> +                       uint64_t io_size;
> +
>                          if (o->size_percent && o->size_percent != 100) {
>                                 uint64_t file_size;
>
> @@ -1150,7 +1152,14 @@ int setup_files(struct thread_data *td)
>
>                                 f->io_size -= (f->io_size % td_min_bs(td));
>                         }
> -                       total_size += f->io_size;
> +
> +                       io_size = f->io_size;
> +                       if (o->io_size_percent && o->io_size_percent != 100) {
> +                               io_size *= o->io_size_percent;
> +                               io_size /= 100;
> +                       }
> +
> +                       total_size += io_size;
>                 }
>
>                 if (f->filetype == FIO_TYPE_FILE &&
> --- a/options.c
> +++ b/options.c
> @@ -1476,6 +1476,22 @@ static int str_size_cb(void *data, unsigned long long *__val)
>         return 0;
>  }
>
> +static int str_io_size_cb(void *data, unsigned long long *__val)
> +{
> +       struct thread_data *td = cb_data_to_td(data);
> +       unsigned long long v = *__val;
> +
> +       if (parse_is_percent(v)) {
> +               td->o.io_size = 0;
> +               td->o.io_size_percent = -1ULL - v;
> +               dprint(FD_PARSE, "SET io_size_percent %d\n",
> +                                       td->o.io_size_percent);
> +       } else
> +               td->o.io_size = v;
> +
> +       return 0;
> +}
> +
>  static int str_write_bw_log_cb(void *data, const char *str)
>  {
>         struct thread_data *td = cb_data_to_td(data);
> @@ -2043,6 +2059,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
>                 .alias  = "io_limit",
>                 .lname  = "IO Size",
>                 .type   = FIO_OPT_STR_VAL,
> +               .cb     = str_io_size_cb,
>                 .off1   = offsetof(struct thread_options, io_size),
>                 .help   = "Total size of I/O to be performed",
>                 .interval = 1024 * 1024,
> --- a/server.h
> +++ b/server.h
> @@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
>  };
>
>  enum {
> -       FIO_SERVER_VER                  = 85,
> +       FIO_SERVER_VER                  = 86,
>
>         FIO_SERVER_MAX_FRAGMENT_PDU     = 1024,
>         FIO_SERVER_MAX_CMD_MB           = 2048,
> --- a/thread_options.h
> +++ b/thread_options.h
> @@ -83,6 +83,7 @@ struct thread_options {
>         unsigned long long size;
>         unsigned long long io_size;
>         unsigned int size_percent;
> +       unsigned int io_size_percent;
>         unsigned int fill_device;
>         unsigned int file_append;
>         unsigned long long file_size_low;
> @@ -381,6 +382,7 @@ struct thread_options_pack {
>         uint64_t size;
>         uint64_t io_size;
>         uint32_t size_percent;
> +       uint32_t io_size_percent;
>         uint32_t fill_device;
>         uint32_t file_append;
>         uint32_t unique_filename;
> @@ -460,6 +462,8 @@ struct thread_options_pack {
>         struct zone_split zone_split[DDIR_RWDIR_CNT][ZONESPLIT_MAX];
>         uint32_t zone_split_nr[DDIR_RWDIR_CNT];
>
> +       uint8_t pad1[4];
> +
>         fio_fp64_t zipf_theta;
>         fio_fp64_t pareto_h;
>         fio_fp64_t gauss_dev;



-- 
Sitsofe | http://sucs.org/~sits/

