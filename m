Return-Path: <axboe@kernel.dk>
Message-ID: <5346A508.1000800@kernel.dk>
Date: Thu, 10 Apr 2014 08:04:56 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [patch 1/1] [PATCH] fio: fix s390 timing for older machines/binutils
References: <20140410130946.570253556@linux.vnet.ibm.com> <20140410131000.557506615@linux.vnet.ibm.com>
In-Reply-To: <20140410131000.557506615@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: ehrhardt@linux.vnet.ibm.com, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-04-10 07:09, ehrhardt@linux.vnet.ibm.com wrote:
> From: Christian Ehrhardt<ehrhardt@linux.vnet.ibm.com>
>
> Older gcc/binutils or one with very low default march will refuse to use stckf.
> On top of that machines older than a z196 don not even have the store clock
> fast facility.
>
> To fix all of those issues, check for the facilities in configure step and make
> the usage of stckf and a matching march dependent to it.
>
> Signed-off-by: Christian Ehrhardt<ehrhardt@linux.vnet.ibm.com>

Thanks, applied.

-- 
Jens Axboe


