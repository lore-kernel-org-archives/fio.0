Return-Path: <asomers@gmail.com>
MIME-Version: 1.0
In-Reply-To: <51F290C0.6020404@kernel.dk>
References: <CAOtMX2jEtNYwUct2VN6E2TBoDXXm7oJSXwzJiqKfXGzNvG3QLQ@mail.gmail.com>
	<20130726031034.GO29296@kernel.dk>
	<CAOtMX2g9=nmyify=YL+WjiB9rhLPqB5-5q4ARqY=-D_vK6Q9Kg@mail.gmail.com>
	<51F290C0.6020404@kernel.dk>
Date: Fri, 26 Jul 2013 16:28:33 -0600
Message-ID: <CAOtMX2gtJd2owH35FYVUBkKiZT0n93zySB7beTwh-oOMAh3X-Q@mail.gmail.com>
Subject: Re: Definition of IO depth distribution in the terse output
From: asomers@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Fri, Jul 26, 2013 at 9:07 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 07/26/2013 08:51 AM, asomers@gmail.com wrote:
>> I still don't understand how there isn't a gap.  Are you saying that
>> the buckets go like this:
>> <=1, >=2, >=4, >=8, >=16, >=32, >=64 ?
>>
>> Is the lowest bucket misnamed, or is there a gap between 1 and 2?
>
> Bucket0         1

Should this be 0..1?  Or is there some guarantee that there will
always be at least one outstanding IO?

> Bucket1         2..3
> Bucket2         4..7
> Bucket3         8..15
> Bucket4         16..31
> Bucket5         32..63
> Bucket6         64..
>
> --
> Jens Axboe
>

