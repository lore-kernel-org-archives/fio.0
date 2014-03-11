Return-Path: <axboe@kernel.dk>
Message-ID: <531F25B7.2070507@kernel.dk>
Date: Tue, 11 Mar 2014 09:03:19 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: json output issue on solaris sparc
References: <48976ca93fb54c4182ec7189ffc533d1@DB4PR03MB572.eurprd03.prod.outlook.com> <5318ECDA.3060502@kernel.dk> <3e371a215a394ca383f6c1206a09fa6e@DB4PR03MB572.eurprd03.prod.outlook.com> <5462368f49b44fcda98c00c97314435c@DB4PR03MB572.eurprd03.prod.outlook.com>
In-Reply-To: <5462368f49b44fcda98c00c97314435c@DB4PR03MB572.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
Content-Transfer-Encoding: quoted-printable
To: =?ISO-8859-1?Q?S=E9bastien_Bouchex_Bellomi=E9?= <sbouchex@infovista.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 03/11/2014 08:39 AM, S=EF=BF=BDbastien Bouchex Bellomi=EF=BF=BD wrote:
> Hi,
>
> OK, the issue was related to the alignment issue between the thread_optio=
ns structure and its "packed" version : The lexxx_to_cpu macros are incorre=
ctly casting the pointers and that causes an bus error.
> I have fixed the issue by avoid casting the pointers and calling directly=
 the "swap" method.
>
> I have also included a fixed on the thread_options structure regarding th=
e ddir_seq_add variable : Its length was incorrect.
>
> Attached, you will find a patch that's fixed both.
>
> The 32 bit version is still not working on json but since the 64 bit vers=
ion is working fine, I will not probably work on it.

Nice work! I have applied the patch.

--=20
Jens Axboe


