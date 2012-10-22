Return-Path: <yufei.ren@stonybrook.edu>
MIME-Version: 1.0
In-Reply-To: <5084FE8B.6090608@kernel.dk>
References: <1350702712-5168-1-git-send-email-yufei.ren@stonybrook.edu>
 <1350702712-5168-4-git-send-email-yufei.ren@stonybrook.edu> <5084FE8B.6090608@kernel.dk>
From: Yufei Ren <yufei.ren@stonybrook.edu>
Date: Mon, 22 Oct 2012 14:39:04 -0400
Message-ID: <CAG5pYQdJ8oZZhazrJEED+zu9bR4zJ6h_G=wTnG3MF0mJeDgegQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] rdma ioengine improvement
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Mon, Oct 22, 2012 at 4:06 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2012-10-20 05:11, Yufei Ren wrote:
>> From: Yufei Ren <renyufei83@gmail.com>
>
> This one needs a bit of explaining. What is the point of using a
> re-entrant variant of rand(), if you are using a shared static variable
> anyway?
>

It's my buggy :-)

> Would it be better to use the fio shipped rand, now we're in there
> anyway?
>

Thanks for remind me the fio shipped rand. Let me send you another patch.

>> @@ -790,6 +792,13 @@ static int fio_rdmaio_connect(struct thread_data *td, struct fio_file *f)
>>       /* wait for remote MR info from server side */
>>       rdma_poll_wait(td, IBV_WC_RECV);
>>
>> +     /* In SEND/RECV test, iodepth in RECV side is deeper
>> +      * in SEND side. RECV needs more time to construct the
>> +      * buffer blocks, so the server side may need to stop
                                                   ~~~~~~~~~ should be SEND side
>> +      * some time before transfer data.
>> +      */
>> +     usleep(500000);
>> +
>>       return 0;
>
> Hmm?

After rdma connection(queue pair) established, data source and data
sink commit data blocks into send queue and receive queue,
respectively. If data source posts so many io requests that over the
capacity of the receiver queue. Receiver Not Ready (RNR) error comes
out. To avoid this, it's better that data source waits for some time
until data sink posts sufficient number of recv buffers into recv
queue.

Maybe it is a better way to add a `receiver ready notification' from
the sink to the source for addressing this problem.

Anyway, I will send you another patch with clear comments.

>
> --
> Jens Axboe
>

