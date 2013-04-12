Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56601 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab3DLDhS (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 11 Apr 2013 23:37:18 -0400
Received: by mail-vc0-f174.google.com with SMTP id kw10so1832904vcb.19
        for <fio@vger.kernel.org>; Thu, 11 Apr 2013 20:37:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKCZDgmiGQFX1kHrjA9zR_LJLxw-rBotyCXegqQG0gdN99cOtg@mail.gmail.com>
References: <428EE8BD-3617-404A-8661-792573E308D5@intel.com>
	<CAKCZDgnM85AcwD6Ss5YWNjXwY-OE7QFQh22nFdEFHkta_N0hRA@mail.gmail.com>
	<F36FEB27-8751-4321-8E58-661924945DCE@intel.com>
	<CAKCZDgkbxsgB-LDLSSJr3bm2j-aEj783kLT52h9emb18Rs1pUg@mail.gmail.com>
	<1C4A98C0-A6F6-4E57-8A97-C4E8D253D819@intel.com>
	<CAKCZDgmiGQFX1kHrjA9zR_LJLxw-rBotyCXegqQG0gdN99cOtg@mail.gmail.com>
Date: Fri, 12 Apr 2013 13:37:17 +1000
Message-ID: <CAKCZDgkybSpM5r6b46qO7MsRy6BdFW3O_CAGtoc=8N4zSB5Lpg@mail.gmail.com>
Subject: Re: Make FIO for Android
From: Aaron Carroll <xaaronc@gmail.com>
Content-Type: multipart/mixed; boundary=047d7b5d4530a9499904da219ea5
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Krishnamurthy, Anush" <anush.krishnamurthy@intel.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

--047d7b5d4530a9499904da219ea5
Content-Type: text/plain; charset=ISO-8859-1

Apologies, I'm being a moron today.

That won't apply cleanly due to minor changes in arch-x86.h, but easy
to apply by hand. Also the type of ioprio_set() has changed, but
Android was not updated.

So, attached is a patch that should get tip back to the state where I
thought it was -- weird asm errors.

Sorry for the confusion.
  -- Aaron


On 12 April 2013 13:28, Aaron Carroll <xaaronc@gmail.com> wrote:
> Anush,
>
> Yes, you are right.  I'd forgot I'd fixed that in my local tree.  The
> following patch should fix that issue, but as I said I still get the
> unresolved inline asm problem.
>
>  -- Aaron
>
>
> diff --git a/arch/arch-x86.h b/arch/arch-x86.h
> index 8eea538..69cf60b 100644
> --- a/arch/arch-x86.h
> +++ b/arch/arch-x86.h
> @@ -20,6 +20,12 @@
>  #define __NR_sys_vmsplice      316
>  #endif
>
> +#ifndef __NR_shmget
> +#define __NR_shmget 29
> +#define __NR_shmat 30
> +#define __NR_shmctl 31
> +#endif
> +
>  #define        FIO_HUGE_PAGE           4194304
>
>  #define nop            __asm__ __volatile__("rep;nop": : :"memory")
>
>
>
> On 12 April 2013 13:17, Krishnamurthy, Anush
> <anush.krishnamurthy@intel.com> wrote:
>> Thanks Aaron -
>>
>> I tried doing that and I got stuck at gettime_thread.c which refers to shmctl and shmat etc. it is looking for __NR_shmat and not able to find it. Basically native android source does not have shared memory in any of the headers.
>>
>> Regards
>> Anush Krishnamurthy
>>
>>
>> On Apr 11, 2013, at 7:49 PM, "Aaron Carroll" <xaaronc@gmail.com> wrote:
>>
>>> On 12 April 2013 11:20, Krishnamurthy, Anush
>>> <anush.krishnamurthy@intel.com> wrote:
>>>> Thanks Aaron. I will give this a go. I also wanted to know if you ever tried
>>>> compiling this in the native source. I mean the whole android source.
>>>
>>> I have not.  Others have tried creating Android.mk make files for
>>> this, but IIRC they bypass the fio build system and specify everything
>>> manually. If you know how to do such a thing without creating a
>>> maintenance nightmare, I think that would be well received.
>>>
>>> Thanks,
>>>  -- Aaron
>>>
>>>
>>>>
>>>> Regards
>>>> Anush Krishnamurthy
>>>>
>>>>
>>>> On Apr 11, 2013, at 6:17 PM, "Aaron Carroll" <xaaronc@gmail.com> wrote:
>>>>
>>>> Hi Anush,
>>>>
>>>> On 12 April 2013 03:57, Krishnamurthy, Anush <anush.krishnamurthy@intel.com>
>>>> wrote:
>>>>>
>>>>> I would like to make FIO for Android source. I tried Aaron's post and ran
>>>>> into problems. I also tried making a Android.mk and got into undeclared
>>>>> values for __NR_shm*
>>>>>
>>>>> When I make here is what i get..
>>>>>
>>>>> akrish9@akrish9-ws:~/setup/fio [master] $ make V=1 UNAME=Android
>>>>> cross_prefix=~/android-ndk-r8e/toolchains/x86-4.6/prebuilt/linux-x86_64/bin/i686-linux-android-
>>>>
>>>>
>>>> This is not the problem here, but the preferred way to invoke cross compiles
>>>> is now:
>>>>  make CROSS_COMPILE=/path/to/bin/i686-linux-android-
>>>> Uname is deprecated.
>>>>
>>>> Now, the issue is that you can't run the Android toolchains directly out of
>>>> the NDK, because the lib paths are wrong.  What you need to do is build a
>>>> standalone toolchain with ./build/tools/make-standalone-toolchain.sh from
>>>> the NDK root dir. The script has a bunch of args to specify the versions and
>>>> archs.  That will generate a tar of a standalone toolchain: untar is
>>>> somewhere and point CROSS_COMPILE to there, and it should build.
>>>>
>>>> Except that if you're targeting x86, it doesn't, due to a previously
>>>> reported issue with some inline asm:
>>>>  arch/arch-x86-common.h:9:2: error: inconsistent operand constraints in an
>>>> 'asm'
>>>>
>>>> I'm not sure what's going on there, but I don't speak x86 asm.
>>>>
>>>>
>>>>
>>>> Cheers,
>>>>   -- Aaron
>>>>
>>>>
>>>>
>>>>
>>>>
>>>>> Makefile:12: config-host.mak: No such file or directory
>>>>> Running configure for you...
>>>>> compile test failed
>>>>> Configure failed, check config.log and/or the above output
>>>>>
>>>>>
>>>>>
>>>>> when i try to configure i get this..
>>>>>
>>>>> akrish9@akrish9-ws:~/setup/fio [master] $ ./configure --cpu=i386
>>>>> --extra-cflags="-D__ANDROID__"
>>>>> --cc=/home/akrish9/android-ndk-r8e/toolchains/x86-4.6/prebuilt/linux-x86_64/i686-linux-android/bin/gcc
>>>>> compile test failed
>>>>> Configure failed, check config.log and/or the above output
>>>>> akrish9@akrish9-ws:~/setup/fio [master] $ cat config.log
>>>>> # FIO configure log Thu Apr 11 10:46:48 MST 2013
>>>>> # Configured with: './configure' '--cpu=i386'
>>>>> '--extra-cflags=-D__ANDROID__'
>>>>> '--cc=/home/akrish9/android-ndk-r8e/toolchains/x86-4.6/prebuilt/linux-x86_64/i686-linux-android/bin/gcc'
>>>>> #
>>>>> gcc -D_GNU_SOURCE -include config-host.h -D__ANDROID__ -c -o
>>>>> /tmp/fio-conf--4681-.o /tmp/fio-conf--4681-.c
>>>>> Compiling test case cross
>>>>>
>>>>>
>>>>> Any help here is appreciated.
>>>>>
>>>>> Thanks,
>>>>> Anush Krishnamurthy
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe fio" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>>

--047d7b5d4530a9499904da219ea5
Content-Type: application/octet-stream; name="android-x86.patch"
Content-Disposition: attachment; filename="android-x86.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hfet0i7x0

ZGlmZiAtLWdpdCBhL2FyY2gvYXJjaC14ODYuaCBiL2FyY2gvYXJjaC14ODYuaAppbmRleCA4ZWVh
NTM4Li42OWNmNjBiIDEwMDY0NAotLS0gYS9hcmNoL2FyY2gteDg2LmgKKysrIGIvYXJjaC9hcmNo
LXg4Ni5oCkBAIC0yMCw2ICsyMCwxMiBAQAogI2RlZmluZSBfX05SX3N5c192bXNwbGljZQkzMTYK
ICNlbmRpZgogCisjaWZuZGVmIF9fTlJfc2htZ2V0CisjZGVmaW5lIF9fTlJfc2htZ2V0IDI5Cisj
ZGVmaW5lIF9fTlJfc2htYXQgMzAKKyNkZWZpbmUgX19OUl9zaG1jdGwgMzEKKyNlbmRpZgorCiAj
ZGVmaW5lCUZJT19IVUdFX1BBR0UJCTQxOTQzMDQKIAogI2RlZmluZSBub3AJCV9fYXNtX18gX192
b2xhdGlsZV9fKCJyZXA7bm9wIjogOiA6Im1lbW9yeSIpCmRpZmYgLS1naXQgYS9vcy9vcy1hbmRy
b2lkLmggYi9vcy9vcy1hbmRyb2lkLmgKaW5kZXggMDcwYWExYS4uYjg0NDk4MiAxMDA2NDQKLS0t
IGEvb3Mvb3MtYW5kcm9pZC5oCisrKyBiL29zL29zLWFuZHJvaWQuaApAQCAtNzksMTEgKzc5LDYg
QEAgc3RhdGljIGlubGluZSBpbnQgc2htZHQgKGNvbnN0IHZvaWQgKl9fc2htYWRkcikKIAogI2Rl
ZmluZSBTUExJQ0VfREVGX1NJWkUJKDY0KjEwMjQpCiAKLXN0YXRpYyBpbmxpbmUgaW50IGlvcHJp
b19zZXQoaW50IHdoaWNoLCBpbnQgd2hvLCBpbnQgaW9wcmlvKQotewotCXJldHVybiBzeXNjYWxs
KF9fTlJfaW9wcmlvX3NldCwgd2hpY2gsIHdobywgaW9wcmlvKTsKLX0KLQogZW51bSB7CiAJSU9Q
UklPX0NMQVNTX05PTkUsCiAJSU9QUklPX0NMQVNTX1JULApAQCAtMTAwLDYgKzk1LDE4IEBAIGVu
dW0gewogI2RlZmluZSBJT1BSSU9fQklUUwkJMTYKICNkZWZpbmUgSU9QUklPX0NMQVNTX1NISUZU
CTEzCiAKK3N0YXRpYyBpbmxpbmUgaW50IGlvcHJpb19zZXQoaW50IHdoaWNoLCBpbnQgd2hvLCBp
bnQgaW9wcmlvX2NsYXNzLCBpbnQgaW9wcmlvKQoreworCS8qCisJICogSWYgbm8gY2xhc3MgaXMg
c2V0LCBhc3N1bWUgQkUKKwkgKi8KKwlpZiAoIWlvcHJpb19jbGFzcykKKwkJaW9wcmlvX2NsYXNz
ID0gSU9QUklPX0NMQVNTX0JFOworCisJaW9wcmlvIHw9IGlvcHJpb19jbGFzcyA8PCBJT1BSSU9f
Q0xBU1NfU0hJRlQ7CisJcmV0dXJuIHN5c2NhbGwoX19OUl9pb3ByaW9fc2V0LCB3aGljaCwgd2hv
LCBpb3ByaW8pOworfQorCiAjaWZuZGVmIEJMS0dFVFNJWkU2NAogI2RlZmluZSBCTEtHRVRTSVpF
NjQJX0lPUigweDEyLDExNCxzaXplX3QpCiAjZW5kaWYK
--047d7b5d4530a9499904da219ea5--
--:
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html


