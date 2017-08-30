Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:35523 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751317AbdH3NQX (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 30 Aug 2017 09:16:23 -0400
Received: by mail-wr0-f173.google.com with SMTP id j29so17509337wre.2
        for <fio@vger.kernel.org>; Wed, 30 Aug 2017 06:16:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxjKcy-AiNUQP_huQnVRMmO9iuZEwmD7zAs4OYNJ=0XWHg@mail.gmail.com>
References: <CALjAwxhcXOTXmOGC4O8o0mndM61E6esUN8x9n1NGkGoUKsZDfA@mail.gmail.com>
 <CALjAwxjKcy-AiNUQP_huQnVRMmO9iuZEwmD7zAs4OYNJ=0XWHg@mail.gmail.com>
From: Elhamer Oussama AbdelKHalek <abdelkhalekdev@gmail.com>
Date: Wed, 30 Aug 2017 15:16:20 +0200
Message-ID: <CABhOJBQvLLZ+tY6BXVSiYbo4MQCxZ_Vjc_DUELQWcpipFWUnRw@mail.gmail.com>
Subject: Re: Delete
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio@vger.kernel.org

Hi, thank you for your reply :))

On Wed, Aug 30, 2017 at 7:54 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> On 30 August 2017, Abdelkhalek Oussama Elhamer <Abdelkhalekdev@gmail.com>=
 wrote:
>> I have a simple question that I promise won=E2=80=99t take much of your =
time (
>> the mailing list doesn=E2=80=99t look like the right place for such ques=
tions
>> :/), hoping for your kind help.
>
> The mailing list is absolutely the right place for this one (and
> tagged on to the end of an issue that is totally unrelated is the
> wrong place I'm afraid ;-) so as a one off I've taken this question to
> the mailing list for you (but you may want to subscribe).
>
> Please, please avoid only asking me about fio questions. I know it's
> tempting but it will lead to bad results in the long run.

Thank you, and sorry for that, i've removed my question from the
unrelated Issue.

>> I want to test how a couple of Intel devices perform with a specific
>> workload that contains mainly random 128k writes, but the random
>> offsets must be generated using a Fisher and Yates shufflealgorithm
>> (basically to make sure that there are zero collisions between
>> requested offsets ).
>
> I'm going to stop you right there: do you know that fio maintains an
> "axmap" by default (Jens swears it wasn't named after him over in
> https://github.com/axboe/fio/blob/308d69b5d340577b7886696f39753b7ba5ae9e1=
1/lib/axmap.c
> ) to ensure when you choose a random workload (which is uniform by
> default) every block is hit only once per pass with no overlaps (i.e.
> no collisions)? See
> http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-norandomma=
p
> which turns this behvaiour off for more details. Anyway...
>

I am afraid there there was a bunch of collisions between the offsets
and i didn't set the norandommap attribute,
i have printed the generated offsets (the values of *b) for different
offsets (on a size of 2M using bs=3D128k): http://prntscr.com/gex940
Unfortunately, the collisions are visible :/.

>> So, i added an implementation to that random generator to fio, and
>> added a =E2=80=9Cget_next_Fisher_and_Yates_offset=E2=80=9D function tore=
trieve the
>> next offset each time.
>>
>> To quickly test that, i replaced the default TAUSWORTHE random offset
>> function call, more precisely I=E2=80=99ve changed the __get_next_rand_o=
ffset
>> function from the io_u.c file to something like that:
>>
>> //=E2=80=A6
>> static int __get_next_rand_offset(struct thread_data *td, struct fio_fil=
e *f,
>>  enum fio_ddir ddir, uint64_t *b,
>>  uint64_t lastb)
>> {
>> uint64_t r;
>>
>> if (td->o.random_generator =3D=3D FIO_RAND_GEN_TAUSWORTHE ||
>>    td->o.random_generator =3D=3D FIO_RAND_GEN_TAUSWORTHE64) {
>>
>> r =3D __rand(&td->random_state);
>>
>> dprint(FD_RANDOM, "off rand %llu\n", (unsigned long long) r);
>>
>> //*b =3D lastb * (r / (rand_max(&td->random_state) + 1.0));
>>                   b =3D get_next_Fisher_and_Yates_offset (=E2=80=A6)
>>               // update
>
> Surely it will still need to be *b =3D
> get_next_Fisher_and_Yates_offset(...) as you don't want to set the
> pointer but the contents of the memory it is pointing at?
>
Yes sure, that was a typo :))

>> } else {
>> uint64_t off =3D 0;
>>
>>  //=E2=80=A6.
>>
>> Is that enough to replace the default random generator (for a quick test=
)??
>>
>> PS: the reason i am asking is that after doing that, i am getting top
>> performances each run, even on limited fully written device range.
>> this doesn=E2=80=99t look right! :/
>>
>> Here a sample of my test fio file:
>>
>> [global]
>> ioengine=3Dlibaio
>> iodepth=3D256
>
> Fairly high depth which is good for your NVMe disk.
>
>> io_size=3D256G
>
> You aren't going to write much data before stopping (so it's highly
> unlikely you will ever fall to garbage collection speeds)...
>
Actually, i did get a drop of bandwidth using randwrites (with the
default random generator) !

>> size=3D1117G
>
> ...because I'm guessing this is closer to the true size of the disk?
>
>> direct=3D1
>> do_verify=3D0
>> continue_on_error=3Dall
>> filename=3D/dev/nvme0n1
>> randseed=3D29
>
> You're using a fixed seed so you'll write the same sequence of the
> same data again and again which mildly friendly to an SSD because you
> are likely writing data in the order it hit the cells last time so you
> will most likely be erasing the cells in the order they were
> previously written (see
> http://codecapsule.com/2014/02/12/coding-for-ssds-part-5-access-patterns-=
and-system-optimizations/
> for more details). Are you sure you want this - perhaps
> http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-randrepeat
> would be better as the sequence used would be most likely different to
> the last one used...
>
>> sync=3D1
>> [write-job]
>> rw=3Drandwrite
>> bs=3D128k
>
> And your block size is quite chunky and large which again is very
> friendly to the SSD. An additional tip: your NVMe disk may have really
> clever compression and depduplication allowing it to do less work. You
> may want to look into using
> http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-refill-buf=
fers
> .
>
>> Thank you in advance.
>
> In all honesty, I'd guess this workload would offer very stable and
> good performance on the sort of disk you are using but I'm not an SSD
> manufacturer so take my advice with a grain of salt :-)
>

Thank you, i will check those out.
> --
> Sitsofe | http://sucs.org/~sits/
