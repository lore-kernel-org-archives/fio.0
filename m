Return-Path: <gavin_martin@xyratex.com>
MIME-Version: 1.0
In-Reply-To: <20130412081324.GL12244@kernel.dk>
References: <CANUChTygO-6HnaDU+eufAAtJoGCn9J0UgcEd16+7dgeOXa-92Q@mail.gmail.com>
 <20130412081324.GL12244@kernel.dk>
From: Gavin Martin <gavin_martin@xyratex.com>
Date: Fri, 12 Apr 2013 09:27:05 +0100
Message-ID: <CANUChTysujbj-TQR3MK8_CErA68sVP=H9-+3TXri4S4v5Zs9ZA@mail.gmail.com>
Subject: Re: Unable to Configure latest build
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 12 April 2013 09:13, Jens Axboe <axboe@kernel.dk> wrote:
> On Fri, Apr 12 2013, Gavin Martin wrote:
>> Hi Jens,
>>
>> I grabbed the 2.0.15 when it came out and it configured and compiled
>> fine, but the latest one from today (12/04) displays errors when
>> trying to configure.
>>
>> I'm not doing anything different to what I was doing for the previous
>> builds.  Just running ./configure, below is the output from
>> config.log;
>>
>> # FIO configure log Fri Apr 12 08:25:30 BST 2013
>> # Configured with: './configure'
>> #
>> gcc -D_GNU_SOURCE -include config-host.h -c -o
>> /tmp/fio-conf-9434-20722-5490.o /tmp/fio-conf-27676-20722-14401.c
>> /tmp/fio-conf-27676-20722-14401.c:2:2: error: #error __ANDROID__ not def=
ined
>> gcc -D_GNU_SOURCE -include config-host.h -c -o
>> /tmp/fio-conf-9434-20722-5490.o /tmp/fio-conf-27676-20722-14401.c
>> gcc -D_GNU_SOURCE -include config-host.h -c -o
>> /tmp/fio-conf-9434-20722-5490.o /tmp/fio-conf-27676-20722-14401.c
>> /tmp/fio-conf-27676-20722-14401.c:2:2: error: #error __i386__ not define=
d
>> gcc -D_GNU_SOURCE -include config-host.h -c -o
>> /tmp/fio-conf-9434-20722-5490.o /tmp/fio-conf-27676-20722-14401.c
>> Compiling test case cross
>> gcc -D_GNU_SOURCE -include config-host.h -o
>> /tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
>> Compiling test case endian
>> gcc -D_GNU_SOURCE -include config-host.h -o
>> /tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
>> Compiling test case wordsize
>> gcc -D_GNU_SOURCE -include config-host.h -DWORDSIZE=3D32 -o
>> /tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
>> /tmp/fio-conf-27676-20722-14401.c: In function =C4=81main=C4=81:
>> /tmp/fio-conf-27676-20722-14401.c:5: error: size of array =C4=81type nam=
e=C4=81
>> is negative
>> Compiling test case wordsize
>> gcc -D_GNU_SOURCE -include config-host.h -DWORDSIZE=3D64 -o
>> /tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
>> Compiling test case zlib
>> gcc -D_GNU_SOURCE -include config-host.h -o
>> /tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
>> -lz
>> /tmp/fio-conf-27676-20722-14401.c:1:18: error: zlib.h: No such file or d=
irectory
>> /tmp/fio-conf-27676-20722-14401.c: In function =C4=81main=C4=81:
>> /tmp/fio-conf-27676-20722-14401.c:4: error: =C4=81z_stream=C4=81 undecla=
red
>> (first use in this function)
>> /tmp/fio-conf-27676-20722-14401.c:4: error: (Each undeclared
>> identifier is reported only once
>> /tmp/fio-conf-27676-20722-14401.c:4: error: for each function it appears=
 in.)
>> /tmp/fio-conf-27676-20722-14401.c:4: error: expected =C4=81;=C4=81 befor=
e =C4=81stream=C4=81
>> /tmp/fio-conf-27676-20722-14401.c:5: error: =C4=81stream=C4=81 undeclare=
d (first
>> use in this function)
>> /tmp/fio-conf-27676-20722-14401.c:5: error: =C4=81Z_OK=C4=81 undeclared =
(first
>> use in this function)
>>
>> This is on a SLES11 SP1 x86_64 machine, I don't know enough to see if
>> I am doing something wrong, but it has worked on previous builds.
>
> You need the zlib devel libraries installed, configure should have told
> you that. Ala:
>
> ERROR
> ERROR: User requested feature zlib
> ERROR: configure was not able to find it
> ERROR
> Configure failed, check config.log and/or the above output
>
> Not sure what that package is called on SLES, but probably zlib-devel.
>
> --
> Jens Axboe
>

Thanks, this must be a new requirement as I have never needed it for
previous builds.

--=20


------------------------------
For additional information including the registered office and the treatmen=
t of Xyratex confidential information please visit www.xyratex.com

------------------------------

