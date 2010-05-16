Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-gx0-f217.google.com ([209.85.217.217]:63378 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab0EPOyP (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 16 May 2010 10:54:15 -0400
Received: by gxk9 with SMTP id 9so2703832gxk.8
        for <fio@vger.kernel.org>; Sun, 16 May 2010 07:54:14 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 16 May 2010 16:54:13 +0200
Message-ID: <AANLkTikDsv9H0S_fE9JkAJOn6dxIW_wnMmiIq13hidL7@mail.gmail.com>
Subject: replay blktrace to different device
From: =?ISO-8859-1?Q?Sebastian_F=E4rber?= <faerber@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

i discovered that fio is able to replay captured blktrace patterns and
just tried it ... without luck.
It seems that fio can only replay the blktrace to the device that the
trace was captured on?

I did a blktrace on one of my servers which uses /dev/md1 as its main
device and tried replaying
the patterns on another server where i prepared a spare device (/dev/sdc).

I'm running fio like this:
# fio --name=replay --filename=/dev/sdc --read_iolog=trace_input_fio
and it aborts with
fio: filesetup.c:855: get_file: Assertion `fio_file_open(f)' failed.

I also enabled --debug=all and noticed that while parsing the blktrace
fio adds /dev/md1 to it's list of devices.
The system i'm running fio on also has a /dev/md1 but this is my
root-device and i don't want fio to run the r/w benchmark
there.
Is this a bug or would it be possible to modify fio so "--filename"
overrides the device in captured trace?

- Sebastian
