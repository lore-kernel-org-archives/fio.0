Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] fio: Add support for auto detect dev-dax and libpmemblk
 engines
References: <148227610076.6737.8439319975188847318.stgit@djiang5-desk3.ch.intel.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <d3b55a68-0c6b-6415-7b06-6c8996ed38a5@kernel.dk>
Date: Tue, 20 Dec 2016 16:28:51 -0700
MIME-Version: 1.0
In-Reply-To: <148227610076.6737.8439319975188847318.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Dave Jiang <dave.jiang@intel.com>
Cc: ross.zwisler@linux.intel.com, fio@vger.kernel.org, dan.j.williams@intel.com, elliott@hpe.com
List-ID: <fio@vger.kernel.org>

On 12/20/2016 04:21 PM, Dave Jiang wrote:
> +if test "$libpmem" == "yes" && test "$disable_pmem" == "no"; then
> +  devdax="yes"
> +  if test "$libpmemblk" == "yes"; then
> +    pmemblk="yes"
> +  fi
> +fi
> +

Just use

test "$var" = "yes"

etc, no double ==, or it won't work. Otherwise looks fine.

-- 
Jens Axboe


