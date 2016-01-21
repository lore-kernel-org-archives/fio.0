Return-Path: <axboe@kernel.dk>
Subject: Re: fio newer than 2.2.12 segfaults on examples/tiobench-example.fio
References: <569B9F48.3010808@cran.org.uk> <569D5FB4.6050602@kernel.dk>
 <56A05EDC.4030309@cran.org.uk> <56A05F80.7070903@kernel.dk>
 <56A0620D.6000204@cran.org.uk> <56A063DD.8040502@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56A0647C.6030607@kernel.dk>
Date: Wed, 20 Jan 2016 21:54:20 -0700
MIME-Version: 1.0
In-Reply-To: <56A063DD.8040502@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 01/20/2016 09:51 PM, Jens Axboe wrote:
> On 01/20/2016 09:43 PM, Bruce Cran wrote:
>> On 01/20/2016 09:33 PM, Jens Axboe wrote:
>>> Can you try and revert commit 09400a60042 and see if that fixes it?
>>
>> Yes, that does fix it.
>
> So it sounds like a double unlock issue, as per the bug report you also
> referenced.
>
> Can you checkout out the 2.4 release again, and see if there are cases
> where pthread_cond_timedwait() returns with the mutex unlocked already?
> The man page states:
>
> "Upon successful return, the mutex shall have been locked and shall  be
>   owned by the calling thread."
>
> but it's not clear if that's not the case for error return (eg timed out).

Duh, nevermind:

http://git.kernel.dk/cgit/fio/commit/?id=42e833fa08803ccea6c99df353398a7423845c51

-- 
Jens Axboe


