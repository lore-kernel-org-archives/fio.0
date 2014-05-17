Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:48170 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbaEQLwr (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 17 May 2014 07:52:47 -0400
Received: by mail-ie0-f177.google.com with SMTP id y20so781702ier.8
        for <fio@vger.kernel.org>; Sat, 17 May 2014 04:52:47 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 17 May 2014 12:52:46 +0100
Message-ID: <CA+BkS8M8GDkb7st7Q=TZzXmXHW6HrvjnrSoVnP8f74v9r0g1Nw@mail.gmail.com>
Subject: unable to replay a trace generated w/ fio
From: Alket Memushaj <amemushaj@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi all,

I am trying to replay traces with fio (2.1.5) and unable to do so. I
create the trace by adding --write_iolog to a simple job, ie: fio
--name=test --write_iolog=/var/tmp/ex.trace --time_based --runtime=10
--filename=/dev/sdb

I then try to replay this like: fio --name=replay
--read_iolog=/var/tmp/ex.trace but fio exits immediately with counters
set to 0

I would have expected this to run without issue - am I doing anything wrong?

Thanks,
Alket
