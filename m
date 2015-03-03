Return-Path: <axboe@kernel.dk>
Message-ID: <54F62FAC.8090208@kernel.dk>
Date: Tue, 03 Mar 2015 15:03:24 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] fio: increase max smalloc pools
References: <1425383094-9242-1-git-send-email-ehrhardt@de.ibm.com>
In-Reply-To: <1425383094-9242-1-git-send-email-ehrhardt@de.ibm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Christian Ehrhardt <ehrhardt@de.ibm.com>, fio@vger.kernel.org
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
List-ID: <fio@vger.kernel.org>

On 03/03/2015 04:44 AM, Christian Ehrhardt wrote:
> From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
>
> For our tests with about 250k files we found the smalloc pool being depleated.
> Now for us values of 3-4 would be enough, but since it is a compile time switch
> I'd like to make it safe for everybody and set 8.
>
> Since it is a dynamic sizing anyway that should hopefully be ok for everybody.

The reason it was scaled down to 1 pool is because we could run into 
situations where one of the forked processes (or threads) would cause 
the expansion of pools, and smalloc() could then return memory that 
wasn't properly shared (or valid) between all jobs. This was recently 
found and fixed, and the smalloc code should probably just be updated to 
reflect that. We can't runtime add pools safely.

Right now it's 1 pool at 16MB - how about we just bump it to 64MB for 
that one pool? Or, alternatively, pre-add 4 pools initially when smalloc 
is setup?

-- 
Jens Axboe


