Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49923 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043Ab0EQRmh (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 17 May 2010 13:42:37 -0400
Date: Mon, 17 May 2010 19:42:34 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: replay blktrace to different device
Message-ID: <20100517174233.GQ25951@kernel.dk>
References: <AANLkTikDsv9H0S_fE9JkAJOn6dxIW_wnMmiIq13hidL7@mail.gmail.com> <AANLkTilwHeA9olwqW5PFcvotNxuCqfoN5_iyUe6PokFh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <AANLkTilwHeA9olwqW5PFcvotNxuCqfoN5_iyUe6PokFh@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sebastian =?iso-8859-1?Q?F=E4rber?= <faerber@gmail.com>
Cc: fio@vger.kernel.org

On Sun, May 16 2010, Sebastian F=EF=BF=BDrber wrote:
> > I'm running fio like this:
> > # fio --name=3Dreplay --filename=3D/dev/sdc --read_iolog=3Dtrace_input_=
fio
> > and it aborts with
> > fio: filesetup.c:855: get_file: Assertion `fio_file_open(f)' failed.
>=20
> I captured another trace, this time for /dev/sdc, tried again using it
> as input to read_iolog
> and got the same error message.
> So it looks like there is a general problem with "read_iolog" in fio 1.38?
> I can supply the "--debug=3Dall" logfile if needed.

I'll take a look.

--=20
Jens Axboe

