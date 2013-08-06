Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:60710 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab3HFLMo (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 6 Aug 2013 07:12:44 -0400
Received: by mail-ob0-f169.google.com with SMTP id wc20so478390obb.28
        for <fio@vger.kernel.org>; Tue, 06 Aug 2013 04:12:44 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 6 Aug 2013 16:42:44 +0530
Message-ID: <CAJqT0iwmEvv5RXseLs+9XePax8wefj7xa9gdpwdfNZqzvQFEQQ@mail.gmail.com>
Subject: Help : Facing this when i trigger FIO from command line :"fio: file
 hash not empty on exit"
From: sampath rapaka <sampath.rapaka@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hello all

I am trying to trigger FIO from command line using below command.

But i was thrown below error message.

Error:
fio: pid=13800, got signal=11
fio: file hash not empty on exit

Command line command:

fio --output=test_1 --name=test_1 --filename=/dev/md0
--ioengine=libaio --direct=1 --norandommap --randrepeat=0
--refill_buffers --time_based --runtime=180s --blocksize=8k
--rw=randrw --rwmixwrite=67 --iodepth=32 --overwrite=1

There is something wrong in the command I have run ?

regards
sampath
