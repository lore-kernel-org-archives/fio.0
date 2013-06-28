Return-Path: <davidoff@qedmf.net>
MIME-Version: 1.0
In-Reply-To: <20130628140856.GO24293@kernel.dk>
References: <CAJLXCZTeqg6DTeRcMK0asRoZ7EShD8Od+Y05R-Tgi7OEcS2Fuw@mail.gmail.com>
	<20130628140856.GO24293@kernel.dk>
Date: Fri, 28 Jun 2013 16:41:07 -0400
Message-ID: <CAJLXCZSmKBV34qgC3NMyEWD-i3kV8e1b8e_-Cat6o32JZzP-Hw@mail.gmail.com>
Subject: Re: Make threads access the same files?
From: Andrew Davidoff <davidoff@qedmf.net>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Thank you. Sorry I overlooked this. I do appreciate the detailed
documentation you provide!

Andy

On Fri, Jun 28, 2013 at 10:08 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On Thu, Jun 27 2013, Andrew Davidoff wrote:
>> Hi,
>>
>> If I understand fio's threaded operation, mrfiles are generated for
>> each thread (jobs=N), and each thread operates on its own files. Is
>> there a way to tell fio to spawn multiple threads, but for each to
>> access a single set of files?
>>
>> So:
>>
>> nrfiles=2048
>> jobs=12
>>
>> Would produce 12 threads working against the same 2048 files.
>
> See the 'filename_format' option.
>
> --
> Jens Axboe
>

