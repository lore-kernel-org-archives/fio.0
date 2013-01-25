Return-Path: <brianjamesarb@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20130125212215.GA15635@kernel.dk>
References: <CABYizFKetDGfE_fOARgbehmJo_uDTqy32bMTQTDVyny-Nk5riQ@mail.gmail.com>
	<20130111091010.GA32674@kernel.dk>
	<50F12401.8090606@kernel.dk>
	<CABYizFLj4LSJApybuRfUfCiuqhVNac0T733BcMnpUOAivWhi7A@mail.gmail.com>
	<20130118204040.GT3571@kernel.dk>
	<20130121212925.GA1300@kernel.dk>
	<20130123182100.GC30268@kernel.dk>
	<CABYizF+3JhYd8zRwjq5JNSq5KVPbOs=FjY-4J-1hPK5hCFEEpA@mail.gmail.com>
	<20130125212215.GA15635@kernel.dk>
Date: Fri, 25 Jan 2013 16:28:05 -0500
Message-ID: <CABYizF+DChr6a-NbeJe5isvaWCrTxHVQV+4MOCc3F7prVqwD7w@mail.gmail.com>
Subject: Re: fio is being killed by the oom-killer after fio verify runs for
 some time ~13 hours
From: brian arb <brianjamesarb@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Yes Sir,
It ran to completion with out incident and completed the verification
successfully too.

On Fri, Jan 25, 2013 at 4:22 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On Fri, Jan 25 2013, brian arb wrote:
>> Hi Jen,
>> It appears every thing ran as expected.
>
> Great! I take it that means it:
>
> 1) Ran to completion
> 2) Completed the verify successfully
>
> Correct?
>
> BTW, fio also supports a json output format. It's more robust than the
> csv format, so both easier to parse by a computer reliably, and readable
> by humans as well.
>
> --
> Jens Axboe
>

