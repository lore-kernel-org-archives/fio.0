Return-Path: <axboe@kernel.dk>
Subject: Re: Assertion `t->bytes' failed in blktrace replay
References: <c799b578ed44ed560c36ec7ef1a93b8076e6cc64.camel@suse.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <d4fe481d-8c6e-b618-2cff-bc01af265a4d@kernel.dk>
Date: Wed, 4 Jul 2018 15:00:20 -0600
MIME-Version: 1.0
In-Reply-To: <c799b578ed44ed560c36ec7ef1a93b8076e6cc64.camel@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Martin Wilck <mwilck@suse.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 7/2/18 1:26 PM, Martin Wilck wrote:
> While trying to replay a blktrace file with fio 3.7, I got the
> following error:
> 
> io: blktrace.c:326: handle_trace_fs: Assertion `t->bytes' failed.
> fio: pid=7353, got signal=6
> 
> After reverting c1f22c2 "blktrace: kill zero sized write test",
> I could replay the file, which was generated with blkparse from
> blktrace 1.1.0.
> 
> The way I read the commit message of c1f22c2, it means that fio can't
> deal with 0-byte writes. But they do occur in the trace in question.
> AFAICS it's true that they're flushes but how else would I get rid of
> them?
> 
> Does fio require blktrace files with a certain version?

Should not, I do wonder what that those zero byte traces are? I've
committed a fix that just logs a warning (once) for them, so -git
should work fine for you.

Can you share the trace?

-- 
Jens Axboe


