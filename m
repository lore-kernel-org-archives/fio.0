Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:34553 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425904AbdDUUHU (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Apr 2017 16:07:20 -0400
Received: by mail-ua0-f174.google.com with SMTP id h2so87821200uaa.1
        for <fio@vger.kernel.org>; Fri, 21 Apr 2017 13:07:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <000501d2ba6e$6d308170$47918450$@citigo.com.vn>
References: <000001d2ba42$3546dc90$9fd495b0$@citigo.com.vn>
 <CABtFm2W3cL2f96xpHERD-7E-7509Hn6E3F_kVhNBfy=19PbNgw@mail.gmail.com>
 <000201d2ba62$d6900610$83b01230$@citigo.com.vn> <CALjAwxjOc-hrLqgGatLKftxjK0GfonpHqG6Y_jL+W2pmrYA4dg@mail.gmail.com>
 <000501d2ba6e$6d308170$47918450$@citigo.com.vn>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 21 Apr 2017 21:06:49 +0100
Message-ID: <CALjAwxheMdwbdVQ1J6y6DBbUo8Dq-Yqy=8UJ2TTmisMtSZ9a8Q@mail.gmail.com>
Subject: Re: Does fio really bypass page cache with option direct=1?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Son Chu <son.ct@citigo.com.vn>
Cc: Srinivasa Chamarthy <chamarthy.raju@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 21 April 2017 at 08:10, Son Chu <son.ct@citigo.com.vn> wrote:
>
> Here is my dd command:
> dd if=3D/dev/zero of=3D/opt/laptop.bin bs=3D1G count=3D5 oflag=3Ddirect

That comparison isn't really apples to apples comparison of what fio
has to do because you got dd to send a giant block block down and made
the kernel split it up into little pieces.

> The file system of /opt is XFS:
> [root@localhost opt]# df -T | awk '{print $1,$2,$NF}' | grep "^/dev"
> /dev/mapper/cl-root xfs /
> /dev/sda1 xfs /boot
>
> And this is virtual machine on my dektop so I just use it to test fio too=
l only and there is no read/write running process. And I don=E2=80=99t thin=
k there is no problem between virtual machine and physical machine.
>
> I have also tested on 1 VM where I  hosted using Virtuozzo. The page cach=
e still increase.

I can't reproduce your results. Here's a quick run where I use the
vmtouch tool (vmtouch comes from https://github.com/hoytech/vmtouch )
to check what's in cache (the wrapping may be bad but it should give a
general overview):
$ dd if=3D/dev/zero of=3D/tmp/fiotest bs=3D4K count=3D2560; ~/vmtouch/vmtou=
ch
/tmp/fiotest
2560+0 records in
2560+0 records out
10485760 bytes (10 MB, 10 MiB) copied, 0.0128309 s, 817 MB/s
           Files: 1
     Directories: 0
  Resident Pages: 2560/2560  10M/10M  100%
         Elapsed: 0.00035 seconds
$ dd if=3D/dev/zero of=3D/tmp/fiotest bs=3D4K count=3D2560 oflag=3Ddirect;
~/vmtouch/vmtouch /tmp/fiotest
2560+0 records in
2560+0 records out
10485760 bytes (10 MB, 10 MiB) copied, 0.592612 s, 17.7 MB/s
           Files: 1
     Directories: 0
  Resident Pages: 0/2560  0/10M  0%
         Elapsed: 0.000195 seconds
$ ~/fio/fio --size=3D10M --filename=3D/tmp/fiotest --sync=3D1 --rw=3Drandrw
--bs=3D4k --numjobs=3D1 --iodepth=3D8 --runtime=3D10 --time_based
--group_reporting --name=3Djournal-test --invalidate=3D1 --gtod_reduce=3D1
--ioengine=3Dlibaio; ~/vmtouch/vmtouch /tmp/fiotest
journal-test: (g=3D0): rw=3Drandrw, bs=3D(R) 4096B-4096B, (W) 4096B-4096B,
(T) 4096B-4096B, ioengine=3Dlibaio, iodepth=3D8
fio-2.19
Starting 1 process
Jobs: 1 (f=3D1): [m(1)][100.0%][r=3D136KiB/s,w=3D132KiB/s][r=3D34,w=3D33
IOPS][eta 00m:00s]
journal-test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D42838: Fri Apr 21 19=
:32:32 2017
   read: IOPS=3D30, BW=3D124KiB/s (127kB/s)(1244KiB/10061msec)
  write: IOPS=3D32, BW=3D130KiB/s (133kB/s)(1308KiB/10061msec)
  cpu          : usr=3D0.12%, sys=3D0.36%, ctx=3D968, majf=3D0, minf=3D10
  IO depths    : 1=3D0.2%, 2=3D0.3%, 4=3D0.6%, 8=3D98.9%, 16=3D0.0%, 32=3D0=
.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D99.8%, 8=3D0.2%, 16=3D0.0%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
     issued rwt: total=3D311,327,0, short=3D0,0,0, dropped=3D0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D8

Run status group 0 (all jobs):
   READ: bw=3D124KiB/s (127kB/s), 124KiB/s-124KiB/s (127kB/s-127kB/s),
io=3D1244KiB (1274kB), run=3D10061-10061msec
  WRITE: bw=3D130KiB/s (133kB/s), 130KiB/s-130KiB/s (133kB/s-133kB/s),
io=3D1308KiB (1339kB), run=3D10061-10061msec

Disk stats (read/write):
  sda: ios=3D310/968, merge=3D0/323, ticks=3D2084/7648, in_queue=3D9808, ut=
il=3D98.28%
           Files: 1
     Directories: 0
  Resident Pages: 638/2560  2M/10M  24.9%
         Elapsed: 0.000354 seconds
$ ~/fio/fio --size=3D10M --filename=3D/tmp/fiotest --direct=3D1 --sync=3D1
--rw=3Drandrw --bs=3D4k --numjobs=3D1 --iodepth=3D8 --runtime=3D10 --time_b=
ased
--group_reporting --name=3Djournal-test --invalidate=3D1 --gtod_reduce=3D1
--ioengine=3Dlibaio; ~/vmtouch/vmtouch /tmp/fiotest
journal-test: (g=3D0): rw=3Drandrw, bs=3D(R) 4096B-4096B, (W) 4096B-4096B,
(T) 4096B-4096B, ioengine=3Dlibaio, iodepth=3D8
fio-2.19
Starting 1 process
Jobs: 1 (f=3D1): [m(1)][100.0%][r=3D316KiB/s,w=3D296KiB/s][r=3D79,w=3D74
IOPS][eta 00m:00s]
journal-test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D42842: Fri Apr 21 19=
:33:21 2017
   read: IOPS=3D64, BW=3D260KiB/s (266kB/s)(2680KiB/10308msec)
  write: IOPS=3D65, BW=3D261KiB/s (267kB/s)(2688KiB/10308msec)
  cpu          : usr=3D0.00%, sys=3D0.47%, ctx=3D934, majf=3D0, minf=3D9
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.3%, 8=3D99.5%, 16=3D0.0%, 32=3D0=
.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D99.9%, 8=3D0.1%, 16=3D0.0%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
     issued rwt: total=3D670,672,0, short=3D0,0,0, dropped=3D0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D8

Run status group 0 (all jobs):
   READ: bw=3D260KiB/s (266kB/s), 260KiB/s-260KiB/s (266kB/s-266kB/s),
io=3D2680KiB (2744kB), run=3D10308-10308msec
  WRITE: bw=3D261KiB/s (267kB/s), 261KiB/s-261KiB/s (267kB/s-267kB/s),
io=3D2688KiB (2753kB), run=3D10308-10308msec

Disk stats (read/write):
  sda: ios=3D656/992, merge=3D0/167, ticks=3D10436/15916, in_queue=3D26376,=
 util=3D99.13%
           Files: 1
     Directories: 0
  Resident Pages: 0/2560  0/10M  0%
         Elapsed: 0.000192 seconds

/tmp is on an ext4 filesystem. Without direct I/O some or all of the
file is cached when the I/O finishes. With direct I/O, none of the
file is cached by the end so I'd say fio is correctly bypassing the
cache.

However it's worth noting that while fio is running it will allocate
shared memory (viewable with ipcs shm while fio is running) so it
would be worth sending a follow up email saying whether that explains
where the page cache memory went.

--=20
Sitsofe | http://sucs.org/~sits/
