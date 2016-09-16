Return-Path: <axboe@kernel.dk>
Subject: Re: progress on fio --client
References: <1887684558.8387275.1473806634276.JavaMail.zimbra@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <96a00a71-dcca-c34c-7428-f14df4f1b823@kernel.dk>
Date: Fri, 16 Sep 2016 09:30:27 -0600
MIME-Version: 1.0
In-Reply-To: <1887684558.8387275.1473806634276.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Ben England <bengland@redhat.com>, fio@vger.kernel.org
Cc: Nick Dokos <ndokos@redhat.com>
List-ID: <fio@vger.kernel.org>

On 09/13/2016 04:43 PM, Ben England wrote:
> Am now running with Jens patch "ignore SEND_ETA, if we can't fin a
> reply command ".   Thanks!  I was trying to solve it by increasing
> timeout.
>
> I did the last commit on PR 241 to address the remaining comment.  If
> it looks ok to you, I would appreciate this being pulled in because it
> is important to distributed fio --client testing in order to get
> bandwidth/iops logs and latency histogram logs.    I have been testing
> it for about a week now with 900 workload generator threads across 7
> hosts and it seems to work, especially now that assertion isn't firing
> because of above patch.

Glad that works!

> An unrelated minor problem - There are still a couple of threads that
> have trouble returning a fio histogram to the test driver, will look
> into that, but at least fio --client is getting almost all the logs now
> with PR 241, enough that meaningful stats can be generated.  Error
> messages are:
>
> fio: failed decompressing log
> fio: failed converting IO log
>
> This doesn't happen for smaller numbers of workload generator threads.

That usually points to a bug in the compression or decompression
handling, so I'd probably look at that. We've had that in a few other
areas, you might want to look at the changelog and see the fixes for
those.

-- 
Jens Axboe


