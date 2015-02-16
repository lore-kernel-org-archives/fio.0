Return-Path: <axboe@kernel.dk>
Message-ID: <54E26898.5030706@kernel.dk>
Date: Mon, 16 Feb 2015 15:00:56 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [RFC] [PATCH] Allow random overwrite workloads to write io_limit
References: <5A8251503902B84E89CE171AD126BCFB2DE5C431@NTXBOIMBX01.micron.com>
In-Reply-To: <5A8251503902B84E89CE171AD126BCFB2DE5C431@NTXBOIMBX01.micron.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: "Justin Eno (jeno)" <jeno@micron.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 02/13/2015 04:17 PM, Justin Eno (jeno) wrote:
> For a (random) overwrite workload, 'size' amount of access doesn't correspond to
> each byte on the target having been touched, so setting size as the limit between
> write- and verify-phases doesn't really apply.  The attached patch proposes to
> instead use io_limit as the limit if it's set.
>
> io_limit < size is already handled by subsequent logic.  This patch just allows
> for io_limit > size.

Thanks Justin, applied.

-- 
Jens Axboe


