Return-Path: <fio-owner@vger.kernel.org>
Received: from server506f.appriver.com ([50.56.144.36]:61798 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753753AbaCEVMr convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 5 Mar 2014 16:12:47 -0500
From: "Robin P. Blanchard" <robin@coraid.com>
Subject: Re: regression since 2.1.3 (solaris/zfs)
Date: Wed, 5 Mar 2014 21:12:45 +0000
Message-ID: <5ED3076B-B15B-42B1-8AD4-500B62D19EFA@coraid.com>
References: <1E602C14-0C00-4258-94C2-8F16A56C509D@coraid.com>
 <53149EF3.7020005@kernel.dk>
 <AAC03F56-6145-4649-AA09-32AEF3452119@coraid.com> <53174E4C.90402@kernel.dk>
 <E0FE1FC4-FA69-40E4-AD88-3F0743A51345@coraid.com>
 <D173A05B-AD5C-4F5A-9106-53D188B44A3E@kernel.dk>
 <9F498F1D-A6EC-4012-B6CC-271EEA8F4F32@coraid.com>
 <531791B5.2010606@kernel.dk>
In-Reply-To: <531791B5.2010606@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="windows-1252"
Content-ID: <1FC21182F3E1B0409958434B47BCF891@fwd6.exghost.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>


On Mar 5, 2014, at 16:05 PM, Jens Axboe <axboe@kernel.dk> wrote:

> On 03/05/2014 01:39 PM, Robin P. Blanchard wrote:
>>=20
>> On Mar 5, 2014, at 12:06 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>=20
>>> On Mar 5, 2014, at 9:27 AM, Robin P. Blanchard <robin@coraid.com> wrote:
>>>=20
>>>>=20
>>>> On Mar 5, 2014, at 11:18 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>=20
>>>>> On 2014-03-05 09:11, Robin P. Blanchard wrote:
>>>>>>=20
>>>>>> On Mar 3, 2014, at 10:25 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>=20
>>>>>>> On 03/02/2014 07:59 AM, Robin P. Blanchard wrote:
>>>>>>>> My config file has direct=3D0, which until 2.1.4 worked as expecte=
d.
>>>>>>>> Things seem to regress since.
>>>>>>>>=20
>>>>>>>> I apologize in advance if this has already been reported. Please
>>>>>>>> let me know what I can do to further help (truss/debug).
>>>>>>>=20
>>>>>>> This isn't a known issue, so thanks for reporting it. The easiest w=
ay to debug this is to git bisect it. Looks like you are running from the t=
ar balls, but I assume you have git installed? I'm assuming fio-2.1.3 worke=
d for you - if not, just replace fio-2.1.3 in the below with whatever lates=
t version did work. If you do, the cheat sheet is something ala:
>>>>>>>=20
>>>>>>> $ git clone git://git.kernel.dk/fio
>>>>>>> $ cd fio; make
>>>>>>> $ git bisect start
>>>>>>> $ git bisect good fio-2.1.3
>>>>>>> $ git bisect bad fio-2.1.4
>>>>>>>=20
>>>>>>> This starts the bisect series, now do:
>>>>>>>=20
>>>>>>> $ make clean; make
>>>>>>>=20
>>>>>>> and re-run your direct=3D0 job file. If it worked, then you do
>>>>>>>=20
>>>>>>> $ git bisect good
>>>>>>>=20
>>>>>>> and if not, you do git bisect bad instead. This gets you a new poin=
t in the tree to test, so repeat the make clean; make and re-run the test.
>>>>>>> Keep doing this good/bad iteration until fio tells you what commit =
broke the test for you. Then send those results here!
>>>>>>>=20
>>>>>>> --
>>>>>>> Jens Axboe
>>>>>>>=20
>>>>>>=20
>>>>>>=20
>>>>>> Here=EF=BF=BDs where it started working again:
>>>>>>=20
>>>>>> # git bisect good
>>>>>> Bisecting: 4 revisions left to test after this (roughly 2 steps)
>>>>>> [3bb0a7b0fda9945973f799ab253c70d3cb0e5c8b] howto: Fix redundant entr=
ies
>>>>>>=20
>>>>>> Let me know how else I can help.
>>>>>=20
>>>>> Please keep going until it tells you what the definitively bad commit=
 is. It'll end up spitting out that info, if you keep doing git bisect good=
/bad on each test point. You need just ~2 more tests after this one.
>>>>>=20
>>>>> --
>>>>> Jens Axboe
>>>>>=20
>>>>=20
>>>> Here you go:
>>>>=20
>>>> # git bisect good
>>>> ddc0cc31a2b75b1c7dde870c8867af11fa44db92 is the first bad commit
>>>> commit ddc0cc31a2b75b1c7dde870c8867af11fa44db92
>>>> Author: Jens Axboe <axboe@kernel.dk>
>>>> Date:   Fri Oct 11 10:27:28 2013 -0600
>>>>=20
>>>>   ppc: disable CPU clock until we can detect whether we have it or not
>>>>=20
>>>>   The child segfault test should catch it, however it does not on
>>>>   AIX at least.
>>>>=20
>>>>   Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>=20
>>> Hmm, that can=EF=BF=BDt possibly be correct. Would you mind redoing the=
 bisection,
>>> just to double check?
>>>=20
>>> Thanks!
>>>=20
>>> =EF=BF=BD
>>> Jens Axboe
>>=20
>> Ok. Let=EF=BF=BDs try this again. Silly user, me.
>>=20
>> # git bisect good
>> 7cb024f89dbbc314e740885afccd9a05da056cf1 is the first bad commit
>> commit 7cb024f89dbbc314e740885afccd9a05da056cf1
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Wed Nov 6 15:37:35 2013 -0700
>>=20
>>     solaris: ensure that -D_REENTRANT gets set
>>=20
>>     Apparently some Solaris' require this for threadsafe
>>     errno.
>>=20
>>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>=20
>> :100755 100755 b6bfe19aa743fc4104eb587b3ff6068fb5dc67ef ef7be0180258abec=
d4703ebfcf4ed63625d6392f M      configure
>>=20
>>=20
>> I have the complete git/bisect session in a screen log if you=EF=BF=BDd =
like it.
>=20
> That makes a lot more sense! Can you do:
>=20
> $ git checkout -f master
> $ git revert 7cb024f89dbbc314e740885afccd9a05da056cf1
> $ make clean; make
>=20
> and retest just to be on the safe side? Also, please attach the job file =
you are using.
>=20
> --=20
> Jens Axboe


Actually, based on the git bisect work, I took out -D_REENTRANT from config=
ure, and fio-2.1.6 now works as expected. Still want the job file?



# diff -u configure configure.dist
--- configure   2014-03-05 16:10:50.195429114 -0500
+++ configure.dist      2014-03-05 16:10:21.590075963 -0500
@@ -183,7 +183,7 @@
   targetos=3D'OpenBSD'
 elif check_define __sun__ ; then
   targetos=3D'SunOS'
-  CFLAGS=3D"$CFLAGS"
+  CFLAGS=3D"$CFLAGS -D_REENTRANT"
 else
   targetos=3D`uname -s`
 fi



--=20
Robin P. Blanchard
Solutions Engineer
Coraid Global Field Services
www.coraid.com
+1 650.730.5140

