Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <MWHPR11MB2045A939088A8133BB30CDEB875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
References: <MWHPR11MB2045B4FFEB905261E1FAFD1E875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <863271c2-eeb4-b770-bdfa-89746d4d9c70@kernel.dk> <MWHPR11MB2045DFA579DB2BDC5B1EA466875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <2feebb78-c436-3187-f28d-588f18b9dfc4@kernel.dk> <CALjAwxiwWDghXZpsN9vzR7AjwTgHU-g+iYeogbWvO5p6itMd6A@mail.gmail.com>
 <ddbb5d83-cc30-db5f-5c98-0b5809a15d76@kernel.dk> <MWHPR11MB2045095AA21ED4BF8BA38021875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <CALjAwxhx45=uTivppp3A1ACdGmon-oaH9S4b41MJQ6TfQCP7ZA@mail.gmail.com>
 <MWHPR11MB204527783F0D03DE6DE3556D875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <CALjAwxjO0i34McDkRRoeYCxW=CD4WG_=2Aohh=UA34tLL8w3AQ@mail.gmail.com>
 <MWHPR11MB20457601992059B3E7C48865875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <CALjAwxi+1Djmm_0SqEDTYV_Oc5yBDZYyak1Vd3S6Bsr8BNjjqg@mail.gmail.com>
 <MWHPR11MB204592682060845766230A8D875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <CALjAwxiNeLuF2QSf6rg5wF4rLv47Fc=XreZR1pQf6V9zjiTy6A@mail.gmail.com>
 <MWHPR11MB2045F05DB9FFF9FA44A04E6F875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <CALjAwxgAOCNQbWUw+eTiu3J2ZprXpmxpezLe53eFno0s0oaFDQ@mail.gmail.com>
 <MWHPR11MB2045A9D5365FF57AC31CC87D875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <CALjAwxjsP=r87NXxurSXa86YUt7orCuPTAK=Gu3qfpUaUcCV5w@mail.gmail.com> <MWHPR11MB2045A939088A8133BB30CDEB875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 31 Oct 2017 22:45:25 +0000
Message-ID: <CALjAwxiS8XOFhwweHRND3ocJFY2FH_aud=9_OXtbWAM7-b1LJQ@mail.gmail.com>
Subject: Re: FIO windows
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: David Hare <david.hare@primarydata.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hmm, I can't reproduce the problem here but still it's curious. Do you
get the same problem with one file and if so after the job runs can
you check what size the file was?

Is there anything special about the filesystems? Are they local NTFS
and quite small (less than 16TBytes)? Do they have a custom cluster
size?

On 31 October 2017 at 22:33, David Hare <david.hare@primarydata.com> wrote:
> You may be on to something!
>
> I tried 3 drives, got the exact same results. See attached.
>
>
>
> [global]
>
> ioengine=3Dwindowsaio
> blocksize=3D64k
> direct=3D1
>
>
> thread
> size=3D250m
>
>
>
> time_based
> runtime=3D10
>
>
> [asdf]
> filename=3DF\:\\testfile:G\:\\testfile:H\:\\testfile
>
> ;:I\:\\testfile:J\:\\testfile:K\:\\testfile:L\:\\testfile:M\:\\testfile:N=
\:\\testfile
> ;:O\:\\testfile:P\:\\testfile:Q\:\\testfile
>
>
> -Dave
>
>
> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Tuesday, October 31, 2017 3:15 PM
> To: David Hare <david.hare@primarydata.com>
> Cc: Jens Axboe <axboe@kernel.dk>; fio@vger.kernel.org
> Subject: Re: FIO windows
>
> One idea is that you are seeing the effect of trying to do I/O to a file
> that is not a multiple of the blocksize. In theory if you have size=3D1g =
and
> you have 9 files then each file ends up being 1024**3/9.0 ~
> 119304647.1111111 big (see
> http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-filename
> for where this is described). Could it be that Windows goes on to make a
> file that is smaller than what we were asking for?
>
> If this theory were right you might see a similar problem if you were onl=
y
> using 3 files.
>
> On 31 October 2017 at 22:06, David Hare <david.hare@primarydata.com> wrot=
e:
>> Yes.. I made a typo when I changed it back, sorry.
>>
>> -----Original Message-----
>> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
>> Sent: Tuesday, October 31, 2017 3:05 PM
>> To: David Hare <david.hare@primarydata.com>
>> Cc: Jens Axboe <axboe@kernel.dk>; fio@vger.kernel.org
>> Subject: Re: FIO windows
>>
>> Yes that's right. Also previously did you mean you had set size=3D512m
>> even though you wrote size=3D512g ?
>>
>> On 31 October 2017 at 22:03, David Hare <david.hare@primarydata.com>
>> wrote:
>>> I assume you want me to change the size parameter with a 64k
>>> blocksize as everything is working with 16k blocksize?
>>>
>>> -----Original Message-----
>>> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
>>> Sent: Tuesday, October 31, 2017 2:54 PM
>>> To: David Hare <david.hare@primarydata.com>
>>> Cc: Jens Axboe <axboe@kernel.dk>; fio@vger.kernel.org
>>> Subject: Re: FIO windows
>>>
>>> Hi,
>>>
>>> Can you add unlink=3D1 and keep reducing the size parameter (e.g. down
>>> to 128m then down to 16m then down to 4m then down to 1m then down to
>>> 512k etc)?
>>>
>>> Can you attach the full output that's produced it fails with this
>>> reduced job?
>>>
>>> IF you are make the problem happen with very little I/O being done
>>> (i.e. the job bombs out after doing less than 1MiBytes worth of I/O)
>>> you can try adding --debug=3Dall to the job and seeing if that offers
>>> any clues as to what the last thing it was doing was?
>>>
>>> On 31 October 2017 at 21:46, David Hare <david.hare@primarydata.com>
>>> wrote:
>>>> It was ok with or without the colon, the size didn=E2=80=99t seem to m=
ake a
>>>> difference, but blocksize did.. see the commented block sizes below.
>>>>
>>>> fio2.fio
>>>> [global]
>>>>
>>>> ioengine=3Dwindowsaio
>>>>
>>>> ;blocksize=3D64k - error
>>>> ;blocksize=3D32k - error
>>>> ;blocksize=3D16k - no error
>>>>
>>>> blocksize=3D16k
>>>>
>>>> direct=3D1
>>>>
>>>> thread
>>>>
>>>> size=3D512g
>>>>
>>>>
>>>>
>>>> time_based
>>>> runtime=3D10
>>>>
>>>> [asdf]
>>>> filename=3DF\:\\testfile:G\:\\testfile:H\:\\testfile:I\:\\testfile:J\:
>>>> \ \ testfile:K\:\\testfile:L\:\\testfile:M\:\\testfile:P\:\\testfile
>>>>
>>>> Results:
>>>> Run status group 0 (all jobs):
>>>> READ: bw=3D141MiB/s (148MB/s), 141MiB/s-141MiB/s (148MB/s-148MB/s),
>>>> io=3D1413MiB (1481MB), run=3D10001-10001msec
>>>>
>>>>
>>>> -Dave
>>
>> --
>> Sitsofe | http://sucs.org/~sits/
>>
>>
>> Disclaimer
>>
>> The information contained in this communication from the sender is
>> confidential. It is intended solely for use by the recipient and
>> others authorized to receive it. If you are not the recipient, you are
>> hereby notified that any disclosure, copying, distribution or taking
>> action in relation of the contents of this information is strictly
>> prohibited and may be unlawful.
>
>
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

