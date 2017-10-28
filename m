Return-Path: <paolo.valente@linaro.org>
Return-Path: <paolo.valente@linaro.org>
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: buffer-cache builds up with invalidate=1 too
From: Paolo Valente <paolo.valente@linaro.org>
In-Reply-To: <B356CDFD-F114-4B95-A106-02BC94C77B31@linaro.org>
Date: Sat, 28 Oct 2017 12:23:08 +0200
Content-Transfer-Encoding: quoted-printable
Message-Id: <547CF853-FE9F-4A39-A251-8B93EEF24ACF@linaro.org>
References: <55C233AE-83A3-4277-9EE5-7FF66CB6E52F@linaro.org> <CALjAwxi0n+Y-amRXkfWkn9HVBoLrGvXD093k=O6TS-qR2=Gtsw@mail.gmail.com> <7077593F-C30A-415E-B090-7D0F671394C6@linaro.org> <CALjAwxg02AqDB78Nai_jbZ_EU3S5Wf20jQ1WKuTzb-4SG9Qd0g@mail.gmail.com> <FC918187-B671-44DF-B412-077FC7B683D7@linaro.org> <d4c25e14-564d-a77a-274e-5a9cb3717386@kernel.dk> <CAD7QDb2mYJzVUbscNq72MLYzD_cPish+=5S_fu9awxm7Sz+hzw@mail.gmail.com> <ECE9D641-A649-4B25-8088-CCA6DF4BCB57@linaro.org> <201bb045-c776-f3cc-a710-ab9bed32fada@kernel.dk> <B356CDFD-F114-4B95-A106-02BC94C77B31@linaro.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>


> Il giorno 28 ott 2017, alle ore 10:37, Paolo Valente =
<paolo.valente@linaro.org> ha scritto:
>=20
>>=20
>> Il giorno 27 ott 2017, alle ore 16:21, Jens Axboe <axboe@kernel.dk> =
ha scritto:
>>=20
>> On 10/27/2017 12:52 AM, Paolo Valente wrote:
>>> [RESENDING, BECAUSE REJECTED BY THE VGER]
>>>=20
>>>> Il giorno 27 ott 2017, alle ore 08:22, Paolo Valente =
<paolo.valente@linaro.org> ha scritto:
>>>>=20
>>>>=20
>>>>=20
>>>> Il 26/ott/2017 06:32 AM, "Jens Axboe" <axboe@kernel.dk> ha scritto:
>>>> On 10/24/2017 08:10 AM, Paolo Valente wrote:
>>>>>=20
>>>>>> Il giorno 24 ott 2017, alle ore 08:28, Sitsofe Wheeler =
<sitsofe@gmail.com> ha scritto:
>>>>>>=20
>>>>>> Hi,
>>>>>>=20
>>>>>> If memory serves it's actually slightly more complicated. If you =
are
>>>>>> using loops=3D<number> then I *think* (you'll have to check) you =
will
>>>>>> find that invalidation happens once per each loop start. However =
when
>>>>>> you use time_based to do the repetition there is essentially only =
one
>>>>>> "loop" (even though the job goes on forever) so loop actions only
>>>>>> happen right at the start of the job with that option (that's why =
I
>>>>>> put the scare quotes around "beginning" ;-).
>>>>>>=20
>>>>>=20
>>>>> Thanks for this additional, useful piece of information.  =
Actually,
>>>>> this further, possibly different caching behavior makes me think =
that
>>>>> some extra comment in the manpage might be helpful.
>>>>=20
>>>> Would probably make sense to change 'invalidate' to be a range of
>>>> possible values:
>>>>=20
>>>> 0       As it is now, never invalidate
>>>> 1       As it is now, invalidate initially
>>>> once    Same as '1', invalidate initially / once
>>>> open    New value, invalidate on every open
>>>> close   New value, invalidate on close
>>>>=20
>>>> as I can definitely see reasons why you would want to invalidate =
every
>>>> time you open the file.
>>>>=20
>>>> To do that, the 'invalidate' option should be changed from a
>>>> FIO_OPT_BOOL to a FIO_OPT_STR, and the above possible values should =
be
>>>> added as posval[] for that option.
>>>>=20
>>>> Compliment that with the an enum of ranges for the ovals:
>>>>=20
>>>> enum {
>>>>       FIO_FILE_INVALIDATE_OFF =3D 0,
>>>>       FIO_FILE_INVALIDATE_ONCE,
>>>>       FIO_FILE_INVALIDATE_OPEN,
>>>>       FIO_FILE_INVALIDATE_CLOSE
>>>> };
>>>>=20
>>>> Hope this makes sense, should be trivial to add as most of the work =
is
>>>> already documented in this email :-). The remaining bits is just =
calling
>>>> file_invalidate_cache() in the proper locations,
>>>> td_io_{open,close}_file() would be prime candidates.
>>>>=20
>>>> IMO this solution would make things both clearer and more flexible
>>=20
>> See my followup, fio already does invalidates for each open. The
>> problem with time_based was that we just reset the file, we don't
>> close and re-open it. That was fixed in git:
>>=20
>> commit 0bcf41cdc22dfee6b3f3b2ba9a533b4b103c70c2
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Thu Oct 26 12:08:20 2017 -0600
>>=20
>>   io_u: re-invalidate cache when looping around without file =
open/close
>>=20
>> so current git should work for your test case. Please test.
>>=20
>=20
> Tested, it does solve the problem.  As a side note, and if useful for
> you, the throughput is much higher with sequential reads and direct=3D0
> (4.14-rc5, virtual disk on an SSD).  It happens because of merges,
> which seem to not occur with direct=3D1.  I thought direct I/O skipped
> buffering, but still enjoyed features as request merging, but probably
> I'm just wrong.
>=20

Just to be clear, by much higher I mean ten times higher.

Thanks,
Paolo

> Thanks for addressing this caching issue,
> Paolo
>=20
>> --=20
>> Jens Axboe


