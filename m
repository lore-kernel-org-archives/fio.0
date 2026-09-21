Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58ED244667
	for <fio@vger.kernel.org>; Mon, 21 Sep 2026 02:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789959333; cv=none; b=FmUjQG+mgPdQL68jRdImhG9SMu9v1lmoRf8lFaQnSJGbCdXRGAPnRH15b3jPQRqYC31YJLErIl793/Xky9dSBTTi4Tmg/iUSEf8gYx4wFsfl0bNV4iLX55dAKfD0ayMXTOwDccXeKbEpZbMHHgmi1c0JNEQyIQjSgRNXyctPhwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789959333; c=relaxed/simple;
	bh=uhUOmEIuoIJh9eWFjLRZHxLzmHLHntOLfZu/Sa42va8=;
	h=Mime-Version:Subject:From:To:CC:Message-ID:Date:Content-Type:
	 References; b=ldLV3s8lu5hEhS/DIz5sIy4h3g/L5Q23Kb044gCtjcVhC11uMS6d0zc09kCLah1pTm85CgH/94AVY32tu/vYWt0fLD9XFUznzkuCmFXjuUtoucScAf34OAeKNw3MftqHPsdKJ5tG7eXCUTBDYPPSEadMcy5g2EuweVzTPA440TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=vUnLkibt; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="vUnLkibt"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260921025522epoutp019d15caa9b34b38e8fd484b4b7ff68cf6~XNoUqpTqH1964419644epoutp01y
	for <fio@vger.kernel.org>; Mon, 21 Sep 2026 02:55:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260921025522epoutp019d15caa9b34b38e8fd484b4b7ff68cf6~XNoUqpTqH1964419644epoutp01y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1789959322;
	bh=uhUOmEIuoIJh9eWFjLRZHxLzmHLHntOLfZu/Sa42va8=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=vUnLkibtA2qRyp/mAtFntP7+pNcjX3py+/010uVl/T8W6VLKhX5F44WEeO0jJ65jR
	 J+xSRk3F2cXRlRXgUsfW+/xQqciBiLycOXELPqIByGg3ll9h02Q+o/YebPC0axRKOp
	 kVHYwUFVdN/xTxPYeoDsf/MWaubKvkGt6vRFi+nM=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20260921025522epcas2p44939c66bd5b3627ccd0bec4e77ec131f~XNoUU7_ch2200022000epcas2p4Q;
	Mon, 21 Sep 2026 02:55:22 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.206]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4hp7Bd5Nvwz3hhT8; Mon, 21 Sep
	2026 02:55:21 +0000 (GMT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH] examples: add seq-rand-read-write.fio
Reply-To: jieon.seol@samsung.com
Sender: =?UTF-8?B?7ISk7KeA7Ja4?= <jieon.seol@samsung.com>
From: =?UTF-8?B?7ISk7KeA7Ja4?= <jieon.seol@samsung.com>
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
CC: =?UTF-8?B?7ISk7KeA7Ja4?= <jieon.seol@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260921025521epcms2p34a2d819339601929f469f71ca7014901@epcms2p3>
Date: Mon, 21 Sep 2026 11:55:21 +0900
X-CMS-MailID: 20260921025521epcms2p34a2d819339601929f469f71ca7014901
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260921025521epcms2p34a2d819339601929f469f71ca7014901
References: <CGME20260921025521epcms2p34a2d819339601929f469f71ca7014901@epcms2p3>

Add an example job file that runs four basic storage performance
workloads in a single fio invocation:

- 512 KiB sequential read
- 512 KiB sequential write
- 4 KiB random read
- 4 KiB random write

The sequential workloads transfer 1 GiB each. The random workloads
operate over a 1 GiB region using eight synchronous workers, with each
worker transferring 128 MiB (1 GiB aggregate per workload).

Unlike examples/ssd-test.fio, which uses 4 KiB I/O for both sequential
and random workloads, this job uses large-block sequential I/O for
bandwidth measurement and small-block random I/O for random
performance.

The four workloads are serialized with stonewall and explicitly use
the psync I/O engine. The target directory is supplied at invocation
time, for example:

=C2=A0=20=C2=A0=20fio=20--directory=3D/path/to/test=20examples/seq-rand-rea=
d-write.fio=0D=0A=0D=0ATesting:=0D=0A-=20fio=20--parse-only=20examples/seq-=
rand-read-write.fio=0D=0A=0D=0ASigned-off-by:=20Jieon=20Seol=20<jieon.seol=
=40samsung.com>=0D=0A---=0D=0A=C2=A0examples/seq-rand-read-write.fio=2045=
=20++++++++++++++++++++++++++++++++=0D=0A=C2=A01=20file=20changed,=2045=20i=
nsertions(+)=0D=0A=C2=A0create=20mode=20100644=20examples/seq-rand-read-wri=
te.fio=0D=0A=0D=0Adiff=20--git=20a/examples/seq-rand-read-write.fio=20b/exa=
mples/seq-rand-read-write.fio=0D=0Anew=20file=20mode=20100644=0D=0Aindex=20=
00000000..77128ac7=0D=0A---=20/dev/null=0D=0A+++=20b/examples/seq-rand-read=
-write.fio=0D=0A=40=40=20-0,0=20+1,45=20=40=40=0D=0A+=23=20Basic=20sequenti=
al=20and=20random=20read/write=20workloads.=0D=0A+=23=0D=0A+=23=20Sequentia=
l=20workloads=20transfer=201=20GiB=20using=20512=20KiB=20blocks.=0D=0A+=23=
=20Random=20workloads=20access=20a=201=20GiB=20file=20using=20eight=20synch=
ronous=20workers,=0D=0A+=23=20each=20transferring=20128=20MiB=20(1=20GiB=20=
aggregate).=0D=0A+=0D=0A+=5Bglobal=5D=0D=0A+ioengine=3Dpsync=0D=0A+direct=
=3D1=0D=0A+group_reporting=0D=0A+=0D=0A+=5Bseq-read=5D=0D=0A+filename=3Dseq=
-rand-readwrite-seq=0D=0A+rw=3Dread=0D=0A+bs=3D512k=0D=0A+size=3D1g=0D=0A+f=
ilesize=3D1g=0D=0A+=0D=0A+=5Bseq-write=5D=0D=0A+stonewall=0D=0A+filename=3D=
seq-rand-readwrite-seq=0D=0A+rw=3Dwrite=0D=0A+bs=3D512k=0D=0A+size=3D1g=0D=
=0A+filesize=3D1g=0D=0A+unlink=3D1=0D=0A+=0D=0A+=5Brand-read=5D=0D=0A+stone=
wall=0D=0A+filename=3Dseq-rand-readwrite-rand=0D=0A+rw=3Drandread=0D=0A+bs=
=3D4k=0D=0A+numjobs=3D8=0D=0A+size=3D128m=0D=0A+filesize=3D1g=0D=0A+=0D=0A+=
=5Brand-write=5D=0D=0A+stonewall=0D=0A+filename=3Dseq-rand-readwrite-rand=
=0D=0A+rw=3Drandwrite=0D=0A+bs=3D4k=0D=0A+numjobs=3D8=0D=0A+size=3D128m=0D=
=0A+filesize=3D1g=0D=0A+unlink=3D1=0D=0A--=C2=A0=0D=0A2.34.1
