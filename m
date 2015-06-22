Return-Path: <gavin.martin@seagate.com>
MIME-Version: 1.0
In-Reply-To: <55859C87.7060502@kernel.dk>
References: <CAFSgMbgY7LHJdaVNb=7Eub=vNohVPemjmSNs_SOFmb8y8eK7Aw@mail.gmail.com>
 <55859A90.1060604@kernel.dk> <55859C87.7060502@kernel.dk>
From: Gavin Martin <gavin.martin@seagate.com>
Date: Mon, 22 Jun 2015 09:41:16 +0100
Message-ID: <CAFSgMbjADZRVV4fYAQeoqXXt2R2G66ebrgKbVJ_o46tGd2EMvw@mail.gmail.com>
Subject: Re: Verify concentrated on first few drives
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 20 June 2015 at 18:01, Jens Axboe <axboe@kernel.dk> wrote:
> On 06/20/2015 12:53 PM, Jens Axboe wrote:
>>
>> On 06/17/2015 10:45 AM, Gavin Martin wrote:
>>>
>>> Hi,
>>>
>>> Running FIO (2.2.8) with the verify option I see that it seems to
>>> concentrate the Reads (from the Verify) on the first few drives and
>>> tails off as you run more drives, as reported in the Disk Stats.
>>>
>>> Is this normal? Does the Verify follow the Round-Robin approach of
>>> normal workloads?
>>>
>>> Config file:-
>>> [global]
>>> ioengine=libaio
>>> iodepth=2
>>> direct=1
>>> runtime=30s
>>> time_based
>>> bs=64K
>>> verify=meta
>>> verify_backlog=32
>>> verify_state_save=0
>>> stonewall
>>> norandommap
>>> atomic=1
>>>
>>> filename=/dev/sdb
>>> filename=/dev/sdc
>>> filename=/dev/sdd
>>> filename=/dev/sde
>>> filename=/dev/sdf
>>> filename=/dev/sdg
>>> filename=/dev/sdh
>>> filename=/dev/sdi
>>> filename=/dev/sdj
>>> filename=/dev/sdk
>>> filename=/dev/sdl
>>> filename=/dev/sdm
>>> filename=/dev/sdn
>>> filename=/dev/sdo
>>> filename=/dev/sdp
>>> filename=/dev/sdq
>>> filename=/dev/sdr
>>> filename=/dev/sds
>>> filename=/dev/sdt
>>> filename=/dev/sdu
>>> filename=/dev/sdv
>>> filename=/dev/sdw
>>> filename=/dev/sdx
>>> filename=/dev/sdy
>>>
>>> [RUN01]
>>> rw=randwrite
>>> do_verify=1
>>>
>>> Output:-
>>> RUN01: (g=0): rw=randwrite, bs=64K-64K/64K-64K/64K-64K,
>>> ioengine=libaio, iodepth=2
>>> fio-2.2.8
>>> Starting 1 process
>>> Jobs: 1 (f=24): [w(1)] [100.0% done] [10199KB/9816KB/0KB /s]
>>> [159/153/0 iops] [eta 00m:00s]
>>> RUN01: (groupid=0, jobs=1): err= 0: pid=22749: Wed Jun 17 10:28:23 2015
>>>    write: io=296000KB, bw=9862.5KB/s, iops=154, runt= 30013msec
>>>      slat (usec): min=10, max=86, avg=32.74, stdev= 8.18
>>>      clat (msec): min=1, max=50, avg=11.80, stdev= 3.94
>>>       lat (msec): min=2, max=50, avg=11.83, stdev= 3.94
>>>      clat percentiles (usec):
>>>       |  1.00th=[ 3120],  5.00th=[ 9408], 10.00th=[10432],
>>> 20.00th=[10816],
>>>       | 30.00th=[10944], 40.00th=[11072], 50.00th=[11200],
>>> 60.00th=[11328],
>>>       | 70.00th=[11456], 80.00th=[11584], 90.00th=[12480],
>>> 95.00th=[19328],
>>>       | 99.00th=[30336], 99.50th=[33024], 99.90th=[44288],
>>> 99.95th=[44800],
>>>       | 99.99th=[50432]
>>>      bw (KB  /s): min= 8431, max=11241, per=100.00%, avg=9876.58,
>>> stdev=453.15
>>>      lat (usec) : 250=6.93%, 500=36.19%, 750=3.56%, 1000=0.17%
>>>      lat (msec) : 2=0.19%, 4=1.19%, 10=4.42%, 20=44.42%, 50=2.91%
>>>      lat (msec) : 100=0.01%
>>>    cpu          : usr=0.68%, sys=0.99%, ctx=9001, majf=0, minf=87
>>>    IO depths    : 1=0.1%, 2=100.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%,
>>> >=64=0.0%
>>>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>>> >=64=0.0%
>>>       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>>> >=64=0.0%
>>>       issued    : total=r=4608/w=4625/d=0, short=r=0/w=0/d=0,
>>> drop=r=0/w=0/d=0
>>>       latency   : target=0, window=0, percentile=100.00%, depth=2
>>>
>>> Run status group 0 (all jobs):
>>>    WRITE: io=296000KB, aggrb=9862KB/s, minb=9862KB/s, maxb=9862KB/s,
>>> mint=30013msec, maxt=30013msec
>>>
>>> Disk stats (read/write):
>>>    sdb: ios=274/192, merge=0/0, ticks=305/2299, in_queue=2604, util=8.65%
>>>    sdc: ios=225/192, merge=0/0, ticks=359/2232, in_queue=2591, util=8.61%
>>>    sdd: ios=191/192, merge=0/0, ticks=222/2278, in_queue=2500, util=8.31%
>>>    sde: ios=217/192, merge=0/0, ticks=509/2235, in_queue=2744, util=9.12%
>>>    sdf: ios=191/192, merge=0/0, ticks=199/2209, in_queue=2408, util=8.01%
>>>    sdg: ios=191/192, merge=0/0, ticks=390/2254, in_queue=2644, util=8.80%
>>>    sdh: ios=191/192, merge=0/0, ticks=122/2339, in_queue=2461, util=8.19%
>>>    sdi: ios=191/192, merge=0/0, ticks=123/2270, in_queue=2393, util=7.95%
>>>    sdj: ios=191/191, merge=0/0, ticks=107/2188, in_queue=2302, util=7.64%
>>>    sdk: ios=191/191, merge=0/0, ticks=82/2168, in_queue=2255, util=7.51%
>>>    sdl: ios=191/191, merge=0/0, ticks=134/2322, in_queue=2456, util=8.17%
>>>    sdm: ios=191/191, merge=0/0, ticks=131/2152, in_queue=2283, util=7.61%
>>>    sdn: ios=191/191, merge=0/0, ticks=127/2288, in_queue=2415, util=8.05%
>>>    sdo: ios=191/191, merge=0/0, ticks=134/2312, in_queue=2446, util=8.13%
>>>    sdp: ios=191/191, merge=0/0, ticks=128/2258, in_queue=2386, util=7.95%
>>>    sdq: ios=191/191, merge=0/0, ticks=292/2296, in_queue=2587, util=8.49%
>>>    sdr: ios=191/191, merge=0/0, ticks=189/2341, in_queue=2530, util=8.27%
>>>    sds: ios=191/191, merge=0/0, ticks=167/2379, in_queue=2545, util=8.47%
>>>    sdt: ios=191/191, merge=0/0, ticks=297/2286, in_queue=2583, util=8.39%
>>>    sdu: ios=191/191, merge=0/0, ticks=284/2182, in_queue=2465, util=8.15%
>>>    sdv: ios=189/191, merge=0/0, ticks=191/2134, in_queue=2325, util=7.72%
>>>    sdw: ios=189/191, merge=0/0, ticks=189/2337, in_queue=2526, util=8.36%
>>>    sdx: ios=189/191, merge=0/0, ticks=122/2291, in_queue=2413, util=8.06%
>>>    sdy: ios=189/191, merge=0/0, ticks=195/2164, in_queue=2359, util=7.86%
>>>
>>> If I increase the iodepth to 8 it gets even worse. The Writes
>>> and utilisation
>>>   has increased, but the last few drives are not going through any
>>> verification:-
>>>
>>> Disk stats (read/write):
>>>    sdb: ios=970/899, merge=0/0, ticks=624/9107, in_queue=9736,
>>> util=32.25%
>>>    sdc: ios=901/899, merge=0/0, ticks=622/8927, in_queue=9549,
>>> util=31.58%
>>>    sdd: ios=899/899, merge=0/0, ticks=679/9151, in_queue=9831,
>>> util=32.60%
>>>    sde: ios=899/899, merge=0/0, ticks=657/8991, in_queue=9652,
>>> util=32.02%
>>>    sdf: ios=899/900, merge=0/0, ticks=591/9044, in_queue=9634,
>>> util=31.96%
>>>    sdg: ios=899/899, merge=0/0, ticks=543/9260, in_queue=9805,
>>> util=32.56%
>>>    sdh: ios=899/899, merge=0/0, ticks=547/9435, in_queue=9982,
>>> util=32.82%
>>>    sdi: ios=899/899, merge=0/0, ticks=488/9365, in_queue=9853,
>>> util=32.68%
>>>    sdj: ios=899/899, merge=0/0, ticks=422/9349, in_queue=9771,
>>> util=32.46%
>>>    sdk: ios=899/899, merge=0/0, ticks=577/9414, in_queue=9991,
>>> util=33.11%
>>>    sdl: ios=899/899, merge=0/0, ticks=507/9199, in_queue=9703,
>>> util=32.19%
>>>    sdm: ios=899/899, merge=0/0, ticks=495/9125, in_queue=9619,
>>> util=31.92%
>>>    sdn: ios=899/899, merge=0/0, ticks=485/9103, in_queue=9587,
>>> util=31.82%
>>>    sdo: ios=899/899, merge=0/0, ticks=501/9240, in_queue=9741,
>>> util=32.23%
>>>    sdp: ios=899/899, merge=0/0, ticks=477/9110, in_queue=9586,
>>> util=31.76%
>>>    sdq: ios=899/899, merge=0/0, ticks=557/9169, in_queue=9726,
>>> util=32.11%
>>>    sdr: ios=899/899, merge=0/0, ticks=545/11115, in_queue=11656,
>>> util=35.65%
>>>    sds: ios=899/899, merge=0/0, ticks=1266/11542, in_queue=12808,
>>> util=36.97%
>>>    sdt: ios=330/899, merge=0/0, ticks=363/9283, in_queue=9644,
>>> util=31.43%
>>>    sdu: ios=0/899, merge=0/0, ticks=0/9211, in_queue=9209, util=30.77%
>>>    sdv: ios=0/899, merge=0/0, ticks=0/9232, in_queue=9231, util=30.86%
>>>    sdw: ios=0/899, merge=0/0, ticks=0/9470, in_queue=9470, util=31.68%
>>>    sdx: ios=0/899, merge=0/0, ticks=0/9342, in_queue=9342, util=31.26%
>>>    sdy: ios=0/898, merge=0/0, ticks=0/9174, in_queue=9181, util=30.74%
>>>
>>> Have I missed an option or have the wrong one in my config file that
>>> could be causing this?
>>
>>
>> That does look very odd. I'll take a look at this. As a temporary
>> work-around, you could have separate jobs for each of the devices. Or
>> try using your original job file, but add:
>>
>> verifysort=0
>>
>> I suspect the latter would also fix it for you.
>
>
> I looked at the code, and it is an artifact of how the verify sorting works.
> It has a builtin check for overlaps, and includes the file in the sorting.
> This means that it will favor the starting files when you do verify like
> this. If the job ran to completion, you would get full verification. Setting
> verifysort=0 should make the time limited backlog verification more fair for
> you, since it'll turn the backlog into FIFO behavior.
>
> --
> Jens Axboe
>

Hi Jens,

Thanks for the reply and the suggestion of using verifysort.

I gave it a try and unfortunately it did not make much difference for me;

Disk stats (read/write):
  sdb: ios=971/904, merge=0/0, ticks=602/9354, in_queue=9954, util=33.02%
  sdc: ios=904/904, merge=0/0, ticks=722/8983, in_queue=9704, util=32.18%
  sdd: ios=903/903, merge=0/0, ticks=678/9246, in_queue=9933, util=32.96%
  sde: ios=903/904, merge=0/0, ticks=610/9269, in_queue=9878, util=32.65%
  sdf: ios=903/904, merge=0/0, ticks=619/9087, in_queue=9703, util=32.19%
  sdg: ios=903/904, merge=0/0, ticks=677/9221, in_queue=9896, util=32.73%
  sdh: ios=903/903, merge=0/0, ticks=545/9333, in_queue=9883, util=32.83%
  sdi: ios=903/903, merge=0/0, ticks=489/9217, in_queue=9710, util=32.26%
  sdj: ios=903/903, merge=0/0, ticks=494/9556, in_queue=10053, util=33.42%
  sdk: ios=903/903, merge=0/0, ticks=482/9509, in_queue=9991, util=33.15%
  sdl: ios=903/903, merge=0/0, ticks=489/9347, in_queue=9836, util=32.64%
  sdm: ios=903/903, merge=0/0, ticks=467/9434, in_queue=9902, util=32.77%
  sdn: ios=903/903, merge=0/0, ticks=541/9252, in_queue=9792, util=32.46%
  sdo: ios=903/903, merge=0/0, ticks=434/9298, in_queue=9729, util=32.28%
  sdp: ios=903/903, merge=0/0, ticks=542/9200, in_queue=9741, util=32.07%
  sdq: ios=903/903, merge=0/0, ticks=519/9233, in_queue=9751, util=32.16%
  sdr: ios=895/903, merge=0/0, ticks=550/9814, in_queue=10363, util=33.86%
  sds: ios=892/903, merge=0/0, ticks=1371/10481, in_queue=11851, util=35.37%
  sdt: ios=769/903, merge=0/0, ticks=642/9403, in_queue=10044, util=32.17%
  sdu: ios=0/903, merge=0/0, ticks=0/9371, in_queue=9370, util=31.29%
  sdv: ios=0/903, merge=0/0, ticks=0/9333, in_queue=9333, util=31.22%
  sdw: ios=0/903, merge=0/0, ticks=0/9553, in_queue=9553, util=31.97%
  sdx: ios=0/903, merge=0/0, ticks=0/9441, in_queue=9440, util=31.60%
  sdy: ios=0/903, merge=0/0, ticks=0/9271, in_queue=9270, util=30.94%

The last 5 drives get ignored for reads. I'll look at separate jobs
for each drive, the problem here is that I would like the script to be
as generic as possible as we use it in different scenarios with a
number of different drive configurations, and the original script
contains a number of different jobs that it runs on all the drives, I
just broke it down to demonstrate the issue.

I had a play with a couple of other settings in the script and found
that if I increase the verify_backlog then it does seem to be a bit
more fair with the read commands. Increasing it from 32 to 256, and I
get the following results;

Disk stats (read/write):
  sdb: ios=921/866, merge=0/0, ticks=577/9022, in_queue=9599, util=31.26%
  sdc: ios=933/866, merge=0/0, ticks=726/8590, in_queue=9315, util=29.76%
  sdd: ios=864/866, merge=0/0, ticks=803/8870, in_queue=9671, util=30.72%
  sde: ios=864/866, merge=0/0, ticks=837/8677, in_queue=9510, util=30.08%
  sdf: ios=864/866, merge=0/0, ticks=828/8827, in_queue=9654, util=30.62%
  sdg: ios=864/866, merge=0/0, ticks=777/8956, in_queue=9731, util=30.87%
  sdh: ios=864/866, merge=0/0, ticks=832/9123, in_queue=9955, util=31.63%
  sdi: ios=864/866, merge=0/0, ticks=825/9255, in_queue=10077, util=31.86%
  sdj: ios=864/865, merge=0/0, ticks=832/9147, in_queue=9995, util=31.70%
  sdk: ios=864/866, merge=0/0, ticks=776/9151, in_queue=9926, util=31.60%
  sdl: ios=864/865, merge=0/0, ticks=842/9018, in_queue=9875, util=31.20%
  sdm: ios=864/866, merge=0/0, ticks=762/8915, in_queue=9676, util=30.67%
  sdn: ios=864/866, merge=0/0, ticks=743/9165, in_queue=9907, util=31.42%
  sdo: ios=864/866, merge=0/0, ticks=806/9206, in_queue=10009, util=31.49%
  sdp: ios=864/866, merge=0/0, ticks=737/8948, in_queue=9684, util=30.70%
  sdq: ios=864/865, merge=0/0, ticks=794/8985, in_queue=9789, util=31.03%
  sdr: ios=864/865, merge=0/0, ticks=640/9645, in_queue=10294, util=32.80%
  sds: ios=864/865, merge=0/0, ticks=696/10969, in_queue=11671, util=34.56%
  sdt: ios=864/865, merge=0/0, ticks=662/9036, in_queue=9703, util=30.79%
  sdu: ios=864/865, merge=0/0, ticks=660/8930, in_queue=9589, util=30.43%
  sdv: ios=864/865, merge=0/0, ticks=712/9084, in_queue=9796, util=31.00%
  sdw: ios=864/865, merge=0/0, ticks=681/9148, in_queue=9828, util=31.18%
  sdx: ios=864/865, merge=0/0, ticks=785/9170, in_queue=9954, util=31.25%
  sdy: ios=864/865, merge=0/0, ticks=797/8822, in_queue=9618, util=30.16%

Obviously this works well for the 24 drives connected. I'll need to
check as we do run a configuration of 84 drives, so might have to
increase further to cope with that number of devices.

I'm assuming that as I increase the backlog more memory would be used
by Fio, is there limits on the values that can go in this field? Or am
I only limited by the Host?

Thanks,

