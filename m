Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46601
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978Ab3DMSF7 (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 13 Apr 2013 14:05:59 -0400
Date: Sat, 13 Apr 2013 20:05:30 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Make FIO for Android
Message-ID: <20130413180530.GY12244@kernel.dk>
References: <20130412063005.GG12244@kernel.dk>
 <CAKCZDg=yf2y6hiSoxEExkEo91txMn3HEp7TVovDAmVwJK_M6mw@mail.gmail.com>
 <20130412063851.GH12244@kernel.dk>
 <CAKCZDgkXzGvvdUaYqqR0-3zV==spgU=8QA757CfnRwFbdVj_JA@mail.gmail.com>
 <20130412070034.GI12244@kernel.dk>
 <CAKCZDgmS0mL=7Yiya2yWmfBY5EyE79kwQt66hSxfVOSwHWUCfA@mail.gmail.com>
 <20130412071601.GJ12244@kernel.dk>
 <CAKCZDg=4xEuokz_em7p0EqAbQaLEQ7ZC9YddmZFHDvf15Ptunw@mail.gmail.com>
 <20130412080424.GK12244@kernel.dk>
 <CAKCZDg=3vo9gFMSxUiU7uerLnvw6RWiC-7TW48rhJBKMPfpDuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKCZDg=3vo9gFMSxUiU7uerLnvw6RWiC-7TW48rhJBKMPfpDuA@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Aaron Carroll <xaaronc@gmail.com>
Cc: "Krishnamurthy, Anush" <anush.krishnamurthy@intel.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Sat, Apr 13 2013, Aaron Carroll wrote:
> On 12 April 2013 18:04, Jens Axboe <axboe@kernel.dk> wrote:
> > On Fri, Apr 12 2013, Aaron Carroll wrote:
> >> s pointer from integer without a
> >> > cast [enabled by default]
> >> > cgroup.c:46:2: warning: implicit declaration of function 'endmntent'
> >> > [-Wimplicit-function-declaration]
> >> > cgroup.c: At top level:
> >> > cgroup.c:78:6: error: redefinition of 'cgroup_kill'
> >> > cgroup.h:24:20: note: previous definition of 'cgroup_kill' was here
> >> > cgroup.c:147:5: error: redefinition of 'cgroup_setup'
> >> > cgroup.h:13:19: note: previous definition of 'cgroup_setup' was here
> >> > cgroup.c:189:6: error: redefinition of 'cgroup_shutdown'
> >> > cgroup.h:20:20: note: previous definition of 'cgroup_shutdown' was here
> >> > make: *** [cgroup.o] Error 1
> >>
> >> What compiler generates that?  As I said I'm now getting clean builds
> >> for Android.
> >
> > I grabbed the 32-bit NDK from the page you referenced.
> 
> I'm using that exact NDK and don't get that error. Weird.

What about the mntent related ones? Looking at mntent.h in
sysroot/usr/include/, it contains:

----

#ifndef _MNTENT_H_
#define _MNTENT_H_

#include <stdio.h>

#define MNTTYPE_IGNORE "ignore"

struct mntent
{
    char* mnt_fsname;
    char* mnt_dir;
    char* mnt_type;
    char* mnt_opts;
    int mnt_freq;
    int mnt_passno;
};


__BEGIN_DECLS


struct mntent* getmntent(FILE*);

__END_DECLS

#endif

----

So bits missing... The cgroup stuff I didn't look at. You are using the
32-bit variant as well, not the 64-bit one?

-- 
Jens Axboe

