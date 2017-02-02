Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:36811 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750907AbdBBHNu (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 2 Feb 2017 02:13:50 -0500
Received: by mail-vk0-f46.google.com with SMTP id t8so4925058vke.3
        for <fio@vger.kernel.org>; Wed, 01 Feb 2017 23:13:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ec99c46fa7a7476da9246c74ae90fab6@bowex36c.micron.com>
References: <cd5deac3ce8b4c6da58b3f720f88941c@bowex36c.micron.com>
 <CALjAwxh6X_oMyCrAR43xXwtzQmyEw5Mwf9rX5kCtj09SbeCYJQ@mail.gmail.com>
 <CALjAwxhQottB9wjeUeCLR+5g_R8DFWHghtBgXWFdWjcC0v54Mw@mail.gmail.com>
 <0e2fb8e4543f4a6ba48c04d261f78e5a@bowex36c.micron.com> <CALjAwxg2oDWyYJ3YSK-i9EVZJeUxt_mK34=uUca6SAcUqMJb5Q@mail.gmail.com>
 <ec99c46fa7a7476da9246c74ae90fab6@bowex36c.micron.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 2 Feb 2017 07:13:19 +0000
Message-ID: <CALjAwxhqb7A=DkKsMHhAKsrGsSc4h08kia+BZdOZZBZ104OrwA@mail.gmail.com>
Subject: Re: not all the jobs running at equal speed
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Prabhu Murugesan (pmurugesan)" <pmurugesan@micron.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

I strongly recommend you reduce the options in your configuration such
that you still see the problem and then update us with the
configuration that still shows the problem.

Something else to look at is adjusting your size and offset parameters
to be multiples of your blocksize:
bs=3D4k
ba=3D4k
[...]
size=3D112524539904
[...]
offset=3D112524539904
112524539904 % 4096 doesn't equal 0 so you are potentially forcing fio
to do extra work to keep realigning your I/O (you have ba=3D4k in there
which ideally wouldn't be if the I/Os were to naturally align). Note
that 0 % 4096 and 225049079808 % 4096 do equal 0 so there's less
alignment fixing taking place there...

On 1 February 2017 at 23:05, Prabhu Murugesan (pmurugesan)
<pmurugesan@micron.com> wrote:
> No, with or without stonewall, I am seeing unequal speeds. Even with 'off=
set_increment', I am seeing the same. It exactly behaves the same way as my=
 very first configuration with offset.
>
> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Wednesday, February 01, 2017 3:13 PM
> To: Prabhu Murugesan (pmurugesan) <pmurugesan@micron.com>
> Cc: fio@vger.kernel.org
> Subject: Re: not all the jobs running at equal speed
>
> It doesn't surprise me that run time increases but does that "make"
> all the jobs have equal speed? If so, do you see unequal speeds when you =
remove the stonewall from the numjobs setup? PS after checking that you mig=
ht want to investigate the offset_increment option (http://fio.readthedocs.=
io/en/sphinx-doc/fio_doc.html#cmdoption-arg-offset_increment
> ).
>
> On 1 February 2017 at 21:48, Prabhu Murugesan (pmurugesan) <pmurugesan@mi=
cron.com> wrote:
>> Actually, I wanted all the four jobs to run in parallel as opposed to ru=
nning them in sequence. It is similar to the 'numjobs' concept. But, I want=
ed to limit the amount of data being written and the lba range, so that not=
 more than one lba is being written.
>>
>> The way you suggested increases runtime from original 30 mins to 45 mins=
 now.
>>
>> -----Original Message-----
>> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
>> Sent: Wednesday, February 01, 2017 12:21 PM
>> To: Prabhu Murugesan (pmurugesan) <pmurugesan@micron.com>
>> Cc: fio@vger.kernel.org
>> Subject: Re: not all the jobs running at equal speed
>>
>> Looking a bit closer:
>>
>> The jobs in the first run have no stonewall so all 4 jobs will run simul=
taneously. The jobs in the second run have stonewall so at any given time o=
nly one of the jobs will be running. Does adding stonewall to the the globa=
l of the first run give similar results to the second run?
>>
>> On 1 February 2017 at 19:04, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>> Hi,
>>>
>>> On 1 February 2017 at 16:46, Prabhu Murugesan (pmurugesan)
>>> <pmurugesan@micron.com> wrote:
>>>>
>>>> I am trying to run 4 jobs in parallel in order to fill a drive once
>>>> randomly. The dut that I am using is a 450GB NVMe drive. The problem
>>>> is, not all the jobs are running at equal speed. You can find iops
>>>> log file data for all the jobs below
>>>
>>> The numjobs run is going to make all four jobs scribble over the
>>> "same" range compared to your carefully crafted first run. What
>>> happens if you set the offset to be 0 for all your jobs in your first
>>> run and let the size be 100%?
>>>
>>> PS: it helps if you reduce the the number of parameters to the bare
>>> minimum that still show the problem as it's less to look through.
>
> --
> Sitsofe | http://sucs.org/~sits/



--=20
Sitsofe | http://sucs.org/~sits/
