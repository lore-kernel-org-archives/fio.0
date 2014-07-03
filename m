Return-Path: <axboe@kernel.dk>
Message-ID: <53B58957.3090609@kernel.dk>
Date: Thu, 03 Jul 2014 10:48:23 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Bail out if glfs_creat failed
References: <1404404549-864-1-git-send-email-tiziano.mueller@stepping-stone.ch>
In-Reply-To: <1404404549-864-1-git-send-email-tiziano.mueller@stepping-stone.ch>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: =?ISO-8859-1?Q?Tiziano_M=FCller?= <tiziano.mueller@stepping-stone.ch>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 07/03/2014 10:22 AM, Tiziano M=EF=BF=BDller wrote:
> Otherwise we will get segfaults from gfapi when it tries to access the
> invalid fd.

Applied, thanks.

--=20
Jens Axboe


