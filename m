Return-Path: <girish.satihal@yahoo.com>
Message-ID: <669351.35730.qm@web63805.mail.re1.yahoo.com>
Date: Tue, 21 Apr 2009 15:17:12 -0700 (PDT)
From: Girish Satihal <girish.satihal@yahoo.com>
Reply-To: girish.satihal@yahoo.com
Subject: Re: Recent changes
In-Reply-To: <20090421191545.GO4593@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/alternative; boundary="0-1765801769-1240352232=:35730"
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>


--0-1765801769-1240352232=:35730
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Jens,
The reason for saying ext3, is I run fdisk on /dev/cciss/c1d0 and created a=
 primary partition.
=A0
Then I created a ext3 filesystem on this partition by running mkefs and mou=
nted this partition on /mnt folder. Then I run fio on this partition.
=A0
We earlier use to run fio on raw partition. But now we tried running fio on=
 a partition which has ext3 filesystem.
=A0
When I run fio on raw filesystem I dont get any errors for Sequential Write=
s, but when I run fio test on this ext3 filesystem then I am getting the er=
rors for Sequential Writes=A0what I mentioned u earlier.
=A0
Thanks,
=A0Girish=A0

--- On Wed, 4/22/09, Jens Axboe <jens.axboe@oracle.com> wrote:

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Recent changes
To: "Girish Satihal" <girish.satihal@yahoo.com>
Cc: fio@vger.kernel.org
Date: Wednesday, April 22, 2009, 12:45 AM

On Tue, Apr 21 2009, Girish Satihal wrote:
> Hi Jens,
> I guess I did not understand your question for which I am very sorry.

Don't apologize for that. But if there's something I write you
don't
understand, do just ask for an explanation.

> As per my understanding I have sent you the job file which was
> input file to fio for the performance testing.  As only the problem
> with Seqential Writes, I have cut down the job file to only Write
> parameters where the issue is being seen. The problem is seen with all
> block size and IO depths of Sequential Writes.  Please let me know
> if this would help you or still you arelooking for anything else.

So my current question is why you are mentioning ext3? The test case you
provided is reading and writing directly to the CCISS device, not a file
inside a file system hosted on that device.

Also, please try a make clean && make && make install in your
fio
directory. Sometimes things get hosed when updates are pulled, which may
explain why yours is acting up.

--=20
Jens Axboe

=0A=0A=0A      
--0-1765801769-1240352232=:35730
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

<table cellspacing=3D"0" cellpadding=3D"0" border=3D"0" ><tr><td valign=3D"=
top" style=3D"font: inherit;"><DIV>Hi Jens,</DIV>
<DIV>The reason for saying ext3, is I run fdisk on /dev/cciss/c1d0 and crea=
ted a primary partition.</DIV>
<DIV>&nbsp;</DIV>
<DIV>Then I created a ext3 filesystem on this partition by running mkefs an=
d mounted this partition on /mnt folder. Then I run fio on this partition.<=
/DIV>
<DIV>&nbsp;</DIV>
<DIV>We earlier use to run fio on raw partition. But now we tried running f=
io on a partition which has ext3 filesystem.</DIV>
<DIV>&nbsp;</DIV>
<DIV>When I run fio on raw filesystem I dont get any errors for Sequential =
Writes, but when I run fio test on this ext3 filesystem then I am getting t=
he errors for Sequential Writes&nbsp;what I mentioned u earlier.</DIV>
<DIV>&nbsp;</DIV>
<DIV>Thanks,</DIV>
<DIV>&nbsp;Girish&nbsp;<BR><BR>--- On <B>Wed, 4/22/09, Jens Axboe <I>&lt;je=
ns.axboe@oracle.com&gt;</I></B> wrote:<BR></DIV>
<BLOCKQUOTE style=3D"PADDING-LEFT: 5px; MARGIN-LEFT: 5px; BORDER-LEFT: rgb(=
16,16,255) 2px solid">From: Jens Axboe &lt;jens.axboe@oracle.com&gt;<BR>Sub=
ject: Re: Recent changes<BR>To: "Girish Satihal" &lt;girish.satihal@yahoo.c=
om&gt;<BR>Cc: fio@vger.kernel.org<BR>Date: Wednesday, April 22, 2009, 12:45=
 AM<BR><BR><PRE>On Tue, Apr 21 2009, Girish Satihal wrote:
&gt; Hi Jens,
&gt; I guess I did not understand your question for which I am very sorry.

Don't apologize for that. But if there's something I write you
don't
understand, do just ask for an explanation.

&gt; As per my understanding I have sent you the job file which was
&gt; input file to fio for the performance testing.  As only the problem
&gt; with Seqential Writes, I have cut down the job file to only Write
&gt; parameters where the issue is being seen. The problem is seen with all
&gt; block size and IO depths of Sequential Writes.  Please let me know
&gt; if this would help you or still you arelooking for anything else.

So my current question is why you are mentioning ext3? The test case you
provided is reading and writing directly to the CCISS device, not a file
inside a file system hosted on that device.

Also, please try a make clean &amp;&amp; make &amp;&amp; make install in yo=
ur
fio
directory. Sometimes things get hosed when updates are pulled, which may
explain why yours is acting up.

--=20
Jens Axboe

</PRE></BLOCKQUOTE></td></tr></table><br>=0A=0A      
--0-1765801769-1240352232=:35730--


