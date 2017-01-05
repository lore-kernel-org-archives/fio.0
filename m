Return-Path: <axboe@kernel.dk>
Subject: Re: pmemblk and dev-dax cleanups
References: <20170104065453.15106-1-elliott@hpe.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <b9c1a1c7-c2ee-8a21-ee21-8e4a5ae7b46f@kernel.dk>
Date: Thu, 5 Jan 2017 11:47:55 -0700
MIME-Version: 1.0
In-Reply-To: <20170104065453.15106-1-elliott@hpe.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Robert Elliott <elliott@hpe.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 01/03/2017 11:54 PM, Robert Elliott wrote:
> This series changes library loading to startup time, and resubmits
> pmemblk and dev-dax patches that were not posted earlier but not
> included in the previous 12-part series of binary/decimal prefix
> cleanups.
> 
>  [PATCH 1/4] pmemblk, dev-dax: load libpmem and libpmemblk at startup
>  [PATCH 2/4] pmemblk, dev-dax: Update descriptions
>  [PATCH 3/4] pmemblk,dev-dax: clean up error logs
>  [PATCH 4/4] pmemblk: Clarify fsize is in MiB not MB

Will you resend with 1/4 fixed up?

-- 
Jens Axboe


