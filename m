Return-Path: <axboe@kernel.dk>
Message-ID: <534DE08D.2070604@kernel.dk>
Date: Tue, 15 Apr 2014 19:44:45 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Question about FIO sequential writes
References: <CAND_vCYOVgFzN+TQv=onWG-CH2ApczsKUaToxQ-YCiuuJAUr5Q@mail.gmail.com> <534DB18A.4050507@kernel.dk> <CAND_vCbQHu4k5Q2RS5XeFYNTh5r1yC0ORYdv0JG-hHan4404kg@mail.gmail.com>
In-Reply-To: <CAND_vCbQHu4k5Q2RS5XeFYNTh5r1yC0ORYdv0JG-hHan4404kg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Xiaofei Du <xiaofei.du008@gmail.com>
Cc: fio <fio@vger.kernel.org>, aaronc <aaronc@cse.unsw.edu.au>
List-ID: <fio@vger.kernel.org>

On 2014-04-15 17:04, Xiaofei Du wrote:
> [global]
> bs=4k
> size=100m
> direct=1
> filename=100mfile
>
> [seq-write]
> rw=write
> stonewall
>
> [rand-write]
> rw=randwrite
> stonewall
>
> ########################################################################
>
> This is the output. In this run the difference is 115 vs 123. On another
> disk, the number I got was 121 vs 141. Random writes are always faster
> than sequential writes.

Since the region is only 100M, it seems reasonable to expect random IO 
within that region to be faster than sequential ones. The sequential 
ones will always be subject to a full rotational penalty, limiting your 
IOPS to 120 if we disregard software overhead, DMA, etc. So 115 seems 
very in the ballpark. For random IO, we have to move the head a bit, but 
if the seek is less than half 1/RPM, then it's a win.

So I'd say things are looking as expected.

-- 
Jens Axboe


