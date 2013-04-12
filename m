Return-Path: <xaaronc@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20130412071601.GJ12244@kernel.dk>
References: <20130412055808.GE12244@kernel.dk>
	<CAKCZDg=sNxp+mAwTQfBthm-9n=kN2yKgWG52hmmaRBAr+K9fHA@mail.gmail.com>
	<20130412061806.GF12244@kernel.dk>
	<CAKCZDgkF-Pa=5Xzz-PSrFNTjrW-TY2FoQa2m0YpshtLa5SssOw@mail.gmail.com>
	<20130412063005.GG12244@kernel.dk>
	<CAKCZDg=yf2y6hiSoxEExkEo91txMn3HEp7TVovDAmVwJK_M6mw@mail.gmail.com>
	<20130412063851.GH12244@kernel.dk>
	<CAKCZDgkXzGvvdUaYqqR0-3zV==spgU=8QA757CfnRwFbdVj_JA@mail.gmail.com>
	<20130412070034.GI12244@kernel.dk>
	<CAKCZDgmS0mL=7Yiya2yWmfBY5EyE79kwQt66hSxfVOSwHWUCfA@mail.gmail.com>
	<20130412071601.GJ12244@kernel.dk>
Date: Fri, 12 Apr 2013 17:22:24 +1000
Message-ID: <CAKCZDg=4xEuokz_em7p0EqAbQaLEQ7ZC9YddmZFHDvf15Ptunw@mail.gmail.com>
Subject: Re: Make FIO for Android
From: Aaron Carroll <xaaronc@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: "Krishnamurthy, Anush" <anush.krishnamurthy@intel.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12 April 2013 17:16, Jens Axboe <axboe@kernel.dk> wrote:
> Applied! That just leaves the cgroup problems:
>
> cgroup.c: In function 'find_cgroup_mnt':
> cgroup.c:29:2: warning: implicit declaration of function 'setmntent'
> [-Wimplicit-function-declaration]
> cgroup.c:29:4: warning: assignment makes pointer from integer without a
> cast [enabled by default]
> cgroup.c:35:2: warning: implicit declaration of function 'getmntent_r'
> [-Wimplicit-function-declaration]
> cgroup.c:35:14: warning: assignment makes pointer from integer without a
> cast [enabled by default]
> cgroup.c:46:2: warning: implicit declaration of function 'endmntent'
> [-Wimplicit-function-declaration]
> cgroup.c: At top level:
> cgroup.c:78:6: error: redefinition of 'cgroup_kill'
> cgroup.h:24:20: note: previous definition of 'cgroup_kill' was here
> cgroup.c:147:5: error: redefinition of 'cgroup_setup'
> cgroup.h:13:19: note: previous definition of 'cgroup_setup' was here
> cgroup.c:189:6: error: redefinition of 'cgroup_shutdown'
> cgroup.h:20:20: note: previous definition of 'cgroup_shutdown' was here
> make: *** [cgroup.o] Error 1

What compiler generates that?  As I said I'm now getting clean builds
for Android.

