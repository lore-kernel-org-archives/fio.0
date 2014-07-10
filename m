Return-Path: <axboe@kernel.dk>
Message-ID: <53BE5357.8050407@kernel.dk>
Date: Thu, 10 Jul 2014 10:48:23 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Disk utilization statistics in terse format
References: <CAFTzLMPWvQ8+rxmbSruzmHTMvkDXQ_ednA5rkDb3_CVoAtdVVw@mail.gmail.com>
In-Reply-To: <CAFTzLMPWvQ8+rxmbSruzmHTMvkDXQ_ednA5rkDb3_CVoAtdVVw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Vasily Tarasov <tarasov@vasily.name>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-07-09 16:21, Vasily Tarasov wrote:
> Hi All,
>
> When I run fio as a standalone application (without using a
> server-client model) and use terse output format, disk utilization is
> never printed. Here are the results of my analysis:
>
> 1) show_thread_status_terse_v2() does not call show_disk_util() at all.
>
> 2) show_thread_status_terse_v3_v4() does call show_disk_util(), but
> only if is_backend variable is true (which is not, in case of a
> standalone run).
>
> 3) __show_run_stats() call show_disk_util() only in case of
> FIO_OUTPUT_JSON or FIO_OUTPUT_NORMAL formats.
>
> There are several ways to fix this issue. I think the best way is to
> call show_disk_util() from __show_run_stats() in case of terse format.
> This will break the current terse format: disk utilization fields will
> be printed in the end of the lines (after thread statistics), which is
> not how the HOWTO defines it. But, it seems like the v2 format is
> already inconsistent with HOWTO. And for v3 format, if client-server
> model is used, disk utilization fields will be printed in the end of
> the terse line anyway (at least this is my current understanding of
> the code). So, what I suggest will bring consistency accross
> client-server and standalone runs. We will also need to fix HOWTO.
>
> Let me know what is the best way to fix this, and I'll be happy to send a patch.

Seems like the is_backend check in _v3_v4 should just go. Can't come up 
with a good reason why that is there, it already knows if it should do 
json output, or normal output (and in terse format, if asked).

-- 
Jens Axboe


