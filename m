Return-Path: <axboe@kernel.dk>
Message-ID: <54395B3E.3040404@kernel.dk>
Date: Sat, 11 Oct 2014 10:30:54 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: FIO - Client and Server - Suggestion
References: <D0599D7A.51F81%Antonio.Jose.Rodrigues.Neto@netapp.com> <54345B52.7060306@kernel.dk> <543462BE.3000101@kernel.dk> <D059DCD3.52059%Antonio.Jose.Rodrigues.Neto@netapp.com> <D059DD71.5205D%Antonio.Jose.Rodrigues.Neto@netapp.com> <54346A66.6000509@kernel.dk> <40C9565A-0AB9-413A-B342-F5EF247686E5@netapp.com> <D05A0624.520A1%Antonio.Jose.Rodrigues.Neto@netapp.com> <D05A0920.520A9%Antonio.Jose.Rodrigues.Neto@netapp.com> <54349A4E.3080207@kernel.dk> <D05A265C.5210C%Antonio.Jose.Rodrigues.Neto@netapp.com> <5434B79F.4030700@kernel.dk> <D05ABE8A.521B6%Antonio.Jose.Rodrigues.Neto@netapp.com> <54354B49.8040307@kernel.dk> <D05AC6A2.521D3%Antonio.Jose.Rodrigues.Neto@netapp.com> <54354FB7.1010907@kernel.dk> <D05D578B.52714%Antonio.Jose.Rodrigues.Neto@netapp.com> <54395AAA.2010109@kernel.dk>
In-Reply-To: <54395AAA.2010109@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------020000000505070005000302"
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------020000000505070005000302
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 2014-10-11 10:28, Jens Axboe wrote:
> On 2014-10-10 07:32, Neto, Antonio Jose Rodrigues wrote:
>>
>>
>> On 10/8/14, 10:52 AM, "Jens Axboe" <axboe@kernel.dk> wrote:
>>
>>> On 10/08/2014 08:47 AM, Neto, Antonio Jose Rodrigues wrote:
>>>>
>>>>
>>>> On 10/8/14, 10:33 AM, "Jens Axboe" <axboe@kernel.dk> wrote:
>>>>
>>>>> On 10/08/2014 08:13 AM, Neto, Antonio Jose Rodrigues wrote:
>>>>>>
>>>>>>
>>>>>> On 10/8/14, 12:03 AM, "Jens Axboe" <axboe@kernel.dk> wrote:
>>>>>>
>>>>>>> On 2014-10-07 21:24, Neto, Antonio Jose Rodrigues wrote:
>>>>>>>> Nossa Senhora:fio neto$ ./fio --client 10.61.109.151
>>>>>>>> --remote-config
>>>>>>>> /root/fio.patch/fio/model
>>>>>>>> hostname=s1, be=0, 64-bit, os=Linux, arch=x86-64,
>>>>>>>> fio=fio-2.1.13-42-g3232,
>>>>>>>> flags=1
>>>>>>>> <s1> fio: unable to open '/root/fio.patch/fio/model:70?' job file
>>>>>>>> client: host=10.61.109.151 disconnected
>>>>>>>>
>>>>>>>> Any ideas?
>>>>>>>
>>>>>>> Looks like I just forgot to zero terminate that string. It was never
>>>>>>> absolute or relative path, just luck and what was in memory. Try and
>>>>>>> pull again, I committed a fix for that.
>>>>>>>
>>>>>>> --
>>>>>>> Jens Axboe
>>>>>>>
>>>>>>> --
>>>>>>
>>>>>>
>>>>>> Hi Jens,
>>>>>>
>>>>>> This is neto from Brazil
>>>>>>
>>>>>> How are you?
>>>>>>
>>>>>> Seems to me it's working with absolute path now with the latest
>>>>>> commit
>>>>>> to
>>>>>> remote-config branch.
>>>>>
>>>>> Great, I verified this morning that it was an issue, we'd be
>>>>> looking at
>>>>> unitialized/allocated memory without it.
>>>>>
>>>>>> But, running the workload from my mac (connected to 2 Linux
>>>>>> clients) I
>>>>>> do
>>>>>> not see the progress.
>>>>>>
>>>>>> Nossa Senhora:fiop neto$ ./fio --client 10.61.109.151 --remote-config
>>>>>> /root/fiop/model --client 10.61.109.152 --remote-config
>>>>>> /root/fiop/model
>>>>>> hostname=s2, be=0, 64-bit, os=Linux, arch=x86-64, fio=fio-2.1.13,
>>>>>> flags=1
>>>>>> hostname=s1, be=0, 64-bit, os=Linux, arch=x86-64,
>>>>>> fio=fio-2.1.13-31-g15e3,
>>>>>> flags=1
>>>>>> <s2> workload: (g=0): rw=read, <s1> workload: (g=0): rw=read,
>>>>>> bs=64K-64K/64K-64K/64K-64K, bs=64K-64K/64K-64K/64K-64K,
>>>>>> ioengine=libaio,
>>>>>> iodepth=1
>>>>>> ioengine=libaio, iodepth=1
>>>>>> <s2> ...
>>>>>> <s1> ...
>>>>>> <s1> Starting <s2> Starting 128 threads
>>>>>> 128 threads
>>>>>> Jobs: 0 (f=0)
>>>>>>
>>>>>> Any idea why?
>>>>>
>>>>> Works for me, just tried it from an OSX client. I notice that you
>>>>> don't
>>>>> seem to have updated the 's2' fio version, however. So I'd suggest you
>>>>> ensure you are running the same thing on all of them.
>>>>>
>>>>> --
>>>>> Jens Axboe
>>>>>
>>>>
>>>>
>>>> Hi Jens,
>>>>
>>>> This is neto from Brazil
>>>>
>>>> How are you?
>>>>
>>>> With one client and one server it works
>>>>
>>>> Nossa Senhora:fiop neto$ ./fio --client 10.61.109.151 --remote-config
>>>> /root/fiop/model
>>>> hostname=s1, be=0, 64-bit, os=Linux, arch=x86-64,
>>>> fio=fio-2.1.13-31-g15e3,
>>>> flags=1
>>>> <s1> workload: (g=0): rw=read, bs=64K-64K/64K-64K/64K-64K,
>>>> ioengine=libaio, iodepth=1
>>>> <s1> ...
>>>> <s1> Starting 128 threads
>>>> Jobs: 128 (f=2048): [R(128)] [4.4% done] [1770M/0K/0K /s] [27.7K/0/0
>>>> iops]
>>>> [eta 09m:45s]
>>>>
>>>>
>>>>
>>>>
>>>>
>>>> But with one client and 2 servers it does not work (the progress)
>>>>
>>>>
>>>> Nossa Senhora:fiop neto$ ./fio --client 10.61.109.151 --remote-config
>>>> /root/fiop/model --client 10.61.109.152 --remote-config
>>>> /root/fiop/model
>>>> hostname=s2, be=0, 64-bit, os=Linux, arch=x86-64,
>>>> fio=fio-2.1.13-31-g15e3,
>>>> flags=1
>>>> hostname=s1, be=0, 64-bit, os=Linux, arch=x86-64,
>>>> fio=fio-2.1.13-31-g15e3,
>>>> flags=1
>>>> <s2> workload: (g=0): rw=read, <s1> workload: (g=0): rw=read,
>>>> bs=64K-64K/64K-64K/64K-64K, bs=64K-64K/64K-64K/64K-64K,
>>>> ioengine=libaio,
>>>> iodepth=1
>>>> ioengine=libaio, iodepth=1
>>>> <s2> ...
>>>> <s1> ...
>>>> <s2> Starting <s1> Starting 128 threads128 threads
>>>>
>>>> Jobs: 0 (f=0)
>>>> Jobs: 0 (f=0)
>>>
>>> Weird, tested two here, running different jobs, and it summed them up
>>> fine and reported the ETA line. I will take a look, when time permits.
>>>
>>> --
>>> Jens Axboe
>>
>>
>> Hi Jens,
>>
>> This is neto from Brazil
>>
>> How are you?
>>
>> Just a quick update to help you with the troubleshooting.
>>
>>  From latest commit ...
>>
>> When I start the fio (from my mac to use 2 Linux servers)
>>
>> When the job starts, I do not see anything on the screen only this:
>>
>> Nossa Senhora:fio neto$ ./fio --client 10.61.109.151 --remote-config
>> /root/fio/write --client 10.61.109.152 --remote-config /root/fio/write
>> hostname=s2, be=0, 64-bit, os=Linux, arch=x86-64,
>> fio=fio-2.1.13-58-g3441,
>> flags=1
>> hostname=s1, be=0, 64-bit, os=Linux, arch=x86-64,
>> fio=fio-2.1.13-58-g3441,
>> flags=1
>> <s2> workload: (g=0): rw=write, <s1> workload: (g=0): rw=write,
>> bs=32K-32K/32K-32K/32K-32K, bs=32K-32K/32K-32K/32K-32K, ioengine=libaio,
>> iodepth=4
>> ioengine=libaio, iodepth=4
>> <s2> ...
>> <s1> ...
>> <s2> Starting <s1> Starting 64 threads
>> 64 threads
>> Jobs: 0 (f=0)
>>
>>
>>
>>
>> After 60 seconds.... (on my config file)
>>
>> I have this:
>>
>> workload: (groupid=0, jobs=64): err= 0: pid=3644: Fri Oct 10 09:31:50
>> 2014
>>    mixed: io=36714MB, bw=1223.2MB/s, iops=39141, runt= 30015msec
>>      slat (usec): min=10, max=308, avg=20.57, stdev= 5.24
>>      clat (usec): min=265, max=295734, avg=6496.79, stdev=12165.17
>>       lat (usec): min=280, max=295748, avg=6517.62, stdev=12165.19
>>      clat percentiles (usec):
>>       |  1th=[  868],  5th=[ 1336], 10th=[ 1720], 20th=[ 2384], 30th=[
>> 3024],
>>       | 40th=[ 3696], 50th=[ 4448], 60th=[ 5344], 70th=[ 6496], 80th=[
>> 8096],
>>       | 90th=[11968], 95th=[15808], 99th=[22912], 100th=[69120],
>> 100th=[197632],
>>       | 100th=[211968], 100th=[254976]
>>      bw (KB  /s): min= 3648, max=58112, per=1.57%, avg=19618.75,
>> stdev=4463.44
>>      lat (usec) : 500=0.06%, 750=0.45%, 1000=1.38%
>>      lat (msec) : 2=12.27%, 4=29.89%, 10=41.98%, 20=12.22%, 50=1.23%
>>      lat (msec) : 100=0.06%, 250=0.45%, 500=0.01%
>>    cpu          : usr=0.72%, sys=1.15%, ctx=1146612, majf=0, minf=223
>>    IO depths    : 1=0.1%, 2=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%,
>>> =64=0.0%
>>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>>> =64=0.0%
>>       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>>> =64=0.0%
>>       issued    : total=r=1174844/w=0/d=0, short=r=0/w=0/d=0,
>> drop=r=0/w=0/d=0
>>       latency   : target=0, window=0, percentile=100.00%, depth=4
>>
>> Run status group 0 (all jobs):
>>    MIXED: io=36714MB, aggrb=1223.2MB/s, minb=1223.2MB/s, maxb=1223.2MB/s,
>> mint=30015msec, maxt=30015msec
>> Jobs: 0 (f=0)
>>
>>
>>
>> After 60 seconds.... ( I have this)...
>>
>>
>> <s1>  0 (f=0)
>> workload: (groupid=0, jobs=64): err= 0: pid=3607: Fri Oct 10 09:32:04
>> 2014
>>    mixed: io=60243MB, bw=1338.6MB/s, iops=42833, runt= 45006msec
>>      slat (usec): min=10, max=1097, avg=21.47, stdev= 7.11
>>      clat (usec): min=256, max=302936, avg=5944.33, stdev=9841.20
>>       lat (usec): min=275, max=302957, avg=5966.03, stdev=9841.14
>>      clat percentiles (usec):
>>       |  1th=[  820],  5th=[ 1240], 10th=[ 1656], 20th=[ 2416], 30th=[
>> 3120],
>>       | 40th=[ 4048], 50th=[ 4704], 60th=[ 5152], 70th=[ 6048], 80th=[
>> 7328],
>>       | 90th=[10304], 95th=[14912], 99th=[21888], 100th=[25728],
>> 100th=[181248],
>>       | 100th=[207872], 100th=[244736]
>>      bw (KB  /s): min= 8256, max=53824, per=1.57%, avg=21476.50,
>> stdev=4885.09
>>      lat (usec) : 500=0.07%, 750=0.59%, 1000=1.81%
>>      lat (msec) : 2=11.88%, 4=25.20%, 10=49.90%, 20=8.94%, 50=1.29%
>>      lat (msec) : 100=0.04%, 250=0.26%, 500=0.01%
>>    cpu          : usr=0.78%, sys=1.29%, ctx=1952463, majf=0, minf=219
>>    IO depths    : 1=0.1%, 2=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%,
>>> =64=0.0%
>>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>>> =64=0.0%
>>       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>>> =64=0.0%
>>       issued    : total=r=1927764/w=0/d=0, short=r=0/w=0/d=0,
>> drop=r=0/w=0/d=0
>>       latency   : target=0, window=0, percentile=100.00%, depth=4
>>
>> Run status group 0 (all jobs):
>>    MIXED: io=60243MB, aggrb=1338.6MB/s, minb=1338.6MB/s, maxb=1338.6MB/s,
>> mint=45006msec, maxt=45006msec
>
> It's weird, like there's some clock source issue. What happens if you
> add --eta=always as an option to fio?

Or perhaps try this attached patch.


-- 
Jens Axboe


--------------020000000505070005000302
Content-Type: text/x-patch;
 name="genesis.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="genesis.patch"

diff --git a/fio.c b/fio.c
index 7e6b06d3793f..9adc29aee47b 100644
--- a/fio.c
+++ b/fio.c
@@ -43,6 +43,8 @@ int main(int argc, char *argv[], char *envp[])
 	fio_time_init();
 
 	if (nr_clients) {
+		set_genesis_time();
+
 		if (fio_start_all_clients())
 			return 1;
 		return fio_handle_clients(&fio_client_ops);

--------------020000000505070005000302--

