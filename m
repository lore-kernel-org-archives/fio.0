Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALjAwxjLXTCRe0Ky08DB6in2aq_czkx5Oz8Osi7Mo=+7eFH9PQ@mail.gmail.com>
References: <CALjAwxhfyQ3ppw-MXoRwAkhk4+-LSJSTkZQa32ymKizKU0Ox-A@mail.gmail.com>
 <5669B23C.1020001@kernel.dk> <CALjAwxjLXTCRe0Ky08DB6in2aq_czkx5Oz8Osi7Mo=+7eFH9PQ@mail.gmail.com>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Thu, 10 Dec 2015 21:11:51 +0300
Message-ID: <CANvN+e=CtQBfUmj6fQPUgaqHUXwzwY1SLuXV76n=AG2kLFpWSQ@mail.gmail.com>
Subject: Re: Exit all jobs on error
Content-Type: text/plain; charset=UTF-8
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

I've also encountered a similar issue a number of times where the job
failed to stop (and refused to terminate in response to C-C) when a
thread/process fails, e.g. due to an error. My guess is that the loop
that waits for completions doesn't check for td->terminate being set.

Regards,
Andrey
Regards,
Andrey


On Thu, Dec 10, 2015 at 8:58 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> On 10 December 2015 at 17:11, Jens Axboe <axboe@kernel.dk> wrote:
>> On 12/10/2015 12:01 AM, Sitsofe Wheeler wrote:
>>>
>>> Hi,
>>>
>>> Is there an option to exit all jobs but only on error? If I have a job
>>> like this
>>>
>>> [global]
>>> stonewall=1
>>> verify=crc32
>>> rw=write
>>> [pass1]
>>> bs=4k
>>> [pass2]
>>> bs=8k
>>>
>>> I want fio to stop if pass1 fails verification and for pass2 not to be
>>> performed at all. I'm aware of "exitall" but using that will make fio
>>> quit even if pass1 is successful.
>>
>>
>> That doesn't exist, but we could add a exitall_on_error to have that
>> behavior. Should be pretty easy to add.
>
> That would work for me - that way it could be put in the global
> section or per (stonewall) group.
>
> --
> Sitsofe | http://sucs.org/~sits/
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

