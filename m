Return-Path: <axboe@kernel.dk>
Subject: Re: Missing log entries and other questions
References: <eBGJ1s00E1TeosZ01BGKGG> <036a01d19f62$717af530$5470df90$@cox.net>
 <20160427203823.GB25397@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <572A02B9.1040902@kernel.dk>
Date: Wed, 4 May 2016 08:10:01 -0600
MIME-Version: 1.0
In-Reply-To: <20160427203823.GB25397@kernel.dk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Paul Alcorn <paullie1@cox.net>
Cc: 'Mihkal Dunfjeld' <mihkal.dunfjeld@stud.ntnu.no>, fio@vger.kernel.org, birger.lunstoeng@stud.ntnu.no
List-ID: <fio@vger.kernel.org>

On 04/27/2016 02:38 PM, Jens Axboe wrote:
> I'll try and see if I can reproduce this.

So I took a look at your logged output. The way that fio logs is that it 
does it on IO completion. You have set 1s intervals, so it checks, when 
an IO completes, if we're due for logging the previous interval IOPS:

spent = mtime_since(&td->iops_sample_time, t);
if (spent < td->o.iops_avg_time)
         return;

If you are doing lots of IO, it matches pretty evenly. But for slow 
workloads, it will end up being skewed a bit. It won't be too hard to 
fix the drift, though, but it still won't make it clock precise at exact 
1s intervals.

We could move this part into the main thread, and out of the workers. 
Then we could make it more precise. Might not be a bad idea in general, 
since it'll move some of this code out of the fast path.

I'll take a stab at it.

-- 
Jens Axboe


