Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:34452 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698AbcAHLPq (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 8 Jan 2016 06:15:46 -0500
Received: by mail-lb0-f173.google.com with SMTP id cl12so5483027lbc.1
        for <fio@vger.kernel.org>; Fri, 08 Jan 2016 03:15:45 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 8 Jan 2016 12:15:44 +0100
Message-ID: <CADr68WZJ0+r4M5WArqvRkHHTAj=uLg8bi8xmGr+mMJ=KamQ+UQ@mail.gmail.com>
Subject: engine rbd broken after commit 2466096336bd0fbc1a94811aa338926af6baf42f
From: Jens Rosenboom <j.rosenboom@x-ion.de>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

When running fio-2.3 with the rbd engine, the tests themselves run
fine, but instead of the results being printed, I get:

fio: mutex.c:163: fio_mutex_down: Assertion `mutex->magic ==
0x4d555445U' failed.

The command I am using is

fio --ioengine=rbd --clientname=admin --pool=test --rbdname=test1
--rw=randwrite --runtime=10 --ramp_time=None --numjobs=1 --direct=1
--bs=1048576B --iodepth=64 --name=test1

If I instead use another engine, everything is fine, e.g.:

fio --ioengine=libaio --filename=/dev/sdb1 --rw=randwrite --runtime=10
--ramp_time=None --numjobs=1 --direct=1 --bs=1048576B --iodepth=64
--name=test1

Going back to fio-2.2.13 makes the error go away and running a git
bisect leads to the commit mentioned in the subject as the culprit,
the error turns into a Segmentation Fault at that point, though.
