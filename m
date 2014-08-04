Return-Path: <fio-owner@vger.kernel.org>
Received: from na3sys010aog103.obsmtp.com ([74.125.245.74]:44717 "EHLO
	na3sys010aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751622AbaHDAMv convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>); Sun, 3 Aug 2014 20:12:51 -0400
From: Ritchie Babaylan <Ritchie.Babaylan@bitmicro.com>
Subject: Run FIO on a Windows Partition
Date: Mon, 4 Aug 2014 00:12:46 +0000
Message-ID: <9E26C6259ACF1842A4815F929194EDD394C42014@phex01.corp.bitmicro.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

I am just curios if FIO can test a Windows partition, say F: as the assigne=
d drive letter.
What would be the correct syntax do I need to put on a "filename" parameter?
Do I need to use the "directory" parameter instead?

[job1]
ioengine=3Dwindowsaio
iodepth=3D4
rw=3Dwrite
filename=3DF:

Btw, I am using the latest FIO v2.1.10 (32bit) version on Windows 7 (32bit).

=EF=BF=BD
Thanks,
=EF=BF=BD
Ritchie Babaylan
Advance CORE Engineering
BiTMICRO Networks, Inc.


