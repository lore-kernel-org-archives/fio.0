Return-Path: <aaronc@cse.unsw.edu.au>
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
Date: Thu, 14 Mar 2013 11:09:48 +1100
Message-ID: <5141154C.20206@cse.unsw.edu.au>
MIME-Version: 1.0
Subject: Re: [PATCH/RFC] Improve cross-compile support
References: <CAKCZDgn5ds9-Fmn6pLW4Y7eCpeJr2C5gks1jKgCK3J-wNtXoeQ@mail.gmail.com> <20130313145930.GJ25165@kernel.dk>
In-Reply-To: <20130313145930.GJ25165@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 14/03/13 1:59 AM, Jens Axboe wrote:
> On Wed, Mar 13 2013, Aaron Carroll wrote:
>> A first attempt at making cross-compile viable is attached.
>> [..]
> 
> Looks OK to me, I can test on other platforms too. But it does not apply
> against current -git:
> 
> patching file Makefile
> patching file configure
> Hunk #3 FAILED at 235.
> 1 out of 9 hunks FAILED -- saving rejects to file configure.rej
> 
> Can you update and resend? Thanks!

I've made more progress with this, so I'll send a new/updated series
through soon.


Thanks,
  -- Aaron


