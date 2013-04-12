Return-Path: <fio-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:60345 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab3DLDRo convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 11 Apr 2013 23:17:44 -0400
From: "Krishnamurthy, Anush" <anush.krishnamurthy@intel.com>
Subject: Re: Make FIO for Android
Date: Fri, 12 Apr 2013 03:17:41 +0000
Message-ID: <1C4A98C0-A6F6-4E57-8A97-C4E8D253D819@intel.com>
References: <428EE8BD-3617-404A-8661-792573E308D5@intel.com>
	<CAKCZDgnM85AcwD6Ss5YWNjXwY-OE7QFQh22nFdEFHkta_N0hRA@mail.gmail.com>
	<F36FEB27-8751-4321-8E58-661924945DCE@intel.com>,<CAKCZDgkbxsgB-LDLSSJr3bm2j-aEj783kLT52h9emb18Rs1pUg@mail.gmail.com>
In-Reply-To: <CAKCZDgkbxsgB-LDLSSJr3bm2j-aEj783kLT52h9emb18Rs1pUg@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Aaron Carroll <xaaronc@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Thanks Aaron - 

I tried doing that and I got stuck at gettime_thread.c which refers to shmctl and shmat etc. it is looking for __NR_shmat and not able to find it. Basically native android source does not have shared memory in any of the headers. 

Regards
Anush Krishnamurthy


On Apr 11, 2013, at 7:49 PM, "Aaron Carroll" <xaaronc@gmail.com> wrote:

> On 12 April 2013 11:20, Krishnamurthy, Anush
> <anush.krishnamurthy@intel.com> wrote:
>> Thanks Aaron. I will give this a go. I also wanted to know if you ever tried
>> compiling this in the native source. I mean the whole android source.
> 
> I have not.  Others have tried creating Android.mk make files for
> this, but IIRC they bypass the fio build system and specify everything
> manually. If you know how to do such a thing without creating a
> maintenance nightmare, I think that would be well received.
> 
> Thanks,
>  -- Aaron
> 
> 
>> 
>> Regards
>> Anush Krishnamurthy
>> 
>> 
>> On Apr 11, 2013, at 6:17 PM, "Aaron Carroll" <xaaronc@gmail.com> wrote:
>> 
>> Hi Anush,
>> 
>> On 12 April 2013 03:57, Krishnamurthy, Anush <anush.krishnamurthy@intel.com>
>> wrote:
>>> 
>>> I would like to make FIO for Android source. I tried Aaron's post and ran
>>> into problems. I also tried making a Android.mk and got into undeclared
>>> values for __NR_shm*
>>> 
>>> When I make here is what i get..
>>> 
>>> akrish9@akrish9-ws:~/setup/fio [master] $ make V=1 UNAME=Android
>>> cross_prefix=~/android-ndk-r8e/toolchains/x86-4.6/prebuilt/linux-x86_64/bin/i686-linux-android-
>> 
>> 
>> This is not the problem here, but the preferred way to invoke cross compiles
>> is now:
>>  make CROSS_COMPILE=/path/to/bin/i686-linux-android-
>> Uname is deprecated.
>> 
>> Now, the issue is that you can't run the Android toolchains directly out of
>> the NDK, because the lib paths are wrong.  What you need to do is build a
>> standalone toolchain with ./build/tools/make-standalone-toolchain.sh from
>> the NDK root dir. The script has a bunch of args to specify the versions and
>> archs.  That will generate a tar of a standalone toolchain: untar is
>> somewhere and point CROSS_COMPILE to there, and it should build.
>> 
>> Except that if you're targeting x86, it doesn't, due to a previously
>> reported issue with some inline asm:
>>  arch/arch-x86-common.h:9:2: error: inconsistent operand constraints in an
>> 'asm'
>> 
>> I'm not sure what's going on there, but I don't speak x86 asm.
>> 
>> 
>> 
>> Cheers,
>>   -- Aaron
>> 
>> 
>> 
>> 
>> 
>>> Makefile:12: config-host.mak: No such file or directory
>>> Running configure for you...
>>> compile test failed
>>> Configure failed, check config.log and/or the above output
>>> 
>>> 
>>> 
>>> when i try to configure i get this..
>>> 
>>> akrish9@akrish9-ws:~/setup/fio [master] $ ./configure --cpu=i386
>>> --extra-cflags="-D__ANDROID__"
>>> --cc=/home/akrish9/android-ndk-r8e/toolchains/x86-4.6/prebuilt/linux-x86_64/i686-linux-android/bin/gcc
>>> compile test failed
>>> Configure failed, check config.log and/or the above output
>>> akrish9@akrish9-ws:~/setup/fio [master] $ cat config.log
>>> # FIO configure log Thu Apr 11 10:46:48 MST 2013
>>> # Configured with: './configure' '--cpu=i386'
>>> '--extra-cflags=-D__ANDROID__'
>>> '--cc=/home/akrish9/android-ndk-r8e/toolchains/x86-4.6/prebuilt/linux-x86_64/i686-linux-android/bin/gcc'
>>> #
>>> gcc -D_GNU_SOURCE -include config-host.h -D__ANDROID__ -c -o
>>> /tmp/fio-conf--4681-.o /tmp/fio-conf--4681-.c
>>> Compiling test case cross
>>> 
>>> 
>>> Any help here is appreciated.
>>> 
>>> Thanks,
>>> Anush Krishnamurthy
>>> 
>>> 
>>> 
>>> 
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe fio" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>> 
