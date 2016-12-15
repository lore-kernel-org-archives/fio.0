Return-Path: <dave.jiang@intel.com>
Subject: Re: [PATCH v2] fio: add device dax engine
References: <148115127004.159869.15069122701228994037.stgit@djiang5-desk3.ch.intel.com>
 <20161215202512.GB29056@kernel.dk>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <47fcfb81-481c-de24-6007-599808c96d65@intel.com>
Date: Thu, 15 Dec 2016 13:38:06 -0700
MIME-Version: 1.0
In-Reply-To: <20161215202512.GB29056@kernel.dk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, ross.zwisler@linux.intel.com, dan.j.williams@intel.com
List-ID: <fio@vger.kernel.org>



On 12/15/2016 01:25 PM, Jens Axboe wrote:
> On Wed, Dec 07 2016, Dave Jiang wrote:
>> Adding an ioengine that access DAX device directly. Very similar to the
>> mmap engine. Uses the libpmem's pmem_memcpy_persist() call for writes.
> 
> Applied, thanks! One little nit - could you send in a sample job file as
> well, to add to examples/?
> 

Will do. I'll send a follow on patch.

