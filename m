Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:38227 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750957AbdAWRwi (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 Jan 2017 12:52:38 -0500
Received: by mail-wm0-f45.google.com with SMTP id r144so168030502wme.1
        for <fio@vger.kernel.org>; Mon, 23 Jan 2017 09:52:14 -0800 (PST)
Subject: Re: 4x lower IOPS: Linux MD vs indiv. devices - why?
References: <90865544-f790-513c-97df-7e6a6af20ca8@gmail.com>
 <CANvN+en2ihATNgrbgzwNXAK87wNh+6jXHinmg2-VmHon31AJzA@mail.gmail.com>
From: Tobias Oberstein <tobias.oberstein@gmail.com>
Message-ID: <061acabe-dbd0-ae07-cd69-772eccd15b21@gmail.com>
Date: Mon, 23 Jan 2017 18:52:01 +0100
MIME-Version: 1.0
In-Reply-To: <CANvN+en2ihATNgrbgzwNXAK87wNh+6jXHinmg2-VmHon31AJzA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>, fio@vger.kernel.org

Am 23.01.2017 um 18:03 schrieb Andrey Kuzmin:
 > Why don't you just 'perf' your md run and find out where it spends (an
 > awful lot if extra) time?

Good idea!

I ran with threads=1024 (to account for perf overhead). At that 
concurrency, Linux MD reaches 25% lower IOPS and has higher system load.

Please see here:

https://github.com/oberstet/scratchbox/tree/master/cruncher/sql19/linux-md-bottleneck

With higher concurrency, the discrepancy gets wider up to 7 mio vs 1.6 
mio IOPS.

I am not a kernel hacker.

What is osq_lock?

FWIW, this is a NUMA machine with 4 x E7 (88 cores / 176 HT) and 8 x 
Intel P3608 NVMe.

Any hints or anything I should try / measure?

Thanks a lot for your tips and assistence!

Cheers,
/Tobias

>
> On Jan 23, 2017 19:28, "Tobias Oberstein" <tobias.oberstein@gmail.com>
> wrote:
>
>> Hi,
>>
>> I have a question rgd Linux software RAID (MD) as tested with FIO - so
>> this is slightly OT, but I am hoping for expert advice or redirection to a
>> more appropriate place (if this is unwelcome here).
>>
>> I have a box with this HW:
>>
>> - 88 cores Xeon E7 (176 HTs) + 3TB RAM
>> - 8 x Intel P3608 4TB NVMe (which is logicall 16 NVMes)
>>
>> With random 4kB read load, I am able to max it out at 7 million IOPS - but
>> only if I run FIO on the _individual_ NVMe devices.
>>
>> [global]
>> group_reporting
>> filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1
>> :/dev/nvme4n1:/dev/nvme5n1:/dev/nvme6n1:/dev/nvme7n1:/dev/
>> nvme8n1:/dev/nvme9n1:/dev/nvme10n1:/dev/nvme11n1:/dev/
>> nvme12n1:/dev/nvme13n1:/dev/nvme14n1:/dev/nvme15n1
>> size=30G
>> ioengine=sync
>> iodepth=1
>> thread=1
>> direct=1
>> time_based=1
>> randrepeat=0
>> norandommap=1
>> bs=4k
>> runtime=120
>>
>> [randread]
>> stonewall
>> rw=randread
>> numjobs=2560
>>
>> When I create a stripe set over all devices:
>>
>> sudo mdadm --create /dev/md1 --chunk=8 --level=0 --raid-devices=16 \
>>    /dev/nvme0n1 \
>>    /dev/nvme1n1 \
>>    /dev/nvme2n1 \
>>    /dev/nvme3n1 \
>>    /dev/nvme4n1 \
>>    /dev/nvme5n1 \
>>    /dev/nvme6n1 \
>>    /dev/nvme7n1 \
>>    /dev/nvme8n1 \
>>    /dev/nvme9n1 \
>>    /dev/nvme10n1 \
>>    /dev/nvme11n1 \
>>    /dev/nvme12n1 \
>>    /dev/nvme13n1 \
>>    /dev/nvme14n1 \
>>    /dev/nvme15n1
>>
>> I only get 1.6 million IOPS. Detail results down below.
>>
>> Note: the array is created with chunk size 8K because this is for database
>> workload. Here I tested with 4k block size, but the it's similar (lower
>> perf on MD) with 8k
>>
>> Any helps or hints would be greatly appreciated!
>>
>> Cheers,
>> /Tobias
>>
>>
>>
>> 7 million IOPS on raw, individual NVMe devices
>> ==============================================
>>
>> oberstet@svr-psql19:~/scm/parcit/RA/adr/system/docs$ sudo
>> /opt/fio/bin/fio postgresql_storage_workload.fio
>> randread: (g=0): rw=randread, bs=4096B-4096B,4096B-4096B,4096B-4096B,
>> ioengine=sync, iodepth=1
>> ...
>> fio-2.17-17-g9cf1
>> Starting 2560 threads
>> Jobs: 2367 (f=29896): [_(2),f(3),_(2),f(11),_(2),f(2
>> ),_(9),f(1),_(1),f(1),_(3),f(1),_(1),f(1),_(13),f(1),_(8),f(
>> 1),_(1),f(4),_(2),f(1),_(1),f(1),_(3),f(2),_(3),f(3),_(8),f(
>> 2),_(1),f(3),_(3),f(60),_(1),f(20),_(1),f(33),_(1),f(14),_(
>> 1),f(18),_(4),f(6),_(1),f(6),_(1),f(1),_(1),f(1),_(1),f(4),_
>> (1),f(2),_(1),f(11),_(1),f(11),_(4),f(74),_(1),f(8),_(1),f(
>> 11),_(1),f(8),_(1),f(61),_(1),f(38),_(1),f(31),_(1),f(5),_(
>> 1),f(103),_(1),f(24),E(1),f(27),_(1),f(28),_(1),f(1),_(1),f(
>> 134),_(1),f(62),_(1),f(48),_(1),f(27),_(1),f(59),_(1),f(30)
>> ,_(1),f(14),_(1),f(25),_(1),f(2),_(1),f(25),_(1),f(31),_(1),
>> f(9),_(1),f(7),_(1),f(8),_(1),f(13),_(1),f(28),_(1),f(7),_(
>> 1),f(84),_(1),f(42),_(1),f(5),_(1),f(8),_(1),f(20),_(1),f(
>> 15),_(1),f(19),_(1),f(3),_(1),f(19),_(1),f(7),_(1),f(17),_(
>> 1),f(34),_(1),f(1),_(1),f(4),_(1),f(1),_(1),f(1),_(2),f(3),_
>> (1),f(1),_(1),f(1),_(1),f(8),_(1),f(6),_(1),f(3),_(1),f(3),_
>> (1),f(53),_(1),f(7),_(1),f(19),_(1),f(6),_(1),f(5),_(1),f(
>> 22),_(1),f(11),_(1),f(12),_(1),f(3),_(1),f(16),_(1),f(149),_
>> (1),f(20),_(1),f(27),_(1),f(7),_(1),f(29),_(1),f(2),_(1),f(
>> 11),_(1),f(46),_(1),f(8),_(2),f(1),_(1),f(1),_(1),f(14),E(1)
>> ,f(4),_(1),f(22),_(1),f(11),_(1),f(70),_(2),f(11),_(1),f(2),
>> _(1),f(1),_(1),f(1),_(1),f(21),_(1),f(8),_(1),f(4),_(1),f(
>> 45),_(2),f(1),_(1),f(18),_(1),f(12),_(1),f(6),_(1),f(5),_(1)
>> ,f(27),_(1),f(3),_(1),f(3),_(1),f(19),_(1),f(4),_(1),f(25),
>> _(1),f(4),_(1),f(1),_(1),f(2),_(1),f(1),_(1),f(13),_(1),f(
>> 18),_(1),f(1),_(1),f(1),_(1),f(29),_(1),f(27)][100.0%][r=
>> 21.1GiB/s,w=0KiB/s][r=5751k,w=0 IOPS][eta 00m:00s]
>> randread: (groupid=0, jobs=2560): err= 0: pid=114435: Mon Jan 23 15:47:17
>> 2017
>>    read: IOPS=6965k, BW=26.6GiB/s (28.6GB/s)(3189GiB/120007msec)
>>     clat (usec): min=38, max=33262, avg=360.11, stdev=465.36
>>      lat (usec): min=38, max=33262, avg=360.20, stdev=465.40
>>     clat percentiles (usec):
>>      |  1.00th=[  114],  5.00th=[  135], 10.00th=[  149], 20.00th=[  171],
>>      | 30.00th=[  191], 40.00th=[  213], 50.00th=[  239], 60.00th=[  270],
>>      | 70.00th=[  314], 80.00th=[  378], 90.00th=[  556], 95.00th=[  980],
>>      | 99.00th=[ 2704], 99.50th=[ 3312], 99.90th=[ 4576], 99.95th=[ 5216],
>>      | 99.99th=[ 8096]
>>     lat (usec) : 50=0.01%, 100=0.11%, 250=53.75%, 500=34.23%, 750=5.23%
>>     lat (usec) : 1000=1.79%
>>     lat (msec) : 2=2.88%, 4=1.81%, 10=0.20%, 20=0.01%, 50=0.01%
>>   cpu          : usr=0.63%, sys=4.89%, ctx=837434400, majf=0, minf=2557
>>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%,
>>> =64=0.0%
>>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>>> =64=0.0%
>>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>>> =64=0.0%
>>      issued rwt: total=835852266,0,0, short=0,0,0, dropped=0,0,0
>>      latency   : target=0, window=0, percentile=100.00%, depth=1
>>
>> Run status group 0 (all jobs):
>>    READ: bw=26.6GiB/s (28.6GB/s), 26.6GiB/s-26.6GiB/s (28.6GB/s-28.6GB/s),
>> io=3189GiB (3424GB), run=120007-120007msec
>>
>> Disk stats (read/write):
>>   nvme0n1: ios=52191377/0, merge=0/0, ticks=14400568/0, in_queue=14802400,
>> util=100.00%
>>   nvme1n1: ios=52241684/0, merge=0/0, ticks=13919744/0, in_queue=15101276,
>> util=100.00%
>>   nvme2n1: ios=52241537/0, merge=0/0, ticks=11146952/0, in_queue=12053112,
>> util=100.00%
>>   nvme3n1: ios=52241416/0, merge=0/0, ticks=10806624/0, in_queue=11135004,
>> util=100.00%
>>   nvme4n1: ios=52241285/0, merge=0/0, ticks=19320448/0, in_queue=21079576,
>> util=100.00%
>>   nvme5n1: ios=52241142/0, merge=0/0, ticks=18786968/0, in_queue=19393024,
>> util=100.00%
>>   nvme6n1: ios=52241000/0, merge=0/0, ticks=19610892/0, in_queue=20140104,
>> util=100.00%
>>   nvme7n1: ios=52240874/0, merge=0/0, ticks=20482920/0, in_queue=21090048,
>> util=100.00%
>>   nvme8n1: ios=52240731/0, merge=0/0, ticks=14533992/0, in_queue=14929172,
>> util=100.00%
>>   nvme9n1: ios=52240587/0, merge=0/0, ticks=12854956/0, in_queue=13919288,
>> util=100.00%
>>   nvme10n1: ios=52240447/0, merge=0/0, ticks=11085508/0,
>> in_queue=11390392, util=100.00%
>>   nvme11n1: ios=52240301/0, merge=0/0, ticks=18490260/0,
>> in_queue=20110288, util=100.00%
>>   nvme12n1: ios=52240097/0, merge=0/0, ticks=11377884/0,
>> in_queue=11683568, util=100.00%
>>   nvme13n1: ios=52239956/0, merge=0/0, ticks=15205304/0,
>> in_queue=16314628, util=100.00%
>>   nvme14n1: ios=52239766/0, merge=0/0, ticks=27003788/0,
>> in_queue=27659920, util=100.00%
>>   nvme15n1: ios=52239620/0, merge=0/0, ticks=17352624/0,
>> in_queue=17910636, util=100.00%
>>
>>
>> 1.6 millions IOPS on Linux MD over 16 NVMe devices
>> ==================================================
>>
>> oberstet@svr-psql19:~/scm/parcit/RA/adr/system/docs$ sudo
>> /opt/fio/bin/fio postgresql_storage_workload.fio
>> randread: (g=0): rw=randread, bs=4096B-4096B,4096B-4096B,4096B-4096B,
>> ioengine=sync, iodepth=1
>> ...
>> fio-2.17-17-g9cf1
>> Starting 2560 threads
>> Jobs: 2560 (f=2560): [r(2560)][100.0%][r=6212MiB/s,w=0KiB/s][r=1590k,w=0
>> IOPS][eta 00m:00s]
>> randread: (groupid=0, jobs=2560): err= 0: pid=146070: Mon Jan 23 17:21:15
>> 2017
>>    read: IOPS=1588k, BW=6204MiB/s (6505MB/s)(728GiB/120098msec)
>>     clat (usec): min=27, max=28498, avg=124.51, stdev=113.10
>>      lat (usec): min=27, max=28498, avg=124.58, stdev=113.10
>>     clat percentiles (usec):
>>      |  1.00th=[   78],  5.00th=[   84], 10.00th=[   86], 20.00th=[   89],
>>      | 30.00th=[   95], 40.00th=[  102], 50.00th=[  105], 60.00th=[  108],
>>      | 70.00th=[  118], 80.00th=[  133], 90.00th=[  173], 95.00th=[  221],
>>      | 99.00th=[  358], 99.50th=[  506], 99.90th=[ 2192], 99.95th=[ 2608],
>>      | 99.99th=[ 2960]
>>     lat (usec) : 50=0.06%, 100=35.14%, 250=61.83%, 500=2.46%, 750=0.19%
>>     lat (usec) : 1000=0.07%
>>     lat (msec) : 2=0.13%, 4=0.12%, 10=0.01%, 20=0.01%, 50=0.01%
>>   cpu          : usr=0.08%, sys=4.49%, ctx=200431993, majf=0, minf=2557
>>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%,
>>> =64=0.0%
>>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>>> =64=0.0%
>>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>>> =64=0.0%
>>      issued rwt: total=190730463,0,0, short=0,0,0, dropped=0,0,0
>>      latency   : target=0, window=0, percentile=100.00%, depth=1
>>
>> Run status group 0 (all jobs):
>>    READ: bw=6204MiB/s (6505MB/s), 6204MiB/s-6204MiB/s (6505MB/s-6505MB/s),
>> io=728GiB (781GB), run=120098-120098msec
>>
>> Disk stats (read/write):
>>     md1: ios=190632612/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
>> aggrios=11920653/0, aggrmerge=0/0, aggrticks=1228287/0,
>> aggrin_queue=1247601, aggrutil=100.00%
>>   nvme15n1: ios=11919850/0, merge=0/0, ticks=1214924/0, in_queue=1225896,
>> util=100.00%
>>   nvme6n1: ios=11921162/0, merge=0/0, ticks=1182716/0, in_queue=1191452,
>> util=100.00%
>>   nvme9n1: ios=11916313/0, merge=0/0, ticks=1265060/0, in_queue=1296728,
>> util=100.00%
>>   nvme11n1: ios=11922174/0, merge=0/0, ticks=1206084/0, in_queue=1239808,
>> util=100.00%
>>   nvme2n1: ios=11921547/0, merge=0/0, ticks=1238956/0, in_queue=1272916,
>> util=100.00%
>>   nvme14n1: ios=11923176/0, merge=0/0, ticks=1168688/0, in_queue=1178360,
>> util=100.00%
>>   nvme5n1: ios=11923142/0, merge=0/0, ticks=1192656/0, in_queue=1207808,
>> util=100.00%
>>   nvme8n1: ios=11921507/0, merge=0/0, ticks=1250164/0, in_queue=1258956,
>> util=100.00%
>>   nvme10n1: ios=11919058/0, merge=0/0, ticks=1294028/0, in_queue=1304536,
>> util=100.00%
>>   nvme1n1: ios=11923129/0, merge=0/0, ticks=1246892/0, in_queue=1281952,
>> util=100.00%
>>   nvme13n1: ios=11923354/0, merge=0/0, ticks=1241540/0, in_queue=1271820,
>> util=100.00%
>>   nvme4n1: ios=11926936/0, merge=0/0, ticks=1190384/0, in_queue=1224192,
>> util=100.00%
>>   nvme7n1: ios=11921139/0, merge=0/0, ticks=1200624/0, in_queue=1214240,
>> util=100.00%
>>   nvme0n1: ios=11916614/0, merge=0/0, ticks=1230916/0, in_queue=1242372,
>> util=100.00%
>>   nvme12n1: ios=11916963/0, merge=0/0, ticks=1266840/0, in_queue=1277600,
>> util=100.00%
>>   nvme3n1: ios=11914399/0, merge=0/0, ticks=1262128/0, in_queue=1272988,
>> util=100.00%
>> oberstet@svr-psql19:~/scm/parcit/RA/adr/system/docs$
>>
>

