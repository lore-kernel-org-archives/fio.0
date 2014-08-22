Return-Path: <axboe@kernel.dk>
Message-ID: <53F7D3A3.6030009@kernel.dk>
Date: Fri, 22 Aug 2014 17:34:59 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio terse output for WRITE not working.
References: <005e01cfb339$774e4640$65ead2c0$@opengridcomputing.com>	<002d01cfb896$19657b40$4c3071c0$@opengridcomputing.com> <CAFTzLMM=-vUtz8NRZBn7W_whH0Kgw0fzX5R0VsppaO_4xxv85A@mail.gmail.com> <003501cfb89e$07474ad0$15d5e070$@opengridcomputing.com> <53F7C3BE.8070204@kernel.dk> <53F7D109.8070503@opengridcomputing.com>
In-Reply-To: <53F7D109.8070503@opengridcomputing.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Steve Wise <swise@opengridcomputing.com>, 'Vasily Tarasov' <tarasov@vasily.name>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-08-22 17:23, Steve Wise wrote:
> On 8/22/2014 5:27 PM, Jens Axboe wrote:
>> On 2014-08-15 10:31, Steve Wise wrote:
>>>
>>>
>>>> -----Original Message-----
>>>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org]
>>>> On Behalf Of Vasily
>>>> Tarasov
>>>> Sent: Friday, August 15, 2014 10:29 AM
>>>> To: Steve Wise
>>>> Cc: fio@vger.kernel.org
>>>> Subject: Re: fio terse output for WRITE not working.
>>>>
>>>> Hi Steve,
>>>>
>>>> I found terse/minimal output to be quite unstable and inconsistent in
>>>> fio. So, as suggested by Jens, I switched to json output
>>>> (--output-format=json). It seems to be more stable and is also quite
>>>> easy to parse.
>>>>
>>>> Perhaps that's an option for you.
>>>>
>>>> Vasily
>>>
>>> I'll check out json.  Thanks Vasily.
>>
>> json is vastly superior - easy to parse by both humans and computers.
>> That said, the terse format should of course work. I ran a quick test
>> just now, and I don't see anything wrong?
>>
>
> See my original posting on this.  The write terse output only has zeros
> for the over bandwidth in the first few fields of the record. read works
> fine for me though.

Yes, I'm saying I don't see this happening. This is my quickie test case:

3;fio-2.1.11-19-g0297;null;0;0;21019592;7006530;1751632;3000;0;0;0.000000;0.000000;0;31;0.028879;0.181874;1.000000%=0;5.000000%=0;10.000000%=0;20.000000%=0;30.000000%=0;40.000000%=0;50.000000%=0;60.000000%=0;70.000000%=0;80.000000%=0;90.000000%=0;95.000000%=0;99.000000%=1;99.500000%=1;99.900000%=1;99.950000%=1;99.990000%=1;0%=0;0%=0;0%=0;0;32;0.055929;0.249507;5932824;7322384;99.011636%;6937280.000000;569503.420436;21014252;7004750;1751187;3000;0;0;0.000000;0.000000;0;48;0.029822;0.186289;1.000000%=0;5.000000%=0;10.000000%=0;20.000000%=0;30.000000%=0;40.000000%=0;50.000000%=0;60.000000%=0;70.000000%=0;80.000000%=0;90.000000%=0;95.000000%=0;99.000000%=1;99.500000%=1;99.900000%=1;99.950000%=1;99.990000%=1;0%=0;0%=0;0%=0;0;48;0.074062;0.286370;5932824;7324072;98.994494%;6934316.800000;568074.804612;99.666667%;0.000000%;4;0;3;100.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.0%;100.00%;0.01%;0.01%;0.01%;0.01%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;
0.00%

or when run with normal output:

null: (groupid=0, jobs=1): err= 0: pid=26423: Fri Aug 22 17:33:46 2014
   read : io=20499MB, bw=6833.2MB/s, iops=1749.3K, runt=  3000msec
     clat (usec): min=0, max=82, avg= 0.03, stdev= 0.19
      lat (usec): min=0, max=83, avg= 0.06, stdev= 0.26
     clat percentiles (usec):
      |  1.00th=[    0],  5.00th=[    0], 10.00th=[    0], 20.00th=[    0],
      | 30.00th=[    0], 40.00th=[    0], 50.00th=[    0], 60.00th=[    0],
      | 70.00th=[    0], 80.00th=[    0], 90.00th=[    0], 95.00th=[    0],
      | 99.00th=[    1], 99.50th=[    1], 99.90th=[    1], 99.95th=[    1],
      | 99.99th=[    1]
     bw (MB  /s): min= 5617, max= 7119, per=98.96%, avg=6762.01, 
stdev=641.65
   write: io=20495MB, bw=6831.6MB/s, iops=1748.9K, runt=  3000msec
     clat (usec): min=0, max=144, avg= 0.03, stdev= 0.20
      lat (usec): min=0, max=144, avg= 0.07, stdev= 0.30
     clat percentiles (usec):
      |  1.00th=[    0],  5.00th=[    0], 10.00th=[    0], 20.00th=[    0],
      | 30.00th=[    0], 40.00th=[    0], 50.00th=[    0], 60.00th=[    0],
      | 70.00th=[    0], 80.00th=[    0], 90.00th=[    0], 95.00th=[    0],
      | 99.00th=[    1], 99.50th=[    1], 99.90th=[    1], 99.95th=[    1],
      | 99.99th=[    1]
     bw (MB  /s): min= 5617, max= 7118, per=98.94%, avg=6759.24, 
stdev=640.28
     lat (usec) : 2=100.00%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%
     lat (usec) : 100=0.01%, 250=0.01%
   cpu          : usr=100.00%, sys=0.00%, ctx=7, majf=0, minf=3
   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      issued    : total=r=5247840/w=5246653/d=0, short=r=0/w=0/d=0
      latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
    READ: io=20499MB, aggrb=6833.2MB/s, minb=6833.2MB/s, 
maxb=6833.2MB/s, mint=3000msec, maxt=3000msec
   WRITE: io=20495MB, aggrb=6831.6MB/s, minb=6831.6MB/s, 
maxb=6831.6MB/s, mint=3000msec, maxt=3000msec



-- 
Jens Axboe


