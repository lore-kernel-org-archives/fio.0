Return-Path: <axboe@kernel.dk>
Message-ID: <531791B5.2010606@kernel.dk>
Date: Wed, 05 Mar 2014 14:05:57 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: regression since 2.1.3 (solaris/zfs)
References: <1E602C14-0C00-4258-94C2-8F16A56C509D@coraid.com> <53149EF3.7020005@kernel.dk> <AAC03F56-6145-4649-AA09-32AEF3452119@coraid.com> <53174E4C.90402@kernel.dk> <E0FE1FC4-FA69-40E4-AD88-3F0743A51345@coraid.com> <D173A05B-AD5C-4F5A-9106-53D188B44A3E@kernel.dk> <9F498F1D-A6EC-4012-B6CC-271EEA8F4F32@coraid.com>
In-Reply-To: <9F498F1D-A6EC-4012-B6CC-271EEA8F4F32@coraid.com>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
To: "Robin P. Blanchard" <robin@coraid.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 03/05/2014 01:39 PM, Robin P. Blanchard wrote:
>
> On Mar 5, 2014, at 12:06 PM, Jens Axboe <axboe@kernel.dk> wrote:
>
>> On Mar 5, 2014, at 9:27 AM, Robin P. Blanchard <robin@coraid.com> wrote:
>>
>>>
>>> On Mar 5, 2014, at 11:18 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>>> On 2014-03-05 09:11, Robin P. Blanchard wrote:
>>>>>
>>>>> On Mar 3, 2014, at 10:25 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>>> On 03/02/2014 07:59 AM, Robin P. Blanchard wrote:
>>>>>>> My config file has direct=3D0, which until 2.1.4 worked as expected.
>>>>>>> Things seem to regress since.
>>>>>>>
>>>>>>> I apologize in advance if this has already been reported. Please
>>>>>>> let me know what I can do to further help (truss/debug).
>>>>>>
>>>>>> This isn't a known issue, so thanks for reporting it. The easiest wa=
y to debug this is to git bisect it. Looks like you are running from the ta=
r balls, but I assume you have git installed? I'm assuming fio-2.1.3 worked=
 for you - if not, just replace fio-2.1.3 in the below with whatever latest=
 version did work. If you do, the cheat sheet is something ala:
>>>>>>
>>>>>> $ git clone git://git.kernel.dk/fio
>>>>>> $ cd fio; make
>>>>>> $ git bisect start
>>>>>> $ git bisect good fio-2.1.3
>>>>>> $ git bisect bad fio-2.1.4
>>>>>>
>>>>>> This starts the bisect series, now do:
>>>>>>
>>>>>> $ make clean; make
>>>>>>
>>>>>> and re-run your direct=3D0 job file. If it worked, then you do
>>>>>>
>>>>>> $ git bisect good
>>>>>>
>>>>>> and if not, you do git bisect bad instead. This gets you a new point=
 in the tree to test, so repeat the make clean; make and re-run the test.
>>>>>> Keep doing this good/bad iteration until fio tells you what commit b=
roke the test for you. Then send those results here!
>>>>>>
>>>>>> --
>>>>>> Jens Axboe
>>>>>>
>>>>>
>>>>>
>>>>> Here=EF=BF=BDs where it started working again:
>>>>>
>>>>> # git bisect good
>>>>> Bisecting: 4 revisions left to test after this (roughly 2 steps)
>>>>> [3bb0a7b0fda9945973f799ab253c70d3cb0e5c8b] howto: Fix redundant entri=
es
>>>>>
>>>>> Let me know how else I can help.
>>>>
>>>> Please keep going until it tells you what the definitively bad commit =
is. It'll end up spitting out that info, if you keep doing git bisect good/=
bad on each test point. You need just ~2 more tests after this one.
>>>>
>>>> --
>>>> Jens Axboe
>>>>
>>>
>>> Here you go:
>>>
>>> # git bisect good
>>> ddc0cc31a2b75b1c7dde870c8867af11fa44db92 is the first bad commit
>>> commit ddc0cc31a2b75b1c7dde870c8867af11fa44db92
>>> Author: Jens Axboe <axboe@kernel.dk>
>>> Date:   Fri Oct 11 10:27:28 2013 -0600
>>>
>>>    ppc: disable CPU clock until we can detect whether we have it or not
>>>
>>>    The child segfault test should catch it, however it does not on
>>>    AIX at least.
>>>
>>>    Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> Hmm, that can=EF=BF=BDt possibly be correct. Would you mind redoing the =
bisection,
>> just to double check?
>>
>> Thanks!
>>
>> =EF=BF=BD
>> Jens Axboe
>
> Ok. Let=EF=BF=BDs try this again. Silly user, me.
>
> # git bisect good
> 7cb024f89dbbc314e740885afccd9a05da056cf1 is the first bad commit
> commit 7cb024f89dbbc314e740885afccd9a05da056cf1
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Wed Nov 6 15:37:35 2013 -0700
>
>      solaris: ensure that -D_REENTRANT gets set
>
>      Apparently some Solaris' require this for threadsafe
>      errno.
>
>      Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> :100755 100755 b6bfe19aa743fc4104eb587b3ff6068fb5dc67ef ef7be0180258abecd=
4703ebfcf4ed63625d6392f M      configure
>
>
> I have the complete git/bisect session in a screen log if you=EF=BF=BDd l=
ike it.

That makes a lot more sense! Can you do:

$ git checkout -f master
$ git revert 7cb024f89dbbc314e740885afccd9a05da056cf1
$ make clean; make

and retest just to be on the safe side? Also, please attach the job file=20
you are using.

--=20
Jens Axboe


