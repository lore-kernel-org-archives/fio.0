Return-Path: <fio-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:2493 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZHESKX convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 5 Aug 2009 14:10:23 -0400
Received: by qw-out-2122.google.com with SMTP id 8so116042qwh.37
        for <fio@vger.kernel.org>; Wed, 05 Aug 2009 11:10:24 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 5 Aug 2009 12:10:23 -0600
Message-ID: <f3177b9e0908051110t21d989a1rb68d519c25231ba4@mail.gmail.com>
Subject: Solaris issues in 1.3.1
From: Chris Worley <worleys@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I'm running fio 1.3.1 in Solaris.=EF=BF=BD I'm seeing two issues:

1) Direct I/O throws an error.
2) Performance is way too high.

W/o Direct I/O my size is set to 2.5x memory capacity to assure no
caching... yet performance for read/write is up to >7x the theoretical
speed of the storage device (i.e. it's reporting 7GB/s, when
theoretical for the device is 1GB/s).

I'm not seeing the reporting issue in 1.2.1.

Thanks,

Chris
