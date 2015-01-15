Return-Path: <axboe@kernel.dk>
Message-ID: <54B84322.10704@kernel.dk>
Date: Thu, 15 Jan 2015 15:45:54 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Should io_limits/queue depth flushed persist while using verify_state?
References: <CALjAwxgmpWDviJiUyoXSZPy_-JP0va+QdXmhP-r6g6JTTRv7Fg@mail.gmail.com>
In-Reply-To: <CALjAwxgmpWDviJiUyoXSZPy_-JP0va+QdXmhP-r6g6JTTRv7Fg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 01/15/2015 04:01 AM, Sitsofe Wheeler wrote:
> While using fio-2.2.4 the following snippet produces a verification
> error for me on the second fio invocation:
>
> fio --bs=4k --ioengine=libaio --direct=1 --verify=meta --iodepth=128
> --io_limit=300k --verify_state_save=1 --rw=randwrite --name=write3
> --filename=/dev/dm-7 && fio --bs=4k --ioengine=libaio --direct=1
> --verify=meta --iodepth=128 --verify_state_load=1 --rw=randread
> --name=write3 --filename=/dev/dm-7
>
> However if I put the iodepth of the second fio command down to 64 or
> set io_limit the error goes away. I have also sometimes seen an error
> that looks similar if the first fio is killed via ctrl-C. Is this to
> be expected?

Doesn't reproduce here, but both cases would seem to imply that there's 
something not quite right with the completed ios in the verify state 
output. I'll take a look.

-- 
Jens Axboe


