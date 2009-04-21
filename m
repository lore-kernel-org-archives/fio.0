Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:48983 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757196AbZDUTBO (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 21 Apr 2009 15:01:14 -0400
Date: Tue, 21 Apr 2009 21:01:13 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: question about fork_main()
Message-ID: <20090421190113.GN4593@kernel.dk>
References: <m2eiw1fys9.fsf@gmail.com> <ed038eb20904191816u4994898fyeaaad97a9d6147ad@mail.gmail.com> <38b2ab8a0904211137v3369b1cdxf80ee66658284719@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <38b2ab8a0904211137v3369b1cdxf80ee66658284719@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: Carl Henrik Lunde <chlunde@ping.uio.no>, fio@vger.kernel.org

On Tue, Apr 21 2009, Francis Moreau wrote:
> On Mon, Apr 20, 2009 at 3:16 AM, Carl Henrik Lunde <chlunde@ping.uio.no> =
wrote:
> > On Thu, Apr 9, 2009 at 20:49, Francis Moreau <francis.moro@gmail.com> w=
rote:
> >> hello,
> >>
> >> I just took a look to fio source code (great tool BTW), and I'm
> >> wondering about the fork_main() comment:
> >>
> >> /*
> >> =EF=BF=BD* We cannot pass the td data into a forked process, so attach=
 the td
> >> =EF=BF=BD* and pass it to the thread worker.
> >> =EF=BF=BD*/
> >>
> >> Since after a fork(2) the child inherits the attached shared memory
> >> segments from its parent, I don't see the point of this comment.
> >>
> >> Could anybody enlight me ?
> >
> > I think your observation is correct, this is not necessary, shmat in
> > the child can be avoided.
> >
>=20
> Should I send a patch ?

Sure, provided you do testing of it as well ;-)

--=20
Jens Axboe

