Return-Path: <jazeltq@gmail.com>
MIME-Version: 1.0
In-Reply-To: <42f4de17-7106-95de-3da9-c4f61bc541c8@kernel.dk>
References: <CAKZcxgdhYey+dbUN7T5mW=Ghfw34=OtNrocJxqDH8k4fQ1tTJw@mail.gmail.com>
 <CALjAwxjVK5v+JNo2Ww9m3cfwCyjiEMVzjdrYUpMsht2Q2j1AOA@mail.gmail.com>
 <CAKZcxgc2k=o2_kbYdFmxScxC2Zns+SKi++=rdxvwD2vGj83RZg@mail.gmail.com>
 <CAKZcxgfr_RfHD0XcDV0nMgFhU1nPNEzP0GciE-Unw-i-k3eaSw@mail.gmail.com>
 <CAKZcxgeXnostqxPAGi2ek1x+Tw7_CxrnjVzuy3QrJhwbERewnQ@mail.gmail.com>
 <CALjAwxia8JGF2uErqV3BdqLt7YTwZ=qwAKMmU2xJL1FnmcjvKg@mail.gmail.com>
 <CAKZcxgeOzDaJ5vscKZGE2vH=YqEaOwzEyS7j2o6fj0EpvV3z1A@mail.gmail.com> <42f4de17-7106-95de-3da9-c4f61bc541c8@kernel.dk>
From: Jaze Lee <jazeltq@gmail.com>
Date: Fri, 2 Dec 2016 08:10:45 +0800
Message-ID: <CAKZcxgcrkn=O+jvh6U1cvwgu_EV6dUnKANPbZTW9o8ut0UV9RQ@mail.gmail.com>
Subject: Re: fio assert
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Thanks, it works. But can u explain more about how it works?
I thought we may change stat.c.....

2016-12-01 23:12 GMT+08:00 Jens Axboe <axboe@kernel.dk>:
> On 12/01/2016 03:03 AM, Jaze Lee wrote:
>> Hello,
>>   Dose this issue can be fixed? Or the only method is to use offload
>> to workaround.
>
> Can you try the below patch? We simply need to make sure that we always
> regrow, when we enter an idle state. The logic was a little warped, the
> below is cleaner.
>
>
> diff --git a/backend.c b/backend.c
> index 8616fc2..ac71521 100644
> --- a/backend.c
> +++ b/backend.c
> @@ -441,11 +441,8 @@ static int wait_for_completions(struct thread_data *=
td, struct timeval *time)
>         int min_evts =3D 0;
>         int ret;
>
> -       if (td->flags & TD_F_REGROW_LOGS) {
> -               ret =3D io_u_quiesce(td);
> -               regrow_logs(td);
> -               return ret;
> -       }
> +       if (td->flags & TD_F_REGROW_LOGS)
> +               return io_u_quiesce(td);
>
>         /*
>          * if the queue is full, we MUST reap at least 1 event
> diff --git a/io_u.c b/io_u.c
> index 428d4b7..7420629 100644
> --- a/io_u.c
> +++ b/io_u.c
> @@ -653,6 +653,9 @@ int io_u_quiesce(struct thread_data *td)
>                         completed +=3D ret;
>         }
>
> +       if (td->flags & TD_F_REGROW_LOGS)
> +               regrow_logs(td);
> +
>         return completed;
>  }
>
>
> --
> Jens Axboe
>



--=20
=E8=B0=A6=E8=B0=A6=E5=90=9B=E5=AD=90

