Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 2/2] fio: add total_run_time to the thread json output
References: <20180629133335.14618-1-josef@toxicpanda.com>
 <20180629133335.14618-2-josef@toxicpanda.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <baeb1e6d-931b-42be-f069-5f3997f98022@kernel.dk>
Date: Fri, 29 Jun 2018 07:46:21 -0600
MIME-Version: 1.0
In-Reply-To: <20180629133335.14618-2-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Josef Bacik <josef@toxicpanda.com>, fio@vger.kernel.org, kernel-team@fb.com
List-ID: <fio@vger.kernel.org>

On 6/29/18 7:33 AM, Josef Bacik wrote:
> I discovered that the 'elapsed' value of each job is the overall time
> the whole fio run took, not the per-job elapsed time, despite it being
> in the per-job section of the json output.  Rather than break everybody
> by fixing this, just add a 'total_run_time' value to the job section and
> include the time the thread ran in milliseconds.  This is handy for jobs
> that want to compare runtime of two threads in different cgroups.

How about 'job_runtime' instead, total_run_time sounds like higher scope
than 'elapsed'.


-- 
Jens Axboe


