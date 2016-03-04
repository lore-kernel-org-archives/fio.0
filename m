Return-Path: <vst@vlnb.net>
Message-ID: <56D91110.8080203@vlnb.net>
Date: Thu, 03 Mar 2016 20:37:36 -0800
From: Vladislav Bolkhovitin <vst@vlnb.net>
MIME-Version: 1.0
Subject: Re: Fio high IOPS measurement mistake
References: <56D525E1.6010407@vlnb.net> <CALjAwxjLb7L8sZCensSNXZ4kDyHb683bu-zuwDvgk5sFoeMckw@mail.gmail.com> <56D66B1C.6050506@vlnb.net> <56D7A97F.9080800@vlnb.net> <CALjAwxgU06EEYCw9VV7S8UzDtgpo-KUQtS90HK=KpfffkCKn2A@mail.gmail.com> <20160303162037.GD22164@kernel.dk>
In-Reply-To: <20160303162037.GD22164@kernel.dk>
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Jens Axboe wrote on 03/03/2016 08:20 AM:
> On Thu, Mar 03 2016, Sitsofe Wheeler wrote:
>> On 3 March 2016 at 03:03, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>>> For those who asked about perf profiling, it remained the same as before with the CPU
>>> consumption is all about timekeeping and memset:
>>>
>>> -  55.74%  fio  fio                [.] clock_thread_fn
>>>      clock_thread_fn
>>
>> Perhaps this is what is already included above but could you use the
>> -g option on perf to collect it into a call-graph and post the top
>> results?
> 
> The above looks like a side effect of using gtod_cpu, it'll burn one
> core. For the original poster - did you verify whether using gtod_cpu
> was faster than using the CPU clock source in each CPU?

Yes, I had verified it and mentioned in one of my reports. It slightly decreased the
IOPS. I guess, it's a locking contention somewhere.

Thanks,
Vlad


