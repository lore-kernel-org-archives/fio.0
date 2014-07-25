Return-Path: <axboe@kernel.dk>
Message-ID: <53D20C7E.9090802@kernel.dk>
Date: Fri, 25 Jul 2014 09:51:26 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Allow to reset offset_increment counter
References: <537F439E.9040904@gmail.com> <537F7E8E.4050200@kernel.dk> <537F8454.3020203@gmail.com> <538CC242.60109@gmail.com> <53D20B84.4020403@gmail.com>
In-Reply-To: <53D20B84.4020403@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jiri Horky <jiri.horky@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-07-25 09:47, Jiri Horky wrote:
> Hi Jens,
>
> I wonder if you missed this email or you just didn't like the patch?

I mostly delayed it and then forgot about it. I agree on the notion of 
using sub-jobs for the index, practically speaking, I think that is the 
way that people would use it anyway. It'd be confusing if unrelated jobs 
had different offset increments. And with a bit of simple math, you can 
even make different groups of jobs index the same parts, if you want.

-- 
Jens Axboe


