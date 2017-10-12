Return-Path: <andrzej.jakowski@gmail.com>
MIME-Version: 1.0
In-Reply-To: <28cd47ad-913c-0eaa-ec2d-84ab47763029@gmail.com>
References: <20171010212710.12526-1-andrzej.jakowski@intel.com>
 <CALjAwxhFr84M6p3SUmJuu8novyP+Wq7fiyPrTd=qGn4ubHwC1w@mail.gmail.com>
 <cf6c368d-110e-7776-bcc8-76e9d024914a@kernel.dk> <28cd47ad-913c-0eaa-ec2d-84ab47763029@gmail.com>
From: Andrzej Jakowski <andrzej.jakowski@gmail.com>
Date: Wed, 11 Oct 2017 22:28:50 -0700
Message-ID: <CAOmo8DbWZTT=yZE1rDrGBabji83-SwH+p0M5TpFk9awNdvMdGw@mail.gmail.com>
Subject: Re: [PATCH] Fix overflow in percentile calculation for Windows
Content-Type: text/plain; charset="UTF-8"
To: Vincent Fu <vincentfu@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Sitsofe Wheeler <sitsofe@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Andrzej Jakowski <andrzej.jakowski@intel.com>
List-ID: <fio@vger.kernel.org>

On Wed, Oct 11, 2017 at 4:36 PM, Vincent Fu <vincentfu@gmail.com> wrote:
> Andrzej, does this actually resolve the problem you observed? unsigned long
> nr in the parameter list of calc_clat_percentiles() and
> show_clat_percentiles() also looks like it will overflow when you have more
> than 2^32 IOs.
Yes you are right. That original patch is not sufficient. Will get it
fixed and post new version soon.

>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

