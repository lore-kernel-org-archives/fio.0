Return-Path: <xaaronc@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20130415082910.GZ12244@kernel.dk>
References: <CAKCZDgnCkwNGFVrWE706Z4S4MYra+XfeOqSV80n-QhDnoVPBuQ@mail.gmail.com>
	<20130415082910.GZ12244@kernel.dk>
Date: Mon, 15 Apr 2013 19:27:56 +1000
Message-ID: <CAKCZDg=s-SFx9WBxk7sBV+nYGXTgv9JpLNZzY=VrVMY2hXwmmw@mail.gmail.com>
Subject: Re: Unit Prefixes
From: Aaron Carroll <xaaronc@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Seems to have been introduced in commit 57fc29fa to master Wed Jun 23
22:24:07 2010 +0200

On 15 April 2013 18:29, Jens Axboe <axboe@kernel.dk> wrote:
> On Mon, Apr 15 2013, Aaron Carroll wrote:
>> I just noticed that the binary/decimal unit prefixes are around the
>> wrong way, in that [KMG]iB is treated as base-10, and [kMG]B as
>> base-2.
>>
>> Is this intentional?
>
> Is this a new "feature" (eg did it come in from the gfio merge), or has
> it always been so?
>
> --
> Jens Axboe
>

