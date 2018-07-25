Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:40884 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729511AbeGYUQV (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 25 Jul 2018 16:16:21 -0400
Received: by mail-io0-f174.google.com with SMTP id l14-v6so7197231iob.7
        for <fio@vger.kernel.org>; Wed, 25 Jul 2018 12:03:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1532522139.3603237.1452331920.220D1ABD@webmail.messagingengine.com>
References: <1532522139.3603237.1452331920.220D1ABD@webmail.messagingengine.com>
From: Bryan Gurney <bgurney@redhat.com>
Date: Wed, 25 Jul 2018 15:03:20 -0400
Message-ID: <CAHhmqcQ3omorVzsExzzztx-q3GSK+seMR9K796GRXCoe7rsv8Q@mail.gmail.com>
Subject: Re: Understanding fio results on a new ZFS server
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Aravindh Sampathkumar <aravindh@fastmail.com>
Cc: fio@vger.kernel.org

On Wed, Jul 25, 2018 at 8:35 AM, Aravindh Sampathkumar
<aravindh@fastmail.com> wrote:
>
> Hello fio users.
>
> This is my first attempt at using fio, and I'm puzzled by the results I obtained while running fio on a ZFS server I built recently. I'm running these commands mostly out of curiosity, and just to understand what the server is capable of in a ballpark range.
>
> Here goes my naive attempts and results.
>
> Context: FreeBSD 11.2, ZFS, Compression enabled, Deduplication disabled, 120 X 10TB SAS HDD disks, no SSD caching, 768GB of DDR4 memory, 2X intel Xeon silver 4110 processors.
> All commands were run directly on the FreeBSD server.
> Running fio-3.8
>
> Test # 1:
> Use dd to create a 16 GiB file with random contents.
>
> root@delorean:/sec_stor/backup/fiotest # time dd if=/dev/random of=./test_file bs=128k count=131072
> 131072+0 records in
> 131072+0 records out
> 17179869184 bytes transferred in 137.402721 secs (125032962 bytes/sec)
> 0.031u 136.915s 2:17.40 99.6% 30+172k 4+131072io 0pf+0w
>
> This shows that I was able to create a 16GiB file with random data in 137 secs with a throughput of approx. 117 MiB/s.
>
> Test # 2:
> Use fio to perform seq_writes on a 16 GiB file with default random contents.
>
> root@delorean:/sec_stor/backup/fiotest/fio-master # ./fio --name=seqwrite --rw=write --bs=128k --numjobs=1 --size=16G --runtime=60 --iodepth=1 --group_reporting
>
> seqwrite: (g=0): rw=write, bs=(R) 128KiB-128KiB, (W) 128KiB-128KiB, (T) 128KiB-128KiB, ioengine=psync, iodepth=1
>
> fio-3.8
>
> Starting 1 process
>
> Jobs: 1 (f=1): [W(1)][100.0%][r=0KiB/s,w=2188MiB/s][r=0,w=17.5k IOPS][eta 00m:00s]
>
> seqwrite: (groupid=0, jobs=1): err= 0: pid=8693: Wed Jul 25 14:11:54 2018
>
>   write: IOPS=16.5k, BW=2065MiB/s (2165MB/s)(16.0GiB/7935msec)
>
>     clat (usec): min=18, max=17174, avg=58.18, stdev=285.68
>
>      lat (usec): min=18, max=17180, avg=59.94, stdev=285.88
>
>     clat percentiles (usec):
>
>      |  1.00th=[   23],  5.00th=[   39], 10.00th=[   41], 20.00th=[   42],
>
>      | 30.00th=[   43], 40.00th=[   44], 50.00th=[   45], 60.00th=[   47],
>
>      | 70.00th=[   51], 80.00th=[   57], 90.00th=[   73], 95.00th=[   89],
>
>      | 99.00th=[  135], 99.50th=[  165], 99.90th=[  396], 99.95th=[10421],
>
>      | 99.99th=[14877]
>
>    bw (  MiB/s): min= 1648, max= 2388, per=99.00%, avg=2044.07, stdev=218.90, samples=15
>
>    iops        : min=13185, max=19108, avg=16352.07, stdev=1751.17, samples=15
>
>   lat (usec)   : 20=0.33%, 50=67.57%, 100=28.78%, 250=3.12%, 500=0.13%
>
>   lat (usec)   : 750=0.01%, 1000=0.01%
>
>   lat (msec)   : 2=0.01%, 4=0.01%, 20=0.05%
>
>   cpu          : usr=5.08%, sys=90.27%, ctx=40602, majf=0, minf=0
>
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>
>      issued rwts: total=0,131072,0,0 short=0,0,0,0 dropped=0,0,0,0
>
>      latency   : target=0, window=0, percentile=100.00%, depth=1
>
>
> Run status group 0 (all jobs):
>
>   WRITE: bw=2065MiB/s (2165MB/s), 2065MiB/s-2065MiB/s (2165MB/s-2165MB/s), io=16.0GiB (17.2GB), run=7935-7935msec
>
> root@delorean:/sec_stor/backup/fiotest/fio-master # du -sh seqwrite.0.0                                                                                                                                  16G seqwrite.0.0
>
>
> As you can see, it hits a throughput of 2065 MiB/s.
> Question: Why such a drastic difference between dd and this?
>
> My understanding is that dd command must have used createcall to create a file, then issue open, and write calls to write the random data into the open file. Finally closethe file. I chose block size of 128 K to match with ZFS default record size.
>
> The fio test should be measuring just the write calls, but everything else, the same. Why is there so much difference in throughput?
>
> While that question is still open in mind, I ventured into testing with compressible data.
>
> Test # 3:
> Run fio with buffer_compress_percent=0 (0% compression) - My expectation is this to match the results of test #2. But, it didnt actually create 0% compressible data. More like 100% compressible data!
>
> root@delorean:/sec_stor/backup/fiotest/fio-master # ./fio --name=seqwrite --rw=write --bs=128k --numjobs=1 --size=16G --runtime=60 --iodepth=1 --buffer_compress_percentage=0 --buffer_pattern=0xdeadbeef --refill_buffers --group_reporting
>
> seqwrite: (g=0): rw=write, bs=(R) 128KiB-128KiB, (W) 128KiB-128KiB, (T) 128KiB-128KiB, ioengine=psync, iodepth=1
>
> fio-3.8
>
> Starting 1 process
>
> Jobs: 1 (f=1): [W(1)][100.0%][r=0KiB/s,w=2470MiB/s][r=0,w=19.8k IOPS][eta 00m:00s]
>
> seqwrite: (groupid=0, jobs=1): err= 0: pid=10204: Wed Jul 25 14:14:22 2018
>
>   write: IOPS=19.8k, BW=2477MiB/s (2597MB/s)(16.0GiB/6615msec)
>
>     clat (usec): min=25, max=529, avg=45.34, stdev= 7.71
>
>      lat (usec): min=25, max=532, avg=45.39, stdev= 7.73
>
>     clat percentiles (usec):
>
>      |  1.00th=[   34],  5.00th=[   39], 10.00th=[   41], 20.00th=[   42],
>
>      | 30.00th=[   42], 40.00th=[   43], 50.00th=[   44], 60.00th=[   45],
>
>      | 70.00th=[   46], 80.00th=[   49], 90.00th=[   54], 95.00th=[   59],
>
>      | 99.00th=[   71], 99.50th=[   77], 99.90th=[  106], 99.95th=[  121],
>
>      | 99.99th=[  239]
>
>    bw (  MiB/s): min= 2404, max= 2513, per=99.54%, avg=2465.45, stdev=34.80, samples=13
>
>    iops        : min=19235, max=20109, avg=19723.23, stdev=278.34, samples=13
>
>   lat (usec)   : 50=83.01%, 100=16.84%, 250=0.15%, 500=0.01%, 750=0.01%
>
>   cpu          : usr=13.09%, sys=86.82%, ctx=305, majf=0, minf=0
>
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>
>      issued rwts: total=0,131072,0,0 short=0,0,0,0 dropped=0,0,0,0
>
>      latency   : target=0, window=0, percentile=100.00%, depth=1
>
>
> Run status group 0 (all jobs):
>
>   WRITE: bw=2477MiB/s (2597MB/s), 2477MiB/s-2477MiB/s (2597MB/s-2597MB/s), io=16.0GiB (17.2GB), run=6615-6615msec
>
> root@delorean:/sec_stor/backup/fiotest/fio-master # du -sh seqwrite.0.0                                                                                                                                 1.1G seqwrite.0.0
>
>
> As you see, this test created a 1.1GiB file when I was expecting a 16 GiB file. Why? What options did I miss or specify wrong?
>
> I just couldn't stop, so I went on with another test,
>
> Test # 4:
>  Run fio with buffer_compress_percent=50 (50% compression). It looks like it did create a 50% compressible dataset. But, yielded relatively low throughput.
>
> root@delorean:/sec_stor/backup/fiotest/fio-master # ./fio --name=seqwrite --rw=write --bs=128k --numjobs=1 --size=16G --runtime=60 --iodepth=1 --buffer_compress_percentage=50 --buffer_pattern=0xdeadbeef --refill_buffers --group_reporting
>
> seqwrite: (g=0): rw=write, bs=(R) 128KiB-128KiB, (W) 128KiB-128KiB, (T) 128KiB-128KiB, ioengine=psync, iodepth=1
>
> fio-3.8
>
> Starting 1 process
>
> Jobs: 1 (f=1): [W(1)][95.7%][r=0KiB/s,w=715MiB/s][r=0,w=5721 IOPS][eta 00m:01s]
>
> seqwrite: (groupid=0, jobs=1): err= 0: pid=13543: Wed Jul 25 14:18:41 2018
>
>   write: IOPS=5729, BW=716MiB/s (751MB/s)(16.0GiB/22876msec)
>
>     clat (usec): min=26, max=1228, avg=46.59, stdev=19.26
>
>      lat (usec): min=26, max=1229, avg=46.79, stdev=19.73
>
>     clat percentiles (usec):
>
>      |  1.00th=[   35],  5.00th=[   39], 10.00th=[   40], 20.00th=[   42],
>
>      | 30.00th=[   42], 40.00th=[   43], 50.00th=[   44], 60.00th=[   44],
>
>      | 70.00th=[   45], 80.00th=[   47], 90.00th=[   52], 95.00th=[   64],
>
>      | 99.00th=[  120], 99.50th=[  153], 99.90th=[  269], 99.95th=[  359],
>
>      | 99.99th=[  627]
>
>    bw (  KiB/s): min=689820, max=748346, per=99.16%, avg=727266.49, stdev=13577.99, samples=45
>
>    iops        : min= 5389, max= 5846, avg=5681.29, stdev=106.15, samples=45
>
>   lat (usec)   : 50=88.05%, 100=10.38%, 250=1.45%, 500=0.10%, 750=0.02%
>
>   lat (usec)   : 1000=0.01%
>
>   lat (msec)   : 2=0.01%
>
>   cpu          : usr=70.79%, sys=27.64%, ctx=24546, majf=0, minf=0
>
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>
>      issued rwts: total=0,131072,0,0 short=0,0,0,0 dropped=0,0,0,0
>
>      latency   : target=0, window=0, percentile=100.00%, depth=1
>
>
> Run status group 0 (all jobs):
>
>   WRITE: bw=716MiB/s (751MB/s), 716MiB/s-716MiB/s (751MB/s-751MB/s), io=16.0GiB (17.2GB), run=22876-22876msec
>
> root@delorean:/sec_stor/backup/fiotest/fio-master # du -sh seqwrite.0.0                                                                                                                                 9.2G seqwrite.0.0
>
>
> As you see, 9.2G file seems reasonable at 50% compression. But, why 716 MiB/s when compared to test #2(no compression) - 2065 MiB/s? At 50% compression, I understand there is work for the CPUs to compress the data inline, but, would'nt that cost be negated by the reduction in amount of data to be written to disks? Is this kind of drop in throughput reasonable in the field for enabling compression?
>
> Apologies in advance if I missed anything obvious in the documentation. This is my first use of fio.
>
> Thanks,
> --
>   Aravindh Sampathkumar
>   aravindh@fastmail.com
>
>

Hi Aravindh,

I may be able to help you on your questions regarding the compression
outcomes of the fio job in Test #3.

In your original fio command, you had these parameters (separated by
newlines for clarity):

--name=seqwrite
--rw=write
--bs=128k
--numjobs=1
--size=16G
--runtime=60
--iodepth=1
--buffer_compress_percentage=0
--buffer_pattern=0xdeadbeef
--refill_buffers
--group_reporting

However, you have a three conflicting data pattern options:
"buffer_compress_percentage", "buffer_pattern", and "refill_buffers".

With all three of these parameters, you will see buffer contents that
look like this:

00000000  de ad be ef de ad be ef  de ad be ef de ad be ef  |................|
00000010  de ad be ef de ad be ef  de ad be ef de ad be ef  |................|
00000020  de ad be ef de ad be ef  de ad be ef de ad be ef  |................|
00000030  de ad be ef de ad be ef  de ad be ef de ad be ef  |................|
00000040  de ad be ef de ad be ef  de ad be ef de ad be ef  |................|
...

...and so on.  This is because the "buffer_pattern" option takes
priority over all the other options.  (However, "buffer_pattern" is
used as the "fixed pattern" data when the "buffer_compress_percentage"
value is nonzero.)

However, if you remove the "buffer_pattern" option, and run with
"buffer_compress_percentage=0" and "refill_buffers", this will result
in a 0% compressible data pattern.

A year ago, I did some research into the parameter precedence of the
data buffer pattern pararmeters, after finding some similar confusing
behavior.

I'm part of the team at Red Hat that works on Virtual Data Optimizer,
a Linux kernel module that provides thin-provisioned pools of storage
with block-level deduplication, compression, and zero-block
elimination.  VDO was originally proprietary software made by Permabit
Technology Corporation, but after Red Hat acquired Permabit on July
31, 2017, VDO was relicensed as GPL v2, and released in Red Hat
Enterprise Linux 7.5.

The in-development (i.e.: in preparation for integration with the
upstream Linux kernel) source repository for the kernel modules of VDO
are available at https://github.com/dm-vdo/kvdo , and the userspace
utilities are available at https://github.com/dm-vdo/vdo .

With the introduction out of the way, here's what I found while
testing fio (using fio 2.19 from last year, commit
c78997bf625ffcca49c18e11ab0f5448b26d7452, dated May 9 2017):

Through testing, I found that fio has three buffer modes.  With no
buffer mode options specified, the default behavior is to reuse a
relatively small buffer of random data (which I observed to be at
least 2 identical 4 KB blocks per megabyte of data).

The "scramble_buffers=1" option modifies the output of the "normal"
buffer mode with zeroes, the start time in microseconds, or a byte
offset.  However, this option will be disabled (even if specified) if
the "buffer_compress_percentage" and/or "dedupe_percentage" options
are specified (even if they are set to 0).

The "refill_buffers" option refills the buffer on every submit.  This
will be more costly than "scramble_buffers", but it will more
consistently populate the buffers with random data.  If the
"dedupe_percentage" option is specified, refill_buffers is
automatically enabled.

Therefore, if you want 0% compressible data, you should be sure to
specify the "refill_buffers" option.  (You can also specify
"buffer_compress_percentage=0" if you want, but the critical parameter
to add for 0% compression is "refill_buffers".)

If you specify a "buffer_compress_percentage" between 1 and 99, the
"scramble_buffers=1" option will automatically be disabled, if
specified.  This may result in some unwanted deduplication of data.

Specifying a "buffer_compress_percentage" value of 100 will result in
a buffer contents of all zeroes (or the contents of "buffer_pattern",
if it is specified).

(This is interesting, because the contents of "buffer_pattern" are
also used if it is specified, and "buffer_compress_percentage" is 0.)

Specifying a "dedupe_percentage" of 100 will result in a repeating random block.

Also, if you need to, don't forget to set "buffer_compress_chunk" to
the size of the compressible pattern desired.  (The default value is
512; Virtual Data Optimizer optimizes blocks at a size of 4096 bytes,
so I use "--buffer_compress_chunk=4096").

I'll be trying the new version of fio to see if the same parameter
behavior holds true.


Thanks,

Bryan Gurney
Senior Software Engineer, VDO
Red Hat
