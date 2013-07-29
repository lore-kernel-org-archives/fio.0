Return-Path: <asomers@gmail.com>
MIME-Version: 1.0
In-Reply-To: <51F683EC.4090402@kernel.dk>
References: <CAOtMX2if0xLLNngOm4uGgWcrze_61M+jCmHcv0pgNisYsWr_Dg@mail.gmail.com>
	<51F683EC.4090402@kernel.dk>
Date: Mon, 29 Jul 2013 10:00:39 -0600
Message-ID: <CAOtMX2ji_t2MOA_9akkyAkXd=R6sO7V1nWiBfesLFJ5SPg+fdw@mail.gmail.com>
Subject: Re: --minimal does not work in client/server mode
From: asomers@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

I found a few more things that need to be suppressed in terse mode.
The updated patch is here.  In addition to working with JSON output,
we also need to check that the patch doesn't break disk statistics.  I
haven't tried using those at all yet.

https://gist.github.com/asomers/6105396

On Mon, Jul 29, 2013 at 9:02 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 07/26/2013 05:16 PM, asomers@gmail.com wrote:
>> When I use fio in client/server mode, no matter how I try to specify
>> --minimal, I always get the normal output.  I've tried all of these
>> methods, and their combinations:
>>
>> server# fio --server
>> client#  fio --minimal --client=localhost /tmp/cpuio.fio
>>
>> server# fio --server
>> client#  fio --client=localhost --minimal /tmp/cpuio.fio
>>
>> server# fio --minimal --server
>> client# fio --client=localhost  /tmp/cpuio.fio
>>
>> The following patch fixes the problem, though I can't promise it won't
>> break anything else:
>
> It's a good starting point. It needs to handle the json based output too
> though. I'll take a look at fixing that part up and pass you back
> something to test.
>
> --
> Jens Axboe
>

