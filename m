Return-Path: <evelu@redhat.com>
Date: Mon, 8 Aug 2016 03:19:39 -0400 (EDT)
From: Erwan Velu <evelu@redhat.com>
Message-ID: <1678347027.185727.1470640779017.JavaMail.zimbra@redhat.com>
In-Reply-To: <0523eea4-0332-2b8e-a595-fd66cd6ae3de@kernel.dk>
References: <CAG6KGPRQf7Mii35T1drhL=u0mZB8PQEeOMnmuBFWSNgBy4E31A@mail.gmail.com> <48aea5d8-12a5-58ca-9008-913e13bc7a8d@kernel.dk> <CAG6KGPSthqs28GTQYSnFGcs_XzQWdALQ8knUS7ook2-_wurcmw@mail.gmail.com> <4ac1a598-480e-bfa6-3704-929c909be5da@kernel.dk> <b67f4217-97f3-f9f9-46a1-92c9b43ba9b9@kernel.dk> <CAG6KGPSukQwdmfcJiE7CSHZf4hYV4niHm2QQcM1tyE=kBHBtzw@mail.gmail.com> <0523eea4-0332-2b8e-a595-fd66cd6ae3de@kernel.dk>
Subject: Re: Unlink after each loop in job
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: Martin Dev <mrturtledev@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hey Jens,

I don't see where the patch is, did I missed something ?

----- Mail original -----
De: "Jens Axboe" <axboe@kernel.dk>
=C3=80: "Martin Dev" <mrturtledev@gmail.com>, fio@vger.kernel.org
Envoy=C3=A9: Vendredi 5 Ao=C3=BBt 2016 15:50:53
Objet: Re: Unlink after each loop in job

On 08/05/2016 01:31 AM, Martin Dev wrote:
> Hey Jens,
>
> I applied your patch, but it doesn't unlink the file as it continues
> at the !fio_file_open(f) in unlink_files(), run for 2 loops
>
> Clear State: 0
> Clear State: 1
> Doing unlink
> Starting file loop
> File is not open!
>
> I assume it's OK to flip it and check if the file is open then
> continue (so not to unlink files that are potentially still in use)
>
> I'll update the readme/docs and fio.1 as suggested.

The file_open() should just be removed, at best, or at least we should=20
flip the check, it doesn't make a lot of sense to only unlink if it's=20
open. In any case, it doesn't really matter if it's open or not, last=20
user will drop it.

So I'd just drop that check.

--=20
Jens Axboe

