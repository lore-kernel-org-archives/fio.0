Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36179
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752662Ab3DLHBB (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 12 Apr 2013 03:01:01 -0400
Date: Fri, 12 Apr 2013 09:00:34 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Make FIO for Android
Message-ID: <20130412070034.GI12244@kernel.dk>
References: <CAKCZDgmiGQFX1kHrjA9zR_LJLxw-rBotyCXegqQG0gdN99cOtg@mail.gmail.com>
 <CAKCZDgkybSpM5r6b46qO7MsRy6BdFW3O_CAGtoc=8N4zSB5Lpg@mail.gmail.com>
 <20130412055808.GE12244@kernel.dk>
 <CAKCZDg=sNxp+mAwTQfBthm-9n=kN2yKgWG52hmmaRBAr+K9fHA@mail.gmail.com>
 <20130412061806.GF12244@kernel.dk>
 <CAKCZDgkF-Pa=5Xzz-PSrFNTjrW-TY2FoQa2m0YpshtLa5SssOw@mail.gmail.com>
 <20130412063005.GG12244@kernel.dk>
 <CAKCZDg=yf2y6hiSoxEExkEo91txMn3HEp7TVovDAmVwJK_M6mw@mail.gmail.com>
 <20130412063851.GH12244@kernel.dk>
 <CAKCZDgkXzGvvdUaYqqR0-3zV==spgU=8QA757CfnRwFbdVj_JA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKCZDgkXzGvvdUaYqqR0-3zV==spgU=8QA757CfnRwFbdVj_JA@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Aaron Carroll <xaaronc@gmail.com>
Cc: "Krishnamurthy, Anush" <anush.krishnamurthy@intel.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Fri, Apr 12 2013, Aaron Carroll wrote:
> tuff
> > should be basic enough that it isn't a lot of trouble to carry it. At
> > least when we figure out why the Android NDK doesn't like the current
> > restraints :-)
> 
> Digging around the GCC headers seems to have helped.  If you change
> the constraint on ebx to:
>         : "=a" (*eax), "=r" (*ebx), "=c" (*ecx), "=d" (*edx)
> then it builds.

But it doesn't work, we lose the output :-)

> The relevant comment from cpuid.h:
>   /* %ebx may be the PIC register.  */
> which is ifdef'd on __PIC__
> 
> Dunno what that means, but it builds with that, plus a very small
> Android-specific fix.  Both in attached patch.

Patch is garbled?

-- 
Jens Axboe

