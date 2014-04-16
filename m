Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-la0-f68.google.com ([209.85.215.68]:64710 "EHLO
	mail-la0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaDPOVU (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 16 Apr 2014 10:21:20 -0400
Received: by mail-la0-f68.google.com with SMTP id pv20so2597856lab.7
        for <fio@vger.kernel.org>; Wed, 16 Apr 2014 07:21:19 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 16 Apr 2014 10:21:19 -0400
Message-ID: <CANyhEAtZQdnzCiQj77u+WbGkk1d6yXBnrHE0pKypbX0mDPNeeQ@mail.gmail.com>
Subject: fio laying out file question
From: Yuyang Wang <yyalex.wang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

hi all

I am using fio (2.1.7) for a simple sequential write test (see command
below). It seems the process will get stuck on "Laying out IO file" for a
long long time ...  Of course, smaller size take less time for layout,  I
am curious as to, is FIO trying to precreate the file before doing write,
what's going on there?

./fio --rw=write --size=128g --bs=8m --filename=/test/$RANDOM
--ioengine=posixaio --iodepth=16 --name=mytest

Thanks

Alex
