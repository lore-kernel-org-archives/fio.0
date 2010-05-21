Return-Path: <yamamoto@valinux.co.jp>
Subject: Re: fio netbsd support
In-Reply-To: Your message of "Thu, 20 May 2010 11:20:58 +0200"
	<20100520092057.GK25951@kernel.dk>
References: <20100520092057.GK25951@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20100521014950.37C6371473@kuma.localdomain>
Date: Fri, 21 May 2010 10:49:50 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
To: jens.axboe@oracle.com
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

hi,

> On Thu, May 20 2010, YAMAMOTO Takashi wrote:
>> > On Wed, May 12 2010, YAMAMOTO Takashi wrote:
>> >> hi,
>> >> 
>> >> the attached patch is for preliminary support for netbsd.
>> > 
>> > Thanks, looks good. Applied. The rb bit is a bit icky, but we can fix
>> > that up later.
>> > 
>> > -- 
>> > Jens Axboe
>> 
>> thanks.
>> 
>> it seems that the following small change is necessary to catch up with
>> the recent changes.
> 
> Indeed, thanks. I should have noticed that. I have committed it.

and it seems that you forgot to add os-netbsd.h.

YAMAMOTO Takashi

> 
> -- 
> Jens Axboe

