Return-Path: <elliott@hpe.com>
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH 2/4] HOWTO: fix unit type suffix in "Parameter types"
 section
Date: Wed, 9 Aug 2017 01:00:15 +0000
Message-ID: <AT5PR84MB00821C93CAA7FE17DE565B77AB8B0@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
References: <20170807173754.80126-1-tkusumi@tuxera.com>
 <20170807173754.80126-3-tkusumi@tuxera.com>
In-Reply-To: <20170807173754.80126-3-tkusumi@tuxera.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "kusumi.tomohiro@gmail.com" <kusumi.tomohiro@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>



> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Beh=
alf
> Of kusumi.tomohiro@gmail.com
> Sent: Monday, August 07, 2017 12:38 PM
> To: axboe@kernel.dk; fio@vger.kernel.org
> Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
> Subject: [PATCH 2/4] HOWTO: fix unit type suffix in "Parameter types" sec=
tion
>=20
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
>=20
> These should be all in lower case or all in upper case, but not both.
> Given the examples of these are mostly in lower case, this commit
> uses lower.
>=20
> The man page already has these in lower case.
>=20
> Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
> ---
>  HOWTO | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>=20
> diff --git a/HOWTO b/HOWTO
> index ee2b996..cad9500 100644
> --- a/HOWTO
> +++ b/HOWTO
> @@ -505,19 +505,19 @@ Parameter types
>  	prefixes.  To specify power-of-10 decimal values defined in the
>  	International System of Units (SI):
>=20
> -		* *Ki* -- means kilo (K) or 1000
> -		* *Mi* -- means mega (M) or 1000**2
> -		* *Gi* -- means giga (G) or 1000**3
> -		* *Ti* -- means tera (T) or 1000**4
> -		* *Pi* -- means peta (P) or 1000**5
> +		* *ki* -- means kilo (K) or 1000
> +		* *mi* -- means mega (M) or 1000**2
> +		* *gi* -- means giga (G) or 1000**3
> +		* *ti* -- means tera (T) or 1000**4
> +		* *pi* -- means peta (P) or 1000**5
>=20
>  	To specify power-of-2 binary values defined in IEC 80000-13:
>=20
>  		* *k* -- means kibi (Ki) or 1024
> -		* *M* -- means mebi (Mi) or 1024**2
> -		* *G* -- means gibi (Gi) or 1024**3
> -		* *T* -- means tebi (Ti) or 1024**4
> -		* *P* -- means pebi (Pi) or 1024**5
> +		* *m* -- means mebi (Mi) or 1024**2
> +		* *g* -- means gibi (Gi) or 1024**3
> +		* *t* -- means tebi (Ti) or 1024**4
> +		* *p* -- means pebi (Pi) or 1024**5
>=20
>  	With :option:`kb_base`\=3D1024 (the default), the unit prefixes are
> opposite
>  	from those specified in the SI and IEC 80000-13 standards to provide
> --

SI prefixes are case-sensitive, with several conflicts:
* m means milli (10**-3)
* p means pico (10**-12)

and more looming if fio ever suported even bigger quantities:
* z means zepto (10**-21) vs. zetta (10**21)
* y means yocto (10**-24) vs. yotta (10**24)

Since fio never deals with subdivisions of a byte, it allows the
job file to be sloppy and use the wrong case.  However, I recommend
that we stick to the correct capitalization in the documentation.


---
Robert Elliott, HPE Persistent Memory



