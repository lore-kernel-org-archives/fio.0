Return-Path: <jcasse@google.com>
MIME-Version: 1.0
In-Reply-To: <5215B983.6090306@enovance.com>
References: <CAPet_20pVqmeXS2YeB9dXnwwira3=RTqS1r4MLvxDNJuRuEHsA@mail.gmail.com>
	<5215B983.6090306@enovance.com>
Date: Thu, 22 Aug 2013 09:48:55 -0700
Message-ID: <CAPet_215++pkVjqjXuVswbRG7kjmhcwOQF206C6ZhTnLW=yzWQ@mail.gmail.com>
Subject: Re: Data Integrity Test with fio
From: Juan Casse <jcasse@google.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Erwan Velu <erwan@enovance.com>
Cc: Juan Casse <jcasse@chromium.org>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, grundler@chromium.org
List-ID: <fio@vger.kernel.org>

Hi Erwan:

Thank you for the prompt reply. I apologize for my lengthy previous email.

On Thu, Aug 22, 2013 at 12:10 AM, Erwan Velu <erwan@enovance.com> wrote:
>
> On 22/08/2013 00:02, Juan Casse wrote:
>>
>> Hi Jens:
>>
>> I wanted to let you know what we intend to do in advance in case you
>> can foresee any problems or have any preferences.
>>
>> We would like fio to test for data integrity/retention as follows.
>
> Does this sample fio job isn't what you are looking at ?
>
> http://git.kernel.dk/?p=fio.git;a=blob;f=examples/surface-scan.fio;h=dc3373a2ea48f495cdc03ccf4dc2e1ed23e3e434;hb=HEAD
>

The sample job is fine. We want to improve the data integrity check to
detect types of failures.

We want fio to check for stale data. We would like to add a generation
number, which counts the number of times the same block has been
written.

So here is what Grant and I are currently considering doing; a bit
different from what I proposed in my previous email.

- Add a separate LFSR, one for reads and one for writes
- Add a check for numberio_w; numberio_w is a global count of writes
that fio currently keeps track of, but can serve the same purpose as
the generation number.
- During the verification phase, we simply run the LFSR forward
(without actually writing) and fill a numberio_w table with the last
computed numberio_w for each block, then read each block back and
compare against the computed numberio_w.

Thank you,
Juan

>
> Erwan,

