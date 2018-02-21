Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CY1PR0401MB11163A5F0CE792CC28A7252D81CE0@CY1PR0401MB1116.namprd04.prod.outlook.com>
References: <CY1PR0401MB11163E6C999998E0A2F13F9E81F70@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CY1PR0401MB111689EE46B3839EB0675D7B81F70@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CY1PR0401MB1116307F93264CDB7F09870981F70@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxhHoS62hDsz9cvwjYBJFODDZ6EvTry9u4nErXAC67JwKg@mail.gmail.com>
 <CY1PR0401MB111673C9DC353353BACFCE5B81F50@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CY1PR0401MB1116FC09283C22316161F3E381CE0@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxgi-muVZ4XVF53amSHOzLjMEDSY2Z2GRmKso_VZ1sVazA@mail.gmail.com> <CY1PR0401MB11163A5F0CE792CC28A7252D81CE0@CY1PR0401MB1116.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 21 Feb 2018 17:23:35 +0000
Message-ID: <CALjAwxiso_3xAjP1CJ91=qXcsyKcwzN2XfBeGLvPzeMj45BLGQ@mail.gmail.com>
Subject: Re: fiologparser_hist.py script patch and enhancements?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Kris Davis <Kris.Davis@wdc.com>
Cc: Vincent Fu <vincentfu@gmail.com>, Vincent Fu <Vincent.Fu@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hi,

Alas no. It's less of a case of "is the Python version at least 2.7"
and more a case of "not all platforms have a "python2" link (see
macOS) / distros are banning interpreters lines that mention just
"python" (see https://fedoraproject.org/wiki/Packaging:Python#Multiple_Pyth=
on_Runtimes
).

On 21 February 2018 at 17:00, Kris Davis <Kris.Davis@wdc.com> wrote:
> I had changed the interpreter to just be "python" rather than "python2.7"=
, and added a check to ensure that the python version was at least 2.7.  Th=
is allows it to use whatever version (2.7 or above) that has been associate=
d with "python" (usually 2.7+ in recent linux os's).  What I've see (unless=
 a virtualenv is used), python 3+ has a symlink set to python3.
> The point is, if the interpreter is set to python2.7, the user is general=
ly "forced" to use 2.7, unless all command lines are prepended with the pyt=
hon??
>
> Does that address your concern?

--=20
Sitsofe | http://sucs.org/~sits/

