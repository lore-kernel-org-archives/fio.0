Return-Path: <girish.satihal@yahoo.com>
Message-ID: <248188.1200.qm@web63806.mail.re1.yahoo.com>
Date: Mon, 20 Apr 2009 13:54:44 -0700 (PDT)
From: Girish Satihal <girish.satihal@yahoo.com>
Subject: Re: Recent changes
In-Reply-To: <20090420180555.GH4593@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1464918922-1240260884=:1200"
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>


--0-1464918922-1240260884=:1200
Content-Type: multipart/alternative; boundary="0-522963622-1240260884=:1200"

--0-522963622-1240260884=:1200
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Jens,
Here is the job file. I am facing problem with Sequential Writes on ext3 fi=
le system.
=A0
Thanks,
=A0Girish

--- On Mon, 4/20/09, Jens Axboe <jens.axboe@oracle.com> wrote:

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Recent changes
To: "Girish Satihal" <girish.satihal@yahoo.com>
Cc: fio@vger.kernel.org
Date: Monday, April 20, 2009, 11:35 PM

On Mon, Apr 20 2009, Girish Satihal wrote:
>=20
> Hi Jens,
> This build is the latest build after version 1.24. This build was the
> outcome of the request for adding blockalign/ba option. Can you please
> help in resolving this issue of sequential writes on ext3 file system?

I'd love to help you, but you have to help me a bit as well. I asked you
for a job file that reproduces the problem. If you can send me such a
job file (preferably cut down to just a single section that exhibits the
problem), then I can probably find the error quickly.

>=20
> Thanks,
> Girish=20
>=20
>=20
> --- On Sat, 4/18/09, Jens Axboe <jens.axboe@oracle.com> wrote:
>=20
> > From: Jens Axboe <jens.axboe@oracle.com>
> > Subject: Re: Recent changes
> > To: "Girish Satihal" <girish.satihal@yahoo.com>
> > Cc: fio@vger.kernel.org
> > Date: Saturday, April 18, 2009, 11:18 PM
> > On Fri, Apr 17 2009, Girish Satihal wrote:
> > > Hi Jens,
> > > I am seeing a serious problem with fio testing. I
> > tried running fio
> > > test on ext3 partition with Sequential Reads and
> > Writes. I keep
> > > getting the I/O write error for Sequential writes. I
> > tried with
> > > multiple servers with different controllers and I
> > still get the same
> > > error. With Sequential Reads and Random Reads/Writes
> > there is no issue
> > > seen. Please find the attached fio results file for
> > Sequential
> > > Reads/Writes which has the error details pertaining to
> > Sequential
> > > writes on ext3 file system. Thanks, Girish
> >=20
> > That's pretty strange. Your test job(s) seem pretty
> > massive, you don't
> > happen to have a cut down version that exhibits the
> > problem?
> >=20
> > There also seems to be parts of the error missing from
> > io_u_log_error(),
> > like the file associated with the error and the io_u
> > details (offset=3D
> > and buflen=3D, for instance).
> >=20
> > What version of fio are you using?
> >=20
> > --=20
> > Jens Axboe
> >=20
> > --
> > To unsubscribe from this list: send the line
> > "unsubscribe fio" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at=20
> > http://vger.kernel.org/majordomo-info.html
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
--0-522963622-1240260884=:1200
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

<table cellspacing=3D"0" cellpadding=3D"0" border=3D"0" ><tr><td valign=3D"=
top" style=3D"font: inherit;"><DIV>Hi Jens,</DIV>
<DIV>Here is the job file. I am facing problem with Sequential Writes on ex=
t3 file system.</DIV>
<DIV>&nbsp;</DIV>
<DIV>Thanks,</DIV>
<DIV>&nbsp;Girish<BR><BR>--- On <B>Mon, 4/20/09, Jens Axboe <I>&lt;jens.axb=
oe@oracle.com&gt;</I></B> wrote:<BR></DIV>
<BLOCKQUOTE style=3D"PADDING-LEFT: 5px; MARGIN-LEFT: 5px; BORDER-LEFT: rgb(=
16,16,255) 2px solid">From: Jens Axboe &lt;jens.axboe@oracle.com&gt;<BR>Sub=
ject: Re: Recent changes<BR>To: "Girish Satihal" &lt;girish.satihal@yahoo.c=
om&gt;<BR>Cc: fio@vger.kernel.org<BR>Date: Monday, April 20, 2009, 11:35 PM=
<BR><BR><PRE>On Mon, Apr 20 2009, Girish Satihal wrote:
&gt;=20
&gt; Hi Jens,
&gt; This build is the latest build after version 1.24. This build was the
&gt; outcome of the request for adding blockalign/ba option. Can you please
&gt; help in resolving this issue of sequential writes on ext3 file system?

I'd love to help you, but you have to help me a bit as well. I asked you
for a job file that reproduces the problem. If you can send me such a
job file (preferably cut down to just a single section that exhibits the
problem), then I can probably find the error quickly.

&gt;=20
&gt; Thanks,
&gt; Girish=20
&gt;=20
&gt;=20
&gt; --- On Sat, 4/18/09, Jens Axboe &lt;jens.axboe@oracle.com&gt; wrote:
&gt;=20
&gt; &gt; From: Jens Axboe &lt;jens.axboe@oracle.com&gt;
&gt; &gt; Subject: Re: Recent changes
&gt; &gt; To: "Girish Satihal" &lt;girish.satihal@yahoo.com&gt;
&gt; &gt; Cc: fio@vger.kernel.org
&gt; &gt; Date: Saturday, April 18, 2009, 11:18 PM
&gt; &gt; On Fri, Apr 17 2009, Girish Satihal wrote:
&gt; &gt; &gt; Hi Jens,
&gt; &gt; &gt; I am seeing a serious problem with fio testing. I
&gt; &gt; tried running fio
&gt; &gt; &gt; test on ext3 partition with Sequential Reads and
&gt; &gt; Writes. I keep
&gt; &gt; &gt; getting the I/O write error for Sequential writes. I
&gt; &gt; tried with
&gt; &gt; &gt; multiple servers with different controllers and I
&gt; &gt; still get the same
&gt; &gt; &gt; error. With Sequential Reads and Random Reads/Writes
&gt; &gt; there is no issue
&gt; &gt; &gt; seen. Please find the attached fio results file for
&gt; &gt; Sequential
&gt; &gt; &gt; Reads/Writes which has the error details pertaining to
&gt; &gt; Sequential
&gt; &gt; &gt; writes on ext3 file system. Thanks, Girish
&gt; &gt;=20
&gt; &gt; That's pretty strange. Your test job(s) seem pretty
&gt; &gt; massive, you don't
&gt; &gt; happen to have a cut down version that exhibits the
&gt; &gt; problem?
&gt; &gt;=20
&gt; &gt; There also seems to be parts of the error missing from
&gt; &gt; io_u_log_error(),
&gt; &gt; like the file associated with the error and the io_u
&gt; &gt; details (offset=3D
&gt; &gt; and buflen=3D, for instance).
&gt; &gt;=20
&gt; &gt; What version of fio are you using?
&gt; &gt;=20
&gt; &gt; --=20
&gt; &gt; Jens Axboe
&gt; &gt;=20
&gt; &gt; --
&gt; &gt; To unsubscribe from this list: send the line
&gt; &gt; "unsubscribe fio" in
&gt; &gt; the body of a message to majordomo@vger.kernel.org
&gt; &gt; More majordomo info at=20
&gt; &gt; http://vger.kernel.org/majordomo-info.html
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
--0-522963622-1240260884=:1200--

--0-1464918922-1240260884=:1200
Content-Type: application/octet-stream; name="StandardSeqnWorkload.fio"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="StandardSeqnWorkload.fio"

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
bF0NCmJzPTUxMg0KW2dsb2JhbF0NCnJ3PXJlYWQNCls1MTJCX01heElPX1Jl
YWRdDQpzdG9uZXdhbGwNCmlvZGVwdGg9MQ0KWzUxMkJfTWF4SU9fUmVhZF0N
CnN0b25ld2FsbA0KaW9kZXB0aD0yDQpbNTEyQl9NYXhJT19SZWFkXQ0Kc3Rv
bmV3YWxsDQppb2RlcHRoPTQNCls1MTJCX01heElPX1JlYWRdDQpzdG9uZXdh
bGwNCmlvZGVwdGg9OA0KWzUxMkJfTWF4SU9fUmVhZF0NCnN0b25ld2FsbA0K
aW9kZXB0aD0xNg0KWzUxMkJfTWF4SU9fUmVhZF0NCnN0b25ld2FsbA0KaW9k
ZXB0aD0zMg0KWzUxMkJfTWF4SU9fUmVhZF0NCnN0b25ld2FsbA0KaW9kZXB0
aD02NA0KW2dsb2JhbF0NCnJ3PXdyaXRlDQpbNTEyQl9NYXhJT19Xcml0ZV0N
CnN0b25ld2FsbA0KaW9kZXB0aD0xDQpbNTEyQl9NYXhJT19Xcml0ZV0NCnN0
b25ld2FsbA0KaW9kZXB0aD0yDQpbNTEyQl9NYXhJT19Xcml0ZV0NCnN0b25l
d2FsbA0KaW9kZXB0aD00DQpbNTEyQl9NYXhJT19Xcml0ZV0NCnN0b25ld2Fs
bA0KaW9kZXB0aD04DQpbNTEyQl9NYXhJT19Xcml0ZV0NCnN0b25ld2FsbA0K
aW9kZXB0aD0xNg0KWzUxMkJfTWF4SU9fV3JpdGVdDQpzdG9uZXdhbGwNCmlv
ZGVwdGg9MzINCls1MTJCX01heElPX1dyaXRlXQ0Kc3RvbmV3YWxsDQppb2Rl
cHRoPTY0DQpbSWRsZV0NCnN0b25ld2FsbA0KcndtaXhyZWFkPTEwMA0KYnM9
NjRrDQpyYXRlPTENCltnbG9iYWxdDQpicz00Sw0KW2dsb2JhbF0NCnJ3PXJl
YWQNCls0S0JfU2VxdWVudGlhbF9SZWFkXQ0Kc3RvbmV3YWxsDQppb2RlcHRo
PTENCls0S0JfU2VxdWVudGlhbF9SZWFkXQ0Kc3RvbmV3YWxsDQppb2RlcHRo
PTINCls0S0JfU2VxdWVudGlhbF9SZWFkXQ0Kc3RvbmV3YWxsDQppb2RlcHRo
PTQNCls0S0JfU2VxdWVudGlhbF9SZWFkXQ0Kc3RvbmV3YWxsDQppb2RlcHRo
PTgNCls0S0JfU2VxdWVudGlhbF9SZWFkXQ0Kc3RvbmV3YWxsDQppb2RlcHRo
PTE2DQpbNEtCX1NlcXVlbnRpYWxfUmVhZF0NCnN0b25ld2FsbA0KaW9kZXB0
aD0zMg0KWzRLQl9TZXF1ZW50aWFsX1JlYWRdDQpzdG9uZXdhbGwNCmlvZGVw
dGg9NjQNCltnbG9iYWxdDQpydz13cml0ZQ0KWzRLQl9TZXF1ZW50aWFsX1dy
aXRlXQ0Kc3RvbmV3YWxsDQppb2RlcHRoPTENCls0S0JfU2VxdWVudGlhbF9X
cml0ZV0NCnN0b25ld2FsbA0KaW9kZXB0aD0yDQpbNEtCX1NlcXVlbnRpYWxf
V3JpdGVdDQpzdG9uZXdhbGwNCmlvZGVwdGg9NA0KWzRLQl9TZXF1ZW50aWFs
X1dyaXRlXQ0Kc3RvbmV3YWxsDQppb2RlcHRoPTgNCls0S0JfU2VxdWVudGlh
bF9Xcml0ZV0NCnN0b25ld2FsbA0KaW9kZXB0aD0xNg0KWzRLQl9TZXF1ZW50
aWFsX1dyaXRlXQ0Kc3RvbmV3YWxsDQppb2RlcHRoPTMyDQpbNEtCX1NlcXVl
bnRpYWxfV3JpdGVdDQpzdG9uZXdhbGwNCmlvZGVwdGg9NjQNCltJZGxlXQ0K
c3RvbmV3YWxsDQpyd21peHJlYWQ9MTAwDQpicz02NGsNCnJhdGU9MQ0KW2ds
b2JhbF0NCmJzPTY0Sw0KW2dsb2JhbF0NCnJ3PXJlYWQNCls2NEtCX1NlcXVl
bnRpYWxfUmVhZF0NCnN0b25ld2FsbA0KaW9kZXB0aD0xDQpbNjRLQl9TZXF1
ZW50aWFsX1JlYWRdDQpzdG9uZXdhbGwNCmlvZGVwdGg9Mg0KWzY0S0JfU2Vx
dWVudGlhbF9SZWFkXQ0Kc3RvbmV3YWxsDQppb2RlcHRoPTQNCls2NEtCX1Nl
cXVlbnRpYWxfUmVhZF0NCnN0b25ld2FsbA0KaW9kZXB0aD04DQpbNjRLQl9T
ZXF1ZW50aWFsX1JlYWRdDQpzdG9uZXdhbGwNCmlvZGVwdGg9MTYNCls2NEtC
X1NlcXVlbnRpYWxfUmVhZF0NCnN0b25ld2FsbA0KaW9kZXB0aD0zMg0KWzY0
S0JfU2VxdWVudGlhbF9SZWFkXQ0Kc3RvbmV3YWxsDQppb2RlcHRoPTY0DQpb
Z2xvYmFsXQ0Kcnc9d3JpdGUNCls2NEtCX1NlcXVlbnRpYWxfV3JpdGVdDQpz
dG9uZXdhbGwNCmlvZGVwdGg9MQ0KWzY0S0JfU2VxdWVudGlhbF9Xcml0ZV0N
CnN0b25ld2FsbA0KaW9kZXB0aD0yDQpbNjRLQl9TZXF1ZW50aWFsX1dyaXRl
XQ0Kc3RvbmV3YWxsDQppb2RlcHRoPTQNCls2NEtCX1NlcXVlbnRpYWxfV3Jp
dGVdDQpzdG9uZXdhbGwNCmlvZGVwdGg9OA0KWzY0S0JfU2VxdWVudGlhbF9X
cml0ZV0NCnN0b25ld2FsbA0KaW9kZXB0aD0xNg0KWzY0S0JfU2VxdWVudGlh
bF9Xcml0ZV0NCnN0b25ld2FsbA0KaW9kZXB0aD0zMg0KWzY0S0JfU2VxdWVu
dGlhbF9Xcml0ZV0NCnN0b25ld2FsbA0KaW9kZXB0aD02NA0KW0lkbGVdDQpz
dG9uZXdhbGwNCnJ3bWl4cmVhZD0xMDANCmJzPTY0aw0KcmF0ZT0xDQpbZ2xv
YmFsXQ0KYnM9NTEySw0KW2dsb2JhbF0NCnJ3PXJlYWQNCls1MTJLQl9TZXF1
ZW50aWFsX1JlYWRdDQpzdG9uZXdhbGwNCmlvZGVwdGg9MQ0KWzUxMktCX1Nl
cXVlbnRpYWxfUmVhZF0NCnN0b25ld2FsbA0KaW9kZXB0aD0yDQpbNTEyS0Jf
U2VxdWVudGlhbF9SZWFkXQ0Kc3RvbmV3YWxsDQppb2RlcHRoPTQNCls1MTJL
Ql9TZXF1ZW50aWFsX1JlYWRdDQpzdG9uZXdhbGwNCmlvZGVwdGg9OA0KWzUx
MktCX1NlcXVlbnRpYWxfUmVhZF0NCnN0b25ld2FsbA0KaW9kZXB0aD0xNg0K
WzUxMktCX1NlcXVlbnRpYWxfUmVhZF0NCnN0b25ld2FsbA0KaW9kZXB0aD0z
Mg0KWzUxMktCX1NlcXVlbnRpYWxfUmVhZF0NCnN0b25ld2FsbA0KaW9kZXB0
aD02NA0KW2dsb2JhbF0NCnJ3PXdyaXRlDQpbNTEyS0JfU2VxdWVudGlhbF9X
cml0ZV0NCnN0b25ld2FsbA0KaW9kZXB0aD0xDQpbNTEyS0JfU2VxdWVudGlh
bF9Xcml0ZV0NCnN0b25ld2FsbA0KaW9kZXB0aD0yDQpbNTEyS0JfU2VxdWVu
dGlhbF9Xcml0ZV0NCnN0b25ld2FsbA0KaW9kZXB0aD00DQpbNTEyS0JfU2Vx
dWVudGlhbF9Xcml0ZV0NCnN0b25ld2FsbA0KaW9kZXB0aD04DQpbNTEyS0Jf
U2VxdWVudGlhbF9Xcml0ZV0NCnN0b25ld2FsbA0KaW9kZXB0aD0xNg0KWzUx
MktCX1NlcXVlbnRpYWxfV3JpdGVdDQpzdG9uZXdhbGwNCmlvZGVwdGg9MzIN
Cls1MTJLQl9TZXF1ZW50aWFsX1dyaXRlXQ0Kc3RvbmV3YWxsDQppb2RlcHRo
PTY0DQpbSWRsZV0NCnN0b25ld2FsbA0KcndtaXhyZWFkPTEwMA0KYnM9NjRr
DQpyYXRlPTENCltnbG9iYWxdDQpicz0xTQ0KW2dsb2JhbF0NCnJ3PXJlYWQN
ClsxTUJfU2VxdWVudGlhbF9SZWFkXQ0Kc3RvbmV3YWxsDQppb2RlcHRoPTEN
ClsxTUJfU2VxdWVudGlhbF9SZWFkXQ0Kc3RvbmV3YWxsDQppb2RlcHRoPTIN
ClsxTUJfU2VxdWVudGlhbF9SZWFkXQ0Kc3RvbmV3YWxsDQppb2RlcHRoPTQN
ClsxTUJfU2VxdWVudGlhbF9SZWFkXQ0Kc3RvbmV3YWxsDQppb2RlcHRoPTgN
ClsxTUJfU2VxdWVudGlhbF9SZWFkXQ0Kc3RvbmV3YWxsDQppb2RlcHRoPTE2
DQpbMU1CX1NlcXVlbnRpYWxfUmVhZF0NCnN0b25ld2FsbA0KaW9kZXB0aD0z
Mg0KWzFNQl9TZXF1ZW50aWFsX1JlYWRdDQpzdG9uZXdhbGwNCmlvZGVwdGg9
NjQNCg==

--0-1464918922-1240260884=:1200--


