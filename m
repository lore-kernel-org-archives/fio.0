Return-Path: <axboe@kernel.dk>
Content-Type: multipart/alternative;
	boundary=Apple-Mail-42E6509C-0CF6-4D68-B7B2-EB20171A88AE
Mime-Version: 1.0 (1.0)
Subject: Re: bug in logging code?
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CANvN+e=Fmx36j0kVtyyfaYEgm-K_s=-nm3eCQBgpY=6oOAFN6g@mail.gmail.com>
Date: Thu, 3 Apr 2014 23:05:15 -0600
Content-Transfer-Encoding: 7bit
Message-Id: <27C33847-D9A1-441C-87C1-6D660078F16F@kernel.dk>
References: <533C2B54.6030606@gmail.com> <533C4B06.9070108@kernel.dk> <533C4E9D.8050901@gmail.com> <533C4F2B.5070708@kernel.dk> <533C55E8.1010108@gmail.com> <533C5D2F.1080308@kernel.dk> <533C755D.1070601@gmail.com> <533CD452.7080205@kernel.dk> <CANvN+e=Fmx36j0kVtyyfaYEgm-K_s=-nm3eCQBgpY=6oOAFN6g@mail.gmail.com>
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>


--Apple-Mail-42E6509C-0CF6-4D68-B7B2-EB20171A88AE
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable

On Apr 3, 2014, at 10:58 PM, Andrey Kuzmin <andrey.v.kuzmin@gmail.com> wrote=
:
>=20
> Another reduction idea would be to open/read/write io logs via gz frontend=
, defaulting to regular I/O where compression is either unavailable or undes=
ired. Should be a big deal with large logs, which is often the case. I plann=
ed to take on this in my spare time couple of months back, but it's still wh=
ere it was at that time :(.
>=20
Should be trivial to wire up actually, the network code already does gz of l=
ogs.=20


--Apple-Mail-42E6509C-0CF6-4D68-B7B2-EB20171A88AE
Content-Type: text/html;
	charset=utf-8
Content-Transfer-Encoding: 7bit

<html><head><meta http-equiv="content-type" content="text/html; charset=utf-8"></head><body dir="auto"><div>On Apr 3, 2014, at 10:58 PM, Andrey Kuzmin &lt;<a href="mailto:andrey.v.kuzmin@gmail.com">andrey.v.kuzmin@gmail.com</a>&gt; wrote:</div><div><br></div><blockquote type="cite"><div><p dir="ltr">Another reduction idea would be to open/read/write io logs via gz frontend, defaulting to regular I/O where compression is either unavailable or undesired. Should be a big deal with large logs, which is often the case. I planned to take on this in my spare time couple of months back, but it's still where it was at that time :(.</p></div></blockquote>Should be trivial to wire up actually, the network code already does gz of logs.&nbsp;<br><div><br></div></body></html>
--Apple-Mail-42E6509C-0CF6-4D68-B7B2-EB20171A88AE--

