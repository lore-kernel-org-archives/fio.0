Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:55793 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab3HAVDY (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 1 Aug 2013 17:03:24 -0400
Message-ID: <51FACCF8.2050304@kernel.dk>
Date: Thu, 01 Aug 2013 15:02:48 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: FIO and Storage Data Integrity testing
References: <CANEJEGsMAS3uYtQx04bq8mPcdnhtXaVwg=vS=TgcY97d2kQeqw@mail.gmail.com> <51F98044.1080105@kernel.dk> <CANEJEGvQZXa4NhsjZcawQ+Z6MTOgzfJEX+t1WY2yX_+R-qC3Og@mail.gmail.com> <20130801022535.GF24569@kernel.dk>
In-Reply-To: <20130801022535.GF24569@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: Juan Casse <jcasse@google.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 07/31/2013 08:25 PM, Jens Axboe wrote:
>> I want four pieces of data for bread crumbs:
>> o timestamp
> 
> Don't have that, trivial to add.

Just went and looked at what we had for the meta verify. There is
actually already a timestamp there (sec + usec), and there's the notion
of a generation number as well (it includes what number write this was).

The structure looks like this:

struct vhdr_meta
{
        uint64_t offset;
        unsigned char thread;
        unsigned short numberio;
        unsigned long time_sec;
        unsigned long time_usec;
};

Though the 'generation' number might have to be either used differently
that it is now, or made into a different type. The meta verify is also
the only one that isn't already 32 vs 64-bit agnostic.

-- 
Jens Axboe

