Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63143 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097Ab1INJxv convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 14 Sep 2011 05:53:51 -0400
Received: by qyk30 with SMTP id 30so3662754qyk.19
        for <fio@vger.kernel.org>; Wed, 14 Sep 2011 02:53:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADson1wk9astwdroeAtPXb4A3+yrAcDcCXaEPvEGJPhM4TBfqQ@mail.gmail.com>
References: <CADson1wk9astwdroeAtPXb4A3+yrAcDcCXaEPvEGJPhM4TBfqQ@mail.gmail.com>
Date: Wed, 14 Sep 2011 17:53:50 +0800
Message-ID: <CADson1wi5=W-WDbDGy1j2T4FZD_2yoGGzOG8Af7GKKppiY7Lrg@mail.gmail.com>
Subject: memory leak bug? when do write with verify
From: Zhang Taile <zhangtl@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

HI
When I do RandWrite with verify, fio will use a lot of memory. The fio
will increase memory about 10MB in every second. And, the system will
become very slow, after fio start to use swap partition.

For example,=EF=BF=BD if use fio with following configuration,
[rand-write]
rw=3Drandwrite
numjobs=3D32
loops=3D10
thread=3D1
filename=3D/dev/sdb
verify=3Dmd5
verify_interval=3D4k

after=EF=BF=BD minutes, top will Like this :
=EF=BF=BDPID USER=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD PR=EF=BF=BD =
NI=EF=BF=BD VIRT=EF=BF=BD RES=EF=BF=BD SHR S %CPU %MEM=EF=BF=BD=EF=BF=BD=EF=
=BF=BD TIME+=EF=BF=BD COMMAND
=EF=BF=BD3749 root=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD 15=EF=BF=BD=
=EF=BF=BD 0 2672m 1.5g 304m S 169.4 40.4=EF=BF=BD=EF=BF=BD 4:10.04 fio


If remove the verify from the configuration, there will be no the
memory problem.

I guess it is a memory leak problem?


Thanks!
--
Taile
