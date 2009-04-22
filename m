Return-Path: <girish.satihal@yahoo.com>
Message-ID: <622307.79920.qm@web63807.mail.re1.yahoo.com>
Date: Wed, 22 Apr 2009 09:46:00 -0700 (PDT)
From: Girish Satihal <girish.satihal@yahoo.com>
Reply-To: girish.satihal@yahoo.com
Subject: Re: Recent changes
In-Reply-To: <20090422054614.GT4593@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/alternative; boundary="0-628678096-1240418760=:79920"
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>


--0-628678096-1240418760=:79920
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Jens,
Running the fio on the partition mounted with filesystem was the intention =
to=A0compare the functinality of fio with other performance benchmarking to=
ol called IOmeter which is used for Windows. We use two different performan=
ce test tools, one is IOmeter for Windows and fio for Linux.=20
=A0
Also, recently we got a customer issue who had very bad performance numbers=
 for the test they conducted on ext2 filesystem and wanted us to try the sa=
me. They dont use fio. They have thier=A0own proprietery tool for performan=
ce measure. So it was just an investigation for us to run fio=A0on partitio=
n with filesystem instead of keep it raw.=A0Since we did not find any probl=
em with=A0Random Writes but only problem with Seqential Writes thought of r=
eporting to you and get the solution.
=A0
I am not bothered about the contents of the device. I was just wanted to co=
mpare the performance numbers between the Raw partition and the filesystem =
partition.
=A0
If you want I can look into the erroe messages=A0logged in=A0dmesg.
=A0
=A0
Thanks,
=A0Girish=A0

--- On Wed, 4/22/09, Jens Axboe <jens.axboe@oracle.com> wrote:

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Recent changes
To: "Girish Satihal" <girish.satihal@yahoo.com>
Cc: fio@vger.kernel.org
Date: Wednesday, April 22, 2009, 11:16 AM

On Tue, Apr 21 2009, Girish Satihal wrote:
> Hi Jens,
> The reason for saying ext3, is I run fdisk on /dev/cciss/c1d0 and created
a primary partition.
> =A0
> Then I created a ext3 filesystem on this partition by running mkefs and
mounted this partition on /mnt folder. Then I run fio on this partition.

You run fio on the partition, or on the mount point? Your fio job file
indicates that you run fio on the full device, not even just the
partition. This has _nothing_ to do with ext3. Irregardless of whether
you run fio on the partition or the device, your file system will be
hosed. Perhaps things go bad because ext3 turns your device read-only on
errors. Did you get any errors logged in dmesg?

> We earlier use to run fio on raw partition. But now we tried running fio
on a partition which has ext3 filesystem.

Why would the content of the device matter?

> When I run fio on raw filesystem I dont get any errors for Sequential
Writes, but when I run fio test on this ext3 filesystem then I am getting t=
he
errors for Sequential Writes=A0what I mentioned u earlier.

Lets back up a bit... What are you trying to test? Running fio on a
device/partition that is mounted with a file system is just a crazy
thing to do. Why would you do that?


> =A0
> Thanks,
> =A0Girish=A0
>=20
> --- On Wed, 4/22/09, Jens Axboe <jens.axboe@oracle.com> wrote:
>=20
> From: Jens Axboe <jens.axboe@oracle.com>
> Subject: Re: Recent changes
> To: "Girish Satihal" <girish.satihal@yahoo.com>
> Cc: fio@vger.kernel.org
> Date: Wednesday, April 22, 2009, 12:45 AM
>=20
> On Tue, Apr 21 2009, Girish Satihal wrote:
> > Hi Jens,
> > I guess I did not understand your question for which I am very sorry.
>=20
> Don't apologize for that. But if there's something I write you
> don't
> understand, do just ask for an explanation.
>=20
> > As per my understanding I have sent you the job file which was
> > input file to fio for the performance testing.  As only the problem
> > with Seqential Writes, I have cut down the job file to only Write
> > parameters where the issue is being seen. The problem is seen with
all
> > block size and IO depths of Sequential Writes.  Please let me know
> > if this would help you or still you arelooking for anything else.
>=20
> So my current question is why you are mentioning ext3? The test case you
> provided is reading and writing directly to the CCISS device, not a file
> inside a file system hosted on that device.
>=20
> Also, please try a make clean && make && make install in
your
> fio
> directory. Sometimes things get hosed when updates are pulled, which may
> explain why yours is acting up.
>=20
> --=20
> Jens Axboe
>=20
>=20
>=20
>=20
>      =20
--=20
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
=0A=0A=0A      
--0-628678096-1240418760=:79920
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

<table cellspacing=3D"0" cellpadding=3D"0" border=3D"0" ><tr><td valign=3D"=
top" style=3D"font: inherit;"><DIV>Hi Jens,</DIV>
<DIV>Running the fio on the partition mounted with filesystem was the inten=
tion to&nbsp;compare the functinality of fio with other performance benchma=
rking tool called IOmeter which is used for Windows. We use two different p=
erformance test tools, one is IOmeter for Windows and fio for Linux. </DIV>
<DIV>&nbsp;</DIV>
<DIV>Also, recently we got a customer issue who had very bad performance nu=
mbers for the test they conducted on ext2 filesystem and wanted us to try t=
he same. They dont use fio. They have thier&nbsp;own proprietery tool for p=
erformance measure. So it was just an investigation for us to run fio&nbsp;=
on partition with filesystem instead of keep it raw.&nbsp;Since we did not =
find any problem with&nbsp;Random Writes but only problem with Seqential Wr=
ites thought of reporting to you and get the solution.</DIV>
<DIV>&nbsp;</DIV>
<DIV>I am not bothered about the contents of the device. I was just wanted =
to compare the performance numbers between the Raw partition and the filesy=
stem partition.</DIV>
<DIV>&nbsp;</DIV>
<DIV>If you want I can look into the erroe messages&nbsp;logged in&nbsp;dme=
sg.</DIV>
<DIV>&nbsp;</DIV>
<DIV>&nbsp;</DIV>
<DIV>Thanks,</DIV>
<DIV>&nbsp;Girish&nbsp;<BR><BR>--- On <B>Wed, 4/22/09, Jens Axboe <I>&lt;je=
ns.axboe@oracle.com&gt;</I></B> wrote:<BR></DIV>
<BLOCKQUOTE style=3D"PADDING-LEFT: 5px; MARGIN-LEFT: 5px; BORDER-LEFT: rgb(=
16,16,255) 2px solid">From: Jens Axboe &lt;jens.axboe@oracle.com&gt;<BR>Sub=
ject: Re: Recent changes<BR>To: "Girish Satihal" &lt;girish.satihal@yahoo.c=
om&gt;<BR>Cc: fio@vger.kernel.org<BR>Date: Wednesday, April 22, 2009, 11:16=
 AM<BR><BR><PRE>On Tue, Apr 21 2009, Girish Satihal wrote:
&gt; Hi Jens,
&gt; The reason for saying ext3, is I run fdisk on /dev/cciss/c1d0 and crea=
ted
a primary partition.
&gt; &nbsp;
&gt; Then I created a ext3 filesystem on this partition by running mkefs an=
d
mounted this partition on /mnt folder. Then I run fio on this partition.

You run fio on the partition, or on the mount point? Your fio job file
indicates that you run fio on the full device, not even just the
partition. This has _nothing_ to do with ext3. Irregardless of whether
you run fio on the partition or the device, your file system will be
hosed. Perhaps things go bad because ext3 turns your device read-only on
errors. Did you get any errors logged in dmesg?

&gt; We earlier use to run fio on raw partition. But now we tried running f=
io
on a partition which has ext3 filesystem.

Why would the content of the device matter?

&gt; When I run fio on raw filesystem I dont get any errors for Sequential
Writes, but when I run fio test on this ext3 filesystem then I am getting t=
he
errors for Sequential Writes&nbsp;what I mentioned u earlier.

Lets back up a bit... What are you trying to test? Running fio on a
device/partition that is mounted with a file system is just a crazy
thing to do. Why would you do that?


&gt; &nbsp;
&gt; Thanks,
&gt; &nbsp;Girish&nbsp;
&gt;=20
&gt; --- On Wed, 4/22/09, Jens Axboe &lt;jens.axboe@oracle.com&gt; wrote:
&gt;=20
&gt; From: Jens Axboe &lt;jens.axboe@oracle.com&gt;
&gt; Subject: Re: Recent changes
&gt; To: "Girish Satihal" &lt;girish.satihal@yahoo.com&gt;
&gt; Cc: fio@vger.kernel.org
&gt; Date: Wednesday, April 22, 2009, 12:45 AM
&gt;=20
&gt; On Tue, Apr 21 2009, Girish Satihal wrote:
&gt; &gt; Hi Jens,
&gt; &gt; I guess I did not understand your question for which I am very so=
rry.
&gt;=20
&gt; Don't apologize for that. But if there's something I write you
&gt; don't
&gt; understand, do just ask for an explanation.
&gt;=20
&gt; &gt; As per my understanding I have sent you the job file which was
&gt; &gt; input file to fio for the performance testing.  As only the probl=
em
&gt; &gt; with Seqential Writes, I have cut down the job file to only Write
&gt; &gt; parameters where the issue is being seen. The problem is seen wit=
h
all
&gt; &gt; block size and IO depths of Sequential Writes.  Please let me kno=
w
&gt; &gt; if this would help you or still you arelooking for anything else.
&gt;=20
&gt; So my current question is why you are mentioning ext3? The test case y=
ou
&gt; provided is reading and writing directly to the CCISS device, not a fi=
le
&gt; inside a file system hosted on that device.
&gt;=20
&gt; Also, please try a make clean &amp;&amp; make &amp;&amp; make install =
in
your
&gt; fio
&gt; directory. Sometimes things get hosed when updates are pulled, which m=
ay
&gt; explain why yours is acting up.
&gt;=20
&gt; --=20
&gt; Jens Axboe
&gt;=20
&gt;=20
&gt;=20
&gt;=20
&gt;      =20
--=20
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
</PRE></BLOCKQUOTE></td></tr></table><br>=0A=0A      
--0-628678096-1240418760=:79920--


