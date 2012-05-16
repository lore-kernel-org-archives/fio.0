Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-out1.uio.no ([129.240.10.57]:53972 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760529Ab2EPTg2 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 16 May 2012 15:36:28 -0400
Received: from mail-mx3.uio.no ([129.240.10.44])
	by mail-out1.uio.no with esmtp (Exim 4.75)
	(envelope-from <jarle.bjorgeengen@usit.uio.no>)
	id 1SUjmf-00042o-J3
	for fio@vger.kernel.org; Wed, 16 May 2012 21:21:17 +0200
Received: from 7.123.45.31.customer.cdi.no ([31.45.123.7] helo=heritage.uio.no)
	by mail-mx3.uio.no with esmtpsa (TLSv1:AES256-SHA:256)
	user jb (Exim 4.76)
	(envelope-from <jarle.bjorgeengen@usit.uio.no>)
	id 1SUjme-0006uc-UE
	for fio@vger.kernel.org; Wed, 16 May 2012 21:21:17 +0200
Message-ID: <4FB3FE27.3030302@usit.uio.no>
Date: Wed, 16 May 2012 21:21:11 +0200
From: =?ISO-8859-1?Q?Jarle_Bj=F8rgeengen?= 
	<jarle.bjorgeengen@usit.uio.no>
MIME-Version: 1.0
Subject: blktrace with fio replay for benchmarking vendor offerings
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

I'm involved in the purchasing process of block storage systems, and=20
research viable benchmarking strategies for specifying and verifying=20
performance requirements.

Ideally I would like to capture our traces of our current daily=20
production workload  with blktrace, attach the traces to the tender and=20
require the configuration to be able to run 2x that kind of workload.=20
During acceptance I would like to hook enough hardware to saturate the=20
system with the same workload, and measure that the requirement has been=20
met.

I'm interested in comments about the practical viability of such=20
approach if anyone have similar experiences.

Some open questions:

How safe is it to run blktrace on critical production environment? What=20
precautions should be made?

Given that the current system consists of 3 HP EVA800 with X number of=20
LUNS about 50 hosts, and the new system likely is a single system with 5=20
new servers running at at full speed, how much value will the benchmark=20
provide compared to "real world" ? Should I create equally many luns and=20
distribute load across the 5 machines?

Is it best to scale the workload to 2X replaying all traces=20
simultanously with one fio-trace-replay/lun, and then dublicate alle=20
replays so that each lun serves two fio-replays rather than one, and=20
then 3 and so on.

Any thoughts or comments are very much appreciated.

Best regards
Jarle Bj=EF=BF=BDrgeengen
University of Oslo / USIT
