Return-Path: <axboe@kernel.dk>
Subject: Re: Fio high IOPS measurement mistake
References: <56D525E1.6010407@vlnb.net>
 <CALjAwxjLb7L8sZCensSNXZ4kDyHb683bu-zuwDvgk5sFoeMckw@mail.gmail.com>
 <56D66B1C.6050506@vlnb.net> <56D7A97F.9080800@vlnb.net>
 <CALjAwxgU06EEYCw9VV7S8UzDtgpo-KUQtS90HK=KpfffkCKn2A@mail.gmail.com>
 <20160303162037.GD22164@kernel.dk> <56D91110.8080203@vlnb.net>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56D9AADC.3070600@kernel.dk>
Date: Fri, 4 Mar 2016 08:33:48 -0700
MIME-Version: 1.0
In-Reply-To: <56D91110.8080203@vlnb.net>
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit
To: Vladislav Bolkhovitin <vst@vlnb.net>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 03/03/2016 09:37 PM, Vladislav Bolkhovitin wrote:
> Jens Axboe wrote on 03/03/2016 08:20 AM:
>> On Thu, Mar 03 2016, Sitsofe Wheeler wrote:
>>> On 3 March 2016 at 03:03, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>>>> For those who asked about perf profiling, it remained the same as before with the CPU
>>>> consumption is all about timekeeping and memset:
>>>>
>>>> -  55.74%  fio  fio                [.] clock_thread_fn
>>>>       clock_thread_fn
>>>
>>> Perhaps this is what is already included above but could you use the
>>> -g option on perf to collect it into a call-graph and post the top
>>> results?
>>
>> The above looks like a side effect of using gtod_cpu, it'll burn one
>> core. For the original poster - did you verify whether using gtod_cpu
>> was faster than using the CPU clock source in each CPU?
>
> Yes, I had verified it and mentioned in one of my reports. It slightly decreased the
> IOPS. I guess, it's a locking contention somewhere.

For clocksource=cpu there is no internal fio contention, nor can there 
be any kernel/OS contention. Getting the clock is serializing, so that 
might slow things down a bit.

I've seen you bring up this contention idea before. Is that pure 
guesswork on your end, or have you profiled any contention? For most fio 
workloads there is no cross-job traffic, that's by design. Fio does add 
some overhead in general (everything does), and some of it is opt-out 
like cutting down on the number of time calls (gtod_cpu). But that's 
different from any locking contention between jobs, since it's constant 
and isn't affected by how you spread the workloads.

-- 
Jens Axboe


