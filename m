Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 3/4] blktrace: add option to scale a trace
References: <20180919182532.8405-1-dennis@kernel.org>
 <20180919182532.8405-4-dennis@kernel.org>
 <f210cabe-9b1c-c35b-db8a-b7514d8d172a@kernel.dk>
 <20180919195607.GB14982@dennisz-mbp.dhcp.thefacebook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <d094f4cb-e89f-fb2c-7aeb-9af42b60bfd7@kernel.dk>
Date: Wed, 19 Sep 2018 13:59:53 -0600
MIME-Version: 1.0
In-Reply-To: <20180919195607.GB14982@dennisz-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Andy Newell <newella@fb.com>, fio@vger.kernel.org, kernel-team@fb.com
List-ID: <fio@vger.kernel.org>

On 9/19/18 1:56 PM, Dennis Zhou wrote:
> On Wed, Sep 19, 2018 at 12:49:15PM -0600, Jens Axboe wrote:
>> On 9/19/18 12:25 PM, Dennis Zhou wrote:
>>> As we explore stacking traces, it is nice to be able to scale a trace to
>>> understand how the traces end up interacting.
>>>
>>> This patch adds scaling by letting the user pass in percentages to scale
>>> a trace by. When passed '--merge_blktrace_scalars="100", the trace is
>>> ran at 100% speed. If passed 50%, this will halve the trace timestamps.
>>> The new option takes in a comma separated list that index-wise pairs
>>> with the passed files in "--read_iolog".
>>
>> How is this different than replay_time_scale?
>>
> 
> I think merge_blktrace_scalars is a trace building parameter whereas
> replay_time scale is a runtime parameter. merge_blktrace_scalars is an
> index-paired list with the logs passed to --read_iolog allowing for each
> trace to be independently scaled. replay_time_scale happens at runtime
> and scales the entire trace uniformly. And because replay_time_scale
> happens at runtime, I'm not sure repurposing the numbers would be super
> intuitive.

Not sure I see the difference, if you just allow replay_time_scale to
take multiple values (one for each trace)?

-- 
Jens Axboe


