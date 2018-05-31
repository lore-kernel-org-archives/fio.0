Return-Path: <paolo.valente@linaro.org>
Return-Path: <paolo.valente@linaro.org>
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Subject: Re: time_based not working with randread
From: Paolo Valente <paolo.valente@linaro.org>
In-Reply-To: <14c60616-42dd-705a-1617-08c4a70e5a05@kernel.dk>
Date: Thu, 31 May 2018 16:49:08 +0200
Content-Transfer-Encoding: quoted-printable
Message-Id: <668383BC-4178-41DF-8C20-FED79FD4B262@linaro.org>
References: <F0E1506A-A23F-4C12-B003-9860F71FC91A@linaro.org>
 <CALjAwxiWDecVfJsUr2eiBnL4q4nc_v+XZwjVNiOE0rKj+hc_aQ@mail.gmail.com>
 <42E4AE76-FC46-44EF-9B7A-430B0148E1AD@linaro.org>
 <14c60616-42dd-705a-1617-08c4a70e5a05@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>



> Il giorno 31 mag 2018, alle ore 16:38, Jens Axboe <axboe@kernel.dk> ha =
scritto:
>=20
> On 5/31/18 2:55 AM, Paolo Valente wrote:
>>=20
>>=20
>>> Il giorno 27 mag 2018, alle ore 16:24, Sitsofe Wheeler =
<sitsofe@gmail.com> ha scritto:
>>>=20
>>> Hi Paolo!
>>>=20
>>> On 25 May 2018 at 20:20, Paolo Valente <paolo.valente@linaro.org> =
wrote:
>>>> Hi,
>>>> if I run this job (even with the last version GitHub version of =
fio) on an SSD:
>>>> [global]
>>>> ioengine=3Dsync
>>>> time_based=3D1
>>>> runtime=3D20
>>>> readwrite=3Drandread
>>>> size=3D100m
>>>> numjobs=3D1
>>>> invalidate=3D1
>>>> [job1]
>>>>=20
>>>> then, after little time (I think after 100MB have been read), fio =
reports a nonsensically large value for the throughput, while a simple =
iostat shows that no I/O is going on. By just replacing time_based with =
loops, i.e., with a job file like this:
>>>>=20
>>>> [global]
>>>> ioengine=3Dsync
>>>> loops=3D1000
>>>> readwrite=3Drandread
>>>> size=3D100m
>>>> numjobs=3D1
>>>> invalidate=3D1
>>>> [job1]
>>>>=20
>>>> the problem disappears.
>>>=20
>>> I've taken a stab at fixing this over in
>>> https://github.com/sitsofe/fio/tree/random_reinvalidate - does that
>>> solve the issue for you too?
>>=20
>> Nope :(
>>=20
>>> ...
>>> I know I'm "Teaching grandmother to suck eggs" given that you're the
>>> author of BFQ but just in case...
>>>=20
>>> This issue happens on loops=3D1000 too and I believe it's down to
>>> readahead.
>>=20
>> I'm afraid there is a misunderstanding on this, grandson :)
>>=20
>> As I wrote, this problem does not occur with loops=3D1000.  My
>> impression is that, with loops, as well as with time-based and read,
>> fio does invalidate the cache every time it restarts reading the same
>> file, while with time_based and randread it does not (or maybe it
>> tries to, but fails for some reason).
>=20
> This is basically by design. loop will go through the full
> open+invalidate, whereas time_based will just keep chugging
> along. Once your 100mb is in page cache, then no more IO
> will be done, as reads are just served from there.
>=20

Such a design confused me.  Highlighting somewhere this deviation
(between loops and time_based) might help other dull people like me.

Thanks,
Paolo

> --=20
> Jens Axboe


