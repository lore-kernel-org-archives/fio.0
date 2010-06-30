Return-Path: <vgoyal@redhat.com>
MIME-Version: 1.0
From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 30 Jun 2010 06:59:40 -0600
Subject: Re: Have we changed number of fields in fio --minimal output
Message-ID: <20100630125940.GA6229@redhat.com>
References: <20100629193247.GA3819@redhat.com>
 <4C2AF2EC.1090806@fusionio.com> <4C2AF382.7000708@fusionio.com>
 <4C2AF5DF.8050705@fusionio.com>
In-Reply-To: <4C2AF5DF.8050705@fusionio.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Wed, Jun 30, 2010 at 09:44:31AM +0200, Jens Axboe wrote:
> On 2010-06-30 09:34, Jens Axboe wrote:
> > On 2010-06-30 09:31, Jens Axboe wrote:
> >> On 2010-06-29 21:32, Vivek Goyal wrote:
> >>> Hi,
> >>>=20
> >>> I was running latest fio and noticed that number of fields in fio
> >>> --minimal output have gone up from 69 to 77. A increase of 8=20
> >>> fields. Don't see any update in --minimal documentation. Is it=20
> >>> regarding total latency thing?
> >>=20
> >> Woops yes, there's a total latency in there as well now. Should=20
> >> just be 4 extra fields, though. It gets logged after completion=20
> >> latency, but before bandwidth stats. I'll update the=20
> >> documentation.
> >>=20
> >> Should we perhaps put a versioning field in there? Now would seem=20
> >> to be a good time, since the output has changed anyway. I'm open to
> >> suggestions from you or other terse output users.
> >=20
> > How about redesigning it a bit to make it more bullet proof... We=20
> > could prefix series of fields with the value they are logging. So
> > for instance, the 4 completion latency fields would include a clat
> > prefix first:
> >=20
> > clat[%lu;%lu;%f;%f],foo[%lu;%lu],etc
> >=20
> > Would that not be more resilient to future changes? New fields would=20
> > not bother you, and reordering should also be fine.
> >=20
> > Any other ideas?
>=20
> With that change, the output would be modified from:
>=20
> file;0;0;131072;356015;377;0;0;0.000000;0.000000;0;0;0.000000;0.000000;0;=
0;0.000000;0.000000;0;0;0.000000%;0.000000;0.000000;131072;303660;442;0;0;0=
.000000;0.000000;0;0;0.000000;0.000000;0;0;0.000000;0.000000;0;0;0.000000%;=
0.000000;0.000000;99.265606%;0.367197%;95;0;343;100.0%;0.0%;0.0%;0.0%;0.0%;=
0.0%;0.0%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%=
;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%
>=20
> to
>=20
> id[file;0;0];overview[131072;357913;375];slat[0;0;0.000000;0.000000];clat=
[0;0;0.000000;0.000000];lat[0;0;0.000000;0.000000];bw[0;0;0.000000%;0.00000=
0;0.000000];overview[131072;304348;441];slat[0;0;0.000000;0.000000];clat[0;=
0;0.000000;0.000000];lat[0;0;0.000000;0.000000];bw[0;0;0.000000%;0.000000;0=
.000000];sys[99.754601%;0.000000%;116;0;342];iodepth[100.0%;0.0%;0.0%;0.0%;=
0.0%;0.0%;0.0%];iolat[0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%=
;0.00%0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.0=
0%];
>=20
> The upside is that it should be easier to parse, and it's even humanly
> readable to a much greater extent than the current format. But let me
> know what you think.

Hi Jens,

I have a very simple awk script which looks for bw and max clat fields. I=20
can definitely enhance it to parse this new format.

Above will be broken if you decide the change the name of existing field or
try to introduce more stats in the existing field. Say some thing additiona=
l
in "overview" field.

Personally I would prefer to version the fio and change the version=20
whenever something significant like this happen. Then I can change my
parsing method based on version.

I think irrespective of the format of the string, versioning fio is
probably a good idea.

May be we can also provide this new format of output with a new fio
option say, "fio --terse".

At the end of the day, I will just adjust my scripts based on whatever
format you decide to keep. :-)

Thanks
Vivek

