Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <F0E1506A-A23F-4C12-B003-9860F71FC91A@linaro.org>
References: <F0E1506A-A23F-4C12-B003-9860F71FC91A@linaro.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 27 May 2018 15:24:30 +0100
Message-ID: <CALjAwxiWDecVfJsUr2eiBnL4q4nc_v+XZwjVNiOE0rKj+hc_aQ@mail.gmail.com>
Subject: Re: time_based not working with randread
Content-Type: text/plain; charset="UTF-8"
To: Paolo Valente <paolo.valente@linaro.org>
Cc: fio <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hi Paolo!

On 25 May 2018 at 20:20, Paolo Valente <paolo.valente@linaro.org> wrote:
> Hi,
> if I run this job (even with the last version GitHub version of fio) on an SSD:
> [global]
>  ioengine=sync
>  time_based=1
>  runtime=20
>  readwrite=randread
>  size=100m
>  numjobs=1
>  invalidate=1
> [job1]
>
> then, after little time (I think after 100MB have been read), fio reports a nonsensically large value for the throughput, while a simple iostat shows that no I/O is going on. By just replacing time_based with loops, i.e., with a job file like this:
>
> [global]
>  ioengine=sync
>  loops=1000
>  readwrite=randread
>  size=100m
>  numjobs=1
>  invalidate=1
> [job1]
>
> the problem disappears.

I've taken a stab at fixing this over in
https://github.com/sitsofe/fio/tree/random_reinvalidate - does that
solve the issue for you too? There's an argument that the code should
only do this loop invalidation when time_based is set and not when
td->o.file_service_type is __FIO_FSERVICE_NONUNIFORM but I kind of
wanted to keep this commit small.

Jens: any thoughts on whether we should add another if guard to ensure
we only call loop_cache_invalidate() with time_based around
https://github.com/sitsofe/fio/commit/854d8e626e7008df43640b5e08bf980fe30a6037#diff-fa5026e1991e27a64e5921f64f6cf2d6R329
?

> In a similar vein, there is no problem with sequential reads, even in time_based mode.
>
> Looks like fio re-reads the file from cache in with time_based randread.

I know I'm "Teaching grandmother to suck eggs" given that you're the
author of BFQ but just in case...

This issue happens on loops=1000 too and I believe it's down to
readahead. Basically fio is trying to invalidate the cache but said
cache is also being populated by readahead and in the end some data
ends up reused from the cache:

# modprobe null_blk completion_nsec=100000 irqmode=2
#
# ./fio --ioengine=sync --runtime=10 --size=100m
--filename=/dev/nullb0 --time_based --name=cached --rw=read --stats=0
--invalidate=1
cached: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
4096B-4096B, ioengine=sync, iodepth=1
fio-3.6-40-g854d
Starting 1 process
Jobs: 1 (f=1): [R(1)][100.0%][r=2233MiB/s,w=0KiB/s][r=572k,w=0
IOPS][eta 00m:00s]

Run status group 0 (all jobs):

Disk stats (read/write):
  nullb0: ios=266158/0, merge=0/0, ticks=26611/0, in_queue=26492, util=82.39%
# ./fio --ioengine=sync --runtime=10 --size=100m
--filename=/dev/nullb0 --time_based --name=cached --rw=read --stats=0
--invalidate=1 --fadvise=random
cached: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
4096B-4096B, ioengine=sync, iodepth=1
fio-3.6-40-g854d
Starting 1 process
Jobs: 1 (f=1): [R(1)][100.0%][r=37.3MiB/s,w=0KiB/s][r=9561,w=0
IOPS][eta 00m:00s]

Run status group 0 (all jobs):

Disk stats (read/write):
  nullb0: ios=94364/0, merge=0/0, ticks=9615/0, in_queue=9612, util=96.15%
# ./fio --ioengine=sync --runtime=10 --size=100m
--filename=/dev/nullb0 --time_based --name=cached --rw=read --stats=0
--invalidate=0
cached: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
4096B-4096B, ioengine=sync, iodepth=1
fio-3.6-40-g854d
Starting 1 process
Jobs: 1 (f=1): [R(1)][100.0%][r=3888MiB/s,w=0KiB/s][r=995k,w=0
IOPS][eta 00m:00s]

Run status group 0 (all jobs):

Disk stats (read/write):
  nullb0: ios=1208/0, merge=0/0, ticks=122/0, in_queue=121, util=0.37%
#
# echo 0 > /sys/block/nullb0/queue/read_ahead_kb
#
# ./fio --ioengine=sync --runtime=10 --size=100m
--filename=/dev/nullb0 --time_based --name=cached --rw=read --stats=0
--invalidate=1
cached: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
4096B-4096B, ioengine=sync, iodepth=1
fio-3.6-40-g854d
Starting 1 process
Jobs: 1 (f=1): [R(1)][100.0%][r=37.0MiB/s,w=0KiB/s][r=9478,w=0
IOPS][eta 00m:00s]

Run status group 0 (all jobs):

Disk stats (read/write):
  nullb0: ios=93518/0, merge=0/0, ticks=9654/0, in_queue=9653, util=96.56%
# ./fio --ioengine=sync --runtime=10 --size=100m
--filename=/dev/nullb0 --time_based --name=cached --rw=read --stats=0
--invalidate=0
cached: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
4096B-4096B, ioengine=sync, iodepth=1
fio-3.6-40-g854d
Starting 1 process
Jobs: 1 (f=1): [R(1)][100.0%][r=3894MiB/s,w=0KiB/s][r=997k,w=0
IOPS][eta 00m:00s]

Run status group 0 (all jobs):

Disk stats (read/write):
  nullb0: ios=25600/0, merge=0/0, ticks=2650/0, in_queue=2649, util=26.50%

Note: readahead (if set) can still take place even when the
ioscheduler has been set to none.

-- 
Sitsofe | http://sucs.org/~sits/

