Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 02/13] Use GOLDEN_RATIO_PRIME
References: <20170328200301.8622-1-tkusumi@tuxera.com>
 <20170328200301.8622-2-tkusumi@tuxera.com>
 <a0c00913-954f-0bc7-a0fa-abbcd87bff7e@kernel.dk>
 <CAHndrBmX18v5sS7DSuj--m1LHe-2R8543SN=OaRy5cmkptqg2g@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <3d7d03f2-f217-2fad-a910-702dcb5b4ebb@kernel.dk>
Date: Tue, 28 Mar 2017 15:19:29 -0600
MIME-Version: 1.0
In-Reply-To: <CAHndrBmX18v5sS7DSuj--m1LHe-2R8543SN=OaRy5cmkptqg2g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 03/28/2017 03:17 PM, Tomohiro Kusumi wrote:
> Hi
> 
> Sorry, I thought using 64bit version on 64bit was the intention..

It would certainly have been nicer from the get-go, but it's not
what we currently have. And I don't want to change seeds just
because. If we were changing them, using the better:

#define GOLDEN_RATIO_32 0x61C88647
#define GOLDEN_RATIO_64 0x61C8864680B583EBull

would be the way to go, though.

-- 
Jens Axboe


