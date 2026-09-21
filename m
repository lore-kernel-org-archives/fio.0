Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E374457B6
	for <fio@vger.kernel.org>; Mon, 21 Sep 2026 23:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790032828; cv=none; b=eYa5qNb0erJemkVcy1b07ueXO/00XaZcTM4hjZ5IVt9vqiXcDZv7oSr5BLjIij1Tjv0kLpVKynXu/9s3OZ48U33S89uZ3htUwbrkpsjqfGl70/0SUeVZirY+aqni40mBrgnVZisvAWo0wwT3gbopLBwHZ3TwOBb+1+SHQdjXn+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790032828; c=relaxed/simple;
	bh=Tl0pECm8XO0tuARFl/YgPiU/Kp9XWd5v4ak+5GGPJ8A=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=tS4PzCYW4LpPDdNjHpw+tOj7LZe48oeH44Qb0PinLi68rVCqiCSTZXpSB0ZWnzPm9IK9XjE/5iPHCI+Z53GpxKV9l/2oUZUsmW42rD4+n6sYfr987FDnldE5+w0QTSpznhMhBsUFcm/INCv5z3zkeU5BpRsAx2S6LU9ycy/8qCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=NzyiWyZQ; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NzyiWyZQ"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260921232022epoutp013ad3db8211c73084169401c515dd1693~XeV5LZ_LA0743207432epoutp01V
	for <fio@vger.kernel.org>; Mon, 21 Sep 2026 23:20:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260921232022epoutp013ad3db8211c73084169401c515dd1693~XeV5LZ_LA0743207432epoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1790032822;
	bh=Tl0pECm8XO0tuARFl/YgPiU/Kp9XWd5v4ak+5GGPJ8A=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=NzyiWyZQw94enwW7WoobDldSwh7WzH1IvebBJgC6xtikfoQsp20Pz2EWTt1wKj5Xg
	 LDUFBToUZI1Nuv8tXqe49ddJip2TUdyLWoQg9BHOe99zJIs/58uHgI2cF02rBUWgWa
	 6n2GniTmvRQnaY0deE4Uuvg9Q0IqT5OlADloE5Nw=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20260921232022epcas2p245db11c7309ae1867bcc7daab0d60600~XeV47KZep1651116511epcas2p2B;
	Mon, 21 Sep 2026 23:20:22 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.199]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4hpfN611lzz2SSKb; Mon, 21 Sep
	2026 23:20:22 +0000 (GMT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE:(2) [PATCH] examples: add seq-rand-read-write.fio
Reply-To: jieon.seol@samsung.com
Sender: Jieon Seol <jieon.seol@samsung.com>
From: Jieon Seol <jieon.seol@samsung.com>
To: Vincent Fu <vincentfu@gmail.com>
CC: "fio@vger.kernel.org" <fio@vger.kernel.org>, "jieon.seol@gmail.com"
	<jieon.seol@gmail.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <CAOp=CXmANYTw3at495z+G3S9injh2nLpgOP=_vQ3LBtbaF-G_Q@mail.gmail.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260921232021epcms2p5c738e175300ab42e01655efe7535dcaf@epcms2p5>
Date: Tue, 22 Sep 2026 08:20:21 +0900
X-CMS-MailID: 20260921232021epcms2p5c738e175300ab42e01655efe7535dcaf
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260921025521epcms2p34a2d819339601929f469f71ca7014901
References: <CAOp=CXmANYTw3at495z+G3S9injh2nLpgOP=_vQ3LBtbaF-G_Q@mail.gmail.com>
	<20260921025521epcms2p34a2d819339601929f469f71ca7014901@epcms2p3>
	<CGME20260921025521epcms2p34a2d819339601929f469f71ca7014901@epcms2p5>

Hi Vincent,

Thanks for the feedback.

The proposed job already has direct=3D1 in the global section.

I considered modifying examples/ssd-test.fio, but kept this separate becaus=
e the workload differs in a few significant ways: in particular, it uses 51=
2 KiB sequential I/O, 4 KiB random I/O, and fixed-size runs rather than the=
 current 4 KiB, libaio/iodepth=3D4, time-based configuration.

If updating ssd-test.fio is preferable, I'm happy to rework the patch in th=
at direction.

Thanks,
Jieon


--------- Original Message ---------
Sender : Vincent Fu <vincentfu=40gmail.com>=C2=A0=0D=0ADate=20:=202026-09-2=
2=2007:59=20(GMT+9)=0D=0ATitle=20:=20Re:=20=5BPATCH=5D=20examples:=20add=20=
seq-rand-read-write.fio=0D=0A=0D=0AOn=20Sun,=20Sep=2020,=202026=20at=2010:5=
8=E2=80=AFPM=20=EC=84=A4=EC=A7=80=EC=96=B8=20<jieon.seol=40samsung.com>=20w=
rote:=0D=0A>=0D=0A>=20Add=20an=20example=20job=20file=20that=20runs=20four=
=20basic=20storage=20performance=0D=0A>=20workloads=20in=20a=20single=20fio=
=20invocation:=0D=0A>=0D=0A>=20-=20512=20KiB=20sequential=20read=0D=0A>=20-=
=20512=20KiB=20sequential=20write=0D=0A>=20-=204=20KiB=20random=20read=0D=
=0A>=20-=204=20KiB=20random=20write=0D=0A>=0D=0A>=20The=20sequential=20work=
loads=20transfer=201=20GiB=20each.=20The=20random=20workloads=0D=0A>=20oper=
ate=20over=20a=201=20GiB=20region=20using=20eight=20synchronous=20workers,=
=20with=20each=0D=0A>=20worker=20transferring=20128=20MiB=20(1=20GiB=20aggr=
egate=20per=20workload).=0D=0A>=0D=0A>=20Unlike=20examples/ssd-test.fio,=20=
which=20uses=204=20KiB=20I/O=20for=20both=20sequential=0D=0A>=20and=20rando=
m=20workloads,=20this=20job=20uses=20large-block=20sequential=20I/O=20for=
=0D=0A>=20bandwidth=20measurement=20and=20small-block=20random=20I/O=20for=
=20random=0D=0A>=20performance.=0D=0A>=0D=0A>=20The=20four=20workloads=20ar=
e=20serialized=20with=20stonewall=20and=20explicitly=20use=0D=0A>=20the=20p=
sync=20I/O=20engine.=20The=20target=20directory=20is=20supplied=20at=20invo=
cation=0D=0A>=20time,=20for=20example:=0D=0A>=0D=0A>=20=C2=A0=20=C2=A0=20fi=
o=20--directory=3D/path/to/test=20examples/seq-rand-read-write.fio=0D=0A>=
=0D=0A>=20Testing:=0D=0A>=20-=20fio=20--parse-only=20examples/seq-rand-read=
-write.fio=0D=0A>=0D=0A>=20Signed-off-by:=20Jieon=20Seol=20<jieon.seol=40sa=
msung.com>=0D=0A>=20---=0D=0A=0D=0A=0D=0AIf=20you=20are=20really=20interest=
ed=20in=20device=20performance=20you=20should=20run=20with=0D=0Adirect=3D1.=
=20Otherwise=20you=20will=20be=20measuring=20the=20performance=20of=20the=
=20page=20cache.=0D=0A=0D=0AWhy=20don't=20you=20just=20modify=20examples/ss=
d-test.fio?=20That=20would=20be=20better=20than=0D=0Acreating=20a=20complet=
ely=20new=20example=20job.=0D=0A=0D=0A=0D=0AVincent
