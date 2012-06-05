Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:63089 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834Ab2FEGHT (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 5 Jun 2012 02:07:19 -0400
Received: by gglu4 with SMTP id u4so3691192ggl.19
        for <fio@vger.kernel.org>; Mon, 04 Jun 2012 23:07:18 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 5 Jun 2012 14:07:18 +0800
Message-ID: <CAG1+85GoeaqNQ9vitHcq6be=XTWJ3jBtE=3gm7P1EcJX-7bj1g@mail.gmail.com>
Subject: Does ext4 better than raw device ?
From: Homer Li <01jay.ly@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

       I don't know why ext4 is better than raw device in sequence
write in my fio benchmark.

      In the rewrite benchmark ,  ext4 is lower than raw device. Is
ext4 need search old data block address from the metadata ?

      Does someone could help me ?  thanks.  :-)

       My environment :
       HP 380 G6 6xHDD 2.5 inch SAS 10000rpm 146GB, Raid 0
       Raid controller : HP P410i  no cache.
       OS: Red Hat Enterprise Linux Server release 6.2 (Santiago)
      MEM: 4x6 GB DDR 3 1066MHz
       # fio -v
       fio 2.0.7



My operate process:

fio fio.cfg_raw    aggrb=459831KB/s  (write raw)
fio fio.cfg_raw    aggrb=460426KB/s  (write raw)
fio fio.cfg_raw    aggrb=455002KB/s  (write raw)


mkfs.ext4--mount--umount    aggrb=481412KB/s  (write)
mkfs.ext4--mount--umount    aggrb=482603KB/s  (write)
mkfs.ext4--mount--umount    aggrb=487245KB/s  (write)
umount--mount                    aggrb=422979KB/s   (rewrite)
umount--mount                    aggrb=419082KB/s,  (rewrite)
umount--mount                    aggrb=416758KB/s,  (rewrite)
umount--mount  fio fio.cfg_new_data aggrb=477553KB/s, (write new data)
umount--mount  fio fio.cfg_new_data aggrb=478463KB/s, (write new data1)
umount--mount  fio fio.cfg_new_data aggrb=470250KB/s, (write new data2)

ext4 write rewrite config:
[global]
rw=write
ioengine=libaio
size=40960m
numjobs=1
bssplit=128k/20:256k/20:512k/20:1024k/40
nrfiles=2
iodepth=128
zero_buffers
timeout=240
thread

[sdb]
directory=/export/data0



ext4 write new data config:
[global]
rw=write
ioengine=libaio
size=40960m
numjobs=1
bssplit=128k/20:256k/20:512k/20:1024k/40
nrfiles=2
iodepth=128
zero_buffers
timeout=240
thread

[new_data]  (new_data,new_data2,new_data3)
directory=/export/data0




raw device config:
[global]
rw=write
ioengine=libaio
size=40960m
numjobs=1
bssplit=128k/20:256k/20:512k/20:1024k/40
nrfiles=2
iodepth=128
zero_buffers
timeout=240
thread

[sdb]
filename=/dev/sdb





Benchmark detail :

FIO libaio ext4   (1st)

# mkfs.ext4 /dev/sdb
# mount /dev/sdb /export/data0/ -o noatime,data=writeback

# fio /tmp/fio.cfg3

sdb: (g=0): rw=write, bs=128K-1M/128K-1M, ioengine=libaio, iodepth=128
fio 2.0.7
Starting 1 thread
sdb: Laying out IO file(s) (2 file(s) / 40960MB)
Jobs: 1 (f=2): [W] [100.0% done] [0K/481.8M /s] [0 /788  iops] [eta 00m:00s]
sdb: (groupid=0, jobs=1): err= 0: pid=7693
  write: io=40960MB, bw=481412KB/s, iops=818 , runt= 87125msec
    slat (usec): min=95 , max=557269 , avg=1216.93, stdev=3802.05
    clat (usec): min=19 , max=946512 , avg=155016.04, stdev=56858.97
     lat (usec): min=158 , max=974215 , avg=156233.59, stdev=57236.46
    clat percentiles (msec):
     |  1.00th=[   53],  5.00th=[   57], 10.00th=[   60], 20.00th=[  143],
     | 30.00th=[  151], 40.00th=[  157], 50.00th=[  163], 60.00th=[  167],
     | 70.00th=[  174], 80.00th=[  180], 90.00th=[  188], 95.00th=[  196],
     | 99.00th=[  237], 99.50th=[  441], 99.90th=[  791], 99.95th=[  799],
     | 99.99th=[  857]
    bw (KB/s)  : min=48681, max=1353472, per=100.00%, avg=481974.53,
stdev=189725.22
    lat (usec) : 20=0.01%, 250=0.01%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.01%, 10=0.01%, 20=0.02%, 50=0.27%, 100=13.12%
    lat (msec) : 250=85.72%, 500=0.39%, 750=0.33%, 1000=0.14%
  cpu          : usr=9.86%, sys=44.85%, ctx=21686, majf=0, minf=365
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=99.9%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
     issued    : total=r=0/w=71348/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
  WRITE: io=40960MB, aggrb=481412KB/s, minb=481412KB/s,
maxb=481412KB/s, mint=87125msec, maxt=87125msec

Disk stats (read/write):
  sdb: ios=0/308736, merge=0/9125042, ticks=0/11905307,
in_queue=11910344, util=97.91%


2nd:

# mkfs.ext4 /dev/sdb
# mount /dev/sdb /export/data0/ -o noatime,data=writeback

# fio /tmp/fio.cfg3

sdb: (g=0): rw=write, bs=128K-1M/128K-1M, ioengine=libaio, iodepth=128
fio 2.0.7
Starting 1 thread
sdb: Laying out IO file(s) (2 file(s) / 40960MB)
Jobs: 1 (f=2): [W] [98.9% done] [0K/484.3M /s] [0 /779  iops] [eta 00m:01s]
sdb: (groupid=0, jobs=1): err= 0: pid=7654
  write: io=40960MB, bw=482603KB/s, iops=820 , runt= 86910msec
    slat (usec): min=95 , max=128132 , avg=1214.06, stdev=3442.75
    clat (usec): min=20 , max=955607 , avg=154643.85, stdev=59326.31
     lat (usec): min=173 , max=955892 , avg=155858.51, stdev=59724.39
    clat percentiles (msec):
     |  1.00th=[   53],  5.00th=[   58], 10.00th=[   61], 20.00th=[  139],
     | 30.00th=[  151], 40.00th=[  157], 50.00th=[  163], 60.00th=[  167],
     | 70.00th=[  174], 80.00th=[  180], 90.00th=[  188], 95.00th=[  196],
     | 99.00th=[  239], 99.50th=[  553], 99.90th=[  799], 99.95th=[  832],
     | 99.99th=[  889]
    bw (KB/s)  : min=93398, max=1320704, per=100.00%, avg=483912.12,
stdev=187716.32
    lat (usec) : 50=0.01%, 250=0.01%
    lat (msec) : 2=0.01%, 4=0.01%, 10=0.02%, 20=0.01%, 50=0.12%
    lat (msec) : 100=13.74%, 250=85.18%, 500=0.39%, 750=0.27%, 1000=0.26%
  cpu          : usr=7.92%, sys=44.01%, ctx=21846, majf=0, minf=364
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=99.9%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
     issued    : total=r=0/w=71343/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
  WRITE: io=40960MB, aggrb=482603KB/s, minb=482603KB/s,
maxb=482603KB/s, mint=86910msec, maxt=86910msec

Disk stats (read/write):
  sdb: ios=0/308658, merge=0/9122789, ticks=0/11872900,
in_queue=11876376, util=97.92%

3rd :
# mkfs.ext4 /dev/sdb
# mount /dev/sdb /export/data0/ -o noatime,data=writeback

# fio /tmp/fio.cfg3

sdb: (g=0): rw=write, bs=128K-1M/128K-1M, ioengine=libaio, iodepth=128
fio 2.0.7
Starting 1 thread
sdb: Laying out IO file(s) (2 file(s) / 40960MB)
Jobs: 1 (f=2): [W] [100.0% done] [0K/453.6M /s] [0 /724  iops] [eta 00m:00s]
sdb: (groupid=0, jobs=1): err= 0: pid=7726
  write: io=40960MB, bw=487245KB/s, iops=830 , runt= 86082msec
    slat (usec): min=96 , max=127776 , avg=1199.79, stdev=3101.33
    clat (usec): min=18 , max=854434 , avg=152840.31, stdev=50350.61
     lat (usec): min=189 , max=855501 , avg=154040.74, stdev=50688.58
    clat percentiles (msec):
     |  1.00th=[   53],  5.00th=[   57], 10.00th=[   60], 20.00th=[  141],
     | 30.00th=[  151], 40.00th=[  157], 50.00th=[  163], 60.00th=[  167],
     | 70.00th=[  174], 80.00th=[  180], 90.00th=[  188], 95.00th=[  196],
     | 99.00th=[  221], 99.50th=[  239], 99.90th=[  717], 99.95th=[  725],
     | 99.99th=[  857]
    bw (KB/s)  : min=87838, max=1331456, per=100.00%, avg=487739.05,
stdev=187212.48
    lat (usec) : 20=0.01%, 250=0.01%, 500=0.01%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.01%, 4=0.01%, 10=0.01%, 50=0.15%, 100=13.65%
    lat (msec) : 250=85.73%, 500=0.19%, 750=0.23%, 1000=0.04%
  cpu          : usr=7.94%, sys=46.60%, ctx=21675, majf=0, minf=359
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=99.9%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
     issued    : total=r=0/w=71493/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
  WRITE: io=40960MB, aggrb=487245KB/s, minb=487245KB/s,
maxb=487245KB/s, mint=86082msec, maxt=86082msec

Disk stats (read/write):
  sdb: ios=0/309468, merge=0/9146259, ticks=0/11775294,
in_queue=11777890, util=97.92%


4th:
# umount /export/data0/
# mount /dev/sdb /export/data0/ -o noatime,data=writeback
# fio /tmp/fio.cfg3

sdb: (g=0): rw=write, bs=128K-1M/128K-1M, ioengine=libaio, iodepth=128
fio 2.0.7
Starting 1 thread
Jobs: 1 (f=2): [W] [100.0% done] [0K/409.2M /s] [0 /688  iops] [eta 00m:00s]
sdb: (groupid=0, jobs=1): err= 0: pid=7743
  write: io=40960MB, bw=422979KB/s, iops=719 , runt= 99161msec
    slat (usec): min=83 , max=288580 , avg=1385.81, stdev=4976.66
    clat (usec): min=20 , max=971979 , avg=176469.46, stdev=75472.13
     lat (usec): min=161 , max=972904 , avg=177855.93, stdev=75928.07
    clat percentiles (msec):
     |  1.00th=[   48],  5.00th=[   51], 10.00th=[   55], 20.00th=[  159],
     | 30.00th=[  174], 40.00th=[  182], 50.00th=[  186], 60.00th=[  192],
     | 70.00th=[  198], 80.00th=[  204], 90.00th=[  215], 95.00th=[  227],
     | 99.00th=[  453], 99.50th=[  578], 99.90th=[  857], 99.95th=[  881],
     | 99.99th=[  938]
    bw (KB/s)  : min=77850, max=1501440, per=100.00%, avg=424520.70,
stdev=203955.22
    lat (usec) : 50=0.01%, 250=0.01%
    lat (msec) : 2=0.01%, 4=0.01%, 10=0.01%, 20=0.01%, 50=3.73%
    lat (msec) : 100=11.88%, 250=81.07%, 500=2.69%, 750=0.30%, 1000=0.31%
  cpu          : usr=7.10%, sys=32.61%, ctx=29159, majf=0, minf=415
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=99.9%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
     issued    : total=r=0/w=71337/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
  WRITE: io=40960MB, aggrb=422979KB/s, minb=422979KB/s,
maxb=422979KB/s, mint=99161msec, maxt=99161msec


5th:
# umount /export/data0/
# mount /dev/sdb /export/data0/ -o noatime,data=writeback
# fio /tmp/fio.cfg3

sdb: (g=0): rw=write, bs=128K-1M/128K-1M, ioengine=libaio, iodepth=128
fio 2.0.7
Starting 1 thread
Jobs: 1 (f=2): [W] [100.0% done] [0K/407.4M /s] [0 /694  iops] [eta 00m:00s]
sdb: (groupid=0, jobs=1): err= 0: pid=7762
  write: io=40960MB, bw=419083KB/s, iops=710 , runt=100083msec
    slat (usec): min=84 , max=300576 , avg=1402.52, stdev=4998.18
    clat (usec): min=19 , max=832664 , avg=178583.40, stdev=74567.29
     lat (usec): min=550 , max=832838 , avg=179986.58, stdev=75021.86
    clat percentiles (msec):
     |  1.00th=[   47],  5.00th=[   51], 10.00th=[   55], 20.00th=[  159],
     | 30.00th=[  176], 40.00th=[  184], 50.00th=[  190], 60.00th=[  196],
     | 70.00th=[  202], 80.00th=[  208], 90.00th=[  217], 95.00th=[  229],
     | 99.00th=[  445], 99.50th=[  570], 99.90th=[  750], 99.95th=[  766],
     | 99.99th=[  832]
    bw (KB/s)  : min=104704, max=1498112, per=100.00%, avg=420263.22,
stdev=209453.40
    lat (usec) : 20=0.01%, 750=0.01%
    lat (msec) : 10=0.01%, 20=0.02%, 50=4.52%, 100=11.61%, 250=80.36%
    lat (msec) : 500=2.89%, 750=0.48%, 1000=0.11%
  cpu          : usr=7.42%, sys=34.68%, ctx=28753, majf=0, minf=419
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=99.9%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
     issued    : total=r=0/w=71144/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
  WRITE: io=40960MB, aggrb=419082KB/s, minb=419082KB/s,
maxb=419082KB/s, mint=100083msec, maxt=100083msec

Disk stats (read/write):
  sdb: ios=2/311827, merge=0/9140886, ticks=9/13853139,
in_queue=13856991, util=98.42%

6th
# umount /export/data0/
# mount /dev/sdb /export/data0/ -o noatime,data=writeback
# fio /tmp/fio.cfg3
sdb: (g=0): rw=write, bs=128K-1M/128K-1M, ioengine=libaio, iodepth=128
fio 2.0.7
Starting 1 thread
Jobs: 1 (f=2): [W] [100.0% done] [0K/330.7M /s] [0 /571  iops] [eta 00m:00s]
sdb: (groupid=0, jobs=1): err= 0: pid=7778
  write: io=40960MB, bw=416759KB/s, iops=706 , runt=100641msec
    slat (usec): min=83 , max=309115 , avg=1411.78, stdev=4966.23
    clat (usec): min=19 , max=867384 , avg=179749.25, stdev=69366.01
     lat (usec): min=159 , max=868372 , avg=181161.68, stdev=69765.22
    clat percentiles (msec):
     |  1.00th=[   48],  5.00th=[   51], 10.00th=[   55], 20.00th=[  159],
     | 30.00th=[  178], 40.00th=[  188], 50.00th=[  194], 60.00th=[  198],
     | 70.00th=[  204], 80.00th=[  210], 90.00th=[  221], 95.00th=[  233],
     | 99.00th=[  420], 99.50th=[  461], 99.90th=[  775], 99.95th=[  791],
     | 99.99th=[  857]
    bw (KB/s)  : min=100821, max=1479680, per=100.00%, avg=418230.12,
stdev=201567.60
    lat (usec) : 20=0.01%, 250=0.01%, 500=0.01%, 750=0.01%
    lat (msec) : 20=0.01%, 50=3.49%, 100=11.93%, 250=81.18%, 500=3.05%
    lat (msec) : 750=0.21%, 1000=0.11%
  cpu          : usr=8.12%, sys=33.22%, ctx=28629, majf=0, minf=421
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=99.9%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
     issued    : total=r=0/w=71074/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
  WRITE: io=40960MB, aggrb=416758KB/s, minb=416758KB/s,
maxb=416758KB/s, mint=100641msec, maxt=100641msec

Disk stats (read/write):
  sdb: ios=2/312068, merge=0/9145308, ticks=12/13922386,
in_queue=13938422, util=98.41%

7th: write new data

# fio /tmp/fio.cfg3
new_data: (g=0): rw=write, bs=128K-1M/128K-1M, ioengine=libaio, iodepth=128
fio 2.0.7
Starting 1 thread
new_data: Laying out IO file(s) (2 file(s) / 40960MB)
Jobs: 1 (f=2): [W] [100.0% done] [0K/451.4M /s] [0 /736  iops] [eta 00m:00s]
new_data: (groupid=0, jobs=1): err= 0: pid=7795
  write: io=40960MB, bw=477553KB/s, iops=811 , runt= 87829msec
    slat (usec): min=94 , max=602062 , avg=1227.51, stdev=4035.39
    clat (usec): min=19 , max=846301 , avg=156351.26, stdev=58249.62
     lat (usec): min=334 , max=847669 , avg=157579.39, stdev=58598.53
    clat percentiles (msec):
     |  1.00th=[   52],  5.00th=[   56], 10.00th=[   60], 20.00th=[  143],
     | 30.00th=[  151], 40.00th=[  157], 50.00th=[  163], 60.00th=[  169],
     | 70.00th=[  176], 80.00th=[  186], 90.00th=[  198], 95.00th=[  208],
     | 99.00th=[  233], 99.50th=[  392], 99.90th=[  766], 99.95th=[  816],
     | 99.99th=[  840]
    bw (KB/s)  : min=74646, max=1340416, per=100.00%, avg=479117.42,
stdev=193506.00
    lat (usec) : 20=0.01%, 500=0.01%, 1000=0.01%
    lat (msec) : 2=0.01%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.18%
    lat (msec) : 100=14.04%, 250=85.06%, 500=0.25%, 750=0.30%, 1000=0.15%
  cpu          : usr=7.82%, sys=46.54%, ctx=21699, majf=0, minf=366
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=99.9%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
     issued    : total=r=0/w=71308/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
  WRITE: io=40960MB, aggrb=477553KB/s, minb=477553KB/s,
maxb=477553KB/s, mint=87829msec, maxt=87829msec

Disk stats (read/write):
  sdb: ios=0/307568, merge=0/9137073, ticks=0/11999322,
in_queue=12008753, util=97.93%





8th: write new data

# fio /tmp/fio.cfg3

new_data2: (g=0): rw=write, bs=128K-1M/128K-1M, ioengine=libaio, iodepth=128
fio 2.0.7
Starting 1 thread
new_data2: Laying out IO file(s) (2 file(s) / 40960MB)
Jobs: 1 (f=2): [W] [100.0% done] [0K/462.5M /s] [0 /794  iops] [eta 00m:00s]
new_data2: (groupid=0, jobs=1): err= 0: pid=7802
  write: io=40960MB, bw=478463KB/s, iops=812 , runt= 87662msec
    slat (usec): min=98 , max=296648 , avg=1227.21, stdev=3443.22
    clat (usec): min=19 , max=810657 , avg=156321.63, stdev=49259.01
     lat (usec): min=191 , max=871270 , avg=157549.46, stdev=49566.46
    clat percentiles (msec):
     |  1.00th=[   65],  5.00th=[   71], 10.00th=[   78], 20.00th=[  141],
     | 30.00th=[  149], 40.00th=[  157], 50.00th=[  161], 60.00th=[  167],
     | 70.00th=[  176], 80.00th=[  184], 90.00th=[  196], 95.00th=[  204],
     | 99.00th=[  227], 99.50th=[  262], 99.90th=[  742], 99.95th=[  783],
     | 99.99th=[  807]
    bw (KB/s)  : min=60077, max=1110528, per=100.00%, avg=479401.66,
stdev=151368.57
    lat (usec) : 20=0.01%, 250=0.01%, 500=0.01%
    lat (msec) : 2=0.01%, 20=0.01%, 50=0.03%, 100=14.49%, 250=84.87%
    lat (msec) : 500=0.31%, 750=0.21%, 1000=0.08%
  cpu          : usr=11.94%, sys=45.09%, ctx=21404, majf=0, minf=365
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=99.9%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
     issued    : total=r=0/w=71182/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
  WRITE: io=40960MB, aggrb=478463KB/s, minb=478463KB/s,
maxb=478463KB/s, mint=87662msec, maxt=87662msec

Disk stats (read/write):
  sdb: ios=0/307644, merge=0/9137272, ticks=0/11908424,
in_queue=11917523, util=97.59%




9th write new data1

# fio /tmp/fio.cfg3

new_data2: (g=0): rw=write, bs=128K-1M/128K-1M, ioengine=libaio, iodepth=128
fio 2.0.7
Starting 1 thread
new_data2: Laying out IO file(s) (2 file(s) / 40960MB)
Jobs: 1 (f=2): [W] [100.0% done] [0K/462.5M /s] [0 /794  iops] [eta 00m:00s]
new_data2: (groupid=0, jobs=1): err= 0: pid=7802
  write: io=40960MB, bw=478463KB/s, iops=812 , runt= 87662msec
    slat (usec): min=98 , max=296648 , avg=1227.21, stdev=3443.22
    clat (usec): min=19 , max=810657 , avg=156321.63, stdev=49259.01
     lat (usec): min=191 , max=871270 , avg=157549.46, stdev=49566.46
    clat percentiles (msec):
     |  1.00th=[   65],  5.00th=[   71], 10.00th=[   78], 20.00th=[  141],
     | 30.00th=[  149], 40.00th=[  157], 50.00th=[  161], 60.00th=[  167],
     | 70.00th=[  176], 80.00th=[  184], 90.00th=[  196], 95.00th=[  204],
     | 99.00th=[  227], 99.50th=[  262], 99.90th=[  742], 99.95th=[  783],
     | 99.99th=[  807]
    bw (KB/s)  : min=60077, max=1110528, per=100.00%, avg=479401.66,
stdev=151368.57
    lat (usec) : 20=0.01%, 250=0.01%, 500=0.01%
    lat (msec) : 2=0.01%, 20=0.01%, 50=0.03%, 100=14.49%, 250=84.87%
    lat (msec) : 500=0.31%, 750=0.21%, 1000=0.08%
  cpu          : usr=11.94%, sys=45.09%, ctx=21404, majf=0, minf=365
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=99.9%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
     issued    : total=r=0/w=71182/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
  WRITE: io=40960MB, aggrb=478463KB/s, minb=478463KB/s,
maxb=478463KB/s, mint=87662msec, maxt=87662msec

Disk stats (read/write):
  sdb: ios=0/307644, merge=0/9137272, ticks=0/11908424,
in_queue=11917523, util=97.59%

10th: write new data2

# fio /tmp/fio.cfg3

new_data4: (g=0): rw=write, bs=128K-1M/128K-1M, ioengine=libaio, iodepth=128
fio 2.0.7
Starting 1 thread
new_data4: Laying out IO file(s) (2 file(s) / 40960MB)
Jobs: 1 (f=2): [W] [100.0% done] [0K/472.6M /s] [0 /766  iops] [eta 00m:00s]
new_data4: (groupid=0, jobs=1): err= 0: pid=7806
  write: io=40960MB, bw=470250KB/s, iops=801 , runt= 89193msec
    slat (usec): min=94 , max=128151 , avg=1243.22, stdev=3417.73
    clat (usec): min=20 , max=867510 , avg=158337.99, stdev=47402.80
     lat (usec): min=154 , max=868036 , avg=159581.83, stdev=47708.86
    clat percentiles (msec):
     |  1.00th=[   60],  5.00th=[   64], 10.00th=[   71], 20.00th=[  143],
     | 30.00th=[  151], 40.00th=[  157], 50.00th=[  163], 60.00th=[  167],
     | 70.00th=[  176], 80.00th=[  186], 90.00th=[  196], 95.00th=[  206],
     | 99.00th=[  227], 99.50th=[  251], 99.90th=[  685], 99.95th=[  742],
     | 99.99th=[  807]
    bw (KB/s)  : min=108456, max=1198592, per=100.00%, avg=471145.09,
stdev=148451.32
    lat (usec) : 50=0.01%, 250=0.01%, 500=0.01%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.01%, 4=0.01%, 10=0.01%, 20=0.02%, 100=10.73%
    lat (msec) : 250=88.72%, 500=0.23%, 750=0.22%, 1000=0.05%
  cpu          : usr=8.04%, sys=46.62%, ctx=22013, majf=0, minf=371
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=99.9%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
     issued    : total=r=0/w=71503/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
  WRITE: io=40960MB, aggrb=470250KB/s, minb=470250KB/s,
maxb=470250KB/s, mint=89193msec, maxt=89193msec

Disk stats (read/write):
  sdb: ios=0/315987, merge=0/9391068, ticks=0/12296959,
in_queue=12303710, util=98.74%




#umount /export/data0


FIO raw device libaio

# fio /tmp/fio.cfg2

sdb: (g=0): rw=write, bs=128K-1M/128K-1M, ioengine=libaio, iodepth=128
fio 2.0.7
Starting 1 thread
Jobs: 1 (f=1): [W] [100.0% done] [0K/0K /s] [0 /0  iops] [eta 00m:00s]
sdb: (groupid=0, jobs=1): err= 0: pid=7573
  write: io=40960MB, bw=459831KB/s, iops=778 , runt= 91214msec
    slat (usec): min=72 , max=185040 , avg=1113.24, stdev=3352.60
    clat (usec): min=20 , max=835519 , avg=141868.68, stdev=44461.62
     lat (usec): min=370 , max=835631 , avg=142982.57, stdev=44779.12
    clat percentiles (msec):
     |  1.00th=[   41],  5.00th=[   45], 10.00th=[  112], 20.00th=[  135],
     | 30.00th=[  141], 40.00th=[  145], 50.00th=[  149], 60.00th=[  153],
     | 70.00th=[  155], 80.00th=[  161], 90.00th=[  169], 95.00th=[  178],
     | 99.00th=[  194], 99.50th=[  217], 99.90th=[  635], 99.95th=[  725],
     | 99.99th=[  791]
    bw (KB/s)  : min=85251, max=1755648, per=100.00%, avg=528790.31,
stdev=207468.01
    lat (usec) : 50=0.01%, 500=0.01%, 750=0.01%
    lat (msec) : 2=0.01%, 10=0.01%, 20=0.02%, 50=9.17%, 100=0.68%
    lat (msec) : 250=89.71%, 500=0.14%, 750=0.25%, 1000=0.02%
  cpu          : usr=10.66%, sys=43.85%, ctx=518516, majf=0, minf=336
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=99.9%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
     issued    : total=r=0/w=70984/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
  WRITE: io=40960MB, aggrb=459831KB/s, minb=459831KB/s,
maxb=459831KB/s, mint=91214msec, maxt=91214msec

Disk stats (read/write):
  sdb: ios=83/307422, merge=0/9178063, ticks=137/11062206,
in_queue=11064868, util=98.34%

# fio /tmp/fio.cfg2

sdb: (groupid=0, jobs=1): err= 0: pid=7614
  write: io=40960MB, bw=460427KB/s, iops=782 , runt= 91096msec
    slat (usec): min=72 , max=127608 , avg=1101.85, stdev=2232.45
    clat (usec): min=20 , max=860645 , avg=140398.70, stdev=47654.98
     lat (usec): min=281 , max=861428 , avg=141501.26, stdev=48002.13
    clat percentiles (msec):
     |  1.00th=[   41],  5.00th=[   44], 10.00th=[   48], 20.00th=[  137],
     | 30.00th=[  143], 40.00th=[  147], 50.00th=[  149], 60.00th=[  153],
     | 70.00th=[  157], 80.00th=[  161], 90.00th=[  167], 95.00th=[  172],
     | 99.00th=[  184], 99.50th=[  194], 99.90th=[  734], 99.95th=[  775],
     | 99.99th=[  816]
    bw (KB/s)  : min=76756, max=1715456, per=100.00%, avg=532564.17,
stdev=226562.34
    lat (usec) : 50=0.01%, 500=0.01%, 750=0.01%, 1000=0.01%
    lat (msec) : 4=0.01%, 10=0.01%, 20=0.01%, 50=11.18%, 100=1.26%
    lat (msec) : 250=87.10%, 500=0.15%, 750=0.21%, 1000=0.07%
  cpu          : usr=8.63%, sys=38.40%, ctx=54233, majf=0, minf=334
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=99.9%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
     issued    : total=r=0/w=71283/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
  WRITE: io=40960MB, aggrb=460426KB/s, minb=460426KB/s,
maxb=460426KB/s, mint=91096msec, maxt=91096msec

Disk stats (read/write):
  sdb: ios=70/304467, merge=0/9137906, ticks=25/10888577,
in_queue=10891095, util=98.12%



# fio /tmp/fio.cfg2

sdb: (g=0): rw=write, bs=128K-1M/128K-1M, ioengine=libaio, iodepth=128
fio 2.0.7
Starting 1 thread
Jobs: 1 (f=1): [W] [100.0% done] [0K/0K /s] [0 /0  iops] [eta 00m:00s]
sdb: (groupid=0, jobs=1): err= 0: pid=7628
  write: io=40960MB, bw=455002KB/s, iops=772 , runt= 92182msec
    slat (usec): min=73 , max=127518 , avg=1102.53, stdev=2294.65
    clat (usec): min=19 , max=826446 , avg=140474.63, stdev=47403.83
     lat (usec): min=139 , max=826793 , avg=141577.85, stdev=47746.51
    clat percentiles (msec):
     |  1.00th=[   43],  5.00th=[   46], 10.00th=[   49], 20.00th=[  137],
     | 30.00th=[  143], 40.00th=[  147], 50.00th=[  151], 60.00th=[  153],
     | 70.00th=[  157], 80.00th=[  161], 90.00th=[  167], 95.00th=[  172],
     | 99.00th=[  186], 99.50th=[  198], 99.90th=[  693], 99.95th=[  742],
     | 99.99th=[  824]
    bw (KB/s)  : min=82507, max=1676032, per=100.00%, avg=533151.29,
stdev=231762.17
    lat (usec) : 20=0.01%, 250=0.01%, 500=0.01%, 1000=0.01%
    lat (msec) : 2=0.01%, 10=0.01%, 50=11.08%, 100=2.14%, 250=86.34%
    lat (msec) : 500=0.15%, 750=0.24%, 1000=0.05%
  cpu          : usr=6.34%, sys=33.41%, ctx=38108, majf=0, minf=334
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=99.9%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
     issued    : total=r=0/w=71252/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
  WRITE: io=40960MB, aggrb=455002KB/s, minb=455002KB/s,
maxb=455002KB/s, mint=92182msec, maxt=92182msec

Disk stats (read/write):
  sdb: ios=72/304474, merge=0/9138038, ticks=27/10887728,
in_queue=10890205, util=98.10%
