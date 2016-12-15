Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2] fio: add device dax engine
References: <148115127004.159869.15069122701228994037.stgit@djiang5-desk3.ch.intel.com>
 <20161215202512.GB29056@kernel.dk>
 <47fcfb81-481c-de24-6007-599808c96d65@intel.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <20de02e1-3e70-97b6-2bdd-eb7e0507b1de@kernel.dk>
Date: Thu, 15 Dec 2016 14:15:28 -0700
MIME-Version: 1.0
In-Reply-To: <47fcfb81-481c-de24-6007-599808c96d65@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Dave Jiang <dave.jiang@intel.com>
Cc: fio@vger.kernel.org, ross.zwisler@linux.intel.com, dan.j.williams@intel.com
List-ID: <fio@vger.kernel.org>

On 12/15/2016 01:38 PM, Dave Jiang wrote:
> 
> 
> On 12/15/2016 01:25 PM, Jens Axboe wrote:
>> On Wed, Dec 07 2016, Dave Jiang wrote:
>>> Adding an ioengine that access DAX device directly. Very similar to the
>>> mmap engine. Uses the libpmem's pmem_memcpy_persist() call for writes.
>>
>> Applied, thanks! One little nit - could you send in a sample job file as
>> well, to add to examples/?
>>
> 
> Will do. I'll send a follow on patch.

Thanks! Also looks like it isn't wired up in the options. Would be nice
with a patch for options.c adding it to the ioengine list, and update
for fio.1 and HOWTO listing it in there too.

-- 
Jens Axboe


