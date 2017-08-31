Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:32922 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750872AbdHaJN0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 31 Aug 2017 05:13:26 -0400
Received: by mail-wr0-f177.google.com with SMTP id k94so433213wrc.0
        for <fio@vger.kernel.org>; Thu, 31 Aug 2017 02:13:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxh2Uy1dbBTndB1i=gRLhXCAgSMwqQmwoQvU1t7p9HeVKQ@mail.gmail.com>
References: <CALjAwxh2Uy1dbBTndB1i=gRLhXCAgSMwqQmwoQvU1t7p9HeVKQ@mail.gmail.com>
From: Elhamer Oussama AbdelKHalek <abdelkhalekdev@gmail.com>
Date: Thu, 31 Aug 2017 11:13:23 +0200
Message-ID: <CABhOJBQNWMipsS1do7rfRP578uxBQAG_LAfPWVCv_Fhz0EQbMw@mail.gmail.com>
Subject: Re: generating unique offsets
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio@vger.kernel.org

Hi,

On Wed, Aug 30, 2017 at 8:21 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> (apologies for the previous duff subject line - the moving process
> involved creating a fake mail that had a duff subject and I forgot to
> update it)
>
> On 30 August 2017 at 14:16, Elhamer Oussama AbdelKHalek
> <abdelkhalekdev@gmail.com> wrote:
>>
>> On Wed, Aug 30, 2017 at 7:54 AM, Sitsofe Wheeler <sitsofe@gmail.com> wro=
te:
>>>
>>> On 30 August 2017, Abdelkhalek Oussama Elhamer <Abdelkhalekdev@gmail.co=
m> wrote:
>>>
>>>> I want to test how a couple of Intel devices perform with a specific
>>>> workload that contains mainly random 128k writes, but the random
>>>> offsets must be generated using a Fisher and Yates shufflealgorithm
>>>> (basically to make sure that there are zero collisions between
>>>> requested offsets ).
>>>
>>> I'm going to stop you right there: do you know that fio maintains an
>>> "axmap" by default (Jens swears it wasn't named after him over in
>>> https://github.com/axboe/fio/blob/308d69b5d340577b7886696f39753b7ba5ae9=
e11/lib/axmap.c
>>> ) to ensure when you choose a random workload (which is uniform by
>>> default) every block is hit only once per pass with no overlaps (i.e.
>>> no collisions)? See
>>> http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-norandom=
map
>>> which turns this behvaiour off for more details. Anyway...
>>
>> I am afraid there there was a bunch of collisions between the offsets
>> and i didn't set the norandommap attribute,
>> i have printed the generated offsets (the values of *b) for different
>> offsets (on a size of 2M using bs=3D128k): http://prntscr.com/gex940
>> Unfortunately, the collisions are visible :/.
>
> A challenge! OK:
> $ fio --randseed=3D25 --debug=3Dio --size=3D2M --ioengine=3Dnull
> --rw=3Drandwrite --name=3Dcheckdup | awk 'match($0,
> /fill_io_u.*off=3D([0-9]+).*/, arr) { print  arr[1] }' | sort | uniq -d
> | wc -l
> 0
>
> No duplicate offsets with the default "uniform" distribution.

I got the same result at my end. The thing is that at first i didn't
know you could dump the generated offsets using  --debug=3Dio , so i've
printed the values of '*b' for 8 different seeds (--size=3D2m --bs=3D128k
--rw=3Drandwrite --ioengine=3Dlibaio) explicitly ( printf the values in
the source code / recompile fio), the result contains  collisions!

If i am understanding correctly, when a generated random value is
already in the axmap table, another one will be generated!
Here a dump fo both  b* and  off values (16 offsets)
https://gist.github.com/SamTheDev/29ede9f3ef2466c5b5d2e026f4bd2aec

Where exactly the *b offset is updated (according to axmap table) in
the code? and does that mean that changing only the *b value for a
custom random generator won't do the trick?

>
> fio --random_distribution=3Dzipf:0.8 --randseed=3D25 --debug=3Dio --size=
=3D2M
> --ioengine=3Dnull --rw=3Drandwrite --name=3Dcheckdup | awk 'match($0,
> /fill_io_u.*off=3D([0-9]+).*/, arr) { print  arr[1] }' | sort | uniq -d
> | wc -l
> 74
>
> We see duplicate offsets with a non-uniform random distribution.
>
> $ ./fio --version
> fio-3.0-9-gb427-dirty
>
> This is on Ubuntu 16.04 x86_64. We'd really need to see the job that
> created your duplicate offsets (please don't skip providing the
> information in https://github.com/axboe/fio/blob/master/REPORTING-BUGS
> :-)
>
> Even without the randommap fio has options that can pick different
> random generators:
> http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-random-gen=
erator
>
Thank you, lfsr suits perfectly my needs :)).
>
>>>> So, i added an implementation to that random generator to fio, and
>>>> added a =E2=80=9Cget_next_Fisher_and_Yates_offset=E2=80=9D function to=
retrieve the
>>>> next offset each time.
>>>>
>>>> To quickly test that, i replaced the default TAUSWORTHE random offset
>>>> function call, more precisely I=E2=80=99ve changed the __get_next_rand=
_offset
>>>> function from the io_u.c file to something like that:
>>>>
> [...]
>>>>
>>>> Is that enough to replace the default random generator (for a quick te=
st)??
>>>>
>>>> PS: the reason i am asking is that after doing that, i am getting top
>>>> performances each run, even on limited fully written device range.
>>>> this doesn=E2=80=99t look right! :/
>
> I should have asked - what performance were you expecting to see?
>
Sorry, i forgot to mention that the drive was fully written and
partially trimmed before running the randwrite job.
On a full nvme drive, i ran a randtrim job, after a reasonable delay i
ran the randwrite job using the same rand-seed. My drive bandwidth can
go up to 1.4 Gb/s, when using the default TAUSWORTHE random generator
the bw was around 150 Mb/s, which sounds reasonable, but when using
the Fisher-yates generator  i was getting top performance (around 1.3
Gb/s!)
the job files look something like that:
[global]
ioengine=3Dlibaio
iodepth=3D256
size=3D1117G
direct=3D1
do_verify=3D0
continue_on_error=3Dall
filename=3D/dev/nvme0n1
randseed=3D23534
sync=3D1
[write-job]
rw=3Drandwrite / randtrim
bs=3D128k


>>>> Here a sample of my test fio file:
>>>>
>>>> [global]
>>>> ioengine=3Dlibaio
>>>> iodepth=3D256
>>>
>>> Fairly high depth which is good for your NVMe disk.
>>>
>>>> io_size=3D256G
>>>
>>> You aren't going to write much data before stopping (so it's highly
>>> unlikely you will ever fall to garbage collection speeds)...
>>>
>> Actually, i did get a drop of bandwidth using randwrites (with the
>> default random generator) !
>
> Ah well I stand corrected :-).
>
Again, i forgot to mention that the drive was full :^p!
> --
> Sitsofe | http://sucs.org/~sits/

Sam.
