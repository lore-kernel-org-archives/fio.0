Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:37743 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751575AbdHUVNR (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 21 Aug 2017 17:13:17 -0400
Received: by mail-vk0-f46.google.com with SMTP id r199so53779728vke.4
        for <fio@vger.kernel.org>; Mon, 21 Aug 2017 14:13:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB14574C48E4CBA2612091232C8F870@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <DE927C68B458BE418D582EC97927A9287FCAD035@ORSMSX113.amr.corp.intel.com>
 <FA2D9B8E-F7EB-48EA-A05B-E7F365A8767C@netapp.com> <DE927C68B458BE418D582EC97927A9287FCAD0D5@ORSMSX113.amr.corp.intel.com>
 <DE927C68B458BE418D582EC97927A9287FCADCEC@ORSMSX113.amr.corp.intel.com>
 <DE927C68B458BE418D582EC97927A9287FCB1765@ORSMSX113.amr.corp.intel.com> <BN3PR0401MB14574C48E4CBA2612091232C8F870@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 21 Aug 2017 22:12:46 +0100
Message-ID: <CALjAwxgfN6rS8oLuxfVo868bXYdB_Z_EQNzPTjyD-8_AET6b_A@mail.gmail.com>
Subject: Re: IOPS Log Incorrect?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: "Gruher, Joseph R" <joseph.r.gruher@intel.com>, neto from Brazil <Antonio.Jose.Rodrigues.Neto@netapp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Hmm. How do things look with the following?

diff --git a/time.c b/time.c
index edfe779..5e38aad 100644
--- a/time.c
+++ b/time.c
@@ -8,7 +8,7 @@ static unsigned long ns_granularity;

 void timespec_add_msec(struct timespec *ts, unsigned int msec)
 {
-       unsigned long adj_nsec =3D 1000000 * msec;
+       unsigned long adj_nsec =3D 1000000UL * msec;

        ts->tv_nsec +=3D adj_nsec;
        if (adj_nsec >=3D 1000000000) {

Perhaps because msec is an unsigned int and 1000000 fits in an
unsigned int the multiplication will wrap unexpectedly even though the
real answer fits in a (64 bit) unsigned long? Perhaps  adj_nsec needs
to be a uint64_t ?

On 21 August 2017 at 20:33, Jeff Furlong <jeff.furlong@wdc.com> wrote:
> Looks like when we set log_avg_msec=3D4000 or less it works as expected. =
 Also, the logged timestamps are very close to 4000 multiples.  When we set=
 log_avg_msec=3D5000 or more the average is wrong, and also the logged time=
stamp has significant jitter from 5000 multiples.  Are we overflowing the l=
og_avg_msec variable (32bits)?
>
> Regards,
> Jeff
>
> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Beh=
alf Of Gruher, Joseph R
> Sent: Monday, August 21, 2017 11:11 AM
> To: neto from Brazil <Antonio.Jose.Rodrigues.Neto@netapp.com>; fio@vger.k=
ernel.org
> Subject: RE: IOPS Log Incorrect?
>
> Feature seems to work in FIO 2.15 through 2.20.  I couldn't test 2.21 (ke=
eps segfaulting when I try to run after compile) and then the feature is br=
oken in the next release which is 2.99 and still broken in 3.0.
>
>> -----Original Message-----
>> From: Gruher, Joseph R
>> Sent: Thursday, August 17, 2017 5:16 PM
>> To: neto from Brazil <Antonio.Jose.Rodrigues.Neto@netapp.com>;
>> fio@vger.kernel.org
>> Subject: RE: IOPS Log Incorrect?
>>
>> This feature seems to work in FIO 2.15:
>>
>> root@nvmfjt01:/home/nvmf/jrg9/chandler# fio 4k-rr-01-01-128.ini
>> job00: (g=3D0): rw=3Drandread, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dlibaio=
,
>> iodepth=3D128
>> fio-2.15
>> Starting 1 thread
>> Jobs: 1 (f=3D1): [r(1)] [78.8% done] [1804MB/0KB/0KB /s] [462K/0/0 iops]
>> [eta 00m:58s]
>> job00: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D5341: Thu Aug 17 16:57:4=
0 2017
>>   read : io=3D277967MB, bw=3D1789.6MB/s, iops=3D457984, runt=3D155375mse=
c
>>     slat (usec): min=3D0, max=3D95, avg=3D 1.44, stdev=3D 0.91
>>     clat (usec): min=3D61, max=3D5168, avg=3D277.60, stdev=3D118.64
>>      lat (usec): min=3D62, max=3D5170, avg=3D279.12, stdev=3D118.63
>>     clat percentiles (usec):
>>      |  1.00th=3D[  129],  5.00th=3D[  155], 10.00th=3D[  173], 20.00th=
=3D[  197],
>>      | 30.00th=3D[  215], 40.00th=3D[  235], 50.00th=3D[  255], 60.00th=
=3D[  278],
>>      | 70.00th=3D[  306], 80.00th=3D[  342], 90.00th=3D[  406], 95.00th=
=3D[  470],
>>      | 99.00th=3D[  636], 99.50th=3D[  716], 99.90th=3D[ 1176], 99.95th=
=3D[ 2096],
>>      | 99.99th=3D[ 2896]
>>     lat (usec) : 100=3D0.12%, 250=3D47.54%, 500=3D48.64%, 750=3D3.31%, 1=
000=3D0.26%
>>     lat (msec) : 2=3D0.08%, 4=3D0.05%, 10=3D0.01%
>>   cpu          : usr=3D28.43%, sys=3D68.46%, ctx=3D736888, majf=3D0, min=
f=3D816
>>   IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=
=3D0.1%,
>> >=3D64=3D137.3%
>>      submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 6=
4=3D0.0%,
>> >=3D64=3D0.0%
>>      complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 6=
4=3D0.0%,
>> >=3D64=3D0.1%
>>      issued    : total=3Dr=3D71159403/w=3D0/d=3D0, short=3Dr=3D0/w=3D0/d=
=3D0,
>> drop=3Dr=3D0/w=3D0/d=3D0
>>      latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1=
28
>> Run status group 0 (all jobs):
>>    READ: io=3D277967MB, aggrb=3D1789.6MB/s, minb=3D1789.6MB/s,
>> maxb=3D1789.6MB/s, mint=3D155375msec, maxt=3D155375msec Disk stats
>> (read/write):
>>   nvme0n1: ios=3D97645100/0, merge=3D0/0, ticks=3D24504996/0,
>> in_queue=3D24519280, util=3D99.95%
>>
>> root@nvmfjt01:/home/nvmf/jrg9/chandler# cat joe1x128_iops.1.log 20001,
>> 438712, 0, 0 39999, 455544, 0, 0 59999, 457418, 0, 0 79999, 462500, 0,
>> 0 99999, 462728, 0, 0 119999, 462893, 0, 0 139999, 462508, 0, 0
>>
>> root@nvmfjt01:/home/nvmf/jrg9/chandler# cat 4k-rr-01-01-128.ini
>> [global] bs=3D4k rw=3Drandread
>> numjobs=3D1
>> iodepth=3D128
>> thread=3D1
>> ioengine=3Dlibaio
>> direct=3D1
>> ramp_time=3D60
>> norandommap=3D1
>> group_reporting=3D1
>> write_iops_log=3Djoe1x128
>> log_avg_msec=3D20000
>> [job00]
>> filename=3D/dev/nvme0n1
>>
>> root@nvmfjt01:/home/nvmf/jrg9/chandler# uname -a Linux nvmfjt01
>> 4.12.7- 041207-generic #201708160856 SMP Wed Aug 16 12:59:25 UTC 2017
>> x86_64
>> x86_64 x86_64 GNU/Linux
>>
>> root@nvmfjt01:/home/nvmf/jrg9/chandler# fio --version
>> fio-2.15
>>
>> > -----Original Message-----
>> > From: Gruher, Joseph R
>> > Sent: Thursday, August 17, 2017 11:52 AM
>> > To: neto from Brazil <Antonio.Jose.Rodrigues.Neto@netapp.com>;
>> > fio@vger.kernel.org
>> > Subject: RE: IOPS Log Incorrect?
>> >
>> > Sure.  That produces a very large log file where every entry is
>> > <timestamp>, 1, 0, 4096.  See example below.
>> >
>> >
>> > root@nvmfjt01:/home/nvmf/jrg9/chandler# cat 4k-rr-01.ini [global]
>> > bs=3D4k rw=3Drandread
>> > numjobs=3D1
>> > iodepth=3D128
>> > ioengine=3Dlibaio
>> > direct=3D1
>> > runtime=3D3
>> > write_iops_log=3Djoe2
>> >  [job00]
>> > filename=3D/dev/nvme0n1
>> >
>> >
>> > root@nvmfjt01:/home/nvmf/jrg9/chandler# fio 4k-rr-01.ini
>> > job00: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, =
(T)
>> > 4096B- 4096B, ioengine=3Dlibaio, iodepth=3D128
>> > fio-3.0
>> > Starting 1 process
>> > Jobs: 1 (f=3D1): [r(1)][100.0%][r=3D1330MiB/s,w=3D0KiB/s][r=3D340k,w=
=3D0
>> > IOPS][eta 00m:00s]
>> > job00: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D3124: Thu Aug 17 11:49=
:47 2017
>> >    read: IOPS=3D317k, BW=3D1238MiB/s (1298MB/s)(3715MiB/3001msec)
>> >     slat (nsec): min=3D930, max=3D114792, avg=3D2418.97, stdev=3D1970.=
30
>> >     clat (usec): min=3D81, max=3D1210, avg=3D400.22, stdev=3D74.26
>> >      lat (usec): min=3D84, max=3D1220, avg=3D402.75, stdev=3D74.53
>> >     clat percentiles (usec):
>> >      |  1.00th=3D[  310],  5.00th=3D[  326], 10.00th=3D[  334], 20.00t=
h=3D[  343],
>> >      | 30.00th=3D[  355], 40.00th=3D[  363], 50.00th=3D[  375], 60.00t=
h=3D[  392],
>> >      | 70.00th=3D[  420], 80.00th=3D[  461], 90.00th=3D[  494], 95.00t=
h=3D[  529],
>> >      | 99.00th=3D[  660], 99.50th=3D[  734], 99.90th=3D[  857], 99.95t=
h=3D[  889],
>> >      | 99.99th=3D[ 1004]
>> >    bw (  MiB/s): min=3D  960, max=3D 1332, per=3D98.62%, avg=3D1220.89=
,
>> >stdev=3D160.84,
>> > samples=3D5
>> >    iops        : min=3D    1, max=3D    1, avg=3D 1.00, stdev=3D 0.00,=
 samples=3D951085
>> >   lat (usec)   : 100=3D0.01%, 250=3D0.05%, 500=3D91.24%, 750=3D8.28%, =
1000=3D0.42%
>> >   lat (msec)   : 2=3D0.01%
>> >   cpu          : usr=3D22.13%, sys=3D77.87%, ctx=3D61, majf=3D0, minf=
=3D3234
>> >   IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=
=3D0.1%,
>> >=3D64=3D99.9%
>> >      submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%,=
 64=3D0.0%,
>> > >=3D64=3D0.0%
>> >      complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%,
>> > 64=3D0.0%,
>> > >=3D64=3D0.1%
>> >      issued rwt: total=3D951085,0,0, short=3D0,0,0, dropped=3D0,0,0
>> >      latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=
=3D128
>> > Run status group 0 (all jobs):
>> >    READ: bw=3D1238MiB/s (1298MB/s), 1238MiB/s-1238MiB/s (1298MB/s-
>> > 1298MB/s), io=3D3715MiB (3896MB), run=3D3001-3001msec Disk stats
>> > (read/write):
>> >   nvme0n1: ios=3D951085/0, merge=3D0/0, ticks=3D121124/0, in_queue=3D1=
20984,
>> > util=3D92.50%
>> >
>> >
>> > root@nvmfjt01:/home/nvmf/jrg9/chandler# head -n 10 joe2_iops.1.log
>> > 2, 1, 0,
>> > 4096 2, 1, 0, 4096 2, 1, 0, 4096 2, 1, 0, 4096 2, 1, 0, 4096 2, 1,
>> > 0,
>> > 4096 2, 1, 0,
>> > 4096 2, 1, 0, 4096 2, 1, 0, 4096 2, 1, 0, 4096
>> >
>> >
>> > root@nvmfjt01:/home/nvmf/jrg9/chandler# tail -n 10 joe2_iops.1.log
>> > 3000, 1, 0, 4096 3000, 1, 0, 4096 3000, 1, 0, 4096 3000, 1, 0, 4096
>> > 3000, 1, 0, 4096 3000, 1, 0, 4096 3000, 1, 0, 4096 3000, 1, 0, 4096
>> > 3000, 1, 0, 4096 3000, 1, 0,
>> > 4096
>> >
>> >
>> > Thanks,
>> > Joe
>> >
>> > > -----Original Message-----
>> > > From: neto from Brazil
>> > > [mailto:Antonio.Jose.Rodrigues.Neto@netapp.com]
>> > > Sent: Thursday, August 17, 2017 11:47 AM
>> > > To: Gruher, Joseph R <joseph.r.gruher@intel.com>;
>> > > fio@vger.kernel.org
>> > > Subject: Re: IOPS Log Incorrect?
>> > >
>> > > Hi Joseph,
>> > >
>> > > This is neto from Brazil
>> > >
>> > > How are you?
>> > >
>> > > Could you try to re-run without log_avg_msec=3D5000?
>> > >
>> > > Thanks,
>> > >
>> > > neto
>> > >
>> > > On 8/17/17, 2:38 PM, "fio-owner@vger.kernel.org on behalf of
>> > > Gruher, Joseph R" <fio-owner@vger.kernel.org on behalf of
>> > joseph.r.gruher@intel.com> wrote:
>> > >
>> > >     Hi, I'm using FIO 3.0 on Ubuntu 16.10 with 4.12.7 kernel (also
>> > > reproduced problem with default 4.8.0-59 kernel). I'm running a
>> > > 4KB random IO pattern against an Intel P3700 400GB NVMe SSD. I'm
>> > > trying to view the IOPS/BW over time using the write_bw_log and
>> > > write_iops_log parameters. FIO is writing the logs but the values
>> > > in the logs don't align with the summary for the run.  Here's a
>> > > simple example.  Notice FIO reports 398K IOPS for the run overall,
>> > > but the IOPS log file shows 383K for the first entry and then
>> > > values around 56K for the rest of the run, so
>> > one or the other must be incorrect (presumably the log file).
>> > > The bandwidth log has a similar issue.
>> > >
>> > >
>> > >     root@nvmfjt01:/home/nvmf/jrg9/chandler# cat 4k-rr-01.ini
>> > >     [global]
>> > >     bs=3D4k
>> > >     rw=3Drandread
>> > >     numjobs=3D1
>> > >     iodepth=3D128
>> > >     ioengine=3Dlibaio
>> > >     direct=3D1
>> > >     runtime=3D30
>> > >     write_iops_log=3Djoe2
>> > >     log_avg_msec=3D5000
>> > >     [job00]
>> > >     filename=3D/dev/nvme0n1
>> > >
>> > >
>> > >     root@nvmfjt01:/home/nvmf/jrg9/chandler# fio 4k-rr-01.ini
>> > >     job00: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W)
>> > > 4096B-4096B,
>> > > (T) 4096B-4096B, ioengine=3Dlibaio, iodepth=3D128
>> > >     fio-3.0
>> > >     Starting 1 process
>> > >     Jobs: 1 (f=3D1): [r(1)][100.0%][r=3D1595MiB/s,w=3D0KiB/s][r=3D40=
8k,w=3D0
>> > > IOPS][eta 00m:00s]
>> > >     job00: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2767: Thu Aug 17=
 10:34:09 2017
>> > >     read: IOPS=3D398k, BW=3D1555MiB/s (1630MB/s)(45.6GiB/30001msec)
>> > >     slat (nsec): min=3D824, max=3D117534, avg=3D1682.36, stdev=3D129=
0.45
>> > >     clat (usec): min=3D96, max=3D2899, avg=3D319.29, stdev=3D69.36
>> > >     lat (usec): min=3D97, max=3D2900, avg=3D321.08, stdev=3D69.39
>> > >     clat percentiles (usec):
>> > >     | 1.00th=3D[ 221], 5.00th=3D[ 243], 10.00th=3D[ 255], 20.00th=3D=
[ 269],
>> > >     | 30.00th=3D[ 281], 40.00th=3D[ 289], 50.00th=3D[ 302], 60.00th=
=3D[ 318],
>> > >     | 70.00th=3D[ 334], 80.00th=3D[ 363], 90.00th=3D[ 412], 95.00th=
=3D[ 453],
>> > >     | 99.00th=3D[ 562], 99.50th=3D[ 611], 99.90th=3D[ 725], 99.95th=
=3D[ 775],
>> > >     | 99.99th=3D[ 906]
>> > >     bw ( MiB/s): min=3D 1081, max=3D 1594, per=3D99.96%, avg=3D1554.=
11,
>> > > stdev=3D68.33,
>> > > samples=3D59
>> > >     iops : min=3D56293, max=3D383046, avg=3D65603.75, stdev=3D54419.=
77,
>> > samples=3D36
>> > >     lat (usec) : 100=3D0.01%, 250=3D7.73%, 500=3D89.82%, 750=3D2.38%=
, 1000=3D0.07%
>> > >     lat (msec) : 2=3D0.01%, 4=3D0.01%
>> > >     cpu : usr=3D32.51%, sys=3D67.50%, ctx=3D105, majf=3D0, minf=3D15=
3
>> > >     IO depths : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 3=
2=3D0.1%,
>> > > >=3D64=3D100.0%
>> > >     submit : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 6=
4=3D0.0%,
>> > >=3D64=3D0.0%
>> > >     complete : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%,
>> > >64=3D0.0%,
>> > > >=3D64=3D0.1%
>> > >     issued rwt: total=3D11941208,0,0, short=3D0,0,0, dropped=3D0,0,0
>> > >     latency : target=3D0, window=3D0, percentile=3D100.00%, depth=3D=
128
>> > >     Run status group 0 (all jobs):
>> > >     READ: bw=3D1555MiB/s (1630MB/s), 1555MiB/s-1555MiB/s (1630MB/s-
>> > > 1630MB/s), io=3D45.6GiB (48.9GB), run=3D30001-30001msec
>> > >     Disk stats (read/write):
>> > >     nvme0n1: ios=3D11890654/0, merge=3D0/0, ticks=3D1923076/0,
>> > > in_queue=3D1925204, util=3D99.69%
>> > >
>> > >
>> > >     root@nvmfjt01:/home/nvmf/jrg9/chandler# cat joe2_iops.1.log
>> > >     5000, 383046, 0, 0
>> > >     10640, 56412, 0, 0
>> > >     15576, 56410, 0, 0
>> > >     20511, 56425, 0, 0
>> > >     25446, 56394, 0, 0
>> > >     30040, 57131, 0, 0
>> > >
>> > >
>> > >     root@nvmfjt01:/home/nvmf/jrg9/chandler# fio --version
>> > >     fio-3.0
>> > >
>> > >
>> > >     root@nvmfjt01:/home/nvmf/jrg9/chandler# uname -a
>> > >     Linux nvmfjt01 4.12.7-041207-generic #201708160856 SMP Wed Aug
>> > > 16
>> > > 12:59:25 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
>> > >
>> > >     --
>> > >     To unsubscribe from this list: send the line "unsubscribe fio" i=
n
>> > >     the body of a message to majordomo@vger.kernel.org
>> > >     More majordomo info at
>> > > http://vger.kernel.org/majordomo-info.html
>> > >
>
>   {.n +       +%  lzwm  b =EB=A7=B2  r  y   {ay  =CA=87=DA=99 ,j   f   h =
  z   w       j:+v   w j m         zZ+     =DD=A2j"  ! i



--=20
Sitsofe | http://sucs.org/~sits/
