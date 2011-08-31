Return-Path: <bfallik@bamboom.com>
MIME-Version: 1.0
From: Brian Fallik <bfallik@bamboom.com>
Date: Wed, 31 Aug 2011 14:34:22 -0600
Subject: Re: fio file test patterns
Message-ID: 
 <CAOYTo+3JyNsxMf+UO5C3N=rrtkGR999XM9Guo5-0TXFqSuUr+Q@mail.gmail.com>
References: 
 <CAOYTo+2Xh=JuLi1rx_LGjfEHheRhp2RE=tT-RZ8arT7ULYziTA@mail.gmail.com>
 <x49ippd5t7y.fsf@segfault.boston.devel.redhat.com>
 <4E5E91D9.4000702@fusionio.com>
In-Reply-To: <4E5E91D9.4000702@fusionio.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi,

Hmm.  I'm still unable to generate random test data using fio.   My
new job control file is:
  [foo0]
  rate =3D,200k
  rw =3Dwrite
  refill_buffers =3D1
  size =3D4m

  [foo1]
  rate =3D,200k
  rw =3Dwrite
  refill_buffers =3D1
  size =3D4m
But:
  $ diff foo0.1.0 foo1.2.0
reports they're identical.  I also tried enabling data verification by
adding "verify=3Dcrc32c-intel" but that had no effect.  Am I missing
something obvious or is this potentially broken in fio 1.57?

I also have another (maybe related?) question.  Apologies if this
belongs in a separate thread, but are there any notes explaining why
fio lays out the files before starting sequential writes?  The
workload I was hoping to simulate is sustained, sequential writes to
disk.  I'm trying to answer the question "How many simultaneous
200kBps writers can we support?"  Using my current jobs file, fio
starts by creating the files (e.g "foo0: Laying out IO file(s) (1
file(s) / 4MB)") before it starts processing.  However, creating the
files in advance accounts for a chunk of performance that doesn't seem
to be measured by fio.  Am I misunderstanding how to configure fio or
its intended usage?

Thanks,
brian


On Wed, Aug 31, 2011 at 3:56 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
> On 2011-08-31 12:30, Jeff Moyer wrote:
>> Brian Fallik <bfallik@bamboom.com> writes:
>>
>>> Hi,
>>>
>>> Apologies if this is documented somewhere else but I couldn't find it
>>> in the fio man page, example job files, or list archives.
>>>
>>> I'm exploring fio as a testing tool and it seems very well suited for
>>> my needs. =A0I'm currently running experiments with N sequential writer=
s
>>> all writing at 200k. =A0The jobs file is very simple:
>>> =A0 =A0 [global]
>>> =A0 =A0 size=3D10m
>>> =A0 =A0 directory=3D.
>>>
>>> =A0 =A0 [foo1]
>>> =A0 =A0 rw=3Dwrite
>>> =A0 =A0 rate=3D200k
>>>
>>> =A0 =A0 [foo2]
>>> =A0 =A0 ...
>>> fio creates various foo* files as part of its test but they all seem
>>> to contain the same content. =A0I would have expected fio to generate
>>> random data in each file to avoid potential optimizations like
>>> deduplication. =A0 Am I missing the flag to generate random test
>>> patterns or is this behavior intentional?
>>
>> =A0 =A0 =A0 =A0refill_buffers
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 If this option is given, fio will refill the=
 IO buffers on every
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 submit. The default is to only fill it at in=
it =A0time and reuse
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 that =A0data. =A0Only =A0makes =A0sense if z=
ero_buffers isn't specified,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 naturally. If data verification is =A0enable=
d, refill_buffers is
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 also automatically enabled.
>
> Yes. Fio does use random data by default, but for to avoid slowing down
> too much, it also defaults to reusing the same random data all the time.
> If you set the above option, you get fully fresh random data for every
> write, thus fully defeating any de-dupe/compression attempts on the
> target.
>
> --
> Jens Axboe
>
>

