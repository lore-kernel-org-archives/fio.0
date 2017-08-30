Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:37315 "EHLO
        mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751463AbdH3SW0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 30 Aug 2017 14:22:26 -0400
Received: by mail-vk0-f52.google.com with SMTP id q189so19725884vke.4
        for <fio@vger.kernel.org>; Wed, 30 Aug 2017 11:22:26 -0700 (PDT)
MIME-Version: 1.0
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 30 Aug 2017 19:21:55 +0100
Message-ID: <CALjAwxh2Uy1dbBTndB1i=gRLhXCAgSMwqQmwoQvU1t7p9HeVKQ@mail.gmail.com>
Subject: Re: generating unique offsets
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Elhamer Oussama AbdelKHalek <abdelkhalekdev@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

(apologies for the previous duff subject line - the moving process
involved creating a fake mail that had a duff subject and I forgot to
update it)

On 30 August 2017 at 14:16, Elhamer Oussama AbdelKHalek
<abdelkhalekdev@gmail.com> wrote:
>
> On Wed, Aug 30, 2017 at 7:54 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrot=
e:
>>
>> On 30 August 2017, Abdelkhalek Oussama Elhamer <Abdelkhalekdev@gmail.com=
> wrote:
>>
>>> I want to test how a couple of Intel devices perform with a specific
>>> workload that contains mainly random 128k writes, but the random
>>> offsets must be generated using a Fisher and Yates shufflealgorithm
>>> (basically to make sure that there are zero collisions between
>>> requested offsets ).
>>
>> I'm going to stop you right there: do you know that fio maintains an
>> "axmap" by default (Jens swears it wasn't named after him over in
>> https://github.com/axboe/fio/blob/308d69b5d340577b7886696f39753b7ba5ae9e=
11/lib/axmap.c
>> ) to ensure when you choose a random workload (which is uniform by
>> default) every block is hit only once per pass with no overlaps (i.e.
>> no collisions)? See
>> http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-norandomm=
ap
>> which turns this behvaiour off for more details. Anyway...
>
> I am afraid there there was a bunch of collisions between the offsets
> and i didn't set the norandommap attribute,
> i have printed the generated offsets (the values of *b) for different
> offsets (on a size of 2M using bs=3D128k): http://prntscr.com/gex940
> Unfortunately, the collisions are visible :/.

A challenge! OK:
$ fio --randseed=3D25 --debug=3Dio --size=3D2M --ioengine=3Dnull
--rw=3Drandwrite --name=3Dcheckdup | awk 'match($0,
/fill_io_u.*off=3D([0-9]+).*/, arr) { print  arr[1] }' | sort | uniq -d
| wc -l
0

No duplicate offsets with the default "uniform" distribution.

fio --random_distribution=3Dzipf:0.8 --randseed=3D25 --debug=3Dio --size=3D=
2M
--ioengine=3Dnull --rw=3Drandwrite --name=3Dcheckdup | awk 'match($0,
/fill_io_u.*off=3D([0-9]+).*/, arr) { print  arr[1] }' | sort | uniq -d
| wc -l
74

We see duplicate offsets with a non-uniform random distribution.

$ ./fio --version
fio-3.0-9-gb427-dirty

This is on Ubuntu 16.04 x86_64. We'd really need to see the job that
created your duplicate offsets (please don't skip providing the
information in https://github.com/axboe/fio/blob/master/REPORTING-BUGS
:-)

Even without the randommap fio has options that can pick different
random generators:
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-random-gener=
ator
.

>>> So, i added an implementation to that random generator to fio, and
>>> added a =E2=80=9Cget_next_Fisher_and_Yates_offset=E2=80=9D function tor=
etrieve the
>>> next offset each time.
>>>
>>> To quickly test that, i replaced the default TAUSWORTHE random offset
>>> function call, more precisely I=E2=80=99ve changed the __get_next_rand_=
offset
>>> function from the io_u.c file to something like that:
>>>
[...]
>>>
>>> Is that enough to replace the default random generator (for a quick tes=
t)??
>>>
>>> PS: the reason i am asking is that after doing that, i am getting top
>>> performances each run, even on limited fully written device range.
>>> this doesn=E2=80=99t look right! :/

I should have asked - what performance were you expecting to see?

>>> Here a sample of my test fio file:
>>>
>>> [global]
>>> ioengine=3Dlibaio
>>> iodepth=3D256
>>
>> Fairly high depth which is good for your NVMe disk.
>>
>>> io_size=3D256G
>>
>> You aren't going to write much data before stopping (so it's highly
>> unlikely you will ever fall to garbage collection speeds)...
>>
> Actually, i did get a drop of bandwidth using randwrites (with the
> default random generator) !

Ah well I stand corrected :-).

--=20
Sitsofe | http://sucs.org/~sits/
