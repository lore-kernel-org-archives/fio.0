Return-Path: <dave.jiang@intel.com>
Subject: Re: [PATCH] fio: add debug compile flag to avoid compiler warning
References: <148095966487.242344.5154555200954971050.stgit@djiang5-desk3.ch.intel.com>
 <20161215202735.GC29056@kernel.dk>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <f75fd83c-fd1e-f416-7167-e9df03f94f95@intel.com>
Date: Thu, 15 Dec 2016 13:37:37 -0700
MIME-Version: 1.0
In-Reply-To: <20161215202735.GC29056@kernel.dk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>



On 12/15/2016 01:27 PM, Jens Axboe wrote:
> On Mon, Dec 05 2016, Dave Jiang wrote:
>> When compile with debug, without the proper -O flag the compiler complains:
>> /usr/include/features.h:331:4: warning: #warning _FORTIFY_SOURCE requires
>> compiling with optimization (-O) [-Wcpp]
>> #  warning _FORTIFY_SOURCE requires compiling with optimization (-O)
> 
> Wouldn't it be better to only add the FORTIFY parts if optimization is
> enabled?
> 

I didn't know what the intention of that compile flag was. I was just
trying to turn on debugging and hit that. But I will get that moved.

