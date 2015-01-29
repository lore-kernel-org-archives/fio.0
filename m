Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALjAwxhAS3GvMMpFkxgsbx1KpS2j4EzyQzX=Xc007axPu0dYsw@mail.gmail.com>
References: <CALjAwxgmpWDviJiUyoXSZPy_-JP0va+QdXmhP-r6g6JTTRv7Fg@mail.gmail.com>
	<54B84322.10704@kernel.dk>
	<54B9495E.1020804@kernel.dk>
	<CALjAwxhAS3GvMMpFkxgsbx1KpS2j4EzyQzX=Xc007axPu0dYsw@mail.gmail.com>
Date: Thu, 29 Jan 2015 06:18:17 +0000
Message-ID: <CALjAwxij4aMr43E64SvQ-2AM9u+tbB4FF4bRY39LrkWvbpWaGA@mail.gmail.com>
Subject: Re: Should io_limits/queue depth flushed persist while using verify_state?
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 17 January 2015 at 09:11, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> On 16 January 2015 at 17:24, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> I wonder if this will do the trick, can you check? If not, I'll need the
>> full output of the two runs, and the state files saved from the first run.
>
> I tried revision ae703cdf31532e337cc18c259c883bf5314aa43a which seems
> to already have that patch rolled into it (via commit
> def0009508f0f3c763c4de5e0b62388b42544faf ) but it made no
> difference...
>
> Find the two runs with --debug=all and and the state file attached.

Just checking - did the above arrive correctly?

-- 
Sitsofe | http://sucs.org/~sits/

