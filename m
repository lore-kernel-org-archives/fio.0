Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36051
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753144Ab3DLGjR (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 12 Apr 2013 02:39:17 -0400
Date: Fri, 12 Apr 2013 08:38:51 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Make FIO for Android
Message-ID: <20130412063851.GH12244@kernel.dk>
References: <CAKCZDgkbxsgB-LDLSSJr3bm2j-aEj783kLT52h9emb18Rs1pUg@mail.gmail.com>
 <1C4A98C0-A6F6-4E57-8A97-C4E8D253D819@intel.com>
 <CAKCZDgmiGQFX1kHrjA9zR_LJLxw-rBotyCXegqQG0gdN99cOtg@mail.gmail.com>
 <CAKCZDgkybSpM5r6b46qO7MsRy6BdFW3O_CAGtoc=8N4zSB5Lpg@mail.gmail.com>
 <20130412055808.GE12244@kernel.dk>
 <CAKCZDg=sNxp+mAwTQfBthm-9n=kN2yKgWG52hmmaRBAr+K9fHA@mail.gmail.com>
 <20130412061806.GF12244@kernel.dk>
 <CAKCZDgkF-Pa=5Xzz-PSrFNTjrW-TY2FoQa2m0YpshtLa5SssOw@mail.gmail.com>
 <20130412063005.GG12244@kernel.dk>
 <CAKCZDg=yf2y6hiSoxEExkEo91txMn3HEp7TVovDAmVwJK_M6mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKCZDg=yf2y6hiSoxEExkEo91txMn3HEp7TVovDAmVwJK_M6mw@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Aaron Carroll <xaaronc@gmail.com>
Cc: "Krishnamurthy, Anush" <anush.krishnamurthy@intel.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Fri, Apr 12 2013, Aaron Carroll wrote:
> On 12 April 2013 16:30, Jens Axboe <axboe@kernel.dk> wrote:
> > Great, thanks! Will see if I can't get that asm android happy too.
> 
> Thanks.  Does it make sense to use the GCC builtin __get_cpuid() ?
> That seems to build fine both native x86 and Android/x86 here.

Depends on when that was introduced. You'd be surprised to find the
ancient distros that some people build it on... But the cpuid stuff
should be basic enough that it isn't a lot of trouble to carry it. At
least when we figure out why the Android NDK doesn't like the current
restraints :-)

-- 
Jens Axboe

