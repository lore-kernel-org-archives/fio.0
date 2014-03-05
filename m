Return-Path: <axboe@kernel.dk>
Message-ID: <53174E4C.90402@kernel.dk>
Date: Wed, 05 Mar 2014 09:18:20 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: regression since 2.1.3 (solaris/zfs)
References: <1E602C14-0C00-4258-94C2-8F16A56C509D@coraid.com> <53149EF3.7020005@kernel.dk> <AAC03F56-6145-4649-AA09-32AEF3452119@coraid.com>
In-Reply-To: <AAC03F56-6145-4649-AA09-32AEF3452119@coraid.com>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
To: "Robin P. Blanchard" <robin@coraid.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-03-05 09:11, Robin P. Blanchard wrote:
>
> On Mar 3, 2014, at 10:25 AM, Jens Axboe <axboe@kernel.dk> wrote:
>
>> On 03/02/2014 07:59 AM, Robin P. Blanchard wrote:
>>> My config file has direct=3D0, which until 2.1.4 worked as expected.
>>> Things seem to regress since.
>>>
>>> I apologize in advance if this has already been reported. Please
>>> let me know what I can do to further help (truss/debug).
>>
>> This isn't a known issue, so thanks for reporting it. The easiest way to=
 debug this is to git bisect it. Looks like you are running from the tar ba=
lls, but I assume you have git installed? I'm assuming fio-2.1.3 worked for=
 you - if not, just replace fio-2.1.3 in the below with whatever latest ver=
sion did work. If you do, the cheat sheet is something ala:
>>
>> $ git clone git://git.kernel.dk/fio
>> $ cd fio; make
>> $ git bisect start
>> $ git bisect good fio-2.1.3
>> $ git bisect bad fio-2.1.4
>>
>> This starts the bisect series, now do:
>>
>> $ make clean; make
>>
>> and re-run your direct=3D0 job file. If it worked, then you do
>>
>> $ git bisect good
>>
>> and if not, you do git bisect bad instead. This gets you a new point in =
the tree to test, so repeat the make clean; make and re-run the test.
>> Keep doing this good/bad iteration until fio tells you what commit broke=
 the test for you. Then send those results here!
>>
>> --
>> Jens Axboe
>>
>
>
> Here=EF=BF=BDs where it started working again:
>
> # git bisect good
> Bisecting: 4 revisions left to test after this (roughly 2 steps)
> [3bb0a7b0fda9945973f799ab253c70d3cb0e5c8b] howto: Fix redundant entries
>
> Let me know how else I can help.

Please keep going until it tells you what the definitively bad commit=20
is. It'll end up spitting out that info, if you keep doing git bisect=20
good/bad on each test point. You need just ~2 more tests after this one.

--=20
Jens Axboe


