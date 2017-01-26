Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38828 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753855AbdAZRwt (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 26 Jan 2017 12:52:49 -0500
Received: by mail-wm0-f44.google.com with SMTP id r144so97160104wme.1
        for <fio@vger.kernel.org>; Thu, 26 Jan 2017 09:52:48 -0800 (PST)
Subject: Re: 4x lower IOPS: Linux MD vs indiv. devices - why?
References: <90865544-f790-513c-97df-7e6a6af20ca8@gmail.com>
 <061acabe-dbd0-ae07-cd69-772eccd15b21@gmail.com>
 <CANvN+em0cjWRnQWccdORKFEJk0OSeQOrZq+XE6kzPmqMPB--4g@mail.gmail.com>
 <49ef9d71-8e52-26e4-76f7-ea03fb331a38@gmail.com>
 <CALjAwxjmW-NgWEcH7+nKNN8U_oUxFoYa23dui9wM6WDqiShWhw@mail.gmail.com>
 <15418080-0bf6-ab40-c05f-69a3fb3d9cc3@gmail.com>
 <CALjAwxhsvfH0-D=4U6nkjFg109Z1ZgVRsOx37X+Lb-EqTf_jOA@mail.gmail.com>
 <6b2cacaf-2946-6046-51c2-b909c6ee0784@gmail.com>
 <CANvN+emLjb9idri9r42V3W9ia6v0EDGdJYFfhzq6rAuzGWec8Q@mail.gmail.com>
 <CANvN+emJBzMeUmjBw5PBSZc66LmjG8-Pz+39dBeL5GseMCdo6g@mail.gmail.com>
 <fca1cdb1-aa66-b21f-d1a0-029ba895d3f2@gmail.com>
 <CANvN+emQ0AYPgT0e6KMKphDTZAY=cW6FyroLw=smReHGpd-=TA@mail.gmail.com>
 <a0dc59e7-9c81-ab5d-45b6-d1d252179837@gmail.com>
 <CANvN+e=qsexdU6Pp4kKQXy-jQKixZhR-WWLQb=713NNAA0ziVg@mail.gmail.com>
 <68e44114-5d14-a714-09a6-d80358d10118@gmail.com>
 <DF4PR84MB0169A885870EDAED7BDB0C23AB740@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
From: Tobias Oberstein <tobias.oberstein@gmail.com>
Message-ID: <63ff7c63-2069-20d2-c177-ac3122fb4cd9@gmail.com>
Date: Thu, 26 Jan 2017 18:52:45 +0100
MIME-Version: 1.0
In-Reply-To: <DF4PR84MB0169A885870EDAED7BDB0C23AB740@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "Jens.Wilke@parcIT.de" <jens.wilke@parcit.de>

Hi Robert,

Am 25.01.2017 um 17:23 schrieb Elliott, Robert (Persistent Memory):
>
>
>> -----Original Message-----
>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
>> Behalf Of Tobias Oberstein
>> Sent: Tuesday, January 24, 2017 4:52 PM
>> To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
>> Cc: fio@vger.kernel.org; Jens Axboe <axboe@kernel.dk>
>> Subject: Re: 4x lower IOPS: Linux MD vs indiv. devices - why?
>>
>> However, during my tests, I get this in kernel log:
>>
>> [459346.155564] NMI watchdog: BUG: soft lockup - CPU#46 stuck for
>> 22s!
>> [swapper/46:0]
>> [461040.530959] NMI watchdog: BUG: soft lockup - CPU#26 stuck for
>> 22s!
>> [swapper/26:0]
>> [461044.279081] NMI watchdog: BUG: soft lockup - CPU#23 stuck for
>> 22s!
>> [swapper/23:0]
>>
>> I wild guess: these lockups are actually deadlocks. AIO seems to be
>> tricky for the kernel too.
>>
>
> Probably not deadlocks.  One easy to way trigger those is to submit
> IOs on one set of CPUs and expect a different set of CPUs to handle
> the interrupts and completions.  The latter CPUs can easily become
> overwhelmed.  The best remedy I've found is to require CPUs to handle
> their own IOs, which self-throttles them from submitting more IOs
> than they can handle.
>
> The storage device driver needs to set up its hardware interrupts
> that way.  Then, rq_affinity=2 ensures the block layer completions
> are handled on the submitting CPU.
>
> You can add this to the kernel command line (e.g., in
> /boot/grub/grub.conf) to squelch those checks:
> 	nosoftlockup
>
> Those prints themselves can induce more soft lockups if you have a
> live serial port, because printing to the serial port is slow
> and blocking.
>

Thanks alot for your tips!

Indeed, we currently have rq_affinity=1.

Are there any risks involved?

I mean, this is a complex box .. pls see below.

Also: sadly, not each of the NUMA sockets has exactly 2 NVMes (due to 
mainboard / slot limitations). So wouldn't enforcing IO affinity be a 
problem with this?

Cheers,
/Tobias

PS: The mainboard is

https://www.supermicro.nl/products/motherboard/Xeon/C600/X10QBI.cfm

Yeah, I know, no offense - this particular piece isn't HPE;)


The current settings / hardware:


oberstet@svr-psql19:~$ cat /sys/block/nvme0n1/queue/rq_affinity
1
oberstet@svr-psql19:~$ cat /sys/block/nvme0n1/queue/scheduler
none
oberstet@svr-psql19:~$ cat /sys/block/nvme0n1/queue/optimal_io_size
0
oberstet@svr-psql19:~$ cat /sys/block/nvme0n1/queue/iostats
1
oberstet@svr-psql19:~$ cat /sys/block/nvme0n1/queue/max_hw_sectors_kb
128
oberstet@svr-psql19:~$ cat /sys/block/nvme0n1/queue/hw_sector_size
4096
oberstet@svr-psql19:~$ cat /sys/block/nvme0n1/queue/physical_block_size
4096
oberstet@svr-psql19:~$ cat /sys/block/nvme0n1/queue/nomerges
0
oberstet@svr-psql19:~$ cat /sys/block/nvme0n1/queue/io_poll
1
oberstet@svr-psql19:~$ cat /sys/block/nvme0n1/queue/minimum_io_size
4096
oberstet@svr-psql19:~$ cat /sys/block/nvme0n1/queue/write_cache
write through



oberstet@svr-psql19:~$ cat /proc/cpuinfo | grep "Intel(R) Xeon(R) CPU 
E7-8880 v4 @ 2.20GHz" | wc -l
176
oberstet@svr-psql19:~$ sudo numactl --hardware
available: 4 nodes (0-3)
node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 88 
89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109
node 0 size: 773944 MB
node 0 free: 770949 MB
node 1 cpus: 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 
42 43 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 
126 127 128 129 130 131
node 1 size: 774137 MB
node 1 free: 762335 MB
node 2 cpus: 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 
64 65 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 
148 149 150 151 152 153
node 2 size: 774126 MB
node 2 free: 763220 MB
node 3 cpus: 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 
86 87 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 
170 171 172 173 174 175
node 3 size: 774136 MB
node 3 free: 770518 MB
node distances:
node   0   1   2   3
   0:  10  21  21  21
   1:  21  10  21  21
   2:  21  21  10  21
   3:  21  21  21  10



oberstet@svr-psql19:~$ find /sys/devices | egrep 'nvme[0-9][0-9]?$'
/sys/devices/pci0000:00/0000:00:03.0/0000:07:00.0/0000:08:02.0/0000:0a:00.0/nvme/nvme3
/sys/devices/pci0000:00/0000:00:03.0/0000:07:00.0/0000:08:01.0/0000:09:00.0/nvme/nvme2
/sys/devices/pci0000:00/0000:00:02.2/0000:03:00.0/0000:04:01.0/0000:05:00.0/nvme/nvme0
/sys/devices/pci0000:00/0000:00:02.2/0000:03:00.0/0000:04:02.0/0000:06:00.0/nvme/nvme1
/sys/devices/pci0000:80/0000:80:03.0/0000:83:00.0/0000:84:02.0/0000:86:00.0/nvme/nvme9
/sys/devices/pci0000:80/0000:80:03.0/0000:83:00.0/0000:84:01.0/0000:85:00.0/nvme/nvme8
/sys/devices/pci0000:40/0000:40:03.2/0000:46:00.0/0000:47:01.0/0000:48:00.0/nvme/nvme6
/sys/devices/pci0000:40/0000:40:03.2/0000:46:00.0/0000:47:02.0/0000:49:00.0/nvme/nvme7
/sys/devices/pci0000:40/0000:40:02.0/0000:41:00.0/0000:42:02.0/0000:44:00.0/nvme/nvme5
/sys/devices/pci0000:40/0000:40:02.0/0000:41:00.0/0000:42:01.0/0000:43:00.0/nvme/nvme4
/sys/devices/pci0000:c0/0000:c0:02.2/0000:c5:00.0/0000:c6:02.0/0000:c8:00.0/nvme/nvme13
/sys/devices/pci0000:c0/0000:c0:02.2/0000:c5:00.0/0000:c6:01.0/0000:c7:00.0/nvme/nvme12
/sys/devices/pci0000:c0/0000:c0:02.0/0000:c1:00.0/0000:c2:01.0/0000:c3:00.0/nvme/nvme10
/sys/devices/pci0000:c0/0000:c0:02.0/0000:c1:00.0/0000:c2:02.0/0000:c4:00.0/nvme/nvme11
/sys/devices/pci0000:c0/0000:c0:03.0/0000:c9:00.0/0000:ca:02.0/0000:cc:00.0/nvme/nvme15
/sys/devices/pci0000:c0/0000:c0:03.0/0000:c9:00.0/0000:ca:01.0/0000:cb:00.0/nvme/nvme14


oberstet@svr-psql19:~$ egrep -H '.*' /sys/bus/pci/slots/*/address
/sys/bus/pci/slots/0/address:0000:01:00
/sys/bus/pci/slots/10/address:0000:c5:00
/sys/bus/pci/slots/11/address:0000:c9:00
/sys/bus/pci/slots/1/address:0000:03:00
/sys/bus/pci/slots/2/address:0000:07:00
/sys/bus/pci/slots/3/address:0000:46:00
/sys/bus/pci/slots/4/address:0000:41:00
/sys/bus/pci/slots/5/address:0000:45:00
/sys/bus/pci/slots/6/address:0000:81:00
/sys/bus/pci/slots/7/address:0000:82:00
/sys/bus/pci/slots/8/address:0000:c1:00
/sys/bus/pci/slots/9/address:0000:83:00


