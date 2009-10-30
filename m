Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pz0-f188.google.com ([209.85.222.188]:40013 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932578AbZJ3Qto convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 30 Oct 2009 12:49:44 -0400
Received: by pzk26 with SMTP id 26so2016357pzk.4
        for <fio@vger.kernel.org>; Fri, 30 Oct 2009 09:49:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f3177b9e0910300820x37a19313te12f1ca48a085c3b@mail.gmail.com>
References: <f3177b9e0910300820x37a19313te12f1ca48a085c3b@mail.gmail.com>
Date: Fri, 30 Oct 2009 10:49:48 -0600
Message-ID: <f3177b9e0910300949r62e057adqd966bca61174e035@mail.gmail.com>
Subject: Re: Every 13 hours sees a spike in fio CPU consumption, and a drop in   IOPS/throughput
From: Chris Worley <worleys@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

On Fri, Oct 30, 2009 at 9:20 AM, Chris Worley <worleys@gmail.com> wrote:
> I'm running fio benchmarks for 120 hours:
>
> fio --rw=3Drandrw --bs=3D4k --rwmixread=3D60 --numjobs=3D64 --iodepth=3D64
> --sync=3D0 --direct=3D1 --randrepeat=3D0 --ioengine=3Dlibaio
> --filename=3D/dev/sde --filename=3D/dev/sdf --name=3Dtest --loops=3D10000
> --size=3D322122547200 --runtime=3D432000 --group_reporting
>
> The fio threads are generally reporting 100K IOPS and each of the 64
> fio threads uses less than 10% CPU.
>
> But, every 13 hours (nearly to the minute), for ~200 seconds, the FIO
> threads start consuming large amounts of CPU, and the IOPS drop to
> ~40K:

Josh is brilliant:

(322122547200[bytes per test]*64[threads])/(4096[block
size]*100000[IOPS]*3600[seconds per hour])=3D13 hours

...it's restarting the next loop and recalculating the random maps
every 13 hours

Chris
>
> top - 07:36:59 up 8 days, =EF=BF=BD8:12, =EF=BF=BD0 users, =EF=BF=BDload =
average: 57.42,
> 58.54, 58.00Tasks: 352 total, =EF=BF=BD17 running, 335 sleeping, =EF=BF=
=BD 0 stopped,
> =EF=BF=BD0 zombie
> Cpu(s): =EF=BF=BD1.2%us, 14.8%sy, =EF=BF=BD0.0%ni, 72.4%id, 10.1%wa, =EF=
=BF=BD1.3%hi, =EF=BF=BD0.2%si,
> =EF=BF=BD0.0%stMem: =EF=BF=BD49449752k total, =EF=BF=BD6643996k used, 428=
05756k free,
> 205832k buffers
> Swap: =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD0k total, =EF=BF=BD =EF=BF=
=BD =EF=BF=BD =EF=BF=BD0k used, =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD0k f=
ree, =EF=BF=BD1432664k cached
> =EF=BF=BDPID USER =EF=BF=BD =EF=BF=BD =EF=BF=BDPR =EF=BF=BDNI =EF=BF=BDVI=
RT =EF=BF=BDRES =EF=BF=BDSHR S %CPU %MEM =EF=BF=BD =EF=BF=BDTIME+
> COMMAND22108 root =EF=BF=BD =EF=BF=BD =EF=BF=BD18 =EF=BF=BD 0 86144 =EF=
=BF=BD10m 9948 R 80.6 =EF=BF=BD0.0 137:55.21
> fio
> 22074 root =EF=BF=BD =EF=BF=BD =EF=BF=BD18 =EF=BF=BD 0 86144 =EF=BF=BD10m=
 9952 R 70.8 =EF=BF=BD0.0 138:07.68 fio
> 22101 root =EF=BF=BD =EF=BF=BD =EF=BF=BD18 =EF=BF=BD 0 86144 =EF=BF=BD10m=
 9952 R 61.0 =EF=BF=BD0.0 138:18.43 fio
> 22095 root =EF=BF=BD =EF=BF=BD =EF=BF=BD16 =EF=BF=BD 0 86144 =EF=BF=BD10m=
 9948 D 51.1 =EF=BF=BD0.0 137:54.02 fio
> 22134 root =EF=BF=BD =EF=BF=BD =EF=BF=BD16 =EF=BF=BD 0 86144 =EF=BF=BD10m=
 9948 R 51.1 =EF=BF=BD0.0 138:03.73 fio
> 22068 root =EF=BF=BD =EF=BF=BD =EF=BF=BD16 =EF=BF=BD 0 86144 =EF=BF=BD10m=
 9952 R 49.2 =EF=BF=BD0.0 138:04.16 fio
> 22083 root =EF=BF=BD =EF=BF=BD =EF=BF=BD16 =EF=BF=BD 0 86144 =EF=BF=BD10m=
 9952 D 45.2 =EF=BF=BD0.0 138:09.32 fio
> 22071 root =EF=BF=BD =EF=BF=BD =EF=BF=BD16 =EF=BF=BD 0 86144 =EF=BF=BD10m=
 9948 D 29.5 =EF=BF=BD0.0 137:37.75 fio
> 22128 root =EF=BF=BD =EF=BF=BD =EF=BF=BD16 =EF=BF=BD 0 86144 =EF=BF=BD10m=
 9952 D 25.6 =EF=BF=BD0.0 137:48.11 fio
> 22092 root =EF=BF=BD =EF=BF=BD =EF=BF=BD16 =EF=BF=BD 0 86144 =EF=BF=BD10m=
 9948 D 11.8 =EF=BF=BD0.0 137:54.14 fio
> 22097 root =EF=BF=BD =EF=BF=BD =EF=BF=BD16 =EF=BF=BD 0 86144 =EF=BF=BD10m=
 9948 D =EF=BF=BD9.8 =EF=BF=BD0.0 138:07.81 fio
> ...
>
> There is nothing in the system to account for this (not occurring in
> conjunction with i.e. logrotate or cron).
>
> I've repeated this with 1.21 and 1.31, on RHEL 5.3 and RHEL 5.4. =EF=BF=
=BDThe
> 1.31/RHEL5.4 case, the period was ~15 hours... this was also a slower
> machine.
>
> Any idea what's going on?
>
> Thanks,
>
> Chris
>
