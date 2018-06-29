Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH][v2] fio: add job_runtime to the thread json output
References: <20180629134903.16002-1-josef@toxicpanda.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <3537a6a7-8c7c-99f2-9027-7ddd1644114d@kernel.dk>
Date: Fri, 29 Jun 2018 07:51:28 -0600
MIME-Version: 1.0
In-Reply-To: <20180629134903.16002-1-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Josef Bacik <josef@toxicpanda.com>, fio@vger.kernel.org, kernel-team@fb.com
List-ID: <fio@vger.kernel.org>

On 6/29/18 7:49 AM, Josef Bacik wrote:
> I discovered that the 'elapsed' value of each job is the overall time
> the whole fio run took, not the per-job elapsed time, despite it being
> in the per-job section of the json output.  Rather than break everybody
> by fixing this, just add a 'job_runtime' value to the job section and
> include the time the thread ran in milliseconds.  This is handy for jobs
> that want to compare runtime of two threads in different cgroups.

Quick turn-around :-)

Applied!

-- 
Jens Axboe


