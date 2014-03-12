Return-Path: <axboe@kernel.dk>
Message-ID: <53208F72.4040404@kernel.dk>
Date: Wed, 12 Mar 2014 10:46:42 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Bug with "multi directory support" on windows
References: <e54fd34a63624f1ca306d3a6970272ac@DB4PR03MB572.eurprd03.prod.outlook.com> <53208C3D.8000500@kernel.dk> <53aec4da21c24553af5648e726474b17@DB4PR03MB572.eurprd03.prod.outlook.com>
In-Reply-To: <53aec4da21c24553af5648e726474b17@DB4PR03MB572.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
Content-Transfer-Encoding: quoted-printable
To: =?ISO-8859-1?Q?S=E9bastien_Bouchex_Bellomi=E9?= <sbouchex@infovista.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 03/12/2014 10:39 AM, S=EF=BF=BDbastien Bouchex Bellomi=EF=BF=BD wrote:
> Hi,
>
> Escaping the directory worked : C\:\temp\fio\read
>
> Documentation update ?

I think so. It's documented under the 'filename' option, so we can just=20
reference that. The directory option is right above it.

--=20
Jens Axboe


