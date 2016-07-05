Return-Path: <axboe@kernel.dk>
Subject: Re: Iosched_switch error
References: <CAF+0mvny52U+Z9LWaHyuEVZjem8q8X11bF6fp-qepa4Y6W8pcQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <577C15F5.2040005@kernel.dk>
Date: Tue, 5 Jul 2016 14:17:57 -0600
MIME-Version: 1.0
In-Reply-To: <CAF+0mvny52U+Z9LWaHyuEVZjem8q8X11bF6fp-qepa4Y6W8pcQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Matthew Eaton <m.eaton82@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 06/30/2016 06:05 PM, Matthew Eaton wrote:
> Hi Jens,
>
> I have run into this error when using ioscheduler=noop in my job
> files. I only run into the error when specifying unsupported devices
> such as nvme or md raid device. Should this be a fatal error? I ask
> because sometimes I want to run the same job on various devices.
>
> sudo fname=/dev/nvme0n1 ./fio seqread.ini
> seq-read: (g=0): rw=read, bs=128K-128K/128K-128K/128K-128K,
> ioengine=libaio, iodepth=32
> fio-2.12-3-g8a09
> Starting 1 process
> fio: io scheduler noop not found
> fio: pid=5541, err=22/file:backend.c:1306, func=iosched_switch,
> error=Invalid argument

IO scheduler switching can only work, if the device is using an IO 
scheduler. md/raid devices are not, and nvme is driven by blk-mq, which 
doesn't have an IO scheduler either. That's why these devices fail for you.

-- 
Jens Axboe


