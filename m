Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp192.dfw.emailsrvr.com ([67.192.241.192]:34381 "EHLO
	smtp192.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab2HPRGi (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 16 Aug 2012 13:06:38 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtp9.relay.dfw1a.emailsrvr.com (SMTP Server) with ESMTP id EC0C83C014E
	for <fio@vger.kernel.org>; Thu, 16 Aug 2012 12:56:51 -0400 (EDT)
Received: by smtp9.relay.dfw1a.emailsrvr.com (Authenticated sender: public-AT-joshcarter.com) with ESMTPSA id EFE0A3C0238
	for <fio@vger.kernel.org>; Thu, 16 Aug 2012 12:56:50 -0400 (EDT)
From: Josh Carter <public@joshcarter.com>
Content-Type: multipart/mixed; boundary="Apple-Mail=_451CBA19-79FD-4D38-9E4B-FB4F5615CF5A"
Message-Id: <22FC97D7-F97F-480D-8132-5DB13B2DFC59@joshcarter.com>
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1485\))
Subject: Re: Suggestion: Add ramp-up for rate testing.
Date: Thu, 16 Aug 2012 10:56:50 -0600
References: <CAHaS=QzhdnM-TpzWb9eC3woLXZPM9t-LmcUzsf24rzUfUzPn-Q@mail.gmail.com>
In-Reply-To: <CAHaS=QzhdnM-TpzWb9eC3woLXZPM9t-LmcUzsf24rzUfUzPn-Q@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org


--Apple-Mail=_451CBA19-79FD-4D38-9E4B-FB4F5615CF5A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Greg (and all),

I actually did some work on this, however I didn't have it ready to push =
upstream. I used the existing "ratemin" and "rate" configuration options =
to represent the starting rate and the final (target) rate, then I added =
a "ratestep" option which added to the current rate every 5 =
"ratecycles".

Problem was, when I changed the rate, there was a brief spike in =
bandwidth for that bw measurement interval. I didn't determine if the =
problem was actually in the rate limiting (most likely), or in the =
bandwidth measurement (less likely but possible). In any case, I didn't =
want to offer the patch until that was solved.

I'm not able to work on this right now, so I'll pass along the patch =
as-is. Maybe someone else can take it and run with it.

Best regards,
Josh


--Apple-Mail=_451CBA19-79FD-4D38-9E4B-FB4F5615CF5A
Content-Disposition: attachment;
	filename=0001-Initial-swag-at-bandwidth-rate-stepping.patch
Content-Type: application/octet-stream;
	name="0001-Initial-swag-at-bandwidth-rate-stepping.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=200a759076c3e7bfdc9610ddd03c20cb3b42f320da=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Josh=20Carter=20<public@joshcarter.com>=0A=
Date:=20Wed,=2016=20Nov=202011=2015:57:36=20-0700=0ASubject:=20[PATCH=20=
1/2]=20Initial=20swag=20at=20bandwidth=20rate=20stepping.=0A=0A-=20=
Adding=20"ratestep=3D"=20option=20to=20config=20files;=20when=20used=20=
with=20"rate=3D"=0A=20=20option,=20it=20will=20step=20the=20rate=20up=20=
by=20ratestep=20every=20(ratecycle=20*=205)=0A=20=20milliseconds.=20=
(Yea,=20should=20make=20the=20step=20interval=20configurable=0A=20=20=
separately.)=0A=0A-=20Added=20step_rate()=20near=20the=20end=20of=20=
do_io(),=20just=20after=20we=20do=20the=0A=20=20check_min_rate()=20part.=0A=
=0ACurrently=20very=20fiddly;=20seems=20to=20get=20blips=20in=20=
bandwidth=20just=20after=20a=0Arate=20step,=20also=20at=20high=20=
rates/steps=20it=20messes=20up=20bandwidth=20logging.=0ANeed=20feedback=20=
from=20mailing=20list.=0A---=0A=20fio.c=20=20=20=20=20|=20=20=2040=20=
++++++++++++++++++++++++++++++++++++++++=0A=20fio.h=20=20=20=20=20|=20=20=
=20=204=20+++-=0A=20init.c=20=20=20=20|=20=20=20=204=20++++=0A=20=
options.c=20|=20=20=20=208=20++++++++=0A=204=20files=20changed,=2055=20=
insertions(+),=201=20deletions(-)=0A=0Adiff=20--git=20a/fio.c=20b/fio.c=0A=
index=205b58ab8..9063c03=20100644=0A---=20a/fio.c=0A+++=20b/fio.c=0A@@=20=
-341,6=20+341,39=20@@=20static=20int=20check_min_rate(struct=20=
thread_data=20*td,=20struct=20timeval=20*now,=0A=20=09return=20ret;=0A=20=
}=0A=20=0A+static=20int=20__step_rate(struct=20thread_data=20*td,=20=
struct=20timeval=20*now,=0A+=09=09=20=20=20=20=20=20=20enum=20fio_ddir=20=
ddir)=0A+{=0A+=20=20=20=20=20=20=20=20unsigned=20long=20spent;=0A+=20=20=20=
=20=20=20=20=20unsigned=20long=20long=20new_rate;=0A+=09=0A+=09=
assert(ddir_rw(ddir));=0A+=0A+=09if=20(!td->o.ratestep[ddir])=0A+=09=09=
return=200;=0A+=0A+=09spent=20=3D=20mtime_since(&td->lastratestep[ddir],=20=
now);=0A+=0A+=09if=20(spent=20<=20td->o.ratecycle=20*=205)=0A+=09=20=20=20=
=20=20=20=20=20return=200;=0A+=09=09=0A+=20=20=20=20=20=20=20=20new_rate=20=
=3D=20td->rate_bps[ddir]=20+=20td->o.ratestep[ddir];=0A+=20=20=20=20=20=20=
=20=20td->o.rate[ddir]=20=3D=20td->rate_bps[ddir]=20=3D=20new_rate;=0A+=0A=
+=09memcpy(&td->lastratestep[ddir],=20now,=20sizeof(*now));=0A+=09return=20=
0;=0A+}=0A+=0A+static=20int=20step_rate(struct=20thread_data=20*td,=20=
struct=20timeval=20*now)=0A+{=0A+=09int=20ret=20=3D=200;=0A+=0A+=09ret=20=
|=3D=20__step_rate(td,=20now,=20DDIR_READ);=0A+=09ret=20|=3D=20=
__step_rate(td,=20now,=20DDIR_WRITE);=0A+=0A+=09return=20ret;=0A+}=0A+=0A=
=20static=20inline=20int=20runtime_exceeded(struct=20thread_data=20*td,=20=
struct=20timeval=20*t)=0A=20{=0A=20=09if=20(!td->o.timeout)=0A@@=20=
-813,6=20+846,8=20@@=20sync_done:=0A=20=09=09=09=09td_verror(td,=20EIO,=20=
"check_min_rate");=0A=20=09=09=09=09break;=0A=20=09=09=09}=0A+=09=09=09=0A=
+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
step_rate(td,=20&comp_time);=0A=20=09=09}=0A=20=0A=20=09=09if=20=
(td->o.thinktime)=20{=0A@@=20-1237,6=20+1272,11=20@@=20static=20void=20=
*thread_main(void=20*data)=0A=20=09fio_gettime(&td->epoch,=20NULL);=0A=20=
=09getrusage(RUSAGE_SELF,=20&td->ru_start);=0A=20=0A+=09if=20=
(td->o.ratestep[0]=20||=20td->o.ratestep[1])=20{=0A+=09=09=
memcpy(&td->lastratestep[0],=20&td->epoch,=20sizeof(td->epoch));=0A+=09=09=
memcpy(&td->lastratestep[1],=20&td->epoch,=20sizeof(td->epoch));=0A+=09}=0A=
+=0A=20=09clear_state=20=3D=200;=0A=20=09while=20(keep_running(td))=20{=0A=
=20=09=09fio_gettime(&td->start,=20NULL);=0Adiff=20--git=20a/fio.h=20=
b/fio.h=0Aindex=20cc1f65f..36b15aa=20100644=0A---=20a/fio.h=0A+++=20=
b/fio.h=0A@@=20-212,6=20+212,7=20@@=20struct=20thread_options=20{=0A=20=0A=
=20=09unsigned=20int=20rate[2];=0A=20=09unsigned=20int=20ratemin[2];=0A+=09=
unsigned=20int=20ratestep[2];=0A=20=09unsigned=20int=20ratecycle;=0A=20=09=
unsigned=20int=20rate_iops[2];=0A=20=09unsigned=20int=20=
rate_iops_min[2];=0A@@=20-361,6=20+362,7=20@@=20struct=20thread_data=20{=0A=
=20=09unsigned=20long=20rate_bytes[2];=0A=20=09unsigned=20long=20=
rate_blocks[2];=0A=20=09struct=20timeval=20lastrate[2];=0A+=20=20=20=20=
struct=20timeval=20lastratestep[2];=0A=20=0A=20=09unsigned=20long=20long=20=
total_io_size;=0A=20=09unsigned=20long=20long=20fill_device_size;=0A@@=20=
-659,7=20+661,7=20@@=20static=20inline=20int=20=
__should_check_rate(struct=20thread_data=20*td,=0A=20=09=20*=20If=20some=20=
rate=20setting=20was=20given,=20we=20need=20to=20check=20it=0A=20=09=20=
*/=0A=20=09if=20(o->rate[ddir]=20||=20o->ratemin[ddir]=20||=20=
o->rate_iops[ddir]=20||=0A-=09=20=20=20=20o->rate_iops_min[ddir])=0A+=09=20=
=20=20=20o->rate_iops_min[ddir]=20||=20o->ratestep[ddir])=0A=20=09=09=
return=201;=0A=20=0A=20=09return=200;=0Adiff=20--git=20a/init.c=20=
b/init.c=0Aindex=20482ce09..717dfc5=20100644=0A---=20a/init.c=0A+++=20=
b/init.c=0A@@=20-498,6=20+498,10=20@@=20static=20int=20=
fixup_options(struct=20thread_data=20*td)=0A=20=09=09log_err("fio:=20=
minimum=20rate=20exceeds=20rate\n");=0A=20=09=09ret=20=3D=201;=0A=20=09}=0A=
+=09if=20((o->ratestep[0]=20&&=20!o->rate[0])=20||=20(o->ratestep[1]=20=
&&=20!o->rate[1]))=20{=0A+=09=09log_err("fio:=20ratestep=20requires=20=
initial=20rate=20also=20set\n");=0A+=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20ret=20=3D=201;=0A+=09}=0A=20=0A=20=09if=20(!o->timeout=20&&=20=
o->time_based)=20{=0A=20=09=09log_err("fio:=20time_based=20requires=20a=20=
runtime/timeout=20setting\n");=0Adiff=20--git=20a/options.c=20=
b/options.c=0Aindex=2053c3a82..a276bcb=20100644=0A---=20a/options.c=0A=
+++=20b/options.c=0A@@=20-1772,6=20+1772,14=20@@=20static=20struct=20=
fio_option=20options[FIO_MAX_OPTS]=20=3D=20{=0A=20=09=09.help=09=3D=20=
"Job=20must=20meet=20this=20rate=20or=20it=20will=20be=20shutdown",=0A=20=
=09=09.parent=09=3D=20"rate",=0A=20=09},=0A+=20=20=20=20=20=20=20=20{=0A=
+=20=20=20=20=20=20=20=20=09.name=09=3D=20"ratestep",=0A+=20=20=20=20=20=20=
=20=20=09.type=09=3D=20FIO_OPT_INT,=0A+=20=20=20=20=20=20=20=20=09.off1=09=
=3D=20td_var_offset(ratestep[0]),=0A+=20=20=20=20=20=20=20=20=09.off2=09=
=3D=20td_var_offset(ratestep[1]),=0A+=20=20=20=20=20=20=20=20=09.help=09=
=3D=20"Job=20will=20increment=20bandwidth=20rate=20by=20this=20amount=20=
each=20ratecycle",=0A+=20=20=20=20=20=20=20=20=09.parent=09=3D=20"rate",=0A=
+=20=20=20=20=20=20=20=20},=0A=20=09{=0A=20=09=09.name=09=3D=20=
"rate_iops",=0A=20=09=09.type=09=3D=20FIO_OPT_INT,=0A--=20=0A1.7.4.4=0A=0A=

--Apple-Mail=_451CBA19-79FD-4D38-9E4B-FB4F5615CF5A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


On Aug 16, 2012, at 9:24 AM, Greg Sullivan <greg.sullivan@sullivang.net> =
wrote:

> I suggest adding a ramp-up time parameter that can be used to prevent
> the rate testing from occurring until the ramp-up time has passed.
> This will more accurately model the throughput capacity of streaming
> systems that have a pre-load buffer to ride over the initial cache
> warm-up period.
>=20
> Greg.
> p.s The rate stuff is working on Windows now - thanks Bruce.
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Apple-Mail=_451CBA19-79FD-4D38-9E4B-FB4F5615CF5A--
--:
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html


