Return-Path: <axboe@kernel.dk>
Message-ID: <5547D8F3.6090408@kernel.dk>
Date: Mon, 04 May 2015 14:39:15 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: achieving a workload to get specific unique duplicate blocks
References: <CABtFm2U5t2=sM4MDKhaPn7n9nsJTSBUCSUeZ=9irt8EEBTogBQ@mail.gmail.com>
In-Reply-To: <CABtFm2U5t2=sM4MDKhaPn7n9nsJTSBUCSUeZ=9irt8EEBTogBQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Srinivasa Chamarthy <chamarthy.raju@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 04/25/2015 07:03 AM, Srinivasa Chamarthy wrote:
> Firstly, thanks before in hand. :)
>
> Using FIO, what is the way to achieve a work load with specific number
> of unique blocks duplicates for specific number of times. For Example,
> i want a 252k block duplicates 1000 times and i want it to be the
> unique block in the complete workload.

If you have very specific requirements, it might be easier to simply 
write an iolog generator that spits out what you want the pattern to 
look like. Then fio can import that, and run the workload.

> Another query is that, for a blocksize of 256k does the io buffers are
> created at 256k and written to the disk and are all those 256k blocks
> unique buffer?. Can there be a change that in a 256k block, the
> smaller size buffers be the same?

That depends on the settings for compressibility, dedupability, etc. In 
general see scramble_buffers, refill_buffers, and so on. That is all in 
the man page or HOWTO.

-- 
Jens Axboe


