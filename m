Return-Path: <axboe@kernel.dk>
Date: Thu, 15 Dec 2016 13:25:12 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2] fio: add device dax engine
Message-ID: <20161215202512.GB29056@kernel.dk>
References: <148115127004.159869.15069122701228994037.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148115127004.159869.15069122701228994037.stgit@djiang5-desk3.ch.intel.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: fio@vger.kernel.org, ross.zwisler@linux.intel.com, dan.j.williams@intel.com
List-ID: <fio@vger.kernel.org>

On Wed, Dec 07 2016, Dave Jiang wrote:
> Adding an ioengine that access DAX device directly. Very similar to the
> mmap engine. Uses the libpmem's pmem_memcpy_persist() call for writes.

Applied, thanks! One little nit - could you send in a sample job file as
well, to add to examples/?

-- 
Jens Axboe


