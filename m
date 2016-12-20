Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2] fio: Add support for auto detect dev-dax and
 libpmemblk engines
References: <148227670571.11076.11558753006919597850.stgit@djiang5-desk3.ch.intel.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <ee280e94-8a95-f75a-6893-dc3c73145e6e@kernel.dk>
Date: Tue, 20 Dec 2016 16:44:03 -0700
MIME-Version: 1.0
In-Reply-To: <148227670571.11076.11558753006919597850.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Dave Jiang <dave.jiang@intel.com>
Cc: ross.zwisler@linux.intel.com, fio@vger.kernel.org, dan.j.williams@intel.com, elliott@hpe.com
List-ID: <fio@vger.kernel.org>

On 12/20/2016 04:31 PM, Dave Jiang wrote:
> Added support code in configure to detect whether libpmem and libpmemblk
> are installed. dev-dax engine is enabled if libpmem is installed.
> pmemblk engine is installed if libpmem and libpmemblk are installed.
> A --disable-pmem flag is added to explicitly disable the libpmem based
> engines even if the libs are detected.

Applied, thanks.

-- 
Jens Axboe


