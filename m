Return-Path: <axboe@kernel.dk>
Message-ID: <54524E66.50502@kernel.dk>
Date: Thu, 30 Oct 2014 08:42:46 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Solaris issue with packed stat structures
References: <14c6d46030d24183a714b5cf90ca81cc@DB4PR03MB572.eurprd03.prod.outlook.com>
In-Reply-To: <14c6d46030d24183a714b5cf90ca81cc@DB4PR03MB572.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
To: =?windows-1252?Q?S=E9bastien_Bouchex_Bellomi=E9?= <sbouchex@infovista.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-10-30 08:34, S=EF=BF=BDbastien Bouchex Bellomi=EF=BF=BD wrote:
> Hi,
>
> I'm the latest source on solaris SPARC and I have BUS errors when generat=
ing stats :
>
> Stack looks like this :
>
> 0002bac4 sum_stat (17973e, fbc05b38, 1, 0, 0, 22) + 38
>   0002cf24 sum_thread_stats (179526, fbc05920, 1, 0, fbd7de7c, 4) + a8
>   0003113c __show_run_stats (fe40ad88, 400, 0, 0, 0, 0) + 1124
>   000b0b10 fio_backend (0, ffbffcf4, 0, 0, 0, 15c174) + 200
>   000e6a40 main     (2, ffbffcf4, ffbffd00, 166130, 0, fefe0180) + c4
>   00017844 _start   (0, 0, 0, 0, 0, 0) + 5c
>
> It works fine on intel processors because the hardware is handling the mi=
salignment but on Sparc, it is not handled, so a BUS error is generated
>
> To fix this issue, I have added some padding here :
>
> [...]
> uint16_t continue_on_error;
> uint16_t continue_on_error_pad;				// <<<<<=3D=3D=3D=3D Pading here
> uint64_t total_err_count;
> uint32_t first_error;

What -git revision are you on? The latest should have the correct padding.

--=20
Jens Axboe


