Return-Path: <Antonio.Jose.Rodrigues.Neto@netapp.com>
From: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: FIO - Client and Server - Suggestion
Date: Mon, 13 Oct 2014 18:29:03 +0000
Message-ID: <D06191EF.52A8B%Antonio.Jose.Rodrigues.Neto@netapp.com>
References: <D0599D7A.51F81%Antonio.Jose.Rodrigues.Neto@netapp.com>
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
 <D06015CE.528F5%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <543AD2B0.2070307@kernel.dk> <543AD621.90404@kernel.dk>
 <83C9DF5B-B222-465E-98B4-D2F1D083E710@netapp.com>
 <543B1C60.5000006@kernel.dk>
 <D0614B54.529B0%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <543BE3BF.7070009@kernel.dk> <543BF966.2070806@kernel.dk>
In-Reply-To: <543BF966.2070806@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1A6A712ABBF27C4DA17CC85BC87E7B8C@hq.netapp.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>



On 10/13/14, 12:10 PM, "Jens Axboe" <axboe@kernel.dk> wrote:

>On 2014-10-13 08:37, Jens Axboe wrote:
>> On 2014-10-13 07:37, Neto, Antonio Jose Rodrigues wrote:
>>>
>>>
>>> On 10/12/14, 8:27 PM, "Jens Axboe" <axboe@kernel.dk> wrote:
>>>
>>>> On 2014-10-12 14:28, Neto, Antonio Jose Rodrigues wrote:
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>> On Oct 12, 2014, at 3:26 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>
>>>>>>> On 2014-10-12 13:12, Jens Axboe wrote:
>>>>>>>> On 2014-10-12 09:26, Neto, Antonio Jose Rodrigues wrote:
>>>>>>>> Just applied the patch and it's perfect.
>>>>>>>>
>>>>>>>> Please see below:
>>>>>>>>
>>>>>>>> Nossa Senhora:fiop neto$ ./fio --client 10.61.109.151
>>>>>>>> --remote-config
>>>>>>>> /root/fiop/iotest --client 10.61.109.152 --remote-config
>>>>>>>> /root/fio/iotest
>>>>>>>> hostname=3Ds2, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
>>>>>>>> fio=3Dfio-2.1.13-59-gaa7bc, flags=3D1
>>>>>>>> hostname=3Ds1, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
>>>>>>>> fio=3Dfio-2.1.13-59-gaa7bc, flags=3D1
>>>>>>>> <s2> fio: unable to open '/root/fio/iotest' job file
>>>>>>>> <s1> workload: (g=3D0): rw=3Dwrite, bs=3D32K-32K/32K-32K/32K-32K,
>>>>>>>> ioengine=3Dlibaio, iodepth=3D4
>>>>>>>> <s1> ...
>>>>>>>> <s1> Starting 64 threads
>>>>>>>> Jobs: 64 (f=3D1024): [W(64)] [43.3% done] [882.5M/0K/0K /s]
>>>>>>>>[27.6K/0/0
>>>>>>>> iops]
>>>>>>>> [eta 00m:34s]
>>>>>>>
>>>>>>> Great, at least that took care of that issue. As to missing output
>>>>>>> from
>>>>>>> one client, I've seen that here before, I will look into that.
>>>>>>>It's a
>>>>>>> separate issue.
>>>>>>
>>>>>> For the above one, s2 never started since it could not find the
>>>>>>config
>>>>>> file you gave it. Have you seen missing final output for cases where
>>>>>> the jobs did all start? This particular one does not look valid.
>>>>>>
>>>>>> --
>>>>>> Jens Axboe
>>>>>>
>>>>>
>>>>>
>>>>> Yes. I did.
>>>>>
>>>>> I ran using both servers but the output was showing the latest
>>>>>client -
>>>>> s2
>>>>
>>>> Odd. Can you reproduce and send the output of such a run?
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
>>> I believe the issue could be formatting....
>>>
>>> Also, when running from both clients, seem to me unified_rw_reporting
>>>is
>>> not working... I do not have the total for all clients....
>>
>> unified_rw_reporting groups reads, writes, and discards into the same
>> reporting bucket. I'm assuming you mean that group_reporting doesn't
>> work for multiple connections? That's the option that groups multiple
>> jobs together for reporting. And yes, that's not supported right now for
>> multiple connections. But it could be, it's not that different from the
>> ETA which is grouped as it would be on a local run.
>
>Try newest -git. It now outputs an "All clients" summed section, if you
>have more than 1 client.
>
>--=20
>Jens Axboe

Hi Jens,

This is neto from Brazil

How are you?

The All Clients session is very nice on the report, but ... Please look
below (the progress has been splitting in two sessions) why?


Nossa Senhora:fio neto$ ./fio --client 10.61.109.151 --remote-config
/root/fio/write --client 10.61.109.152 --remote-config /root/fio/write
hostname=3Ds2, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64, fio=3Dfio-2.1.13-=
64-ga89d,
flags=3D1
hostname=3Ds1, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64, fio=3Dfio-2.1.13-=
64-ga89d,
flags=3D1
<s2> workload: (g=3D0): rw=3Dwrite, <s1> workload: (g=3D0): rw=3Dwrite,
bs=3D32K-32K/32K-32K/32K-32K, bs=3D32K-32K/32K-32K/32K-32K, ioengine=3Dliba=
io,
iodepth=3D4
ioengine=3Dlibaio, iodepth=3D4
<s2> ...
<s1> ...
<s2> Starting <s1> Starting 64 threads
64 threads
>>>>>>>>>>>>>>>>>>      <s2>  128 (f=3D2048): [W(64)] [66.7% done]
>>>>>>>>>>>>>>>>>>[1265M/0K/0K /s] [39.6K/0/0 iops] [eta 00m:30s]
workload: (groupid=3D0, jobs=3D64): err=3D 0: pid=3D17874: Mon Oct 13 14:27=
:31 2014
  mixed: io=3D17775MB, bw=3D606116KB/s, iops=3D18941, runt=3D 30030msec
    slat (usec): min=3D10, max=3D700, avg=3D19.76, stdev=3D 8.97
    clat (usec): min=3D2, max=3D368477, avg=3D13382.30, stdev=3D17037.71
     lat (usec): min=3D303, max=3D368498, avg=3D13402.32, stdev=3D17037.69
    clat percentiles (usec):
     |  1th=3D[  532],  5th=3D[  780], 10th=3D[  996], 20th=3D[ 1992], 30th=
=3D[
6432],
     | 40th=3D[ 7392], 50th=3D[ 8384], 60th=3D[10816], 70th=3D[14400],
80th=3D[21120],
     | 90th=3D[31360], 95th=3D[37120], 99th=3D[58112], 100th=3D[134144],
100th=3D[197632],
     | 100th=3D[218112], 100th=3D[296960]
    bw (KB  /s): min=3D  479, max=3D71040, per=3D1.57%, avg=3D9508.74,
stdev=3D3605.67
    lat (usec) : 4=3D0.01%, 250=3D0.01%, 500=3D0.59%, 750=3D3.93%, 1000=3D5=
.57%
    lat (msec) : 2=3D9.98%, 4=3D4.78%, 10=3D33.23%, 20=3D20.74%, 50=3D19.80=
%
    lat (msec) : 100=3D0.75%, 250=3D0.61%, 500=3D0.02%
  cpu          : usr=3D0.37%, sys=3D0.57%, ctx=3D624447, majf=3D0, minf=3D1=
64
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%,
>=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,
>=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,
>=3D64=3D0.0%
     issued    : total=3Dr=3D568802/w=3D0/d=3D0, short=3Dr=3D0/w=3D0/d=3D0,
drop=3Dr=3D0/w=3D0/d=3D0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D4

Run status group 0 (all jobs):
  MIXED: io=3D17775MB, aggrb=3D606116KB/s, minb=3D606116KB/s, maxb=3D606116=
KB/s,
mint=3D30030msec, maxt=3D30030msec
>>>>>>>>>>>>>>>>>>>>>>    Jobs: 64 (f=3D1024): [W(64)] [90.0% done] [879.7M=
/0K/0K
/s] [27.5K/0/0 iops] [eta 00m:06s]



