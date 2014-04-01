Return-Path: <axboe@kernel.dk>
Message-ID: <533B0A40.3050504@kernel.dk>
Date: Tue, 01 Apr 2014 12:49:36 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Surprising use of basename in finish_log_named
References: <533AD484.2040608@enovance.com>
In-Reply-To: <533AD484.2040608@enovance.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Erwan Velu <erwan@enovance.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 04/01/2014 09:00 AM, Erwan Velu wrote:
> Hi Jens,
>
> I had a input of the fio irc channel (yes some at getting into it
> sometimes :p), and he had a very interesting point.
>
> If you specify a full path name for the iops_log, the file will stay
> into the current dir.
> While looking at the code I found that finish_log_named() is performing
> the following:
>
>      char file_name[256], *p;
>      snprintf(file_name, sizeof(file_name), "%s_%s.log", prefix, postfix);
>      p = basename(file_name);
>
> Why do we basename the file_name ? What's the reason of shrinking the
> path this way ?

I don't think there's a good reason for that. So feel free to send in a 
(tested) patch :-)

> Note for the author: 256 is maybe too small for some ? :)))

We can make it PATH_MAX instead, not a big deal.

-- 
Jens Axboe


