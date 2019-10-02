Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f52.google.com ([209.85.221.52]:34700 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfJBAkW (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 1 Oct 2019 20:40:22 -0400
Received: by mail-wr1-f52.google.com with SMTP id a11so17567834wrx.1
        for <fio@vger.kernel.org>; Tue, 01 Oct 2019 17:40:19 -0700 (PDT)
MIME-Version: 1.0
References: <CABO+gV-fpuOi6u8w8-L5G+sZ7KhvPy9SC3hqXh+q6PReVTxbCA@mail.gmail.com>
 <CALjAwxi3L-N1-fW5PNJbMU0SjY6G2eRXrL4=5Z7egL3w=apPcQ@mail.gmail.com>
 <CABO+gV-uxLsURnoVBS1QcPPadwBVL2rm1Fo1OeG_PHB_0E16eQ@mail.gmail.com> <CALjAwxi+Lpzm3yn-nZSaj+zZB8Bjn8=9gCAkP1yqkiBS8_bm6w@mail.gmail.com>
In-Reply-To: <CALjAwxi+Lpzm3yn-nZSaj+zZB8Bjn8=9gCAkP1yqkiBS8_bm6w@mail.gmail.com>
From: Elliott Balsley <elliott@altsystems.com>
Date: Tue, 1 Oct 2019 17:40:08 -0700
Message-ID: <CABO+gV9bnpokx2QstPLHoErR3N876YtuVuFDsKznqmEQ3K8TAg@mail.gmail.com>
Subject: Re: Disk slows down while empting write buffer
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

> Again my recommendation would be to do I/O against the raw block
> device representing the RAID (or an individual disk)

I didn't know fio could write to a block device.  Or do you mean with dd?

I'm still investigating the original question, but now I notice
something odd about fio.  When writing a single file, I would expect
end_fsync to function the same way as fsync_on_close.  But the latter
option displays a much higher bandwidth at the end of the test.  In
both cases, iostat activity is relatively constant the entire time,
about 230MBps.  In both cases, fio displays the correct speed during
the test, and then shows 0KBps during fsync at the end.  It seems like
these two options have a different way of averaging the write and sync
speeds.  Full output of both commands below.  I'm running on FreeBSD
(FreeNAS 11.2), writing to a single disk vdev on ZFS.

root@freenas ~ # fio --name=larry --rw=write --bs=1M --size=10G
--directory=/single --fsync_on_close=1
larry: (g=0): rw=write, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB,
(T) 1024KiB-1024KiB, ioengine=psync, iodepth=1
fio-3.5
Starting 1 process
Jobs: 1 (f=1): [f(1)][100.0%][r=0KiB/s,w=0KiB/s][r=0,w=0 IOPS][eta 00m:00s]
larry: (groupid=0, jobs=1): err= 0: pid=17944: Tue Oct  1 17:30:20 2019
  write: IOPS=372, BW=372MiB/s (390MB/s)(10.0GiB/27501msec)
    clat (usec): min=236, max=245025, avg=2662.75, stdev=3163.75
     lat (usec): min=246, max=245057, avg=2683.97, stdev=3167.04
    clat percentiles (usec):
     |  1.00th=[  243],  5.00th=[  247], 10.00th=[  249], 20.00th=[  258],
     | 30.00th=[  766], 40.00th=[  799], 50.00th=[ 3785], 60.00th=[ 4047],
     | 70.00th=[ 4293], 80.00th=[ 4490], 90.00th=[ 4752], 95.00th=[ 4948],
     | 99.00th=[ 5407], 99.50th=[ 5669], 99.90th=[12518], 99.95th=[20841],
     | 99.99th=[38011]
   bw (  KiB/s): min=159244, max=3863272, per=100.00%, avg=381324.09,
stdev=584042.66, samples=54
   iops        : min=  155, max= 3772, avg=372.00, stdev=570.30, samples=54
  lat (usec)   : 250=12.21%, 500=12.47%, 750=2.94%, 1000=16.71%
  lat (msec)   : 2=0.41%, 4=12.44%, 10=42.67%, 20=0.09%, 50=0.06%
  lat (msec)   : 250=0.01%
  cpu          : usr=0.92%, sys=10.81%, ctx=67434, majf=0, minf=0
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,10240,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: bw=372MiB/s (390MB/s), 372MiB/s-372MiB/s (390MB/s-390MB/s),
io=10.0GiB (10.7GB), run=27501-27501msec
root@freenas ~ # fio --name=larry --rw=write --bs=1M --size=10G
--directory=/single --end_fsync=1
larry: (g=0): rw=write, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB,
(T) 1024KiB-1024KiB, ioengine=psync, iodepth=1
fio-3.5
Starting 1 process
Jobs: 1 (f=1): [F(1)][100.0%][r=0KiB/s,w=0KiB/s][r=0,w=0 IOPS][eta 00m:00s]
larry: (groupid=0, jobs=1): err= 0: pid=18136: Tue Oct  1 17:31:34 2019
  write: IOPS=158, BW=158MiB/s (166MB/s)(10.0GiB/64645msec)
    clat (usec): min=238, max=273565, avg=2680.80, stdev=3750.63
     lat (usec): min=246, max=273580, avg=2701.70, stdev=3753.46
    clat percentiles (usec):
     |  1.00th=[   243],  5.00th=[   247], 10.00th=[   249], 20.00th=[   258],
     | 30.00th=[   766], 40.00th=[   799], 50.00th=[  3752], 60.00th=[  4047],
     | 70.00th=[  4293], 80.00th=[  4490], 90.00th=[  4752], 95.00th=[  4948],
     | 99.00th=[  5342], 99.50th=[  5604], 99.90th=[ 13566], 99.95th=[ 29492],
     | 99.99th=[164627]
   bw (  KiB/s): min=53141, max=3875850, per=100.00%, avg=376190.78,
stdev=577953.67, samples=55
   iops        : min=   51, max= 3785, avg=366.98, stdev=564.45, samples=55
  lat (usec)   : 250=11.87%, 500=12.82%, 750=2.62%, 1000=16.95%
  lat (msec)   : 2=0.41%, 4=13.14%, 10=42.04%, 20=0.07%, 50=0.06%
  lat (msec)   : 250=0.01%, 500=0.01%
  cpu          : usr=0.36%, sys=5.34%, ctx=100156, majf=0, minf=0
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,10240,0,1 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: bw=158MiB/s (166MB/s), 158MiB/s-158MiB/s (166MB/s-166MB/s),
io=10.0GiB (10.7GB), run=64645-64645msec

