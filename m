Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Mon, 22 Feb 2021 19:37:48 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 1/4] parse: simplify parse_is_percent()
Message-ID: <YDPd3CMn9MRPZ4Do@localhost.localdomain>
References: <YDOvg+OKTZhSoDce@localhost.localdomain>
 <4c012bb6-5100-6262-20a1-ba6992786c25@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4c012bb6-5100-6262-20a1-ba6992786c25@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, dmitry.fomichev@wdc.com
List-ID: <fio@vger.kernel.org>

On Mon, Feb 22, 2021 at 07:36:42AM -0700, Jens Axboe wrote:
> On 2/22/21 6:20 AM, Alexey Dobriyan wrote:
> > Check "unsigned long long val <= -1ULL" is tautologically true
> > because of how value conversions work.
> 
> Thanks, applied this and the other 3 patches. Note for future
> patch series you should use git send-email and provide a small cover
> letter for the series. Also avoids typos like 2/5 for patch 2, and
> it gives the reviewer a sense of the whole series.

Oh well, still can't get used to bulk emailing.

These patches are independent in fact.
There is textual dependency between parse_is_percent() and main 'z'
suffix patch.

And the rest was found while reading code for 'z' suffix.

