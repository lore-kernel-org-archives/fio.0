Return-Path: <Martin@lichtvoll.de>
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Measuring IOPS (solved, I think)
Date: Wed, 3 Aug 2011 11:03:05 +0200
References: <201107291737.40463.Martin@lichtvoll.de> <201108022328.52415.Martin@lichtvoll.de> <4E38F5F1.6010502@kernel.dk> (sfid-20110803_105124_014639_B1B8D621)
In-Reply-To: <4E38F5F1.6010502@kernel.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <201108031103.05502.Martin@lichtvoll.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Am Mittwoch, 3. August 2011 schrieben Sie:
> On 2011-08-02 23:28, Martin Steigerwald wrote:
> > Am Dienstag, 2. August 2011 schrieben Sie:
> >> That's a long email! The stonewall should be put in the job section
> >> that has to wait for previous jobs. So, ala:
> >>=20
> >> [job1]
> >> something
> >>=20
> >> [job2]
> >> stonewall       # will wait for job1 to finish
> >> something
> >>=20
> >> [job3]
> >> something       # will run in parallel with job2
> >>=20
> >> [job4]
> >> stonewall       # will run when job2+3 are finished
> >> something
> >>=20
> >> If that's not the case, something is broken. A quick test here seems
> >> to show that it works.
> >=20
> > Its documented. From the manpage that I read several times by now:
> >=20
> > Wait for preceding jobs in the job file to exit before starting this
> > one. stonewall implies new_group.
> >=20
> >=20
> > Somehow despite my reading of manpage, README, HOWTO I came to the
> > thought that it tells fio to wait for the current job to finish,
> > thus I had the stonewall options misordered.
> >=20
> > I expect that it works exactly as you said and try it this way.
> > Instead of omitting the last stonewall option in my iops job file I
> > could omit the first for the first job. Cause the first job does not
> > need to wait for a previous job.
>=20
> Good, that makes me feel a little better :-)

What did you feel bad about? I didn=C2=B4t intend to trigger bad feelings.

There was nothing wrong with fio. Behavior was documented.

> Perhaps the name isn't that great? I'll gladly put in an alias for that
> option, "wait_for_previous" or "barrier" or something like that. Fence?

wait_before? But then "wait_for_previous" might be the clearest=20
description. "wait_before" would make sense with an "wait_after" that=20
waits after the job for its completion. But two options for basically the=20
same thing might complicate matters even more.

So "wait_for_previous" or maybe "finish_previous_first" or just=20
"finish_previous" would be fine with me.

But then this doesn=C2=B4t imply that fio does a cache flush. But that coul=
d be=20
documented in the manpage with an additional hint on this option. I will=20
think about it and possibly provide a patch.

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

