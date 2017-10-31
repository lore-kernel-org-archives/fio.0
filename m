Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <MWHPR11MB204592682060845766230A8D875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
References: <MWHPR11MB2045B4FFEB905261E1FAFD1E875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <863271c2-eeb4-b770-bdfa-89746d4d9c70@kernel.dk> <MWHPR11MB2045DFA579DB2BDC5B1EA466875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <2feebb78-c436-3187-f28d-588f18b9dfc4@kernel.dk> <CALjAwxiwWDghXZpsN9vzR7AjwTgHU-g+iYeogbWvO5p6itMd6A@mail.gmail.com>
 <ddbb5d83-cc30-db5f-5c98-0b5809a15d76@kernel.dk> <MWHPR11MB2045095AA21ED4BF8BA38021875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <CALjAwxhx45=uTivppp3A1ACdGmon-oaH9S4b41MJQ6TfQCP7ZA@mail.gmail.com>
 <MWHPR11MB204527783F0D03DE6DE3556D875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <CALjAwxjO0i34McDkRRoeYCxW=CD4WG_=2Aohh=UA34tLL8w3AQ@mail.gmail.com>
 <MWHPR11MB20457601992059B3E7C48865875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <CALjAwxi+1Djmm_0SqEDTYV_Oc5yBDZYyak1Vd3S6Bsr8BNjjqg@mail.gmail.com> <MWHPR11MB204592682060845766230A8D875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 31 Oct 2017 21:54:13 +0000
Message-ID: <CALjAwxiNeLuF2QSf6rg5wF4rLv47Fc=XreZR1pQf6V9zjiTy6A@mail.gmail.com>
Subject: Re: FIO windows
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: David Hare <david.hare@primarydata.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi,

Can you add unlink=3D1 and keep reducing the size parameter (e.g. down
to 128m then down to 16m then down to 4m then down to 1m then down to
512k etc)?

Can you attach the full output that's produced it fails with this reduced j=
ob?

IF you are make the problem happen with very little I/O being done
(i.e. the job bombs out after doing less than 1MiBytes worth of I/O)
you can try adding --debug=3Dall to the job and seeing if that offers
any clues as to what the last thing it was doing was?

On 31 October 2017 at 21:46, David Hare <david.hare@primarydata.com> wrote:
> It was ok with or without the colon, the size didn=E2=80=99t seem to make=
 a
> difference, but blocksize did.. see the commented block sizes below.
>
> fio2.fio
> [global]
>
> ioengine=3Dwindowsaio
>
> ;blocksize=3D64k - error
> ;blocksize=3D32k - error
> ;blocksize=3D16k - no error
>
> blocksize=3D16k
>
> direct=3D1
>
> thread
>
> size=3D512g
>
>
>
> time_based
> runtime=3D10
>
> [asdf]
> filename=3DF\:\\testfile:G\:\\testfile:H\:\\testfile:I\:\\testfile:J\:\\t=
estfile:K\:\\testfile:L\:\\testfile:M\:\\testfile:P\:\\testfile
>
> Results:
> Run status group 0 (all jobs):
> READ: bw=3D141MiB/s (148MB/s), 141MiB/s-141MiB/s (148MB/s-148MB/s), io=3D=
1413MiB
> (1481MB), run=3D10001-10001msec
>
>
> -Dave
>
>
>
> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Tuesday, October 31, 2017 2:28 PM
> To: David Hare <david.hare@primarydata.com>
> Cc: Jens Axboe <axboe@kernel.dk>; fio@vger.kernel.org
> Subject: Re: FIO windows
>
> Hi,
>
> On 31 October 2017 at 20:46, David Hare <david.hare@primarydata.com> wrot=
e:
>>
>> If I remove - "blocksize=3D64k" "direct=3D1" "thread=3D8" "size=3D1g"
>> "time_based with runtime=3D10" or ":P\:\\testfile:" (the 9th drive) the =
file
>> works.
>>
>> The below file generates this error:
>> fio: pid=3D8404, err=3D22/file:ioengines.c:333, func=3Dtd_io_queue,
>> error=3DInvalid argument
>> asdf: (groupid=3D0, jobs=3D1): err=3D22 (file:ioengines.c:333,
>> func=3Dtd_io_queue, error=3DInvalid argument): pid=3D8404: Tue Oct 31
>>
>>
>> [global]
>>
>> ioengine=3Dwindowsaio
>> blocksize=3D64k
>> direct=3D1
>>
>> thread=3D8
>> size=3D1g
>>
>> time_based
>> runtime=3D10
>>
>> [asdf]
>>
>> filename=3DF\:\\testfile:G\:\\testfile:H\:\\testfile:I\:\\testfile:J\:\\=
testfile:K\:\\testfile:L\:\\testfile:M\:\\testfile:P\:\\testfile:
>
> "thread=3D8" should be the same as using "thread" and would be required o=
n
> Windows. "P\:\\testfile:" should be "P\:\\testfile" (note the lack of
> trailing colon - see the examples in
> http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-filename
> ). time_based and runtime sound required. Perhaps a smaller blocksize mea=
ns
> it takes longer than 10 seconds to hit the problem - presumably
> blocksize=3D128k is still as problematic? I'm also assuming the problem s=
till
> happens with size=3D512m ?
>
> --
> Sitsofe | http://sucs.org/~sits/
>
>
> Disclaimer
>
> The information contained in this communication from the sender is
> confidential. It is intended solely for use by the recipient and others
> authorized to receive it. If you are not the recipient, you are hereby
> notified that any disclosure, copying, distribution or taking action in
> relation of the contents of this information is strictly prohibited and m=
ay
> be unlawful.



--=20
Sitsofe | http://sucs.org/~sits/

