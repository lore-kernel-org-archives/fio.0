Return-Path: <robin@coraid.com>
From: "Robin P. Blanchard" <robin@coraid.com>
Subject: Re: regression since 2.1.3 (solaris/zfs)
Date: Wed, 5 Mar 2014 16:11:01 +0000
Message-ID: <AAC03F56-6145-4649-AA09-32AEF3452119@coraid.com>
References: <1E602C14-0C00-4258-94C2-8F16A56C509D@coraid.com>
 <53149EF3.7020005@kernel.dk>
In-Reply-To: <53149EF3.7020005@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <5CF9876C09E43E4C9A6C6A89319F63EB@fwd6.exghost.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>


On Mar 3, 2014, at 10:25 AM, Jens Axboe <axboe@kernel.dk> wrote:

> On 03/02/2014 07:59 AM, Robin P. Blanchard wrote:
>> My config file has direct=3D0, which until 2.1.4 worked as expected.
> > Things seem to regress since.
>>=20
>> I apologize in advance if this has already been reported. Please
> > let me know what I can do to further help (truss/debug).
>=20
> This isn't a known issue, so thanks for reporting it. The easiest way to =
debug this is to git bisect it. Looks like you are running from the tar bal=
ls, but I assume you have git installed? I'm assuming fio-2.1.3 worked for =
you - if not, just replace fio-2.1.3 in the below with whatever latest vers=
ion did work. If you do, the cheat sheet is something ala:
>=20
> $ git clone git://git.kernel.dk/fio
> $ cd fio; make
> $ git bisect start
> $ git bisect good fio-2.1.3
> $ git bisect bad fio-2.1.4
>=20
> This starts the bisect series, now do:
>=20
> $ make clean; make
>=20
> and re-run your direct=3D0 job file. If it worked, then you do
>=20
> $ git bisect good
>=20
> and if not, you do git bisect bad instead. This gets you a new point in t=
he tree to test, so repeat the make clean; make and re-run the test.
> Keep doing this good/bad iteration until fio tells you what commit broke =
the test for you. Then send those results here!
>=20
> --=20
> Jens Axboe
>=20


Here=92s where it started working again:

# git bisect good
Bisecting: 4 revisions left to test after this (roughly 2 steps)
[3bb0a7b0fda9945973f799ab253c70d3cb0e5c8b] howto: Fix redundant entries

Let me know how else I can help.



Thanks,
Robin


--=20
Robin P. Blanchard
Solutions Engineer
Coraid Global Field Services
www.coraid.com
+1 650.730.5140


