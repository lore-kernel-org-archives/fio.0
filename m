Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/3] reduce normal output lat (nsec/usec/msec)
 indentation, update latency documentation
From: Jens Axboe <axboe@kernel.dk>
References: <1502737184-25885-1-git-send-email-vincentfu@gmail.com>
 <306fc363-4fc7-ff46-32b7-854e0a62b508@kernel.dk>
Message-ID: <a162b306-73cd-9cd8-4cbf-611ee827c73e@kernel.dk>
Date: Mon, 14 Aug 2017 13:06:29 -0600
MIME-Version: 1.0
In-Reply-To: <306fc363-4fc7-ff46-32b7-854e0a62b508@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Vincent Fu <vincentfu@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 08/14/2017 01:03 PM, Jens Axboe wrote:
> On 08/14/2017 12:59 PM, Vincent Fu wrote:
>> Jens, please consider this patch series.
>>
>> The patches reduce the indentation of the normal output lat (nsec/usec/msec) lines and update the description of the latency output in the HOWTO and man page.
>>
>> The man page changes apply on top of the patches from kusumi.tomohiro@gmail.com.
> 
> But those aren't in yet, since they don't apply to the current
> tree. I have applied 1-2, I'll check #3 once Tomohiro resends
> his series. Or you can resend when that happens.

I missed the v3 update - I have applied that, and your #3 as well.
Thanks!

-- 
Jens Axboe


