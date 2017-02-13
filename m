Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Be more verbose on endianness detection failure
References: <20170213161343.39484-1-tkusumi@tuxera.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <7798a788-4c09-5895-0122-bff132f068f0@kernel.dk>
Date: Mon, 13 Feb 2017 09:15:32 -0700
MIME-Version: 1.0
In-Reply-To: <20170213161343.39484-1-tkusumi@tuxera.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: kusumi.tomohiro@gmail.com, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 02/13/2017 09:13 AM, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
>> I think this deserves and enum. That also enables the compiler to check
>> if the below switch covers all the potential values.
> 
> Updated with enum ENDIAN_XXX, which you can change the naming if it
> doesn't sound good.

Looks fine to me, applied.

-- 
Jens Axboe


