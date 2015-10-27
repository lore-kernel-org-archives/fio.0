Return-Path: <axboe@kernel.dk>
Subject: Re: Problem on using fio replay function with fio iolog trace
References: <CAAkw5-PAt2O01H-i4WrvPaBPuMX7zPDyg8u9jS3KyA4PrNu=2A@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <562F48D6.8090603@kernel.dk>
Date: Tue, 27 Oct 2015 18:50:14 +0900
MIME-Version: 1.0
In-Reply-To: <CAAkw5-PAt2O01H-i4WrvPaBPuMX7zPDyg8u9jS3KyA4PrNu=2A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Hyukjoong Kim <wangmir@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 10/27/2015 02:33 PM, Hyukjoong Kim wrote:
> Hi,
>
> I'm trying to replay iolog using fio iolog, but i failed with that.
>
> simply, I check the example trace with write_iolog option, and I got
> trace like this,
> --------------
> fio version 2 iolog
> /mnt/test/rand-write.1.0 add
> /mnt/test/rand-write.1.0 open
> /mnt/test/rand-write.1.0 read 64757760 4096
> /mnt/test/rand-write.1.0 read 794873856 4096
> /mnt/test/rand-write.1.0 read 905355264 4096
> /mnt/test/rand-write.1.0 write 504672256 4096
> -------------
> So, I make a new trace with similar format like this
> -------------
> fio version 2 iolog
> /dev/sdb open
> /dev/sdb write 4096 4096
> ------------
> However, I failed to replay both with different error.
>
> Firstly, I ran extracted file (fio --name test --read_iolog=trace
> --replay_redirect=/dev/sdb), but error was like this,
> --------------------------------------------
> test: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=sync, iodepth=1
> fio-2.0.10
> Starting 1 process
> bad iolog2: fio version 2 iolog
> fio: pid=14839, got signal=11
>
>
> Run status group 0 (all jobs):
> --------------------------------------------
>
> and if I delete the first line than, fio said don't support iolog 1
>
>
> Secondly, I ran the file I made with same command, and error was
> different from former,
>
> ----------------------------------------
> test: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=sync, iodepth=1
> fio-2.0.10
> Starting 1 process
> fio: pid=12868, got signal=11
>
>
> Run status group 0 (all jobs):
> --------------------------------------------------
>
> I think fio was killed by someone, but I don't know why.
>
> So,, how can I fix this problem? I tried this behavior with apt
> repository fio, and current git, and fio 2.0.10 also, but error was
> same.

Are you sure you tried a recent version? I just tried your trace file 
with current git:

axboe@xps13:/home/axboe/git/fio $ ./fio --name=replay 
--read_iolog=replay.log
replay: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=sync, iodepth=1
fio-2.2.10-26-g3d57
Starting 1 process
[...]
Run status group 0 (all jobs):
    READ: io=12KB, aggrb=222KB/s, minb=222KB/s, maxb=222KB/s, 
mint=54msec, maxt=54msec
   WRITE: io=4KB, aggrb=74KB/s, minb=74KB/s, maxb=74KB/s, mint=54msec, 
maxt=54msec

and it's working fine. 2.0.10 is pretty old.

Assuming current -git, does it work without replay_redirect? Does it 
work with that option?

-- 
Jens Axboe


