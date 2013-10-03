Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.uni-ulm.de ([134.60.1.11]:60837 "EHLO mail.uni-ulm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754917Ab3JCVJJ (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 3 Oct 2013 17:09:09 -0400
Received: from highx.de (p5B2F800F.dip0.t-ipconnect.de [91.47.128.15])
	(authenticated bits=0)
	by mail.uni-ulm.de (8.14.6/8.14.2) with ESMTP id r93KiREO002086
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Thu, 3 Oct 2013 22:44:31 +0200 (MEST)
Date: Thu, 3 Oct 2013 22:42:06 +0200
From: Juergen Salk <juergen.salk@gmx.de>
Subject: Re: precondition ssd drives w/ fio
Message-ID: <20131003204206.GA28048@highx.de>
References: <CAAAK+WW66DdYt2JEG+2K42vWzczn38xtnh5WK-1x97zFbdkyqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAAAK+WW66DdYt2JEG+2K42vWzczn38xtnh5WK-1x97zFbdkyqg@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Brian L." <brianclam@gmail.com>

* Brian L. <brianclam@gmail.com> [131003 12:31]:

> For benchmarking SSD drives, I was told that we should precondition
> our drives to get more accurate real world reading.
>=20
> I was wondering if anyone is using fio itself to precondition ssd
> drives or use a different script to populate random data on the
> drives?

Yes I did. The fio source tarball comes with a number of sample
job files including `ssd-steadystate.fio=EF=BF=BD, which might be
useful for preconditioning of ssd devices.=20

Regards,

Juergen

--=20
GPG A997BA7A | 87FC DA31 5F00 C885 0DC3  E28F BD0D 4B33 A997 BA7A
