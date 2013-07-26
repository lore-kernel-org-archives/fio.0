Return-Path: <asomers@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20130726031034.GO29296@kernel.dk>
References: <CAOtMX2jEtNYwUct2VN6E2TBoDXXm7oJSXwzJiqKfXGzNvG3QLQ@mail.gmail.com>
	<20130726031034.GO29296@kernel.dk>
Date: Fri, 26 Jul 2013 08:51:18 -0600
Message-ID: <CAOtMX2g9=nmyify=YL+WjiB9rhLPqB5-5q4ARqY=-D_vK6Q9Kg@mail.gmail.com>
Subject: Re: Definition of IO depth distribution in the terse output
From: asomers@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

I still don't understand how there isn't a gap.  Are you saying that
the buckets go like this:
<=1, >=2, >=4, >=8, >=16, >=32, >=64 ?

Is the lowest bucket misnamed, or is there a gap between 1 and 2?

On Thu, Jul 25, 2013 at 9:10 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On Thu, Jul 25 2013, asomers@gmail.com wrote:
>> The man page section for the terse output format describes the IO
>> depth distribution fields as "<=1, 2, 4, 8, 16, 32, >=64".  Should the
>> last entry be ">32" instead?  Similarly, in the section for IO latency
>> distribution, should the final value be ">2000" instead of ">=2000"?
>
> The bucket named 32 is 32 and up (but not including) 64. And so forth.
>
> --
> Jens Axboe
>

