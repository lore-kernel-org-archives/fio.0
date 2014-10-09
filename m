Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <5435460A.1040902@kernel.dk>
References: <20141008120003.6C0CC40162@lyth.info> <CANvN+em8Eit_FG_S7QXh+Meej1dvmUKCGC+tsZtCz48BwF1yrw@mail.gmail.com>
 <5435460A.1040902@kernel.dk>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Thu, 9 Oct 2014 19:20:25 +0400
Message-ID: <CANvN+e=nN=a4rBtPMEfKk802fzMZUTgc9Prt5sVE09+LpH2Gvw@mail.gmail.com>
Subject: Re: Recent changes (master)
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

And how about this one?

index 7c3a42a..12f3b36 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -165,9 +165,9 @@ static int fio_libaio_getevents(struct thread_data
*td, unsigned int min,
                        r = io_getevents(ld->aio_ctx, actual_min,
                                max, ld->aio_events + events, lt);
                }
-               if (r >= 0)
+               if (r > 0)
                        events += r;
-               else if (r == -EAGAIN) {
+               else if ((min && r == 0) || r == -EAGAIN) {
                        fio_libaio_commit(td);
                        usleep(100);
                } else if (r != -EINTR)
Regards,
Andrey


On Wed, Oct 8, 2014 at 6:11 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 10/08/2014 07:52 AM, Andrey Kuzmin wrote:
>> Recent libaio fix could be further strengthened with the following
>> addition that addresses a latent tight loop bug on zero events being
>> returned:
>>
>> index 7c3a42a..7760fb8 100644
>> --- a/engines/libaio.c
>> +++ b/engines/libaio.c
>> @@ -165,9 +165,9 @@ static int fio_libaio_getevents(struct thread_data
>> *td, unsigned int min,
>>                         r = io_getevents(ld->aio_ctx, actual_min,
>>                                 max, ld->aio_events + events, lt);
>>                 }
>> -               if (r >= 0)
>> +               if (r > 0)
>>                         events += r;
>> -               else if (r == -EAGAIN) {
>> +               else if (r == 0 || r == -EAGAIN) {
>>                         fio_libaio_commit(td);
>>                         usleep(100);
>>                 } else if (r != -EINTR)
>
> This will break min == 0 being passed in, for the opportunistic check.
> We don't want to commit/sleep for that case.
>
> --
> Jens Axboe
>

