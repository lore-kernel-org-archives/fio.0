Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53751
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759331Ab3CHSFl (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 8 Mar 2013 13:05:41 -0500
Date: Fri, 8 Mar 2013 19:05:19 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Reserved Keywords & Offset Percentage
Message-ID: <20130308180519.GC14525@kernel.dk>
References: <CANUChTzsrxWbxWUS_wQ4eWJ_jVktL=DXvzGqn0U4aCukKWMmew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANUChTzsrxWbxWUS_wQ4eWJ_jVktL=DXvzGqn0U4aCukKWMmew@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gavin Martin <gavin_martin@xyratex.com>
Cc: fio@vger.kernel.org

On Thu, Mar 07 2013, Gavin Martin wrote:
> Does Fio know the MaxLBA for devices it runs to?  If the size variable
> has a percentage value, for example 50%, then it must have to read the
> MaxLBA to know that on a 4TB drive the size of file we want is 2TB?
> Is this correct or does it use another method?

That is correct, when adding files or devices, fio will check and store
the size of them.

> If so would it be possible to have a reserved keyword for the MaxLBA,
> much as you do currently for pagesize, memory & cpu's so that the size
> & offset variable could make use of it, with the simple math
> supported?

The problem here is that the current keywords are system wide specific,
whereas MaxLBA could refer to any particular device. So it would only
be valid within the scope of a single file.

> Not being a programmer and having very limited knowledge when it comes
> to reading code, I have no idea if this is even possible within Fio?
> 
> If the above is not suitable, would it be possible for the offset
> variable to accept percentages much like the size variable?
> 
> This comes from wanting to run Fio from dual hosts, I need to be able
> to control which parts of the disk each host can access, so that they
> do not interfere, on drives & ssds of many different sizes.
> 
> Basic example:
> 
> [Host 1]
> size=50%
> offset=0
> 
> [Host 2]
> size=50%
> offset 50%

Suppporting a percentage with offset would not be hard, but it would
only really work for a single file. For that, it would be doable.

-- 
Jens Axboe

