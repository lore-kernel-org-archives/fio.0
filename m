Return-Path: <ehrhardt@linux.vnet.ibm.com>
Message-ID: <54F6F792.5060604@linux.vnet.ibm.com>
Date: Wed, 04 Mar 2015 13:16:18 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH] fio: increase max smalloc pools
References: <1425383094-9242-1-git-send-email-ehrhardt@de.ibm.com> <54F62FAC.8090208@kernel.dk> <54F63165.9040903@kernel.dk>
In-Reply-To: <54F63165.9040903@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Christian Ehrhardt <ehrhardt@de.ibm.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 03/03/15 23:10, Jens Axboe wrote:
> On 03/03/2015 03:03 PM, Jens Axboe wrote:
> > On 03/03/2015 04:44 AM, Christian Ehrhardt wrote:
> >> From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
> >>
> >> For our tests with about 250k files we found the smalloc pool being
> >> depleated.
> >> Now for us values of 3-4 would be enough, but since it is a compile
> >> time switch
> >> I'd like to make it safe for everybody and set 8.
> >>
> >> Since it is a dynamic sizing anyway that should hopefully be ok for
> >> everybody.
> >
> > The reason it was scaled down to 1 pool is because we could run into
> > situations where one of the forked processes (or threads) would cause
> > the expansion of pools, and smalloc() could then return memory that
> > wasn't properly shared (or valid) between all jobs. This was recently
> > found and fixed, and the smalloc code should probably just be updated to
> > reflect that. We can't runtime add pools safely.
> >
> > Right now it's 1 pool at 16MB - how about we just bump it to 64MB for
> > that one pool? Or, alternatively, pre-add 4 pools initially when smalloc
> > is setup?
>
> Something like the attached, does that work for you? That's 4 pools of
> 16MB added. I think that's more flexible than (the more ideal) 1 pool of
> 64MB, since fio can survive if later pool additions fail. Or we can bump
> it to 8x16 just to be on the safe side...
>
Hi,
I saw you already checked it in with 8 max pools and your new code to initialize on sinit.
We tested that and it works like a charm for our case now.

Thank you.



