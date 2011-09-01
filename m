Return-Path: <bfallik@bamboom.com>
MIME-Version: 1.0
In-Reply-To: <4E5FAD90.80405@kernel.dk>
References: <CAOYTo+2Xh=JuLi1rx_LGjfEHheRhp2RE=tT-RZ8arT7ULYziTA@mail.gmail.com>
 <x49ippd5t7y.fsf@segfault.boston.devel.redhat.com> <4E5E91D9.4000702@fusionio.com>
 <CAOYTo+3JyNsxMf+UO5C3N=rrtkGR999XM9Guo5-0TXFqSuUr+Q@mail.gmail.com>
 <4E5EA5DF.5040609@fusionio.com> <4E5EA9D0.10109@kernel.dk>
 <CAOYTo+2pBwxmX-nhf6MP=Szvm3EoEFjGWapqbtC5JVSQskS4hQ@mail.gmail.com> <4E5FAD90.80405@kernel.dk>
From: Brian Fallik <bfallik@bamboom.com>
Date: Thu, 1 Sep 2011 14:17:20 -0400
Message-ID: <CAOYTo+1Cm4v1QpBmPSTf4pYS170soGByNKJtEvKoXAQFm9JNnw@mail.gmail.com>
Subject: Re: fio file test patterns
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Moyer <jmoyer@redhat.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Thu, Sep 1, 2011 at 12:06 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2011-09-01 08:18, Brian Fallik wrote:
>> Perhaps I should describe what I'm seeing. =A0I have two terminals open.
>> =A0In one, I launch:
>> =A0 $ watch "ls -l foo* | head -n 20"
>> In the other terminal I kick off fio. =A0fio first spits out the "Laying
>> out" messages, one per job. =A0Immediately the full 4MB files appear in
>> the directory listing. =A0*Then* fio starts writing to the files, as
>> indicated by the fio output. =A0The size of each file never changes
>> during the test.
>>
>> I wasn't expecting the full 4Mb files to be created before the
>> sequential writes. =A0I expected to not see any files initially, and
>> then a file for each job growing at a rate of 200Kbs throughout the
>> test until reaching the 4MB limit.
>>
>> Perhaps I'm just configuring fio incorrectly?
>
> That you see them there does not mean they are actually written. Fio
> will use truncate to setup the files, but only actually fill them with
> data if you are going to be reading them (or requested overwrite).

Digging deeper, I ran fio under strace:
  25445 stat("foo0", 0x7ffff0a586b0)      =3D -1 ENOENT (No such file or
directory)
  25445 unlink("foo0")                    =3D -1 ENOENT (No such file or
directory)
  25445 open("foo0", O_WRONLY|O_CREAT, 0644) =3D 3
  25445 fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D0, ...}) =3D 0
  25445 fstatfs(3, {f_type=3D0x58465342, f_bsize=3D4096,
f_blocks=3D4880335840, f_bfree=3D4880324644, f_bavail=3D4880324644,
f_files=3D19521474432, f_ffree=3D19521474273, f_fsid=3D{2065, 0},
f_namelen=3D255, f_frsize=3D4096}) =3D 0
  25445 pwrite(3, "\0", 1, 4095)          =3D 1
  25445 pwrite(3, "\0", 1, 8191)          =3D 1
  ...
  25445 pwrite(3, "\0", 1, 4194303)       =3D 1
  25445 fadvise64(3, 0, 4194304, POSIX_FADV_DONTNEED) =3D 0
  25445 close(3)
and then later in the log:
  25447 open("foo0", O_RDWR|O_CREAT, 0600) =3D 3
  25447 fadvise64(3, 0, 4194304, POSIX_FADV_DONTNEED) =3D 0
  25447 fadvise64(3, 0, 4194304, POSIX_FADV_SEQUENTIAL) =3D 0
  25447 lseek(3, 0, SEEK_SET)             =3D 0
  25447 write(3,
"\324\310\21i7\345\213g\32\271\323\214?\216)\33#7\255K\177ow\34\344F\306\26=
77\2630\24"...,
4096) =3D 4096
  25447 nanosleep({0, 19559000},  <unfinished ...>
  25447 <... nanosleep resumed> NULL)     =3D 0
  25447 write(3,
"\354\316\3126;\355\311A\335\331oj\320{\252\30;[\335\323IL\204\ngK\361\332\=
344m\344\37"...,
4096) =3D 4096
  ...
until the end of the test.

If I'm reading this correctly, during startup fio writes EOF to
successively larger file positions until it achieves the desired file
size.  Then, during the test itself, fio writes sequentially from the
start of the file.  I captured this on RHEL5 with xfs.  When I perform
the same test on Fedora 15 / ext4, fio does not use pwrite() but
instead calls fallocate().

I'm not sure why fallocate() isn't being used in both cases, but
regardless it seems like fio is instructing the filesystem to allocate
the blocks for the file before the sequential write test starts.  I
may be misunderstanding your last response, but I was expecting to see
an strace log containing:
  open()
  truncate()
to setup the test file and then:
  open()
  write()
  ...
during the actual test.

>
> BTW, please don't top-post. Reply beneath the original text, like a
> normal flow of conversation.

Apologies.


Thanks,
brian

