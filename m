Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:63558 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbaATVX0 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 20 Jan 2014 16:23:26 -0500
Received: by mail-lb0-f171.google.com with SMTP id c11so5424042lbj.30
        for <fio@vger.kernel.org>; Mon, 20 Jan 2014 13:23:25 -0800 (PST)
Received: from [192.168.1.201] (89-109-26-113.dynamic.mts-nn.ru. [89.109.26.113])
        by mx.google.com with ESMTPSA id wt2sm1923454lbb.2.2014.01.20.13.23.24
        for <fio@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 20 Jan 2014 13:23:24 -0800 (PST)
From: grant <626542@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Subject: Strange aggregate BW
Message-Id: <748581DD-9A26-41D7-A537-58F6D6741B33@gmail.com>
Date: Tue, 21 Jan 2014 01:23:22 +0400
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

I=EF=BF=BDve got a HWRAID with 10 NL-SAS HDDs.
All of them used in logical volume RAID6.
I=EF=BF=BDve tried to benchmark created volume with FIO v2.1.4:

# cat seqwrite.fio
[write]
blocksize=3D512k
filename=3D/dev/sda
rw=3Dwrite
direct=3D1
buffered=3D0
ioengine=3Dlibaio
iodepth=3D1
runtime=3D10m
numjobs=3D16

#./fio seqwrite.fio

FIO returns:
...
Run status group 0 (all jobs):
  WRITE: io=3D127958MB, aggrb=3D2132.5MB/s, minb=3D56530KB/s, maxb=3D229141=
KB/s..

2132 / 10 ~ 200 MB/s per HDD, is that possible???