Return-Path: <axboe@kernel.dk>
Subject: Re: inflated bandwidth numbers with buffered I/O
References: <CAE9DZUTFeBgZi+sP28RgVpmiVVYyrRj1K2pSZazVjiyQXQeg8g@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56991407.1020809@kernel.dk>
Date: Fri, 15 Jan 2016 08:45:11 -0700
MIME-Version: 1.0
In-Reply-To: <CAE9DZUTFeBgZi+sP28RgVpmiVVYyrRj1K2pSZazVjiyQXQeg8g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Dallas Clement <dallas.a.clement@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 01/14/2016 04:28 PM, Dallas Clement wrote:
> Hi, I hope it's ok to ask usage questions on this mailing list.
>
> I have been using fio version 2.2.4 on a Fedora 22 server host to test
> throughput on a 10 GigE LIO iSCSI block device.  Up until this point I
> have been testing with Direct I/O (direct=1) and writing directly to
> the block device with filename=/dev/blah (no filesystem).  I am seeing
> bandwidth measurements that look reasonable.  I next tried to repeat
> this test with Buffered I/O (direct=0) and the bandwidth numbers are
> way too large.  Here is a comparison of the sequential write results
> for various block sizes:
>
> bs=4k => direct=95.945 MB/s, buffered=1475.4 MB/s
> bs=512 => direct=495.328 MB/s, buffered=2637.333 MB/s
> bs=2048 => direct=502.093 MB/s, buffered=2663.772 MB/s
>
> As you can see the buffered bandwidth measurements are much larger and
> don't make sense given that not more than 1200 MB/s can be transmitted
> over a 10 Gbps network connection.
>
> Now it's very likely I am doing something stupid and lack
> understanding about how fio works.  Someone please enlighten me!
>
> Here is the script I have been using to collect my results for buffered I/O
>
> #!/bin/bash
>
> JOB_FILE=job.fio
>
> cat << EOF > ${JOB_FILE}
> [job]
> ioengine=libaio
> iodepth=\${DEPTH}
> prio=0
> rw=\${RW}
> bs=\${BS}
> filename=/dev/sdc
> numjobs=1
> size=10g
> direct=0
> invalidate=0
> ramp_time=15
> runtime=120
> time_based
> write_bw_log=\${RW}-bs-\${BS}-depth-\${DEPTH}
> write_lat_log=\${RW}-bs-\${BS}-depth-\${DEPTH}
> write_iops_log=\${RW}-bs-\${BS}-depth-\${DEPTH}
> EOF
>
> for RW in read write randread randwrite
> do
>    for BS in 4k 512k 2048k
>    do
>      for DEPTH in 4 32 256
>      do
>        RW=${RW} BS=${BS} DEPTH=${DEPTH} fio ${JOB_FILE}
>      done
>    done
> done
>
> I have also tried running this script without the filename=blah
> setting on an XFS formatted block device.  I am still seeing inflated
> numbers for this also.

buffered IO is, well, buffered. So if you don't include any kind of 
sync'ing, then you are merely measuring how long it took you to dirty 
the amount of memory specified. You can set end_fsync=1 and fio will do 
an fsync at the end of the job run. Or you can sprinkle fsync/fdatasync 
to sync for every X blocks. Or you can set sync=1, which would open the 
device O_SYNC.

axboe@xps13:/home/axboe/git/fio $ ./fio --cmdhelp|grep sync
fsync                   : Issue fsync for writes every given number of 
blocks
fdatasync               : Issue fdatasync for writes every given number 
of blocks
sync_file_range         : Use sync_file_range()
   sync                  : Use O_SYNC for buffered writes
   verify_async          : Number of async verifier threads to use
create_fsync            : fsync file after creation
end_fsync               : Include fsync at the end of job
fsync_on_close          : fsync files on close


-- 
Jens Axboe


