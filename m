Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([64.244.102.30]:52500 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab1CUTOj (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 21 Mar 2011 15:14:39 -0400
Message-ID: <4D87A399.4000909@fusionio.com>
Date: Mon, 21 Mar 2011 20:14:33 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix linking of fio executable.
References: <1300721780-17201-1-git-send-email-flameeyes@gmail.com>
In-Reply-To: <1300721780-17201-1-git-send-email-flameeyes@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?ISO-8859-1?Q?Diego_Elio_Petten=F2?= <flameeyes@gmail.com>
Cc: fio@vger.kernel.org, "Robin H. Johnson" <robbat2@gentoo.org>

On 2011-03-21 16:36, Diego Elio Petten=EF=BF=BD wrote:
> First of all make sure that $(LDFLAGS) are used during linking so that the
> user can set the linker's flags.
>=20
> Then also make sure that libraries are listed after the objects, so that
> GNU ld's --as-needed option will not cause fio linking to fail.

Thanks, applied.

--=20
Jens Axboe

