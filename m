Return-Path: <vst@vlnb.net>
Message-ID: <56DA2C92.5030508@vlnb.net>
Date: Fri, 04 Mar 2016 16:47:14 -0800
From: Vladislav Bolkhovitin <vst@vlnb.net>
MIME-Version: 1.0
Subject: Re: Fio high IOPS measurement mistake
References: <56D525E1.6010407@vlnb.net> <CALjAwxjLb7L8sZCensSNXZ4kDyHb683bu-zuwDvgk5sFoeMckw@mail.gmail.com> <56D66B1C.6050506@vlnb.net> <56D7A97F.9080800@vlnb.net> <CALjAwxgU06EEYCw9VV7S8UzDtgpo-KUQtS90HK=KpfffkCKn2A@mail.gmail.com> <20160303162037.GD22164@kernel.dk> <56D91110.8080203@vlnb.net> <56D9AADC.3070600@kernel.dk>
In-Reply-To: <56D9AADC.3070600@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Jens Axboe wrote on 03/04/2016 07:33 AM:
> On 03/03/2016 09:37 PM, Vladislav Bolkhovitin wrote:
>> Jens Axboe wrote on 03/03/2016 08:20 AM:
>>> On Thu, Mar 03 2016, Sitsofe Wheeler wrote:
>>>> On 3 March 2016 at 03:03, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>>>>> For those who asked about perf profiling, it remained the same as before with the CPU
>>>>> consumption is all about timekeeping and memset:
>>>>>
>>>>> -  55.74%  fio  fio                [.] clock_thread_fn
>>>>>       clock_thread_fn
>>>>
>>>> Perhaps this is what is already included above but could you use the
>>>> -g option on perf to collect it into a call-graph and post the top
>>>> results?
>>>
>>> The above looks like a side effect of using gtod_cpu, it'll burn one
>>> core. For the original poster - did you verify whether using gtod_cpu
>>> was faster than using the CPU clock source in each CPU?
>>
>> Yes, I had verified it and mentioned in one of my reports. It slightly decreased the
>> IOPS. I guess, it's a locking contention somewhere.
> 
> For clocksource=cpu there is no internal fio contention, nor can there be any kernel/OS
> contention. Getting the clock is serializing, so that might slow things down a bit.

Yes. Also, there might be a cache contention here, with one thread writing to a memory
location and multiple threads reading from it. The same type of contention why queue
spinlocks are faster, than ticket spinlocks.

> I've seen you bring up this contention idea before. 

Yes, it was when I forgot to short circuit lseek calls in the sync engine. Usually, if
you see performance dropping from certain number of threads, it is safe to guess there
is a lock contention somewhere.

> Is that pure guesswork on your end, or have you profiled any contention?

Pure guesswork. I'm looking at fio in details only few days, so it is still pretty much
a black box for me. Generally, if you see performance drop with another thread, it must
be either locks contention, or communication overhead. Nowadays the former is more
common, hence the guess.

Thanks,
Vlad

> For most fio workloads there is no cross-job
> traffic, that's by design. Fio does add some overhead in general (everything does), and
> some of it is opt-out like cutting down on the number of time calls (gtod_cpu). But
> that's different from any locking contention between jobs, since it's constant and
> isn't affected by how you spread the workloads.
> 


