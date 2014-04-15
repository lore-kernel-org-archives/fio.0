Return-Path: <axboe@kernel.dk>
Message-ID: <534DB18A.4050507@kernel.dk>
Date: Tue, 15 Apr 2014 16:24:10 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Question about FIO sequential writes
References: <CAND_vCYOVgFzN+TQv=onWG-CH2ApczsKUaToxQ-YCiuuJAUr5Q@mail.gmail.com>
In-Reply-To: <CAND_vCYOVgFzN+TQv=onWG-CH2ApczsKUaToxQ-YCiuuJAUr5Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Xiaofei Du <xiaofei.du008@gmail.com>
Cc: fio@vger.kernel.org, aaronc@cse.unsw.edu.au
List-ID: <fio@vger.kernel.org>

On 2014-04-15 16:14, Xiaofei Du wrote:
> Dear Jens,
>
> I have a couple questions about FIO.
>
> First question. For default ioengine, with direct IO option enabled. On
> a hard drive with writing cache disabled. I got random writes faster
> than sequential writes. I couldn't explain this. Can you please help me
> explain if you know the reason. Could that be a bug?

How big of a difference are you seeing? Depending on the time and size 
of the seek, the random write could be faster. The sequential write in 
this case has to wait for a full revolution of the platters before the 
head is positioned correctly again. For a random write, statistically 
you would have to wait for half a revolution. But you have seek time for 
that case too, so it depends on the IO pattern.

So it might be useful to include the job you ran and the outputs.

> Second question. For libaio ioengin, with direct IO option enabled and
> on a hard drive with writing cache disabled, I could get very high IOPS
> for sequential writes if I keep increasing the iodepth. The IOPS I got
> seems unreasonable. It could go up to 16000 IOPS for 4k blocks. So is
> there anything wrong with sequential writes in FIO?

If you go to a higher depth, the OS/driver may merge sequential IO. So 
this means that fio might be issuing 4K IOs and calculating IOPS based 
on that, but further down they are coalesced and (for instance) 128 4K 
writes are submitted and completed by the drive as a single 512K write.

-- 
Jens Axboe


