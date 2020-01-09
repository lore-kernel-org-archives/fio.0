Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lj1-f181.google.com ([209.85.208.181]:41179 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgAIRav (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Jan 2020 12:30:51 -0500
Received: by mail-lj1-f181.google.com with SMTP id h23so8099208ljc.8
        for <fio@vger.kernel.org>; Thu, 09 Jan 2020 09:30:49 -0800 (PST)
MIME-Version: 1.0
References: <CA+zhgFSVYMYkDeGEc1Tn3yEy24PgmFRiKABcCQkuEByMuLsnsQ@mail.gmail.com>
 <CALjAwxg+OKr3co5K++St1B=EdztytsDbhWUhNe6Bjz0Vg2uVQw@mail.gmail.com>
In-Reply-To: <CALjAwxg+OKr3co5K++St1B=EdztytsDbhWUhNe6Bjz0Vg2uVQw@mail.gmail.com>
From: smitha sunder <sundersmitha@gmail.com>
Date: Thu, 9 Jan 2020 09:30:37 -0800
Message-ID: <CA+zhgFRV0LcX+jZOGgjkfc+5v0iwk=C+hVEoP9e1hnTQEMa2vQ@mail.gmail.com>
Subject: Re: 4KiB + 64 B formatted drive : Invalid or incomplete multibyte or
 wide character: write offset=4096, buflen=4096
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

On Wed, Jan 8, 2020 at 11:41 PM Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>
> On Wed, 8 Jan 2020 at 19:19, smitha sunder <sundersmitha@gmail.com> wrote:
> >
> > How ever if I format the drive with LBAF type 4 that is supported by
> > the drive, then I get the following error :
> >
> > # nvme format /dev/nvme1 --namespace-id=1 --lbaf=4   --pi=1 --ms=0
> > Success formatting namespace:1
> > #  nvme list
> > Node             SN                   Model
> >         Namespace Usage                      Format           FW Rev
> > ---------------- --------------------
> > ---------------------------------------- ---------
> > -------------------------- ---------------- --------
> > /dev/nvme0n1     160401RICHC01        PM1733V4TLC
> >         1           1.92  TB /   1.92  TB      4 KiB + 64 B   TEMC8881
> > /dev/nvme1n1     160401RICHC01        PM1733V4TLC
> >         1           1.92  TB /   1.92  TB      4 KiB + 64 B   TEMC8881
> >
> >
> > # fio --filename=/dev/nvme0n1 --size=1M --rw=write --ioengine=libaio
> > --direct=1 --verify=crc32 --verify_dump=1 --name=test --bs=4096
> > test: (g=0): rw=write, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
> > 4096B-4096B, ioengine=libaio, iodepth=1
> > fio-3.7
> > Starting 1 process
> > fio: io_u error on file /dev/nvme0n1: Invalid or incomplete multibyte
> > or wide character: write offset=4096, buflen=4096
> > fio: pid=32709, err=84/file:io_u.c:1747, func=io_u error,
> > error=Invalid or incomplete multibyte or wide character
>
> [...]
>
> > Am I missing something?
> > Thanks for the help !
>
> All fio is saying is that it didn't get back the data that it wrote
> down on the second block but I don't know what using "LBAF type 4"
> might do to your disk (you are saying it changes the logical block
> size but does it change anything else?).  Do you don't have anything
> else that might be writing to that the device too and might have
> interfered with the data? What happens if you add --offset=1M?
>
> --
> Sitsofe | http://sucs.org/~sits/

Thanks Sitsofe for your reply and your time.

The drive supports various LBA formats :

LBA Format  0 : Metadata Size: 0   bytes - Data Size: 512 bytes -
Relative Performance: 0x1 Better
LBA Format  1 : Metadata Size: 8   bytes - Data Size: 512 bytes -
Relative Performance: 0x2 Good
LBA Format  2 : Metadata Size: 0   bytes - Data Size: 4096 bytes -
Relative Performance: 0 Best
LBA Format  3 : Metadata Size: 8   bytes - Data Size: 4096 bytes -
Relative Performance: 0x2 Good (in use)
LBA Format  4 : Metadata Size: 64  bytes - Data Size: 4096 bytes -
Relative Performance: 0x2 Good

So LBAF 4 is 4K formmated with 64B metadata

Nothing else is running on the device.
The error is seen even if I issue offset=1M or 50% etc.

# fio --filename=/dev/nvme0n1  --rw=write --ioengine=libaio --direct=1
--verify=crc32 --verify_dump=1 --name=test --bs=4096 --offset=1M
test: (g=0): rw=write, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
4096B-4096B, ioengine=libaio, iodepth=1
fio-3.7
Starting 1 process
fio: io_u error on file /dev/nvme0n1: Invalid or incomplete multibyte
or wide character: write offset=1048576, buflen=4096
test: No I/O performed by libaio, perhaps try --debug=io option for details?
fio: pid=3392, err=84/file:io_u.c:1747, func=io_u error, error=Invalid
or incomplete multibyte or wide character

test: (groupid=0, jobs=1): err=84 (file:io_u.c:1747, func=io_u error,
error=Invalid or incomplete multibyte or wide character): pid=3392:
Thu Jan  9 09:28:24 2020
  cpu          : usr=0.00%, sys=0.00%, ctx=1, majf=0, minf=21
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=50.0%, 4=50.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,1,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):

Disk stats (read/write):
  nvme0n1: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%

If I format the drive to 1KiB+8B metadata then fio runs fine :
# nvme list
Node             SN                   Model
        Namespace Usage                      Format           FW Rev
---------------- --------------------
---------------------------------------- ---------
-------------------------- ---------------- --------
/dev/nvme0n1     160401RICHC01        PM1733V4TLC
        1           1.92  TB /   1.92  TB      4 KiB +  8 B   TEMC8881
/dev/nvme1n1     160401RICHC01        PM1733V4TLC
        1           1.92  TB /   1.92  TB      4 KiB +  8 B   TEMC8881
# fio --filename=/dev/nvme0n1  --rw=write --ioengine=libaio --direct=1
--verify=crc32 --verify_dump=1 --name=test --bs=4096 --offset=1M
--size=1G
test: (g=0): rw=write, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
4096B-4096B, ioengine=libaio, iodepth=1
fio-3.7
Starting 1 process
Jobs: 1 (f=1): [V(1)][100.0%][r=43.5MiB/s,w=0KiB/s][r=11.1k,w=0
IOPS][eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=3486: Thu Jan  9 09:30:19 2020
   read: IOPS=11.2k, BW=43.6MiB/s (45.7MB/s)(1024MiB/23485msec)
    slat (nsec): min=1496, max=5603.7k, avg=1745.06, stdev=11027.69
    clat (usec): min=35, max=517, avg=78.56, stdev=13.52
     lat (usec): min=37, max=5672, avg=80.33, stdev=17.43
    clat percentiles (usec):
     |  1.00th=[   63],  5.00th=[   73], 10.00th=[   73], 20.00th=[   73],
     | 30.00th=[   74], 40.00th=[   75], 50.00th=[   75], 60.00th=[   75],
     | 70.00th=[   89], 80.00th=[   89], 90.00th=[   90], 95.00th=[   90],
     | 99.00th=[   90], 99.50th=[   91], 99.90th=[  347], 99.95th=[  375],
     | 99.99th=[  400]
  write: IOPS=27.2k, BW=106MiB/s (112MB/s)(1024MiB/9625msec)
    slat (nsec): min=11232, max=68549, avg=12131.36, stdev=469.35
    clat (usec): min=18, max=372, avg=24.25, stdev= 4.91
     lat (usec): min=29, max=384, avg=36.41, stdev= 4.95
    clat percentiles (nsec):
     |  1.00th=[20352],  5.00th=[20352], 10.00th=[20608], 20.00th=[21120],
     | 30.00th=[22144], 40.00th=[22144], 50.00th=[22400], 60.00th=[22656],
     | 70.00th=[23168], 80.00th=[24448], 90.00th=[33536], 95.00th=[34048],
     | 99.00th=[36096], 99.50th=[38656], 99.90th=[48384], 99.95th=[54016],
     | 99.99th=[74240]
   bw (  KiB/s): min=28447, max=114880, per=96.25%, avg=104854.35,
stdev=18105.13, samples=20
   iops        : min= 7111, max=28720, avg=26213.65, stdev=4526.47, samples=20
  lat (usec)   : 20=0.01%, 50=50.05%, 100=49.86%, 250=0.01%, 500=0.07%
  lat (usec)   : 750=0.01%
  cpu          : usr=17.96%, sys=3.42%, ctx=524342, majf=0, minf=6158
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=262144,262144,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: bw=43.6MiB/s (45.7MB/s), 43.6MiB/s-43.6MiB/s
(45.7MB/s-45.7MB/s), io=1024MiB (1074MB), run=23485-23485msec
  WRITE: bw=106MiB/s (112MB/s), 106MiB/s-106MiB/s (112MB/s-112MB/s),
io=1024MiB (1074MB), run=9625-9625msec

Disk stats (read/write):
  nvme0n1: ios=262222/262144, merge=0/0, ticks=19871/6270, in_queue=0,
util=99.61%

Thanks
smitha

