Return-Path: <bruce@cran.org.uk>
MIME-Version: 1.0
From: Bruce Cran <bruce@cran.org.uk>
Date: Fri, 14 Jan 2011 04:38:09 -0700
Subject: Re: Recent changes
Message-ID: <20110114113809.00005e5f@unknown>
References: <20110114050004.0ECBF37A2F4@kernel.dk>
In-Reply-To: <20110114050004.0ECBF37A2F4@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Fri, 14 Jan 2011 06:00:03 +0100 (CET)
Jens Axboe <jaxboe@fusionio.com> wrote:

> +	strcpy(fname, basename(ptr));

libgen.h needs to be included to pick up basename(3).

--=20
Bruce Cran

