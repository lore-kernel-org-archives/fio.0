Return-Path: <xaaronc@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAKCZDgmS0mL=7Yiya2yWmfBY5EyE79kwQt66hSxfVOSwHWUCfA@mail.gmail.com>
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
	<20130412070034.GI12244@kernel.dk>
	<CAKCZDgmS0mL=7Yiya2yWmfBY5EyE79kwQt66hSxfVOSwHWUCfA@mail.gmail.com>
Date: Fri, 12 Apr 2013 17:12:06 +1000
Message-ID: <CAKCZDgnX1A_ehzaTD1W7kmfj03jm9ibOg+tfJXTcAsBtmZCO2Q@mail.gmail.com>
Subject: Re: Make FIO for Android
From: Aaron Carroll <xaaronc@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: "Krishnamurthy, Anush" <anush.krishnamurthy@intel.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

By the way, that patch plus a (working, ideally) cpuid fix gives a
clean build on Android/arm and Android/x86

On 12 April 2013 17:10, Aaron Carroll <xaaronc@gmail.com> wrote:
> On 12 April 2013 17:00, Jens Axboe <axboe@kernel.dk> wrote:
>> On Fri, Apr 12 2013, Aaron Carroll wrote:
>>> tuff
>>> > should be basic enough that it isn't a lot of trouble to carry it. At
>>> > least when we figure out why the Android NDK doesn't like the current
>>> > restraints :-)
>>>
>>> Digging around the GCC headers seems to have helped.  If you change
>>> the constraint on ebx to:
>>>         : "=a" (*eax), "=r" (*ebx), "=c" (*ecx), "=d" (*edx)
>>> then it builds.
>>
>> But it doesn't work, we lose the output :-)
>
> Ahh, I missed some important stuff.  The ASM from cpuid.h looks like
> this on my Android/x86 GCC:
>
> #define __cpuid(level, a, b, c, d)          \
>   __asm__ ("xchg{l}\t{%%}ebx, %1\n\t"           \
>        "cpuid\n\t"                  \
>        "xchg{l}\t{%%}ebx, %1\n\t"           \
>        : "=a" (a), "=r" (b), "=c" (c), "=d" (d) \
>        : "0" (level))
>
> Hopefully someone who knows what they're doing can turn that into an fio fix :)
>
>>> The relevant comment from cpuid.h:
>>>   /* %ebx may be the PIC register.  */
>>> which is ifdef'd on __PIC__
>>>
>>> Dunno what that means, but it builds with that, plus a very small
>>> Android-specific fix.  Both in attached patch.
>>
>> Patch is garbled?
>
> Ok, so gmail sucks for dev work.  Sorry.  The Android bit follows inline.
>
> diff --git a/os/os-android.h b/os/os-android.h
> index b844982..df22333 100644
> --- a/os/os-android.h
> +++ b/os/os-android.h
> @@ -13,6 +13,7 @@
>  #include <sched.h>
>  #include <linux/unistd.h>
>  #include <linux/major.h>
> +#include <asm/byteorder.h>
>
>  #include "binject.h"
>  #include "../file.h"

