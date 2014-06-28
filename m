Return-Path: <axboe@kernel.dk>
Message-ID: <53AE26F4.9050808@kernel.dk>
Date: Fri, 27 Jun 2014 20:22:44 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: A typo in io_u.c::get_next_file()?
References: <CANvN+ekEc4AW+0WcC2YwmJdXA4WO_APSqPQkhq5oexOdrD+UXw@mail.gmail.com>
In-Reply-To: <CANvN+ekEc4AW+0WcC2YwmJdXA4WO_APSqPQkhq5oexOdrD+UXw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-06-27 18:54, Andrey Kuzmin wrote:
> diff --git a/io_u.c b/io_u.c
> index e132fd9..f487b0a 100644
> --- a/io_u.c
> +++ b/io_u.c
> @@ -1100,7 +1100,7 @@ out:
>
>   static struct fio_file *get_next_file(struct thread_data *td)
>   {
> -       if (!(td->flags & TD_F_PROFILE_OPS)) {
> +       if ((td->flags & TD_F_PROFILE_OPS)) {
>                  struct prof_io_ops *ops = &td->prof_io_ops;
>
>                  if (ops->get_next_file)

Hah indeed, good catch! I was wondering why it would not segfault, but I 
guess we fall through normally anyway. So it only impacts profiles that 
have get_next_file set, which makes it a minor issue.

Thanks for the patch! Applied.

-- 
Jens Axboe


