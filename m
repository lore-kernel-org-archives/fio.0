Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 2/4] blktrace: add support to interleave blktrace files
References: <20180919182532.8405-1-dennis@kernel.org>
 <20180919182532.8405-3-dennis@kernel.org>
 <d55cc43a-c656-bfb9-ff89-9c66c2ebc1ca@kernel.dk>
 <20180919192900.GA14982@dennisz-mbp.dhcp.thefacebook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <4d3d02fb-e563-8a70-e14c-7dda91ea4390@kernel.dk>
Date: Wed, 19 Sep 2018 13:34:55 -0600
MIME-Version: 1.0
In-Reply-To: <20180919192900.GA14982@dennisz-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Andy Newell <newella@fb.com>, fio@vger.kernel.org, kernel-team@fb.com
List-ID: <fio@vger.kernel.org>

On 9/19/18 1:29 PM, Dennis Zhou wrote:
> Hi Jens,
> 
> On Wed, Sep 19, 2018 at 12:47:37PM -0600, Jens Axboe wrote:
>> On 9/19/18 12:25 PM, Dennis Zhou wrote:
>>> Running concurrent workloads via multiple jobs can lead to
>>> nondeterministic results as we are at the schedulers mercy. While the
>>> actual performance of the workload may vary regardless, this makes the
>>> order of events consistent.
>>>
>>> This patch introduces two flags: --merge_blktrace_file=<file> and
>>> --merge-blktrace-only. When the first is specified, files that are ':'
>>> separated in --read_iolog are passed to a merge function wich then
>>> produces a single sorted trace file. This file is then passed on in
>>> place of the sorted list or fio exists if --merge-blktrace-only is
>>> specified.
>>>
>>> During merging, events are filtered based on what fio cares about and
>>> the pdu is discarded as well.
>>
>> This looks fine to me, but it's missing documentation (fio.1 and HOWTO)
>> for added options. For the feature as a whole as well.
>>
>>> diff --git a/thread_options.h b/thread_options.h
>>> index 39315834..99552326 100644
>>> --- a/thread_options.h
>>> +++ b/thread_options.h
>>> @@ -258,6 +258,7 @@ struct thread_options {
>>>  	char *read_iolog_file;
>>>  	bool read_iolog_chunked;
>>>  	char *write_iolog_file;
>>> +	char *merge_blktrace_file;
>>>  
>>>  	unsigned int write_bw_log;
>>>  	unsigned int write_lat_log;
>>
>> This needs an accompanying change to struct thread_options_pack, and a
>> cconv.c addition to ensure it's converted properly over the wire for
>> client/server runs of fio.o
>>
>> Basically both comments here apply to the rest of the series as well :-)
>>
> 
> Ah that makes sense. I wasn't quite sure what the _pack was for. Now I
> get it. I'll add the corresponding documentation and send out a v2!
> Thanks for looking at it so quickly.

No problem - also forgot to mention that you want to bump FIO_SERVER_VER
as well, if you modify thread_options_pack.

-- 
Jens Axboe


