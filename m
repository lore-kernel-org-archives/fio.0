Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35912
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750854Ab3DLF6g (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 12 Apr 2013 01:58:36 -0400
Date: Fri, 12 Apr 2013 07:58:08 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Make FIO for Android
Message-ID: <20130412055808.GE12244@kernel.dk>
References: <428EE8BD-3617-404A-8661-792573E308D5@intel.com>
 <CAKCZDgnM85AcwD6Ss5YWNjXwY-OE7QFQh22nFdEFHkta_N0hRA@mail.gmail.com>
 <F36FEB27-8751-4321-8E58-661924945DCE@intel.com>
 <CAKCZDgkbxsgB-LDLSSJr3bm2j-aEj783kLT52h9emb18Rs1pUg@mail.gmail.com>
 <1C4A98C0-A6F6-4E57-8A97-C4E8D253D819@intel.com>
 <CAKCZDgmiGQFX1kHrjA9zR_LJLxw-rBotyCXegqQG0gdN99cOtg@mail.gmail.com>
 <CAKCZDgkybSpM5r6b46qO7MsRy6BdFW3O_CAGtoc=8N4zSB5Lpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKCZDgkybSpM5r6b46qO7MsRy6BdFW3O_CAGtoc=8N4zSB5Lpg@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Aaron Carroll <xaaronc@gmail.com>
Cc: "Krishnamurthy, Anush" <anush.krishnamurthy@intel.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Fri, Apr 12 2013, Aaron Carroll wrote:
> Apologies, I'm being a moron today.
> 
> That won't apply cleanly due to minor changes in arch-x86.h, but easy
> to apply by hand. Also the type of ioprio_set() has changed, but
> Android was not updated.
> 
> So, attached is a patch that should get tip back to the state where I
> thought it was -- weird asm errors.

Applied, thanks. Let me see if I can rewrite the cpuid bit, that is the
one that is still causing you problems, right?

-- 
Jens Axboe

