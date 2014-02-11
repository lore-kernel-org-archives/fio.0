Return-Path: <Elliott@hp.com>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: Mutex destruction, invalid memory accesses, leaks
Date: Tue, 11 Feb 2014 00:12:54 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029548A645A@G9W0745.americas.hpqcorp.net>
References: <20140206192135.GB3950@kernel.dk>
 <20140207034439.GA17588@sucs.org> <52F505A8.30004@kernel.dk>
 <20140209195042.GA17058@sucs.org> <52F927AC.6020007@cran.org.uk>
 <20140210202245.GA6747@sucs.org> <20140210205659.GC4096@kernel.dk>
In-Reply-To: <20140210205659.GC4096@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Bruce Cran <bruce@cran.org.uk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

The latest pulled version with this change works on my Windows Server 2008 =
R2 system that was crashing with 2-1.4.

---
Rob Elliott    HP Server Storage




> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
> Behalf Of Jens Axboe
> Sent: Monday, 10 February, 2014 2:57 PM
> To: Sitsofe Wheeler
> Cc: Bruce Cran; fio@vger.kernel.org
> Subject: Re: Mutex destruction, invalid memory accesses, leaks
>=20
> On Mon, Feb 10 2014, Sitsofe Wheeler wrote:
> > On Mon, Feb 10, 2014 at 12:25:32PM -0700, Bruce Cran wrote:
> > > On 2/9/2014 12:50 PM, Sitsofe Wheeler wrote:
> > > >
> > > >Yes it's still happening with -git from a moment ago. What is stoppi=
ng a
> > > >sleeping thread from holding a mutex that is destroyed and then waki=
ng
> > > >up on it after the memory has been unmapped?
> > >
> > > In case it *is* a bug in winpthreads-1.dll, are you using version
> > > 3.1.0-1? It was released on the 15th January and there appeared to
> > > be some mutex-related fixes when I looked at the svn log a few weeks
> > > ago.
> >
> > Yes I am using version 3.1.0-1 on Windows 7 installed about a week
> > ago...
>=20
> Actually, the previous wont work, and I don't see how to make it work.
> Please try the below instead. Or just re-pull, I'll check it in now.
>=20
>=20
> diff --git a/backend.c b/backend.c
> index 501c59a..a607134 100644
> --- a/backend.c
> +++ b/backend.c
> @@ -1236,13 +1236,6 @@ static void *thread_main(void *data)
>  	dprint(FD_MUTEX, "done waiting on td->mutex\n");
>=20
>  	/*
> -	 * the ->mutex mutex is now no longer used, close it to avoid
> -	 * eating a file descriptor
> -	 */
> -	fio_mutex_remove(td->mutex);
> -	td->mutex =3D NULL;
> -
> -	/*
>  	 * A new gid requires privilege, so we need to do this before setting
>  	 * the uid.
>  	 */
> @@ -1521,6 +1514,9 @@ err:
>  	fio_mutex_remove(td->rusage_sem);
>  	td->rusage_sem =3D NULL;
>=20
> +	fio_mutex_remove(td->mutex);
> +	td->mutex =3D NULL;
> +
>  	td_set_runstate(td, TD_EXITED);
>  	return (void *) (uintptr_t) td->error;
>  }
>=20
> --
> Jens Axboe
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

