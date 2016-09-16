Return-Path: <fabrice.bacchella@orange.fr>
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: fio and posix_fadvise
From: Fabrice Bacchella <fabrice.bacchella@orange.fr>
In-Reply-To: <35191fbf-d272-31e0-4d66-5b702d91ff03@kernel.dk>
Date: Fri, 16 Sep 2016 18:34:17 +0200
Content-Transfer-Encoding: quoted-printable
Message-Id: <DDFC579C-9A81-4E6D-928E-57BD38E54874@orange.fr>
References: <AEA40A07-F002-4E1C-B4E4-991FF6B13F55@orange.fr> <35191fbf-d272-31e0-4d66-5b702d91ff03@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>


> Le 16 sept. 2016 =E0 17:23, Jens Axboe <axboe@kernel.dk> a =E9crit :
>=20
> On 09/15/2016 08:23 AM, Fabrice Bacchella wrote:
>>=20

>> Is there any plan to support it ?
>=20
> What kind of use case did you have in mind? Dropping pages after =
writing
> them? That basically boils down to being a non data integrity =
fdatasync.
> You would get basically the same effect by using fdatasync=3D1 in your
> workload. The difference would mainly be that DONTNEED would factor in
> the range and offset. So if you have multiple writers on the same =
file,
> then there would be a difference in behavior.
>=20
> That said, I don't mind adding support for using DONTNEED =
specifically.
> Currently it's just used to set a permanent hint, which is why it's =
only
> done once. For DONTNEED, you'd want to call it after each write =
instead.

I was thinking about read. When you have servers with huge amount of =
memory, either you reboot then with mem=3D<less>G or run bench with huge =
datasets. Both are clumsy solutions. directio is not a very good =
solution either, it's a very specific think that don't match not cached =
data. Using DONTNEED allows to simulate (I hope) a "bigger that RAM" =
data set.



=20=

