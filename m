Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33270 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab3BLFjp convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 12 Feb 2013 00:39:45 -0500
Received: by mail-wi0-f170.google.com with SMTP id hm11so4122587wib.3
        for <fio@vger.kernel.org>; Mon, 11 Feb 2013 21:39:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5119A093.2030409@cse.unsw.edu.au>
References: <CACTzACVkfEmHrCTJExxOpPqD7tZLMbmW7n3pJza-g87sZaaK1g@mail.gmail.com>
	<CACTzACUwtE+aoHy72dAvgcx8zby5DYwYZzhoJfOyTCj5ABCGgg@mail.gmail.com>
	<20130211172550.GU21269@kernel.dk>
	<5119A093.2030409@cse.unsw.edu.au>
Date: Tue, 12 Feb 2013 00:39:43 -0500
Message-ID: <CACTzACVH_QOWjKDMBGA9YNa-p1tkCN++OPShr=G3Dfgiy4ivxA@mail.gmail.com>
Subject: Re: problem FIO compiling for Android
From: David N <android.wm.edu@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Aaron Carroll <aaronc@cse.unsw.edu.au>
Cc: fio@vger.kernel.org

Hi Aaron,

Thanks much for your help. I still get following errors. Do you have
any idea where the problem can be?

david@david-HP-ubuntu:~/development/android/external/fio-2.0.13$ make
cross_prefix=3D~/development/android/prebuilts/gcc/linux-x86/arm/arm-linux-=
androideabi-4.7/bin
UNAME=3DAndroid
FIO_VERSION =3D fio-2.0.13
    DEP .depend
    CC gettime.o
    CC fio.o
    CC ioengines.o
    CC init.o
    CC stat.o
    CC log.o
    CC time.o
    CC filesetup.o
    CC eta.o
    CC verify.o
    CC memory.o
    CC io_u.o
    CC parse.o
    CC mutex.o
    CC options.o
    CC rbtree.o
    CC smalloc.o
    CC filehash.o
    CC profile.o
    CC debug.o
    CC lib/rand.o
    CC lib/num2str.o
    CC lib/ieee754.o
    CC crc/crc16.o
    CC crc/crc32.o
    CC crc/crc32c.o
    CC crc/crc32c-intel.o
    CC crc/crc64.o
    CC crc/crc7.o
    CC crc/md5.o
    CC crc/sha1.o
    CC crc/sha256.o
    CC crc/sha512.o
    CC engines/cpu.o
    CC engines/mmap.o
    CC engines/sync.o
    CC engines/null.o
    CC engines/net.o
    CC memalign.o
    CC server.o
    CC client.o
    CC iolog.o
    CC backend.o
    CC libfio.o
    CC flow.o
    CC json.o
    CC lib/zipf.o
    CC lib/axmap.o
    CC lib/lfsr.o
    CC gettime-thread.o
    CC diskutil.o
    CC fifo.o
    CC blktrace.o
    CC trim.o
    CC profiles/tiobench.o
    CC fio
verify.o: In function `verify_async_init':
/home/david/development/android/external/fio-2.0.13/verify.c:1091:
undefined reference to `pthread_attr_setstacksize'
/home/david/development/android/external/fio-2.0.13/verify.c:1104:
undefined reference to `pthread_detach'
/home/david/development/android/external/fio-2.0.13/verify.c:1097:
undefined reference to `pthread_create'
gettime.o: In function `fio_gettime':
/home/david/development/android/external/fio-2.0.13/gettime.c:152:
undefined reference to `pthread_getspecific'
gettime.o: In function `fio_local_clock_init':
/home/david/development/android/external/fio-2.0.13/gettime.c:295:
undefined reference to `pthread_setspecific'
gettime.o: In function `fio_clock_init':
/home/david/development/android/external/fio-2.0.13/gettime.c:309:
undefined reference to `pthread_key_create'
gettime.o: In function `fio_monotonic_clocktest':
/home/david/development/android/external/fio-2.0.13/gettime.c:492:
undefined reference to `pthread_create'
/home/david/development/android/external/fio-2.0.13/gettime.c:511:
undefined reference to `pthread_join'
stat.o: In function `show_running_run_stats':
/home/david/development/android/external/fio-2.0.13/stat.c:1388:
undefined reference to `pthread_create'
/home/david/development/android/external/fio-2.0.13/stat.c:1389:
undefined reference to `pthread_detach'
mutex.o: In function `fio_mutex_init':
/home/david/development/android/external/fio-2.0.13/mutex.c:44:
undefined reference to `pthread_mutexattr_init'
/home/david/development/android/external/fio-2.0.13/mutex.c:54:
undefined reference to `pthread_mutexattr_setpshared'
/home/david/development/android/external/fio-2.0.13/mutex.c:63:
undefined reference to `pthread_condattr_setpshared'
/home/david/development/android/external/fio-2.0.13/mutex.c:74:
undefined reference to `pthread_mutexattr_destroy'
backend.o: In function `thread_main':
/home/david/development/android/external/fio-2.0.13/backend.c:1299:
undefined reference to `cgroup_shutdown'
/home/david/development/android/external/fio-2.0.13/backend.c:1142:
undefined reference to `cgroup_setup'
backend.o: In function `run_threads':
/home/david/development/android/external/fio-2.0.13/backend.c:1568:
undefined reference to `pthread_create'
/home/david/development/android/external/fio-2.0.13/backend.c:1576:
undefined reference to `pthread_detach'
backend.o: In function `create_disk_util_thread':
/home/david/development/android/external/fio-2.0.13/backend.c:1724:
undefined reference to `pthread_create'
/home/david/development/android/external/fio-2.0.13/backend.c:1731:
undefined reference to `pthread_detach'
backend.o: In function `fio_backend':
/home/david/development/android/external/fio-2.0.13/backend.c:1794:
undefined reference to `cgroup_kill'
gettime-thread.o: In function `fio_start_gtod_thread':
/home/david/development/android/external/fio-2.0.13/gettime-thread.c:56:
undefined reference to `pthread_attr_setstacksize'
/home/david/development/android/external/fio-2.0.13/gettime-thread.c:57:
undefined reference to `pthread_create'
/home/david/development/android/external/fio-2.0.13/gettime-thread.c:64:
undefined reference to `pthread_detach'
collect2: ld returned 1 exit status
make: *** [fio] Error 1
david@david-HP-ubuntu:~/development/android/external/fio-2.0.13$ ~~


On Mon, Feb 11, 2013 at 8:53 PM, Aaron Carroll <aaronc@cse.unsw.edu.au> wro=
te:
> On 12/02/13 4:25 AM, Jens Axboe wrote:
>> On Mon, Feb 11 2013, David N wrote:
>>> Hello Everyone,
>>>
>>> I've been trying to compile FIO for Android but keep getting error
>>> bellow. Can anybody give me any guidance please?
>>>
>>> I very much appreciate!
>>>
>>> David
>>>
>>>
>>> david@david-HP-ubuntu:~/development/android/external/fio-2.0.13$ make
>>> UNAME=3DAndroid CROSS_COMPILE=3D$CCOMPILER
>>>     CC init.o
>>> init.c: In function =EF=BF=BDfree_shm=EF=BF=BD:
>>> init.c:224:18: error: storage size of =EF=BF=BDsbuf=EF=BF=BD isn=EF=BF=
=BDt known
>>> init.c:233:3: warning: implicit declaration of function =EF=BF=BDshmdt=
=EF=BF=BD
>>> [-Wimplicit-function-declaration]
>>> init.c:234:3: warning: implicit declaration of function =EF=BF=BDshmctl=
=EF=BF=BD
>>> [-Wimplicit-function-declaration]
>>> init.c:224:18: warning: unused variable =EF=BF=BDsbuf=EF=BF=BD [-Wunuse=
d-variable]
>>> init.c: In function =EF=BF=BDsetup_thread_area=EF=BF=BD:
>>> init.c:263:3: warning: implicit declaration of function =EF=BF=BDshmget=
=EF=BF=BD
>>> [-Wimplicit-function-declaration]
>>> init.c:277:2: warning: implicit declaration of function =EF=BF=BDshmat=
=EF=BF=BD
>>> [-Wimplicit-function-declaration]
>>> init.c:277:10: warning: assignment makes pointer from integer without
>>> a cast [enabled by default]
>>> make: *** [init.o] Error 1
>>
>> Lets CC in Aaron, who added the port.
>
> The switch to configure broke Android.  I got a very minimal build
> working with the attached patch and:
>
>   make
> cross_prefix=3D~/dev/android-toolchain-r8c/bin/arm-linux-androideabi-
> UNAME=3DAndroid
>
>
> Hope that helps,
>   -- Aaron
>
