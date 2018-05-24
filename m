Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] make fio scripts python3-ready (part 2)
References: <20180522174909.15967-1-billodo@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <6a2053e4-2bd1-f01e-7464-03e5a5e98661@kernel.dk>
Date: Thu, 24 May 2018 13:11:20 -0600
MIME-Version: 1.0
In-Reply-To: <20180522174909.15967-1-billodo@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Bill O'Donnell <billodo@redhat.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 5/22/18 11:49 AM, Bill O'Donnell wrote:
> NOTE: this patch (part 2) is in addition to commit 5eac3b00238b
> (this patch was missed on that submit/commit (part 1)).
> 
> Many distributions are moving to python3 by default.  This is
> another patch to make the python scripts in fio python3-ready.
> 
> Conversion was facilitated with automated tools.
> 
> The modified scripts pass rudimentary testing when run under
> python2.7 as well as python3.

Applied, thanks.

-- 
Jens Axboe


