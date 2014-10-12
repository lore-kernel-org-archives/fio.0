Return-Path: <Antonio.Jose.Rodrigues.Neto@netapp.com>
From: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: FIO - Client and Server - Suggestion
Date: Sun, 12 Oct 2014 15:26:05 +0000
Message-ID: <D06015CE.528F5%Antonio.Jose.Rodrigues.Neto@netapp.com>
References: <D0599D7A.51F81%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <54345B52.7060306@kernel.dk> <543462BE.3000101@kernel.dk>
 <D059DCD3.52059%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <D059DD71.5205D%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <54346A66.6000509@kernel.dk>
 <40C9565A-0AB9-413A-B342-F5EF247686E5@netapp.com>
 <D05A0624.520A1%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <D05A0920.520A9%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <54349A4E.3080207@kernel.dk>
 <D05A265C.5210C%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <5434B79F.4030700@kernel.dk>
 <D05ABE8A.521B6%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <54354B49.8040307@kernel.dk>
 <D05AC6A2.521D3%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <54354FB7.1010907@kernel.dk>
 <D05D578B.52714%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <54395AAA.2010109@kernel.dk> <54395B3E.3040404@kernel.dk>
In-Reply-To: <54395B3E.3040404@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5F65342D31225848902213FD727895F1@hq.netapp.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>



On 10/11/14, 12:30 PM, "Jens Axboe" <axboe@kernel.dk> wrote:

>On 2014-10-11 10:28, Jens Axboe wrote:
>> On 2014-10-10 07:32, Neto, Antonio Jose Rodrigues wrote:
>>>
>>>
>>> On 10/8/14, 10:52 AM, "Jens Axboe" <axboe@kernel.dk> wrote:
>>>
>>>> On 10/08/2014 08:47 AM, Neto, Antonio Jose Rodrigues wrote:
>>>>>
>>>>>
>>>>> On 10/8/14, 10:33 AM, "Jens Axboe" <axboe@kernel.dk> wrote:
>>>>>
>>>>>> On 10/08/2014 08:13 AM, Neto, Antonio Jose Rodrigues wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 10/8/14, 12:03 AM, "Jens Axboe" <axboe@kernel.dk> wrote:
>>>>>>>
>>>>>>>> On 2014-10-07 21:24, Neto, Antonio Jose Rodrigues wrote:
>>>>>>>>> Nossa Senhora:fio neto$ ./fio --client 10.61.109.151
>>>>>>>>> --remote-config
>>>>>>>>> /root/fio.patch/fio/model
>>>>>>>>> hostname=3Ds1, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
>>>>>>>>> fio=3Dfio-2.1.13-42-g3232,
>>>>>>>>> flags=3D1
>>>>>>>>> <s1> fio: unable to open '/root/fio.patch/fio/model:70?' job file
>>>>>>>>> client: host=3D10.61.109.151 disconnected
>>>>>>>>>
>>>>>>>>> Any ideas?
>>>>>>>>
>>>>>>>> Looks like I just forgot to zero terminate that string. It was
>>>>>>>>never
>>>>>>>> absolute or relative path, just luck and what was in memory. Try
>>>>>>>>and
>>>>>>>> pull again, I committed a fix for that.
>>>>>>>>
>>>>>>>> --
>>>>>>>> Jens Axboe
>>>>>>>>
>>>>>>>> --
>>>>>>>
>>>>>>>
>>>>>>> Hi Jens,
>>>>>>>
>>>>>>> This is neto from Brazil
>>>>>>>
>>>>>>> How are you?
>>>>>>>
>>>>>>> Seems to me it's working with absolute path now with the latest
>>>>>>> commit
>>>>>>> to
>>>>>>> remote-config branch.
>>>>>>
>>>>>> Great, I verified this morning that it was an issue, we'd be
>>>>>> looking at
>>>>>> unitialized/allocated memory without it.
>>>>>>
>>>>>>> But, running the workload from my mac (connected to 2 Linux
>>>>>>> clients) I
>>>>>>> do
>>>>>>> not see the progress.
>>>>>>>
>>>>>>> Nossa Senhora:fiop neto$ ./fio --client 10.61.109.151
>>>>>>>--remote-config
>>>>>>> /root/fiop/model --client 10.61.109.152 --remote-config
>>>>>>> /root/fiop/model
>>>>>>> hostname=3Ds2, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64, fio=3Dfio=
-2.1.13,
>>>>>>> flags=3D1
>>>>>>> hostname=3Ds1, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
>>>>>>> fio=3Dfio-2.1.13-31-g15e3,
>>>>>>> flags=3D1
>>>>>>> <s2> workload: (g=3D0): rw=3Dread, <s1> workload: (g=3D0): rw=3Drea=
d,
>>>>>>> bs=3D64K-64K/64K-64K/64K-64K, bs=3D64K-64K/64K-64K/64K-64K,
>>>>>>> ioengine=3Dlibaio,
>>>>>>> iodepth=3D1
>>>>>>> ioengine=3Dlibaio, iodepth=3D1
>>>>>>> <s2> ...
>>>>>>> <s1> ...
>>>>>>> <s1> Starting <s2> Starting 128 threads
>>>>>>> 128 threads
>>>>>>> Jobs: 0 (f=3D0)
>>>>>>>
>>>>>>> Any idea why?
>>>>>>
>>>>>> Works for me, just tried it from an OSX client. I notice that you
>>>>>> don't
>>>>>> seem to have updated the 's2' fio version, however. So I'd suggest
>>>>>>you
>>>>>> ensure you are running the same thing on all of them.
>>>>>>
>>>>>> --
>>>>>> Jens Axboe
>>>>>>
>>>>>
>>>>>
>>>>> Hi Jens,
>>>>>
>>>>> This is neto from Brazil
>>>>>
>>>>> How are you?
>>>>>
>>>>> With one client and one server it works
>>>>>
>>>>> Nossa Senhora:fiop neto$ ./fio --client 10.61.109.151 --remote-config
>>>>> /root/fiop/model
>>>>> hostname=3Ds1, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
>>>>> fio=3Dfio-2.1.13-31-g15e3,
>>>>> flags=3D1
>>>>> <s1> workload: (g=3D0): rw=3Dread, bs=3D64K-64K/64K-64K/64K-64K,
>>>>> ioengine=3Dlibaio, iodepth=3D1
>>>>> <s1> ...
>>>>> <s1> Starting 128 threads
>>>>> Jobs: 128 (f=3D2048): [R(128)] [4.4% done] [1770M/0K/0K /s] [27.7K/0/=
0
>>>>> iops]
>>>>> [eta 09m:45s]
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> But with one client and 2 servers it does not work (the progress)
>>>>>
>>>>>
>>>>> Nossa Senhora:fiop neto$ ./fio --client 10.61.109.151 --remote-config
>>>>> /root/fiop/model --client 10.61.109.152 --remote-config
>>>>> /root/fiop/model
>>>>> hostname=3Ds2, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
>>>>> fio=3Dfio-2.1.13-31-g15e3,
>>>>> flags=3D1
>>>>> hostname=3Ds1, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
>>>>> fio=3Dfio-2.1.13-31-g15e3,
>>>>> flags=3D1
>>>>> <s2> workload: (g=3D0): rw=3Dread, <s1> workload: (g=3D0): rw=3Dread,
>>>>> bs=3D64K-64K/64K-64K/64K-64K, bs=3D64K-64K/64K-64K/64K-64K,
>>>>> ioengine=3Dlibaio,
>>>>> iodepth=3D1
>>>>> ioengine=3Dlibaio, iodepth=3D1
>>>>> <s2> ...
>>>>> <s1> ...
>>>>> <s2> Starting <s1> Starting 128 threads128 threads
>>>>>
>>>>> Jobs: 0 (f=3D0)
>>>>> Jobs: 0 (f=3D0)
>>>>
>>>> Weird, tested two here, running different jobs, and it summed them up
>>>> fine and reported the ETA line. I will take a look, when time permits.
>>>>
>>>> --
>>>> Jens Axboe
>>>
>>>
>>> Hi Jens,
>>>
>>> This is neto from Brazil
>>>
>>> How are you?
>>>
>>> Just a quick update to help you with the troubleshooting.
>>>
>>>  From latest commit ...
>>>
>>> When I start the fio (from my mac to use 2 Linux servers)
>>>
>>> When the job starts, I do not see anything on the screen only this:
>>>
>>> Nossa Senhora:fio neto$ ./fio --client 10.61.109.151 --remote-config
>>> /root/fio/write --client 10.61.109.152 --remote-config /root/fio/write
>>> hostname=3Ds2, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
>>> fio=3Dfio-2.1.13-58-g3441,
>>> flags=3D1
>>> hostname=3Ds1, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
>>> fio=3Dfio-2.1.13-58-g3441,
>>> flags=3D1
>>> <s2> workload: (g=3D0): rw=3Dwrite, <s1> workload: (g=3D0): rw=3Dwrite,
>>> bs=3D32K-32K/32K-32K/32K-32K, bs=3D32K-32K/32K-32K/32K-32K,
>>>ioengine=3Dlibaio,
>>> iodepth=3D4
>>> ioengine=3Dlibaio, iodepth=3D4
>>> <s2> ...
>>> <s1> ...
>>> <s2> Starting <s1> Starting 64 threads
>>> 64 threads
>>> Jobs: 0 (f=3D0)
>>>
>>>
>>>
>>>
>>> After 60 seconds.... (on my config file)
>>>
>>> I have this:
>>>
>>> workload: (groupid=3D0, jobs=3D64): err=3D 0: pid=3D3644: Fri Oct 10 09=
:31:50
>>> 2014
>>>    mixed: io=3D36714MB, bw=3D1223.2MB/s, iops=3D39141, runt=3D 30015mse=
c
>>>      slat (usec): min=3D10, max=3D308, avg=3D20.57, stdev=3D 5.24
>>>      clat (usec): min=3D265, max=3D295734, avg=3D6496.79, stdev=3D12165=
.17
>>>       lat (usec): min=3D280, max=3D295748, avg=3D6517.62, stdev=3D12165=
.19
>>>      clat percentiles (usec):
>>>       |  1th=3D[  868],  5th=3D[ 1336], 10th=3D[ 1720], 20th=3D[ 2384],=
 30th=3D[
>>> 3024],
>>>       | 40th=3D[ 3696], 50th=3D[ 4448], 60th=3D[ 5344], 70th=3D[ 6496],=
 80th=3D[
>>> 8096],
>>>       | 90th=3D[11968], 95th=3D[15808], 99th=3D[22912], 100th=3D[69120]=
,
>>> 100th=3D[197632],
>>>       | 100th=3D[211968], 100th=3D[254976]
>>>      bw (KB  /s): min=3D 3648, max=3D58112, per=3D1.57%, avg=3D19618.75=
,
>>> stdev=3D4463.44
>>>      lat (usec) : 500=3D0.06%, 750=3D0.45%, 1000=3D1.38%
>>>      lat (msec) : 2=3D12.27%, 4=3D29.89%, 10=3D41.98%, 20=3D12.22%, 50=
=3D1.23%
>>>      lat (msec) : 100=3D0.06%, 250=3D0.45%, 500=3D0.01%
>>>    cpu          : usr=3D0.72%, sys=3D1.15%, ctx=3D1146612, majf=3D0, mi=
nf=3D223
>>>    IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, =
32=3D0.0%,
>>>> =3D64=3D0.0%
>>>       submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%,=
 64=3D0.0%,
>>>> =3D64=3D0.0%
>>>       complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%,=
 64=3D0.0%,
>>>> =3D64=3D0.0%
>>>       issued    : total=3Dr=3D1174844/w=3D0/d=3D0, short=3Dr=3D0/w=3D0/=
d=3D0,
>>> drop=3Dr=3D0/w=3D0/d=3D0
>>>       latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=
=3D4
>>>
>>> Run status group 0 (all jobs):
>>>    MIXED: io=3D36714MB, aggrb=3D1223.2MB/s, minb=3D1223.2MB/s,
>>>maxb=3D1223.2MB/s,
>>> mint=3D30015msec, maxt=3D30015msec
>>> Jobs: 0 (f=3D0)
>>>
>>>
>>>
>>> After 60 seconds.... ( I have this)...
>>>
>>>
>>> <s1>  0 (f=3D0)
>>> workload: (groupid=3D0, jobs=3D64): err=3D 0: pid=3D3607: Fri Oct 10 09=
:32:04
>>> 2014
>>>    mixed: io=3D60243MB, bw=3D1338.6MB/s, iops=3D42833, runt=3D 45006mse=
c
>>>      slat (usec): min=3D10, max=3D1097, avg=3D21.47, stdev=3D 7.11
>>>      clat (usec): min=3D256, max=3D302936, avg=3D5944.33, stdev=3D9841.=
20
>>>       lat (usec): min=3D275, max=3D302957, avg=3D5966.03, stdev=3D9841.=
14
>>>      clat percentiles (usec):
>>>       |  1th=3D[  820],  5th=3D[ 1240], 10th=3D[ 1656], 20th=3D[ 2416],=
 30th=3D[
>>> 3120],
>>>       | 40th=3D[ 4048], 50th=3D[ 4704], 60th=3D[ 5152], 70th=3D[ 6048],=
 80th=3D[
>>> 7328],
>>>       | 90th=3D[10304], 95th=3D[14912], 99th=3D[21888], 100th=3D[25728]=
,
>>> 100th=3D[181248],
>>>       | 100th=3D[207872], 100th=3D[244736]
>>>      bw (KB  /s): min=3D 8256, max=3D53824, per=3D1.57%, avg=3D21476.50=
,
>>> stdev=3D4885.09
>>>      lat (usec) : 500=3D0.07%, 750=3D0.59%, 1000=3D1.81%
>>>      lat (msec) : 2=3D11.88%, 4=3D25.20%, 10=3D49.90%, 20=3D8.94%, 50=
=3D1.29%
>>>      lat (msec) : 100=3D0.04%, 250=3D0.26%, 500=3D0.01%
>>>    cpu          : usr=3D0.78%, sys=3D1.29%, ctx=3D1952463, majf=3D0, mi=
nf=3D219
>>>    IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, =
32=3D0.0%,
>>>> =3D64=3D0.0%
>>>       submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%,=
 64=3D0.0%,
>>>> =3D64=3D0.0%
>>>       complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%,=
 64=3D0.0%,
>>>> =3D64=3D0.0%
>>>       issued    : total=3Dr=3D1927764/w=3D0/d=3D0, short=3Dr=3D0/w=3D0/=
d=3D0,
>>> drop=3Dr=3D0/w=3D0/d=3D0
>>>       latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=
=3D4
>>>
>>> Run status group 0 (all jobs):
>>>    MIXED: io=3D60243MB, aggrb=3D1338.6MB/s, minb=3D1338.6MB/s,
>>>maxb=3D1338.6MB/s,
>>> mint=3D45006msec, maxt=3D45006msec
>>
>> It's weird, like there's some clock source issue. What happens if you
>> add --eta=3Dalways as an option to fio?
>
>Or perhaps try this attached patch.
>
>
>--=20
>Jens Axboe


Hi Jens,

This is neto from Brazil

How are you?

Just applied the patch and it's perfect.

Please see below:

Nossa Senhora:fiop neto$ ./fio --client 10.61.109.151 --remote-config
/root/fiop/iotest --client 10.61.109.152 --remote-config /root/fio/iotest
hostname=3Ds2, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
fio=3Dfio-2.1.13-59-gaa7bc, flags=3D1
hostname=3Ds1, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
fio=3Dfio-2.1.13-59-gaa7bc, flags=3D1
<s2> fio: unable to open '/root/fio/iotest' job file
<s1> workload: (g=3D0): rw=3Dwrite, bs=3D32K-32K/32K-32K/32K-32K,
ioengine=3Dlibaio, iodepth=3D4
<s1> ...
<s1> Starting 64 threads
Jobs: 64 (f=3D1024): [W(64)] [43.3% done] [882.5M/0K/0K /s] [27.6K/0/0 iops=
]
[eta 00m:34s]

Thank you very much,


neto


