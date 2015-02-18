Return-Path: <axboe@kernel.dk>
Message-ID: <54E4DC17.1080001@kernel.dk>
Date: Wed, 18 Feb 2015 10:38:15 -0800
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [RFC] [PATCH] Allow verification of random overwrites w/ba <
 bs
References: <5A8251503902B84E89CE171AD126BCFB2DE5C66D@NTXBOIMBX01.micron.com>
In-Reply-To: <5A8251503902B84E89CE171AD126BCFB2DE5C66D@NTXBOIMBX01.micron.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: "Justin Eno (jeno)" <jeno@micron.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 02/17/2015 04:36 PM, Justin Eno (jeno) wrote:
> Hi Jens,
>
> This is a two patch set.
>
> blockalign.patch:
> This patch modifies the behavior of write logging such that *any* overlap
> between a newly-submitted io_piece and elements in the hist_tree results
> in the stale element(s) being evicted and replaced by the new io_piece.
> The current implementation performs replacement only for totally overlapping
> (i.e., aligned) io_pieces.  This restriction causes verification failures
> for random overwrite workloads if blockalign is smaller than blocksize, and
> the patch allows such workloads to succeed.
>
> Note that this changes verification semantics for the specified workload.
> Instead of verifying each written byte, verification for this case covers
> only fully-intact blocks, i.e., remnants of partially-overwritten blocks
> are left unverified.
>
> bsrange.patch:
> This takes advantage of the behavior introduced by blockalign.patch to
> unlock verification of random overwrite workloads with multiple blocksizes.
> The caveat about verification applies here as well, so I've left the warning
> in init.c.

Both of these look good, applied, thanks!

-- 
Jens Axboe


