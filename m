Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:52267 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbZDTGpP (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 20 Apr 2009 02:45:15 -0400
Date: Mon, 20 Apr 2009 08:45:14 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: question about fork_main()
Message-ID: <20090420064514.GR4593@kernel.dk>
References: <m2eiw1fys9.fsf@gmail.com> <ed038eb20904191816u4994898fyeaaad97a9d6147ad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <ed038eb20904191816u4994898fyeaaad97a9d6147ad@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Carl Henrik Lunde <chlunde@ping.uio.no>
Cc: Francis Moreau <francis.moro@gmail.com>, fio@vger.kernel.org

On Mon, Apr 20 2009, Carl Henrik Lunde wrote:
> On Thu, Apr 9, 2009 at 20:49, Francis Moreau <francis.moro@gmail.com> wro=
te:
> > hello,
> >
> > I just took a look to fio source code (great tool BTW), and I'm
> > wondering about the fork_main() comment:
> >
> > /*
> > =EF=BF=BD* We cannot pass the td data into a forked process, so attach =
the td
> > =EF=BF=BD* and pass it to the thread worker.
> > =EF=BF=BD*/
> >
> > Since after a fork(2) the child inherits the attached shared memory
> > segments from its parent, I don't see the point of this comment.
> >
> > Could anybody enlight me ?
>=20
> I think your observation is correct, this is not necessary, shmat in
> the child can be avoided.

Yes, I'm not quite sure why it does that anymore, it's been that way
since 2004/5 when fio got moved to its own repo...

--=20
Jens Axboe

