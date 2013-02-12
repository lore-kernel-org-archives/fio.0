Return-Path: <fio-owner@vger.kernel.org>
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:55752 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751267Ab3BLG1e (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 12 Feb 2013 01:27:34 -0500
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
Date: Tue, 12 Feb 2013 17:27:28 +1100
Message-ID: <5119E0D0.8060704@cse.unsw.edu.au>
MIME-Version: 1.0
Subject: Re: problem FIO compiling for Android
References: <CACTzACVkfEmHrCTJExxOpPqD7tZLMbmW7n3pJza-g87sZaaK1g@mail.gmail.com> <CACTzACUwtE+aoHy72dAvgcx8zby5DYwYZzhoJfOyTCj5ABCGgg@mail.gmail.com> <20130211172550.GU21269@kernel.dk> <5119A093.2030409@cse.unsw.edu.au> <CACTzACVH_QOWjKDMBGA9YNa-p1tkCN++OPShr=G3Dfgiy4ivxA@mail.gmail.com> <5119D9FE.8060403@cse.unsw.edu.au> <CACTzACUbDZ6kNnYTeS_Ggj82SjwbNj5VK1it+YjqRRVzh+dsng@mail.gmail.com>
In-Reply-To: <CACTzACUbDZ6kNnYTeS_Ggj82SjwbNj5VK1it+YjqRRVzh+dsng@mail.gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: David N <android.wm.edu@gmail.com>
Cc: fio@vger.kernel.org

On 12/02/13 5:20 PM, David N wrote:
> Aaron,
>=20
> I added -lpthread in the Makefile and most of the errors disappeared.
> This is left:
>=20
> backend.o: In function `thread_main':
> /home/david/development/android/external/fio-2.0.13/backend.c:1299:
> undefined reference to `cgroup_shutdown'
> /home/david/development/android/external/fio-2.0.13/backend.c:1142:
> undefined reference to `cgroup_setup'
> backend.o: In function `fio_backend':
> /home/david/development/android/external/fio-2.0.13/backend.c:1794:
> undefined reference to `cgroup_kill'
> collect2: ld returned 1 exit status
> make: *** [fio] Error 1

Somehow FIO_HAVE_CGROUPS got defined... perhaps you need a make clean.
Again, please use V=3D1 in your make line when posting errors.

Thanks,
  -- Aaron


>=20
>=20
> On Tue, Feb 12, 2013 at 12:58 AM, Aaron Carroll <aaronc@cse.unsw.edu.au> =
wrote:
>> David,
>>
>> On 12/02/13 4:39 PM, David N wrote:
>>> Thanks much for your help. I still get following errors. Do you have
>>> any idea where the problem can be?
>>
>> I've not seen that problem before.  I wonder if adding -lpthread to the
>> linker flags might fix it?
>>
>> Try adding "V=3D1" to the make arguments and post the failing command.
>>
>>
>>
>>    -- Aaron
>>
>>
>>> david@david-HP-ubuntu:~/development/android/external/fio-2.0.13$ make
>>> cross_prefix=3D~/development/android/prebuilts/gcc/linux-x86/arm/arm-li=
nux-androideabi-4.7/bin
>>> UNAME=3DAndroid
>>> FIO_VERSION =3D fio-2.0.132
>>>     DEP .depend
>>>     CC gettime.o
>>>     CC fio.o
>>>     CC ioengines.o
>>>     CC init.o
>>>     CC stat.o
>>>     CC log.o
>>>     CC time.o
>>>     CC filesetup.o
>>>     CC eta.o
>>>     CC verify.o
>>>     CC memory.o
>>>     CC io_u.o
>>>     CC parse.o
>>>     CC mutex.o
>>>     CC options.o
>>>     CC rbtree.o
>>>     CC smalloc.o
>>>     CC filehash.o
>>>     CC profile.o
>>>     CC debug.o
>>>     CC lib/rand.o
>>>     CC lib/num2str.o
>>>     CC lib/ieee754.o
>>>     CC crc/crc16.o
>>>     CC crc/crc32.o
>>>     CC crc/crc32c.o
>>>     CC crc/crc32c-intel.o
>>>     CC crc/crc64.o
>>>     CC crc/crc7.o
>>>     CC crc/md5.o
>>>     CC crc/sha1.o
>>>     CC crc/sha256.o
>>>     CC crc/sha512.o
>>>     CC engines/cpu.o
>>>     CC engines/mmap.o
>>>     CC engines/sync.o
>>>     CC engines/null.o
>>>     CC engines/net.o
>>>     CC memalign.o
>>>     CC server.o
>>>     CC client.o
>>>     CC iolog.o
>>>     CC backend.o
>>>     CC libfio.o
>>>     CC flow.o
>>>     CC json.o
>>>     CC lib/zipf.o
>>>     CC lib/axmap.o
>>>     CC lib/lfsr.o
>>>     CC gettime-thread.o
>>>     CC diskutil.o
>>>     CC fifo.o
>>>     CC blktrace.o
>>>     CC trim.o
>>>     CC profiles/tiobench.o
>>>     CC fio
>>> verify.o: In function `verify_async_init':
>>> /home/david/development/android/external/fio-2.0.13/verify.c:1091:
>>> undefined reference to `pthread_attr_setstacksize'
>>> /home/david/development/android/external/fio-2.0.13/verify.c:1104:
>>> undefined reference to `pthread_detach'
>>> /home/david/development/android/external/fio-2.0.13/verify.c:1097:
>>> undefined reference to `pthread_create'
>>> gettime.o: In function `fio_gettime':
>>> /home/david/development/android/external/fio-2.0.13/gettime.c:152:
>>> undefined reference to `pthread_getspecific'
>>> gettime.o: In function `fio_local_clock_init':
>>> /home/david/development/android/external/fio-2.0.13/gettime.c:295:
>>> undefined reference to `pthread_setspecific'
>>> gettime.o: In function `fio_clock_init':
>>> /home/david/development/android/external/fio-2.0.13/gettime.c:309:
>>> undefined reference to `pthread_key_create'
>>> gettime.o: In function `fio_monotonic_clocktest':
>>> /home/david/development/android/external/fio-2.0.13/gettime.c:492:
>>> undefined reference to `pthread_create'
>>> /home/david/development/android/external/fio-2.0.13/gettime.c:511:
>>> undefined reference to `pthread_join'
>>> stat.o: In function `show_running_run_stats':
>>> /home/david/development/android/external/fio-2.0.13/stat.c:1388:
>>> undefined reference to `pthread_create'
>>> /home/david/development/android/external/fio-2.0.13/stat.c:1389:
>>> undefined reference to `pthread_detach'
>>> mutex.o: In function `fio_mutex_init':
>>> /home/david/development/android/external/fio-2.0.13/mutex.c:44:
>>> undefined reference to `pthread_mutexattr_init'
>>> /home/david/development/android/external/fio-2.0.13/mutex.c:54:
>>> undefined reference to `pthread_mutexattr_setpshared'
>>> /home/david/development/android/external/fio-2.0.13/mutex.c:63:
>>> undefined reference to `pthread_condattr_setpshared'
>>> /home/david/development/android/external/fio-2.0.13/mutex.c:74:
>>> undefined reference to `pthread_mutexattr_destroy'
>>> backend.o: In function `thread_main':
>>> /home/david/development/android/external/fio-2.0.13/backend.c:1299:
>>> undefined reference to `cgroup_shutdown'
>>> /home/david/development/android/external/fio-2.0.13/backend.c:1142:
>>> undefined reference to `cgroup_setup'
>>> backend.o: In function `run_threads':
>>> /home/david/development/android/external/fio-2.0.13/backend.c:1568:
>>> undefined reference to `pthread_create'
>>> /home/david/development/android/external/fio-2.0.13/backend.c:1576:
>>> undefined reference to `pthread_detach'
>>> backend.o: In function `create_disk_util_thread':
>>> /home/david/development/android/external/fio-2.0.13/backend.c:1724:
>>> undefined reference to `pthread_create'
>>> /home/david/development/android/external/fio-2.0.13/backend.c:1731:
>>> undefined reference to `pthread_detach'
>>> backend.o: In function `fio_backend':
>>> /home/david/development/android/external/fio-2.0.13/backend.c:1794:
>>> undefined reference to `cgroup_kill'
>>> gettime-thread.o: In function `fio_start_gtod_thread':
>>> /home/david/development/android/external/fio-2.0.13/gettime-thread.c:56:
>>> undefined reference to `pthread_attr_setstacksize'
>>> /home/david/development/android/external/fio-2.0.13/gettime-thread.c:57:
>>> undefined reference to `pthread_create'
>>> /home/david/development/android/external/fio-2.0.13/gettime-thread.c:64:
>>> undefined reference to `pthread_detach'
>>> collect2: ld returned 1 exit status
>>> make: *** [fio] Error 1
>>> david@david-HP-ubuntu:~/development/android/external/fio-2.0.13$ ~~
>>>
>>>
>>> On Mon, Feb 11, 2013 at 8:53 PM, Aaron Carroll <aaronc@cse.unsw.edu.au>=
 wrote:
>>>> On 12/02/13 4:25 AM, Jens Axboe wrote:
>>>>> On Mon, Feb 11 2013, David N wrote:
>>>>>> Hello Everyone,
>>>>>>
>>>>>> I've been trying to compile FIO for Android but keep getting error
>>>>>> bellow. Can anybody give me any guidance please?
>>>>>>
>>>>>> I very much appreciate!
>>>>>>
>>>>>> David
>>>>>>
>>>>>>
>>>>>> david@david-HP-ubuntu:~/development/android/external/fio-2.0.13$ make
>>>>>> UNAME=3DAndroid CROSS_COMPILE=3D$CCOMPILER
>>>>>>     CC init.o
>>>>>> init.c: In function =EF=BF=BDfree_shm=EF=BF=BD:
>>>>>> init.c:224:18: error: storage size of =EF=BF=BDsbuf=EF=BF=BD isn=EF=
=BF=BDt known
>>>>>> init.c:233:3: warning: implicit declaration of function =EF=BF=BDshm=
dt=EF=BF=BD
>>>>>> [-Wimplicit-function-declaration]
>>>>>> init.c:234:3: warning: implicit declaration of function =EF=BF=BDshm=
ctl=EF=BF=BD
>>>>>> [-Wimplicit-function-declaration]
>>>>>> init.c:224:18: warning: unused variable =EF=BF=BDsbuf=EF=BF=BD [-Wun=
used-variable]
>>>>>> init.c: In function =EF=BF=BDsetup_thread_area=EF=BF=BD:
>>>>>> init.c:263:3: warning: implicit declaration of function =EF=BF=BDshm=
get=EF=BF=BD
>>>>>> [-Wimplicit-function-declaration]
>>>>>> init.c:277:2: warning: implicit declaration of function =EF=BF=BDshm=
at=EF=BF=BD
>>>>>> [-Wimplicit-function-declaration]
>>>>>> init.c:277:10: warning: assignment makes pointer from integer without
>>>>>> a cast [enabled by default]
>>>>>> make: *** [init.o] Error 1
>>>>>
>>>>> Lets CC in Aaron, who added the port.
>>>>
>>>> The switch to configure broke Android.  I got a very minimal build
>>>> working with the attached patch and:
>>>>
>>>>   make
>>>> cross_prefix=3D~/dev/android-toolchain-r8c/bin/arm-linux-androideabi-
>>>> UNAME=3DAndroid
>>>>
>>>>
>>>> Hope that helps,
>>>>   -- Aaron
>>>>
>>

