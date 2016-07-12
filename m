Return-Path: <axboe@kernel.dk>
Subject: Re: terminating fio jobs upon reaching steady state
References: <CY1PR0201MB1882D39478B9483993B429488C240@CY1PR0201MB1882.namprd02.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <57854B1F.1000106@kernel.dk>
Date: Tue, 12 Jul 2016 12:55:11 -0700
MIME-Version: 1.0
In-Reply-To: <CY1PR0201MB1882D39478B9483993B429488C240@CY1PR0201MB1882.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Vincent Fu <Vincent.Fu@sandisk.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 06/30/2016 08:49 AM, Vincent Fu wrote:
> Jens, I have been working on a patch to give fio the ability to
> terminate a job when steady state is attained. I have a crude
> implementation that is working at
> https://bitbucket.org/vincentfu/fio/commits/all but I'm hoping to
> receive some feedback on its design.
>
> Currently, the feature works via helper_thread_main(). It collects data
> in a ring buffer for a specified duration and carries out the
> termination test when the ring buffer is full. If the test passes, the
> job terminates. If the test fails, the job continues, the oldest data
> point in the buffer is dropped, a new data point is added, and the
> termination test is carried out again. The cycle repeats until the job
> terminates because steady state was attained or for other reasons.

Vincent, where are we at on this? Would be nice to get this included. A 
few comments:

- The global 'steadystate' bool. Seems like this should be a per-job 
thing, and not global. For a specific group of threads, whether we are 
in steady state or not should be checked for those td's.

- Should still work with ramptime. If we're in ramp time, no checking. 
Start steady state checking once we are out of ramp time.

- Would be nice if the SS output was there for non-json. At least 
something for the normal output, I think we can safely ignore the 
terse/csv in this regard.

- Should struct steady_state just be embedded in the thread_stat? It 
needs to be transmitted across the wire for client/server. So either you 
need to split it in two, or you need to embed it and sanitize it for 
on-the-wire transmission. You could keep the td->ss, and have a version 
that we export and embed that in thread_stat? If you do that, then have 
a steady_state_bla that's embedded in both struct steady_state and 
struct thread_stat.

Rest of the comments would be around cleanup, lots of little extra 
spaces here and there. But I can script sanitize that, so didn't want to 
address that in here.

-- 
Jens Axboe


