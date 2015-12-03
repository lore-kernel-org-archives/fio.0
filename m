Return-Path: <avi@cloudius-systems.com>
Return-Path: <avi@cloudius-systems.com>
Subject: Re: RFE: Graphing and iteration support for fio
References: <565D7ED9.3000606@scylladb.com> <56607574.6050602@kernel.dk>
 <5660798C.8000900@scylladb.com> <56607B43.4060908@kernel.dk>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <56607C86.5080408@scylladb.com>
Date: Thu, 3 Dec 2015 19:31:50 +0200
MIME-Version: 1.0
In-Reply-To: <56607B43.4060908@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>



On 12/03/2015 07:26 PM, Jens Axboe wrote:
> On 12/03/2015 10:19 AM, Avi Kivity wrote:
>>
>>
>> On 12/03/2015 07:01 PM, Jens Axboe wrote:
>>> On 12/01/2015 04:04 AM, Avi Kivity wrote:
>>>> Sometimes you want to run a set of experiments on a disk, varying a
>>>> parameter between tests (in my case, iodepth, but buffer size is 
>>>> also a
>>>> good candidate).  You then want to present the results in a nice 
>>>> graph.
>>>>
>>>> I wrote a small wrapper around fio to do this
>>>> (https://github.com/avikivity/diskplorer), but it occurs to me that
>>>> generalized support for both in fio would be much more useful.
>>>>
>>>> Possibly, you'd define a job as a template:
>>>>
>>>> [aio-read]
>>>> template_start=1
>>>> template_end=100
>>>> template_step=1
>>>> (or template_ratio=1.05 for exponential growth)
>>>> iodepth=template_variable
>>>>
>>>> (it's just possible that someone can come up with better syntax).
>>>>
>>>> A few more options in the global section can then cause a graph to be
>>>> generated.
>>>
>>> It'd be great to integrate this into fio, as graphing results is
>>> something that most people want to do. Any chance you would be willing
>>> to try and hash that out?
>>
>> I'd love to say yes, but no.
>
> :-)
>
>>>> btw, a fast disk can easily saturate a single core using libaio, so a
>>>> multithreaded libaio ioengine would be welcome (I am currently 
>>>> emulating
>>>> it using multiple jobs and new_group).
>>>
>>> In the context of fio, that doesn't make a lot of sense. A job in fio
>>> is, by definition, either a thread or a process that does IO. So if
>>> you want more threads banging on a device, then you'd add more jobs.
>>> If multiple threads shared on aio context, then we'd also potentially
>>> see contention on that part. If you just use more jobs, then each gets
>>> an aio context as well.
>>>
>>
>> If your jobs are generated via a template, as above, then this is hard
>> to do.  For iodepth=1 you want one job with iodepth=1.  For iodepth=64
>> you want 8 jobs (one per core) each with an iodepth=8; otherwise a fast
>> SSD will overwhelm a single core.
>>
>> Perhaps the job specification can be modified so that it auto-generates
>> subjobs.  In the specification, there is one entry, but fio sees 8 (or
>> 1, when the template sets iodepth=1), and reports them via a group.
>>
>> [aio-read]
>> template_start=1
>> template_end=100
>> template_step=1
>> (or template_ratio=1.05 for exponential growth)
>> subjobs=(min(template_variable, core_count))
>> iodepth=(template_variable / subjobs)
>>
>> (the above doesn't cope will with an iodepth that doesn't divide into
>> your core_count; displorer will generate subjobs with different iodepth
>> for this)
>
> For purely automated or templated, yeah, it's not ideal. But some of 
> this is highly setup specific. For QD=64, 2 threads at QD=32 might be 
> the best option. Or 8/8, perhaps. Sometimes it's a tradeoff between 
> throwing CPU cycles at it to squeeze out the last drop of performance, 
> sometimes (eg on nvme), you need "just enough" threads to reach max 
> performance, since things are mostly 100% parallelized on both the 
> submission and completion path.
>
> Fio does support thread offload (io_submit_mode=offload), which was 
> added not for performance reasons, but because it's important to 
> capture the true latency of the device in case of device backup. So 
> the framework is in place to do that - which was the harder part. You 
> might want to take a look at that. It would need slight modifications 
> for your use case, but it'd be a good general addition.
>

Ok.  For my case the existing diskplorer hack is enough, but this really 
belongs in fio proper.

Maybe it wants integration with a scripting language that can succinctly 
represent the job by returning an object (or array of objects for a 
multi-job test), instead of the ugly template syntax I proposed.


So you'd run 'fio test.lua' and it would generate test specifications 
for you, then graph them.


