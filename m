Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOmo8DbWZTT=yZE1rDrGBabji83-SwH+p0M5TpFk9awNdvMdGw@mail.gmail.com>
References: <20171010212710.12526-1-andrzej.jakowski@intel.com>
 <CALjAwxhFr84M6p3SUmJuu8novyP+Wq7fiyPrTd=qGn4ubHwC1w@mail.gmail.com>
 <cf6c368d-110e-7776-bcc8-76e9d024914a@kernel.dk> <28cd47ad-913c-0eaa-ec2d-84ab47763029@gmail.com>
 <CAOmo8DbWZTT=yZE1rDrGBabji83-SwH+p0M5TpFk9awNdvMdGw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 12 Oct 2017 07:06:09 +0100
Message-ID: <CALjAwxi7cd4RFG7WSz+XWHkouKwvX7iFnU3tNri-MgR1RTstZw@mail.gmail.com>
Subject: Re: [PATCH] Fix overflow in percentile calculation for Windows
Content-Type: text/plain; charset="UTF-8"
To: Andrzej Jakowski <andrzej.jakowski@gmail.com>
Cc: Vincent Fu <vincentfu@gmail.com>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Andrzej Jakowski <andrzej.jakowski@intel.com>
List-ID: <fio@vger.kernel.org>

On 12 October 2017 at 06:28, Andrzej Jakowski
<andrzej.jakowski@gmail.com> wrote:
> On Wed, Oct 11, 2017 at 4:36 PM, Vincent Fu <vincentfu@gmail.com> wrote:
>> Andrzej, does this actually resolve the problem you observed? unsigned long
>> nr in the parameter list of calc_clat_percentiles() and
>> show_clat_percentiles() also looks like it will overflow when you have more
>> than 2^32 IOs.
> Yes you are right. That original patch is not sufficient. Will get it
> fixed and post new version soon.

I've got a feeling there are few other 32 bit platform integer
overflows lurking around. I'm trying a clang sanitizer run...

-- 
Sitsofe | http://sucs.org/~sits/

