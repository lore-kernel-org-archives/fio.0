Return-Path: <axboe@kernel.dk>
Message-ID: <543C3423.5050503@kernel.dk>
Date: Mon, 13 Oct 2014 14:20:51 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: FIO - Client and Server - Suggestion
References: <D0599D7A.51F81%Antonio.Jose.Rodrigues.Neto@netapp.com> <40C9565A-0AB9-413A-B342-F5EF247686E5@netapp.com> <D05A0624.520A1%Antonio.Jose.Rodrigues.Neto@netapp.com> <D05A0920.520A9%Antonio.Jose.Rodrigues.Neto@netapp.com> <54349A4E.3080207@kernel.dk> <D05A265C.5210C%Antonio.Jose.Rodrigues.Neto@netapp.com> <5434B79F.4030700@kernel.dk> <D05ABE8A.521B6%Antonio.Jose.Rodrigues.Neto@netapp.com> <54354B49.8040307@kernel.dk> <D05AC6A2.521D3%Antonio.Jose.Rodrigues.Neto@netapp.com> <54354FB7.1010907@kernel.dk> <D05D578B.52714%Antonio.Jose.Rodrigues.Neto@netapp.com> <54395AAA.2010109@kernel.dk> <54395B3E.3040404@kernel.dk> <D06015CE.528F5%Antonio.Jose.Rodrigues.Neto@netapp.com> <543AD2B0.2070307@kernel.dk> <543AD621.90404@kernel.dk> <83C9DF5B-B222-465E-98B4-D2F1D083E710@netapp.com> <543B1C60.5000006@kernel.dk> <D0614B54.529B0%Antonio.Jose.Rodrigues.Neto@netapp.com> <543BE3BF.7070009@kernel.dk> <543BF966.2070806@kernel.dk> <D06191EF.52A8B%Antonio.Jose.Rodrigues.Neto@netapp.com>
In-Reply-To: <D06191EF.52A8B%Antonio.Jose.Rodrigues.Neto@netapp.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-10-13 12:29, Neto, Antonio Jose Rodrigues wrote:
>
>
> On 10/13/14, 12:10 PM, "Jens Axboe" <axboe@kernel.dk> wrote:
>
>> On 2014-10-13 08:37, Jens Axboe wrote:
>>> On 2014-10-13 07:37, Neto, Antonio Jose Rodrigues wrote:
>>>>
>>>>
>>>> On 10/12/14, 8:27 PM, "Jens Axboe" <axboe@kernel.dk> wrote:
>>>>
>>>>> On 2014-10-12 14:28, Neto, Antonio Jose Rodrigues wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>>> On Oct 12, 2014, at 3:26 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>
>>>>>>>> On 2014-10-12 13:12, Jens Axboe wrote:
>>>>>>>>> On 2014-10-12 09:26, Neto, Antonio Jose Rodrigues wrote:
>>>>>>>>> Just applied the patch and it's perfect.
>>>>>>>>>
>>>>>>>>> Please see below:
>>>>>>>>>
>>>>>>>>> Nossa Senhora:fiop neto$ ./fio --client 10.61.109.151
>>>>>>>>> --remote-config
>>>>>>>>> /root/fiop/iotest --client 10.61.109.152 --remote-config
>>>>>>>>> /root/fio/iotest
>>>>>>>>> hostname=s2, be=0, 64-bit, os=Linux, arch=x86-64,
>>>>>>>>> fio=fio-2.1.13-59-gaa7bc, flags=1
>>>>>>>>> hostname=s1, be=0, 64-bit, os=Linux, arch=x86-64,
>>>>>>>>> fio=fio-2.1.13-59-gaa7bc, flags=1
>>>>>>>>> <s2> fio: unable to open '/root/fio/iotest' job file
>>>>>>>>> <s1> workload: (g=0): rw=write, bs=32K-32K/32K-32K/32K-32K,
>>>>>>>>> ioengine=libaio, iodepth=4
>>>>>>>>> <s1> ...
>>>>>>>>> <s1> Starting 64 threads
>>>>>>>>> Jobs: 64 (f=1024): [W(64)] [43.3% done] [882.5M/0K/0K /s]
>>>>>>>>> [27.6K/0/0
>>>>>>>>> iops]
>>>>>>>>> [eta 00m:34s]
>>>>>>>>
>>>>>>>> Great, at least that took care of that issue. As to missing output
>>>>>>>> from
>>>>>>>> one client, I've seen that here before, I will look into that.
>>>>>>>> It's a
>>>>>>>> separate issue.
>>>>>>>
>>>>>>> For the above one, s2 never started since it could not find the
>>>>>>> config
>>>>>>> file you gave it. Have you seen missing final output for cases where
>>>>>>> the jobs did all start? This particular one does not look valid.
>>>>>>>
>>>>>>> --
>>>>>>> Jens Axboe
>>>>>>>
>>>>>>
>>>>>>
>>>>>> Yes. I did.
>>>>>>
>>>>>> I ran using both servers but the output was showing the latest
>>>>>> client -
>>>>>> s2
>>>>>
>>>>> Odd. Can you reproduce and send the output of such a run?
>>>>>
>>>>> --
>>>>> Jens Axboe
>>>>
>>>>
>>>> Hi Jens,
>>>>
>>>> This is neto from Brazil
>>>>
>>>> How are you?
>>>>
>>>> I believe the issue could be formatting....
>>>>
>>>> Also, when running from both clients, seem to me unified_rw_reporting
>>>> is
>>>> not working... I do not have the total for all clients....
>>>
>>> unified_rw_reporting groups reads, writes, and discards into the same
>>> reporting bucket. I'm assuming you mean that group_reporting doesn't
>>> work for multiple connections? That's the option that groups multiple
>>> jobs together for reporting. And yes, that's not supported right now for
>>> multiple connections. But it could be, it's not that different from the
>>> ETA which is grouped as it would be on a local run.
>>
>> Try newest -git. It now outputs an "All clients" summed section, if you
>> have more than 1 client.
>>
>> --
>> Jens Axboe
>
> Hi Jens,
>
> This is neto from Brazil
>
> How are you?
>
> The All Clients session is very nice on the report, but ... Please look
> below (the progress has been splitting in two sessions) why?
>
>
> Nossa Senhora:fio neto$ ./fio --client 10.61.109.151 --remote-config
> /root/fio/write --client 10.61.109.152 --remote-config /root/fio/write
> hostname=s2, be=0, 64-bit, os=Linux, arch=x86-64, fio=fio-2.1.13-64-ga89d,
> flags=1
> hostname=s1, be=0, 64-bit, os=Linux, arch=x86-64, fio=fio-2.1.13-64-ga89d,
> flags=1
> <s2> workload: (g=0): rw=write, <s1> workload: (g=0): rw=write,
> bs=32K-32K/32K-32K/32K-32K, bs=32K-32K/32K-32K/32K-32K, ioengine=libaio,
> iodepth=4
> ioengine=libaio, iodepth=4
> <s2> ...
> <s1> ...
> <s2> Starting <s1> Starting 64 threads
> 64 threads
>>>>>>>>>>>>>>>>>>>       <s2>  128 (f=2048): [W(64)] [66.7% done]
>>>>>>>>>>>>>>>>>>> [1265M/0K/0K /s] [39.6K/0/0 iops] [eta 00m:30s]
> workload: (groupid=0, jobs=64): err= 0: pid=17874: Mon Oct 13 14:27:31 2014
>    mixed: io=17775MB, bw=606116KB/s, iops=18941, runt= 30030msec
>      slat (usec): min=10, max=700, avg=19.76, stdev= 8.97
>      clat (usec): min=2, max=368477, avg=13382.30, stdev=17037.71
>       lat (usec): min=303, max=368498, avg=13402.32, stdev=17037.69
>      clat percentiles (usec):
>       |  1th=[  532],  5th=[  780], 10th=[  996], 20th=[ 1992], 30th=[
> 6432],
>       | 40th=[ 7392], 50th=[ 8384], 60th=[10816], 70th=[14400],
> 80th=[21120],
>       | 90th=[31360], 95th=[37120], 99th=[58112], 100th=[134144],
> 100th=[197632],
>       | 100th=[218112], 100th=[296960]
>      bw (KB  /s): min=  479, max=71040, per=1.57%, avg=9508.74,
> stdev=3605.67
>      lat (usec) : 4=0.01%, 250=0.01%, 500=0.59%, 750=3.93%, 1000=5.57%
>      lat (msec) : 2=9.98%, 4=4.78%, 10=33.23%, 20=20.74%, 50=19.80%
>      lat (msec) : 100=0.75%, 250=0.61%, 500=0.02%
>    cpu          : usr=0.37%, sys=0.57%, ctx=624447, majf=0, minf=164
>    IO depths    : 1=0.1%, 2=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%,
>> =64=0.0%
>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>> =64=0.0%
>       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>> =64=0.0%
>       issued    : total=r=568802/w=0/d=0, short=r=0/w=0/d=0,
> drop=r=0/w=0/d=0
>       latency   : target=0, window=0, percentile=100.00%, depth=4
>
> Run status group 0 (all jobs):
>    MIXED: io=17775MB, aggrb=606116KB/s, minb=606116KB/s, maxb=606116KB/s,
> mint=30030msec, maxt=30030msec
>>>>>>>>>>>>>>>>>>>>>>>     Jobs: 64 (f=1024): [W(64)] [90.0% done] [879.7M/0K/0K
> /s] [27.5K/0/0 iops] [eta 00m:06s]

Should probably halt the ETA for the final output, it's just 
intermingled atm. I'll update that.

-- 
Jens Axboe


