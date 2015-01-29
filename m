Return-Path: <axboe@kernel.dk>
Message-ID: <54CA6331.5090501@kernel.dk>
Date: Thu, 29 Jan 2015 08:43:29 -0800
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Should io_limits/queue depth flushed persist while using verify_state?
References: <CALjAwxgmpWDviJiUyoXSZPy_-JP0va+QdXmhP-r6g6JTTRv7Fg@mail.gmail.com>	<54B84322.10704@kernel.dk>	<54B9495E.1020804@kernel.dk>	<CALjAwxhAS3GvMMpFkxgsbx1KpS2j4EzyQzX=Xc007axPu0dYsw@mail.gmail.com> <CALjAwxij4aMr43E64SvQ-2AM9u+tbB4FF4bRY39LrkWvbpWaGA@mail.gmail.com>
In-Reply-To: <CALjAwxij4aMr43E64SvQ-2AM9u+tbB4FF4bRY39LrkWvbpWaGA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 01/28/2015 10:18 PM, Sitsofe Wheeler wrote:
> On 17 January 2015 at 09:11, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>> On 16 January 2015 at 17:24, Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> I wonder if this will do the trick, can you check? If not, I'll need the
>>> full output of the two runs, and the state files saved from the first run.
>>
>> I tried revision ae703cdf31532e337cc18c259c883bf5314aa43a which seems
>> to already have that patch rolled into it (via commit
>> def0009508f0f3c763c4de5e0b62388b42544faf ) but it made no
>> difference...
>>
>> Find the two runs with --debug=all and and the state file attached.
>
> Just checking - did the above arrive correctly?

I apparently missed it... Will take a look, but traveling in the next 
few days so response might be a bit slower.

-- 
Jens Axboe


