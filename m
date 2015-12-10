Return-Path: <axboe@kernel.dk>
Subject: Re: Exit all jobs on error
References: <CALjAwxhfyQ3ppw-MXoRwAkhk4+-LSJSTkZQa32ymKizKU0Ox-A@mail.gmail.com>
 <5669B23C.1020001@kernel.dk>
 <CALjAwxjLXTCRe0Ky08DB6in2aq_czkx5Oz8Osi7Mo=+7eFH9PQ@mail.gmail.com>
 <CANvN+e=CtQBfUmj6fQPUgaqHUXwzwY1SLuXV76n=AG2kLFpWSQ@mail.gmail.com>
 <20151210181540.GB21415@kernel.dk>
 <CANvN+e=U5O4LC40uE59iGn1jtkBGygbboXGcKpfXO2uTX3=bVw@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5669C364.9020100@kernel.dk>
Date: Thu, 10 Dec 2015 11:24:36 -0700
MIME-Version: 1.0
In-Reply-To: <CANvN+e=U5O4LC40uE59iGn1jtkBGygbboXGcKpfXO2uTX3=bVw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/10/2015 11:17 AM, Andrey Kuzmin wrote:
> On Thu, Dec 10, 2015 at 9:15 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On Thu, Dec 10 2015, Andrey Kuzmin wrote:
>>> I've also encountered a similar issue a number of times where the job
>>> failed to stop (and refused to terminate in response to C-C) when a
>>> thread/process fails, e.g. due to an error. My guess is that the loop
>>> that waits for completions doesn't check for td->terminate being set.
>>
>> Attach with gdb and see what they are doing, could be a missing
>> terminate check. Or it could already be sitting waiting for completions.
>
> It just sits there waiting for completions, as gdb understandably
> predominantly hits the wait state.

Where is it sitting and/or looping?

-- 
Jens Axboe


