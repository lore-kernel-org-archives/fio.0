Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36040
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753153Ab3DLGaa (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 12 Apr 2013 02:30:30 -0400
Date: Fri, 12 Apr 2013 08:30:05 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Make FIO for Android
Message-ID: <20130412063005.GG12244@kernel.dk>
References: <CAKCZDgnM85AcwD6Ss5YWNjXwY-OE7QFQh22nFdEFHkta_N0hRA@mail.gmail.com>
 <F36FEB27-8751-4321-8E58-661924945DCE@intel.com>
 <CAKCZDgkbxsgB-LDLSSJr3bm2j-aEj783kLT52h9emb18Rs1pUg@mail.gmail.com>
 <1C4A98C0-A6F6-4E57-8A97-C4E8D253D819@intel.com>
 <CAKCZDgmiGQFX1kHrjA9zR_LJLxw-rBotyCXegqQG0gdN99cOtg@mail.gmail.com>
 <CAKCZDgkybSpM5r6b46qO7MsRy6BdFW3O_CAGtoc=8N4zSB5Lpg@mail.gmail.com>
 <20130412055808.GE12244@kernel.dk>
 <CAKCZDg=sNxp+mAwTQfBthm-9n=kN2yKgWG52hmmaRBAr+K9fHA@mail.gmail.com>
 <20130412061806.GF12244@kernel.dk>
 <CAKCZDgkF-Pa=5Xzz-PSrFNTjrW-TY2FoQa2m0YpshtLa5SssOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKCZDgkF-Pa=5Xzz-PSrFNTjrW-TY2FoQa2m0YpshtLa5SssOw@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Aaron Carroll <xaaronc@gmail.com>
Cc: "Krishnamurthy, Anush" <anush.krishnamurthy@intel.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Fri, Apr 12 2013, Aaron Carroll wrote:
> On 12 April 2013 16:18, Jens Axboe <axboe@kernel.dk> wrote:
> > On Fri, Apr 12 2013, Aaron Carroll wrote:
> >> On 12 April 2013 15:58, Jens Axboe <axboe@kernel.dk> wrote:
> >> > On Fri, Apr 12 2013, Aaron Carroll wrote:
> >> >> Apologies, I'm being a moron today.
> >> >>
> >> >> That won't apply cleanly due to minor changes in arch-x86.h, but easy
> >> >> to apply by hand. Also the type of ioprio_set() has changed, but
> >> >> Android was not updated.
> >> >>
> >> >> So, attached is a patch that should get tip back to the state where I
> >> >> thought it was -- weird asm errors.
> >> >
> >> > Applied, thanks. Let me see if I can rewrite the cpuid bit, that is the
> >> > one that is still causing you problems, right?
> >>
> >> Yes, so if I build with:
> >>  make CROSS_COMPILE=~/dev/android-toolchains-r8c/x86-4.6/bin/i686-linux-android-
> >
> > For testing purposes, it'd be handy to have the toolchain. Can I just
> > download it somewhere?
> 
> Yep, grab the NDK from here:
>   http://developer.android.com/tools/sdk/ndk/index.html
> 
> untar, cd to the base dir, and run:
>   ./build/tools/make-standalone-toolchain.sh --arch=x86 --platform=android-14
> 
> That will generate a bzipped tarball, which is a working standalone
> Android/x86 toolchain.

Great, thanks! Will see if I can't get that asm android happy too.

-- 
Jens Axboe

