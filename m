Return-Path: <girish.satihal@yahoo.com>
Message-ID: <309802.6143.qm@web63808.mail.re1.yahoo.com>
Date: Tue, 21 Apr 2009 08:46:39 -0700 (PDT)
From: Girish Satihal <girish.satihal@yahoo.com>
Subject: Re: Recent changes
In-Reply-To: <20090421074720.GC4593@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-376177715-1240328799=:6143"
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>


--0-376177715-1240328799=:6143
Content-Type: multipart/alternative; boundary="0-1600509847-1240328799=:6143"

--0-1600509847-1240328799=:6143
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Jens,
I guess I did not understand your question for which I am very sorry.=20
=A0
As per my understanding I have sent you the job file which was input file t=
o fio=20
for the performance testing.=20
=A0
As only the problem with Seqential Writes, I have cut down the job file to =
only=20
Write parameters where the issue is being seen. The problem is seen with al=
l block size and IO depths of Sequential Writes.
=A0
Please let me know if this would help you or still you are=A0looking for an=
ything else.
=A0
Thanks,
=A0Girish


--- On Tue, 4/21/09, Jens Axboe <jens.axboe@oracle.com> wrote:

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Recent changes
To: "Girish Satihal" <girish.satihal@yahoo.com>
Cc: fio@vger.kernel.org
Date: Tuesday, April 21, 2009, 1:17 PM

On Tue, Apr 21 2009, Jens Axboe wrote:
> On Mon, Apr 20 2009, Girish Satihal wrote:
> > Hi Jens,
> > Here is the job file. I am facing problem with Sequential Writes on
> > ext3 file system.
>=20
> You are starting to annoy me a bit... Are you reading my emails? What
> did I ask you for? A cut down version that exhibits the problem. You are
> using a piece of free software and expecting help/support with your
> issue, the VERY least you can do is pay a bit of attention and provide
> what is asked (or at least say WHY you didn't provide a cut down
> version, perhaps you couldn't get it working etc).

Your job file works fine for me. I'm not sure why you are talking about
ext3, your job file works on the full device, not a file system.

>=20
>=20
>=20
> > =A0
> > Thanks,
> > =A0Girish
> >=20
> > --- On Mon, 4/20/09, Jens Axboe <jens.axboe@oracle.com> wrote:
> >=20
> > From: Jens Axboe <jens.axboe@oracle.com>
> > Subject: Re: Recent changes
> > To: "Girish Satihal" <girish.satihal@yahoo.com>
> > Cc: fio@vger.kernel.org
> > Date: Monday, April 20, 2009, 11:35 PM
> >=20
> > On Mon, Apr 20 2009, Girish Satihal wrote:
> > >=20
> > > Hi Jens,
> > > This build is the latest build after version 1.24. This build
was the
> > > outcome of the request for adding blockalign/ba option. Can you
please
> > > help in resolving this issue of sequential writes on ext3 file
system?
> >=20
> > I'd love to help you, but you have to help me a bit as well. I
asked you
> > for a job file that reproduces the problem. If you can send me such a
> > job file (preferably cut down to just a single section that exhibits
the
> > problem), then I can probably find the error quickly.
> >=20
> > >=20
> > > Thanks,
> > > Girish=20
> > >=20
> > >=20
> > > --- On Sat, 4/18/09, Jens Axboe <jens.axboe@oracle.com>
wrote:
> > >=20
> > > > From: Jens Axboe <jens.axboe@oracle.com>
> > > > Subject: Re: Recent changes
> > > > To: "Girish Satihal"
<girish.satihal@yahoo.com>
> > > > Cc: fio@vger.kernel.org
> > > > Date: Saturday, April 18, 2009, 11:18 PM
> > > > On Fri, Apr 17 2009, Girish Satihal wrote:
> > > > > Hi Jens,
> > > > > I am seeing a serious problem with fio testing. I
> > > > tried running fio
> > > > > test on ext3 partition with Sequential Reads and
> > > > Writes. I keep
> > > > > getting the I/O write error for Sequential writes. I
> > > > tried with
> > > > > multiple servers with different controllers and I
> > > > still get the same
> > > > > error. With Sequential Reads and Random Reads/Writes
> > > > there is no issue
> > > > > seen. Please find the attached fio results file for
> > > > Sequential
> > > > > Reads/Writes which has the error details pertaining to
> > > > Sequential
> > > > > writes on ext3 file system. Thanks, Girish
> > > >=20
> > > > That's pretty strange. Your test job(s) seem pretty
> > > > massive, you don't
> > > > happen to have a cut down version that exhibits the
> > > > problem?
> > > >=20
> > > > There also seems to be parts of the error missing from
> > > > io_u_log_error(),
> > > > like the file associated with the error and the io_u
> > > > details (offset=3D
> > > > and buflen=3D, for instance).
> > > >=20
> > > > What version of fio are you using?
> > > >=20
> > > > --=20
> > > > Jens Axboe
> > > >=20
> > > > --
> > > > To unsubscribe from this list: send the line
> > > > "unsubscribe fio" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at=20
> > > > http://vger.kernel.org/majordomo-info.html
> > >=20
> > >=20
> > >      =20
> >=20
> > --=20
> > Jens Axboe
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe
fio" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
> >=20
> >=20
> >      =20
>=20
>=20
> --=20
> Jens Axboe
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe fio"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
=0A=0A=0A      
--0-1600509847-1240328799=:6143
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

<table cellspacing=3D"0" cellpadding=3D"0" border=3D"0" ><tr><td valign=3D"=
top" style=3D"font: inherit;"><DIV>Hi Jens,</DIV>
<DIV>I guess I did not understand your question for which I am very sorry. =
</DIV>
<DIV>&nbsp;</DIV>
<DIV>As per my understanding I have sent you the job file which was input f=
ile to fio </DIV>
<DIV>for the performance testing. </DIV>
<DIV>&nbsp;</DIV>
<DIV>As only the problem with Seqential Writes, I have cut down the job fil=
e to only </DIV>
<DIV>Write parameters where the issue is being seen. The problem is seen wi=
th all block size and IO depths of Sequential Writes.</DIV>
<DIV>&nbsp;</DIV>
<DIV>Please let me know if this would help you or still you are&nbsp;lookin=
g for anything else.</DIV>
<DIV>&nbsp;</DIV>
<DIV>Thanks,</DIV>
<DIV>&nbsp;Girish</DIV>
<DIV><BR><BR>--- On <B>Tue, 4/21/09, Jens Axboe <I>&lt;jens.axboe@oracle.co=
m&gt;</I></B> wrote:<BR></DIV>
<BLOCKQUOTE style=3D"PADDING-LEFT: 5px; MARGIN-LEFT: 5px; BORDER-LEFT: rgb(=
16,16,255) 2px solid">From: Jens Axboe &lt;jens.axboe@oracle.com&gt;<BR>Sub=
ject: Re: Recent changes<BR>To: "Girish Satihal" &lt;girish.satihal@yahoo.c=
om&gt;<BR>Cc: fio@vger.kernel.org<BR>Date: Tuesday, April 21, 2009, 1:17 PM=
<BR><BR><PRE>On Tue, Apr 21 2009, Jens Axboe wrote:
&gt; On Mon, Apr 20 2009, Girish Satihal wrote:
&gt; &gt; Hi Jens,
&gt; &gt; Here is the job file. I am facing problem with Sequential Writes =
on
&gt; &gt; ext3 file system.
&gt;=20
&gt; You are starting to annoy me a bit... Are you reading my emails? What
&gt; did I ask you for? A cut down version that exhibits the problem. You a=
re
&gt; using a piece of free software and expecting help/support with your
&gt; issue, the VERY least you can do is pay a bit of attention and provide
&gt; what is asked (or at least say WHY you didn't provide a cut down
&gt; version, perhaps you couldn't get it working etc).

Your job file works fine for me. I'm not sure why you are talking about
ext3, your job file works on the full device, not a file system.

&gt;=20
&gt;=20
&gt;=20
&gt; &gt; &nbsp;
&gt; &gt; Thanks,
&gt; &gt; &nbsp;Girish
&gt; &gt;=20
&gt; &gt; --- On Mon, 4/20/09, Jens Axboe &lt;jens.axboe@oracle.com&gt; wro=
te:
&gt; &gt;=20
&gt; &gt; From: Jens Axboe &lt;jens.axboe@oracle.com&gt;
&gt; &gt; Subject: Re: Recent changes
&gt; &gt; To: "Girish Satihal" &lt;girish.satihal@yahoo.com&gt;
&gt; &gt; Cc: fio@vger.kernel.org
&gt; &gt; Date: Monday, April 20, 2009, 11:35 PM
&gt; &gt;=20
&gt; &gt; On Mon, Apr 20 2009, Girish Satihal wrote:
&gt; &gt; &gt;=20
&gt; &gt; &gt; Hi Jens,
&gt; &gt; &gt; This build is the latest build after version 1.24. This buil=
d
was the
&gt; &gt; &gt; outcome of the request for adding blockalign/ba option. Can =
you
please
&gt; &gt; &gt; help in resolving this issue of sequential writes on ext3 fi=
le
system?
&gt; &gt;=20
&gt; &gt; I'd love to help you, but you have to help me a bit as well. I
asked you
&gt; &gt; for a job file that reproduces the problem. If you can send me su=
ch a
&gt; &gt; job file (preferably cut down to just a single section that exhib=
its
the
&gt; &gt; problem), then I can probably find the error quickly.
&gt; &gt;=20
&gt; &gt; &gt;=20
&gt; &gt; &gt; Thanks,
&gt; &gt; &gt; Girish=20
&gt; &gt; &gt;=20
&gt; &gt; &gt;=20
&gt; &gt; &gt; --- On Sat, 4/18/09, Jens Axboe &lt;jens.axboe@oracle.com&gt=
;
wrote:
&gt; &gt; &gt;=20
&gt; &gt; &gt; &gt; From: Jens Axboe &lt;jens.axboe@oracle.com&gt;
&gt; &gt; &gt; &gt; Subject: Re: Recent changes
&gt; &gt; &gt; &gt; To: "Girish Satihal"
&lt;girish.satihal@yahoo.com&gt;
&gt; &gt; &gt; &gt; Cc: fio@vger.kernel.org
&gt; &gt; &gt; &gt; Date: Saturday, April 18, 2009, 11:18 PM
&gt; &gt; &gt; &gt; On Fri, Apr 17 2009, Girish Satihal wrote:
&gt; &gt; &gt; &gt; &gt; Hi Jens,
&gt; &gt; &gt; &gt; &gt; I am seeing a serious problem with fio testing. I
&gt; &gt; &gt; &gt; tried running fio
&gt; &gt; &gt; &gt; &gt; test on ext3 partition with Sequential Reads and
&gt; &gt; &gt; &gt; Writes. I keep
&gt; &gt; &gt; &gt; &gt; getting the I/O write error for Sequential writes.=
 I
&gt; &gt; &gt; &gt; tried with
&gt; &gt; &gt; &gt; &gt; multiple servers with different controllers and I
&gt; &gt; &gt; &gt; still get the same
&gt; &gt; &gt; &gt; &gt; error. With Sequential Reads and Random Reads/Writ=
es
&gt; &gt; &gt; &gt; there is no issue
&gt; &gt; &gt; &gt; &gt; seen. Please find the attached fio results file fo=
r
&gt; &gt; &gt; &gt; Sequential
&gt; &gt; &gt; &gt; &gt; Reads/Writes which has the error details pertainin=
g to
&gt; &gt; &gt; &gt; Sequential
&gt; &gt; &gt; &gt; &gt; writes on ext3 file system. Thanks, Girish
&gt; &gt; &gt; &gt;=20
&gt; &gt; &gt; &gt; That's pretty strange. Your test job(s) seem pretty
&gt; &gt; &gt; &gt; massive, you don't
&gt; &gt; &gt; &gt; happen to have a cut down version that exhibits the
&gt; &gt; &gt; &gt; problem?
&gt; &gt; &gt; &gt;=20
&gt; &gt; &gt; &gt; There also seems to be parts of the error missing from
&gt; &gt; &gt; &gt; io_u_log_error(),
&gt; &gt; &gt; &gt; like the file associated with the error and the io_u
&gt; &gt; &gt; &gt; details (offset=3D
&gt; &gt; &gt; &gt; and buflen=3D, for instance).
&gt; &gt; &gt; &gt;=20
&gt; &gt; &gt; &gt; What version of fio are you using?
&gt; &gt; &gt; &gt;=20
&gt; &gt; &gt; &gt; --=20
&gt; &gt; &gt; &gt; Jens Axboe
&gt; &gt; &gt; &gt;=20
&gt; &gt; &gt; &gt; --
&gt; &gt; &gt; &gt; To unsubscribe from this list: send the line
&gt; &gt; &gt; &gt; "unsubscribe fio" in
&gt; &gt; &gt; &gt; the body of a message to majordomo@vger.kernel.org
&gt; &gt; &gt; &gt; More majordomo info at=20
&gt; &gt; &gt; &gt; http://vger.kernel.org/majordomo-info.html
&gt; &gt; &gt;=20
&gt; &gt; &gt;=20
&gt; &gt; &gt;      =20
&gt; &gt;=20
&gt; &gt; --=20
&gt; &gt; Jens Axboe
&gt; &gt;=20
&gt; &gt; --
&gt; &gt; To unsubscribe from this list: send the line "unsubscribe
fio" in
&gt; &gt; the body of a message to majordomo@vger.kernel.org
&gt; &gt; More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
&gt; &gt;=20
&gt; &gt;=20
&gt; &gt;=20
&gt; &gt;      =20
&gt;=20
&gt;=20
&gt; --=20
&gt; Jens Axboe
&gt;=20
&gt; --
&gt; To unsubscribe from this list: send the line "unsubscribe fio"
in
&gt; the body of a message to majordomo@vger.kernel.org
&gt; More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
</PRE></BLOCKQUOTE></td></tr></table><br>=0A=0A      
--0-1600509847-1240328799=:6143--

--0-376177715-1240328799=:6143
Content-Type: application/octet-stream; name="StandardSeqnWriteWorkload.fio"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="StandardSeqnWriteWorkload.fio"

W2dsb2JhbF0NCjsgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KOyBudW1iZXIgb2YgdGVzdCB0
YXJnZXRzDQpucmZpbGVzPTENCjsgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KOyB0aGlzIGlz
IHRoZSB0ZXN0IHRhcmdldA0KZmlsZW5hbWU9L2Rldi9jY2lzcy9jMWQwDQo7
IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0NCjsgYWxnb3JpdGhtIGZvciBzZWxlY3RpbmcgdGVz
dCB0YXJnZXRzIChpZiBtdWx0aXBsZSkNCmZpbGVfc2VydmljZV90eXBlPXJv
dW5kcm9iaW4NCjsgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KOyBzZWxlY3QgdGhlIEkvTyBl
bmdpbmUNCmlvZW5naW5lPWxpYmFpbw0KOyBpb2VuZ2luZT1wb3NpeGFpbw0K
OyBpb2VuZ2luZT1zb2xhcmlzYWlvDQo7IC0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCjsgdXNl
IG5vbi1idWZmZXJlZCBJL08NCmRpcmVjdD0xDQo7IC0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0N
CnRpbWVfYmFzZWQNCg0KOyAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo7DQo7IHNldCB1cCBT
ZXF1ZW50aWFsIHRlc3QgcGFyYW1ldGVycw0KOw0KOyAtLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
DQpbZ2xvYmFsXQ0KcnVudGltZT0zMA0KcmFtcF90aW1lPTUNCg0KW2dsb2Jh
bF0NCmJzPTUxMg0KW2dsb2JhbF0NCnJ3PXdyaXRlDQpbNTEyQl9NYXhJT19X
cml0ZV0NCnN0b25ld2FsbA0KaW9kZXB0aD0xDQpbNTEyQl9NYXhJT19Xcml0
ZV0NCnN0b25ld2FsbA0KaW9kZXB0aD0yDQpbNTEyQl9NYXhJT19Xcml0ZV0N
CnN0b25ld2FsbA0KaW9kZXB0aD00DQpbNTEyQl9NYXhJT19Xcml0ZV0NCnN0
b25ld2FsbA0KaW9kZXB0aD04DQpbNTEyQl9NYXhJT19Xcml0ZV0NCnN0b25l
d2FsbA0KaW9kZXB0aD0xNg0KWzUxMkJfTWF4SU9fV3JpdGVdDQpzdG9uZXdh
bGwNCmlvZGVwdGg9MzINCls1MTJCX01heElPX1dyaXRlXQ0Kc3RvbmV3YWxs
DQppb2RlcHRoPTY0DQpbSWRsZV0NCnN0b25ld2FsbA0KcndtaXhyZWFkPTEw
MA0KYnM9NjRrDQpyYXRlPTENCltnbG9iYWxdDQpicz00Sw0KW2dsb2JhbF0N
CnJ3PXdyaXRlDQpbNEtCX1NlcXVlbnRpYWxfV3JpdGVdDQpzdG9uZXdhbGwN
CmlvZGVwdGg9MQ0KWzRLQl9TZXF1ZW50aWFsX1dyaXRlXQ0Kc3RvbmV3YWxs
DQppb2RlcHRoPTINCls0S0JfU2VxdWVudGlhbF9Xcml0ZV0NCnN0b25ld2Fs
bA0KaW9kZXB0aD00DQpbNEtCX1NlcXVlbnRpYWxfV3JpdGVdDQpzdG9uZXdh
bGwNCmlvZGVwdGg9OA0KWzRLQl9TZXF1ZW50aWFsX1dyaXRlXQ0Kc3RvbmV3
YWxsDQppb2RlcHRoPTE2DQpbNEtCX1NlcXVlbnRpYWxfV3JpdGVdDQpzdG9u
ZXdhbGwNCmlvZGVwdGg9MzINCls0S0JfU2VxdWVudGlhbF9Xcml0ZV0NCnN0
b25ld2FsbA0KaW9kZXB0aD02NA0KW0lkbGVdDQpzdG9uZXdhbGwNCnJ3bWl4
cmVhZD0xMDANCmJzPTY0aw0KcmF0ZT0xDQpbZ2xvYmFsXQ0KYnM9NjRLDQpb
Z2xvYmFsXQ0Kcnc9d3JpdGUNCls2NEtCX1NlcXVlbnRpYWxfV3JpdGVdDQpz
dG9uZXdhbGwNCmlvZGVwdGg9MQ0KWzY0S0JfU2VxdWVudGlhbF9Xcml0ZV0N
CnN0b25ld2FsbA0KaW9kZXB0aD0yDQpbNjRLQl9TZXF1ZW50aWFsX1dyaXRl
XQ0Kc3RvbmV3YWxsDQppb2RlcHRoPTQNCls2NEtCX1NlcXVlbnRpYWxfV3Jp
dGVdDQpzdG9uZXdhbGwNCmlvZGVwdGg9OA0KWzY0S0JfU2VxdWVudGlhbF9X
cml0ZV0NCnN0b25ld2FsbA0KaW9kZXB0aD0xNg0KWzY0S0JfU2VxdWVudGlh
bF9Xcml0ZV0NCnN0b25ld2FsbA0KaW9kZXB0aD0zMg0KWzY0S0JfU2VxdWVu
dGlhbF9Xcml0ZV0NCnN0b25ld2FsbA0KaW9kZXB0aD02NA0KW0lkbGVdDQpz
dG9uZXdhbGwNCnJ3bWl4cmVhZD0xMDANCmJzPTY0aw0KcmF0ZT0xDQpbZ2xv
YmFsXQ0KYnM9NTEySw0KW2dsb2JhbF0NCnJ3PXdyaXRlDQpbNTEyS0JfU2Vx
dWVudGlhbF9Xcml0ZV0NCnN0b25ld2FsbA0KaW9kZXB0aD0xDQpbNTEyS0Jf
U2VxdWVudGlhbF9Xcml0ZV0NCnN0b25ld2FsbA0KaW9kZXB0aD0yDQpbNTEy
S0JfU2VxdWVudGlhbF9Xcml0ZV0NCnN0b25ld2FsbA0KaW9kZXB0aD00DQpb
NTEyS0JfU2VxdWVudGlhbF9Xcml0ZV0NCnN0b25ld2FsbA0KaW9kZXB0aD04
DQpbNTEyS0JfU2VxdWVudGlhbF9Xcml0ZV0NCnN0b25ld2FsbA0KaW9kZXB0
aD0xNg0KWzUxMktCX1NlcXVlbnRpYWxfV3JpdGVdDQpzdG9uZXdhbGwNCmlv
ZGVwdGg9MzINCls1MTJLQl9TZXF1ZW50aWFsX1dyaXRlXQ0Kc3RvbmV3YWxs
DQppb2RlcHRoPTY0DQpbSWRsZV0NCnN0b25ld2FsbA0KcndtaXhyZWFkPTEw
MA0KYnM9NjRrDQpyYXRlPTENCg==

--0-376177715-1240328799=:6143--


