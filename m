Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C7AF4F1
	for <fio@vger.kernel.org>; Tue, 22 Sep 2026 02:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790043165; cv=none; b=O8llUEjkoBVwWjSE/eCU8cOf7h5662r7dFc1EQSZN7gn865HicAVN4z4y1n0K7v2uH71WcOnQcmJLKHl+46vMFxCh7PgnGMGsWTmvdypexY4Di+J9fOvcwX6xY/5vmHdCl6NWHQmakSHg8HPWA1Lqu4OvuGEfOthjLOcbiwMy5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790043165; c=relaxed/simple;
	bh=tryYYBGIKrgATMMfGNJ4H8xK9OaRsRDNGwuarveaJFs=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=QvFY8b9nTKDs+Ia3qzNUtF8RAOZH41IGBe0krXLrJpHECVUOXh92kKnTuQwQCIiVkwFD/0ODlUjNqg85jG3EbCHghq+vnJXvxjiQJceNCZWx3r2Lkq5ak+1CinNbh/LY5uDWRC2xWF+Z+Xn8b3ywScB22glk/0EGn4nF3twWwmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=HBev8JOi; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="HBev8JOi"
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260922021240epoutp01196d165674c687307a2a051d32bac3c5~XgsUfzzYK2056620566epoutp01j
	for <fio@vger.kernel.org>; Tue, 22 Sep 2026 02:12:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260922021240epoutp01196d165674c687307a2a051d32bac3c5~XgsUfzzYK2056620566epoutp01j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1790043160;
	bh=tryYYBGIKrgATMMfGNJ4H8xK9OaRsRDNGwuarveaJFs=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=HBev8JOiup8QMyTlqD9qZJ2IzIrjH8IfJkDJ5l3rpux62/Ud4xlBfCBnoxPUUoFEj
	 dT0bNY0RYVAuwsq206rjx0kF/zX+3inC8uq2xjQPVK36gm+jt9WG06IAEWi9FbUg3G
	 PQ9vwGzNq6XCUKNpbCx1qu2p5reKlOSIINMm5kdE=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20260922021239epcas2p2c8f671d6f5251402f14acca50c7ded76~XgsUOdd4v0111901119epcas2p2I;
	Tue, 22 Sep 2026 02:12:39 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.210]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4hpkBv31Jtz6B9m6; Tue, 22 Sep
	2026 02:12:39 +0000 (GMT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE: [PATCH] examples: add seq-rand-read-write.fio
Reply-To: jieon.seol@samsung.com
Sender: Jieon Seol <jieon.seol@samsung.com>
From: Jieon Seol <jieon.seol@samsung.com>
To: Vincent Fu <vincentfu@gmail.com>
CC: "fio@vger.kernel.org" <fio@vger.kernel.org>, "jieon.seol@gmail.com"
	<jieon.seol@gmail.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <CAOp=CX=timCvNWUNpkR-sRpwVJ114mzew4-CuQbMTvj4v_tDSQ@mail.gmail.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260922021238epcms2p4439e830aebe8bad4c39f52a1bd03501b@epcms2p4>
Date: Tue, 22 Sep 2026 11:12:38 +0900
X-CMS-MailID: 20260922021238epcms2p4439e830aebe8bad4c39f52a1bd03501b
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260921025521epcms2p34a2d819339601929f469f71ca7014901
References: <CAOp=CX=timCvNWUNpkR-sRpwVJ114mzew4-CuQbMTvj4v_tDSQ@mail.gmail.com>
	<20260921025521epcms2p34a2d819339601929f469f71ca7014901@epcms2p3>
	<CAOp=CXmANYTw3at495z+G3S9injh2nLpgOP=_vQ3LBtbaF-G_Q@mail.gmail.com>
	<20260921232021epcms2p5c738e175300ab42e01655efe7535dcaf@epcms2p5>
	<CGME20260921025521epcms2p34a2d819339601929f469f71ca7014901@epcms2p4>

> On Mon, Sep 21, 2026 at 7:20=E2=80=AFPM=20Jieon=20Seol=20<jieon.seol=40sa=
msung.com>=20wrote:=0D=0A>=20>=0D=0A>=20>=20Hi=20Vincent,=0D=0A>=20>=0D=0A>=
=20>=20Thanks=20for=20the=20feedback.=0D=0A>=20>=0D=0A>=20>=20The=20propose=
d=20job=20already=20has=20direct=3D1=20in=20the=20global=20section.=0D=0A>=
=20>=0D=0A>=20>=20I=20considered=20modifying=20examples/ssd-test.fio,=20but=
=20kept=20this=20separate=20because=20the=20workload=20differs=20in=20a=20f=
ew=20significant=20ways:=20in=20particular,=20it=20uses=20512=20KiB=20seque=
ntial=20I/O,=204=20KiB=20random=20I/O,=20and=20fixed-size=20runs=20rather=
=20than=20the=20current=204=20KiB,=20libaio/iodepth=3D4,=20time-based=20con=
figuration.=0D=0A>=20>=0D=0A>=20>=20If=20updating=20ssd-test.fio=20is=20pre=
ferable,=20I'm=20happy=20to=20rework=20the=20patch=20in=20that=20direction.=
=0D=0A>=20>=0D=0A>=20>=20Thanks,=0D=0A>=20>=20Jieon=0D=0A>=20>=0D=0A>=20>=
=0D=0A>=20>=20---------=20Original=20Message=20---------=0D=0A>=20>=20Sende=
r=20:=20Vincent=20Fu=20<vincentfu=40gmail.com>=0D=0A>=20>=20Date=20:=202026=
-09-22=2007:59=20(GMT+9)=0D=0A>=20>=20Title=20:=20Re:=20=5BPATCH=5D=20examp=
les:=20add=20seq-rand-read-write.fio=0D=0A>=20>=0D=0A>=20>=20On=20Sun,=20Se=
p=2020,=202026=20at=2010:58=E2=80=AFPM=20=EC=84=A4=EC=A7=80=EC=96=B8=20<jie=
on.seol=40samsung.com>=20wrote:=0D=0A>=20>=20>=0D=0A>=20>=20>=20Add=20an=20=
example=20job=20file=20that=20runs=20four=20basic=20storage=20performance=
=0D=0A>=20>=20>=20workloads=20in=20a=20single=20fio=20invocation:=0D=0A>=20=
>=20>=0D=0A>=20>=20>=20-=20512=20KiB=20sequential=20read=0D=0A>=20>=20>=20-=
=20512=20KiB=20sequential=20write=0D=0A>=20>=20>=20-=204=20KiB=20random=20r=
ead=0D=0A>=20>=20>=20-=204=20KiB=20random=20write=0D=0A>=20>=20>=0D=0A>=20>=
=20>=20The=20sequential=20workloads=20transfer=201=20GiB=20each.=20The=20ra=
ndom=20workloads=0D=0A>=20>=20>=20operate=20over=20a=201=20GiB=20region=20u=
sing=20eight=20synchronous=20workers,=20with=20each=0D=0A>=20>=20>=20worker=
=20transferring=20128=20MiB=20(1=20GiB=20aggregate=20per=20workload).=0D=0A=
>=20>=20>=0D=0A>=20>=20>=20Unlike=20examples/ssd-test.fio,=20which=20uses=
=204=20KiB=20I/O=20for=20both=20sequential=0D=0A>=20>=20>=20and=20random=20=
workloads,=20this=20job=20uses=20large-block=20sequential=20I/O=20for=0D=0A=
>=20>=20>=20bandwidth=20measurement=20and=20small-block=20random=20I/O=20fo=
r=20random=0D=0A>=20>=20>=20performance.=0D=0A>=20>=20>=0D=0A>=20>=20>=20Th=
e=20four=20workloads=20are=20serialized=20with=20stonewall=20and=20explicit=
ly=20use=0D=0A>=20>=20>=20the=20psync=20I/O=20engine.=20The=20target=20dire=
ctory=20is=20supplied=20at=20invocation=0D=0A>=20>=20>=20time,=20for=20exam=
ple:=0D=0A>=20>=20>=0D=0A>=20>=20>=20=20=20=20=20fio=20--directory=3D/path/=
to/test=20examples/seq-rand-read-write.fio=0D=0A>=20>=20>=0D=0A>=20>=20>=20=
Testing:=0D=0A>=20>=20>=20-=20fio=20--parse-only=20examples/seq-rand-read-w=
rite.fio=0D=0A>=20>=20>=0D=0A>=20>=20>=20Signed-off-by:=20Jieon=20Seol=20<j=
ieon.seol=40samsung.com>=0D=0A>=20>=20>=20---=0D=0A>=20>=0D=0A>=20>=0D=0A>=
=20>=20If=20you=20are=20really=20interested=20in=20device=20performance=20y=
ou=20should=20run=20with=0D=0A>=20>=20direct=3D1.=20Otherwise=20you=20will=
=20be=20measuring=20the=20performance=20of=20the=20page=20cache.=0D=0A>=20>=
=0D=0A>=20>=20Why=20don't=20you=20just=20modify=20examples/ssd-test.fio?=20=
That=20would=20be=20better=20than=0D=0A>=20>=20creating=20a=20completely=20=
new=20example=20job.=0D=0A>=20>=0D=0A>=20>=0D=0A>=20>=20Vincent=0D=0A>=20=
=0D=0A>=20Jieon,=20send=20your=20patch=20as=20an=20improvement=20to=20examp=
les/ssd-test.fio.=0D=0A>=0D=0A=0D=0AThanks.=20I=20took=20another=20look=20a=
t=20ssd-test.fio=20before=20reworking=20the=20patch,=20and=20I=20realized=
=20that=20I=20had=20described=20the=20scope=20of=20my=20original=20patch=20=
too=20broadly.=0D=0A=0D=0AThe=20workload=20I=20intended=20to=20add=20is=20s=
pecifically=20based=20on=20basic=20mobile-storage=20performance=20testing=
=20rather=20than=20a=20replacement=20for=20a=20generic=20SSD=20test.=20In=
=20particular,=20it=20uses=20512=20KiB=20sequential=20I/O=20with=20a=20sing=
le=20job=20and=204=20KiB=20random=20I/O=20with=20eight=20jobs=20sharing=20a=
=201=20GiB=20address=20range.=0D=0A=0D=0ASimilar=20workload=20characteristi=
cs=20are=20also=20used=20in=20published=20UFS/mobile-storage=20performance=
=20measurements,=20including=20512=20KiB=20sequential=20and=204=20KiB=20ran=
dom=20I/O.=0D=0A=0D=0AChanging=20ssd-test.fio=20would=20therefore=20require=
=20making=20choices=20about=20generic=20SSD=20workloads,=20such=20as=20the=
=20appropriate=20queue=20depth=20and=20I/O=20engine,=20which=20are=20somewh=
at=20different=20from=20the=20purpose=20of=20my=20original=20patch.=0D=0A=
=0D=0AWould=20you=20be=20open=20to=20a=20v2=20that=20makes=20this=20scope=
=20explicit,=20for=20example=20as=20examples/mobile-storage.fio,=20rather=
=20than=20changing=20ssd-test.fio?=0D=0A=20=0D=0A>=20Also,=20avoid=20placin=
g=20the=20new=20text=20of=20your=20reply=20at=20the=20top=20of=20a=20messag=
e.=20The=0D=0A>=20convention=20on=20these=20mailing=20lists=20is=20to=20quo=
te=20the=20previous=20message=20and=20insert=0D=0A>=20your=20reply=20at=20r=
elevant=20points=20of=20the=20quoted=20message.=0D=0A=0D=0AUnderstood.=20Th=
anks=20for=20pointing=20this=20out.=0D=0A=0D=0A>=20=0D=0A>=20Vincent=0D=0A=
=0D=0A=0D=0AThanks,=0D=0AJieon=0D=0A
