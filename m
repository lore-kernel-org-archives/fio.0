Return-Path: <raeburn@permabit.com>
From: Ken Raeburn <raeburn@permabit.com>
Subject: Re: [PATCH] Fix crash with absurdly but not impossibly deeply nested device stacks.
References: <6eham0rdc3.fsf@just-testing.permabit.com>
	<6ea9rsrc7u.fsf@just-testing.permabit.com>
	<20130129091712.GD30188@kernel.dk>
Date: Tue, 29 Jan 2013 16:06:24 -0500
In-Reply-To: <20130129091712.GD30188@kernel.dk> (Jens Axboe's message of "Tue,
	29 Jan 2013 10:17:12 +0100")
Message-ID: <6e622fr967.fsf@just-testing.permabit.com>
MIME-Version: 1.0
Content-Type: text/plain
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Jens Axboe <axboe@kernel.dk> writes:

> On Mon, Jan 28 2013, Ken Raeburn wrote:
>> diskutil.c: Check for overflow in disk_util.path.
>> diskutil.h: Expand disk_util.path to PATH_MAX.
>
> Good stuff, thanks. Though I think that we should just return NULL on
> failing to setup the path.

That seems fine, too. The preferred error handling in that area of the
code wasn't clear to me. Especially since smalloc failure (which doesn't
appear to be impossible) leads to a null pointer dereference.

> And:
>
>> +	l = snprintf(du->path, sizeof(du->path), "%s/stat", path);
>> +	if (l < 0 || l >= sizeof(du->path)) {
>
> cosmetically, that should never be > sizeof(du->path), but it doesn't
> hurt.

According to the GNU libc man page, in truncation cases, snprintf
returns the number of characters that would have been written, excluding
the trailing \0, if the buffer were long enough.  So if we're appending
"/stat" to something just under the buffer size, the return value could
be larger.

So, actually, I think the vsnprintf usage in log.c is wrong in assuming
the return value is no more than the buffer size...

Also, skimming the other uses, I think some of the other calls don't
really need to subtract one from sizeof(buffer), since the passed length
is the maximum number of bytes written, always including a trailing \0.

Ken

