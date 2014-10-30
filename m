Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-am1on0148.outbound.protection.outlook.com ([157.56.112.148]:33499
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932513AbaJ3OzS convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 30 Oct 2014 10:55:18 -0400
From: =?iso-8859-1?Q?S=E9bastien_Bouchex_Bellomi=E9?= 
	<sbouchex@infovista.com>
Subject: RE: Solaris issue with packed stat structures
Date: Thu, 30 Oct 2014 14:55:06 +0000
Message-ID: <813187cb8a7d49ef8795617c22fe0321@DB4PR03MB572.eurprd03.prod.outlook.com>
References: <14c6d46030d24183a714b5cf90ca81cc@DB4PR03MB572.eurprd03.prod.outlook.com>
 <54524E66.50502@kernel.dk>
In-Reply-To: <54524E66.50502@kernel.dk>
Content-Language: fr-FR
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

The version on opencsw.org was buggy. I took the one on the git server and =
everything works fine.

Thanks

Seb

-----Message d'origine-----
De=EF=BF=BD: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] D=
e la part de Jens Axboe
Envoy=EF=BF=BD: jeudi 30 octobre 2014 15:43
=EF=BF=BD=EF=BF=BD: S=EF=BF=BDbastien Bouchex Bellomi=EF=BF=BD; fio@vger.ke=
rnel.org
Objet=EF=BF=BD: Re: Solaris issue with packed stat structures

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
> It works fine on intel processors because the hardware is handling the=20
> misalignment but on Sparc, it is not handled, so a BUS error is=20
> generated
>
> To fix this issue, I have added some padding here :
>
> [...]
> uint16_t continue_on_error;
> uint16_t continue_on_error_pad;				// <<<<<=3D=3D=3D=3D Pading here
> uint64_t total_err_count;
> uint32_t first_error;

What -git revision are you on? The latest should have the correct padding.

--
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe fio" in the body =
of a message to majordomo@vger.kernel.org More majordomo info at  http://vg=
er.kernel.org/majordomo-info.html
