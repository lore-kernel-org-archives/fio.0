Return-Path: <dennisszhou@gmail.com>
Return-Path: <dennisszhou@gmail.com>
Date: Wed, 19 Sep 2018 17:06:33 -0400
From: Dennis Zhou <dennis@kernel.org>
Subject: Re: [PATCH 3/4] blktrace: add option to scale a trace
Message-ID: <20180919210633.GA20849@dennisz-mbp.dhcp.thefacebook.com>
References: <20180919182532.8405-1-dennis@kernel.org>
 <20180919182532.8405-4-dennis@kernel.org>
 <f210cabe-9b1c-c35b-db8a-b7514d8d172a@kernel.dk>
 <20180919195607.GB14982@dennisz-mbp.dhcp.thefacebook.com>
 <d094f4cb-e89f-fb2c-7aeb-9af42b60bfd7@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d094f4cb-e89f-fb2c-7aeb-9af42b60bfd7@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Andy Newell <newella@fb.com>, fio@vger.kernel.org, kernel-team@fb.com
List-ID: <fio@vger.kernel.org>

On Wed, Sep 19, 2018 at 01:59:53PM -0600, Jens Axboe wrote:
> On 9/19/18 1:56 PM, Dennis Zhou wrote:
> > On Wed, Sep 19, 2018 at 12:49:15PM -0600, Jens Axboe wrote:
> >> On 9/19/18 12:25 PM, Dennis Zhou wrote:
> >>> As we explore stacking traces, it is nice to be able to scale a trace to
> >>> understand how the traces end up interacting.
> >>>
> >>> This patch adds scaling by letting the user pass in percentages to scale
> >>> a trace by. When passed '--merge_blktrace_scalars="100", the trace is
> >>> ran at 100% speed. If passed 50%, this will halve the trace timestamps.
> >>> The new option takes in a comma separated list that index-wise pairs
> >>> with the passed files in "--read_iolog".
> >>
> >> How is this different than replay_time_scale?
> >>
> > 
> > I think merge_blktrace_scalars is a trace building parameter whereas
> > replay_time scale is a runtime parameter. merge_blktrace_scalars is an
> > index-paired list with the logs passed to --read_iolog allowing for each
> > trace to be independently scaled. replay_time_scale happens at runtime
> > and scales the entire trace uniformly. And because replay_time_scale
> > happens at runtime, I'm not sure repurposing the numbers would be super
> > intuitive.
> 
> Not sure I see the difference, if you just allow replay_time_scale to
> take multiple values (one for each trace)?
> 

I'm imagining if I reused replay_time_scale, I could use those numbers
for merging, but then I'd have to reset it so that it doesn't affect the
trace a second time during runtime. I feel like this gets a little weird
as we're saying if you are merging, replay_time_scale gets applied
during the merge, otherwise it gets applied during runtime. Reusing also
makes it become a many (merging) to one (runtime) parameter change too
as merging works on multiple files (main thread) while runtime runs a
single file (worker thread).

Additionally, I don't think it's unreasonable to want to store the
merged trace in realtime and then run the merged trace at a different
pace, which would require the merge time and runtime knobs to be
different.

Thanks,
Dennis

