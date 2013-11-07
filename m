Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:36703 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab3KGUmk (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 7 Nov 2013 15:42:40 -0500
Received: by mail-vc0-f175.google.com with SMTP id ht10so764194vcb.20
        for <fio@vger.kernel.org>; Thu, 07 Nov 2013 12:42:39 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 7 Nov 2013 15:42:39 -0500
Message-ID: <CAHPXfP7PFPwAK=CbPYkL_XU5UfjCjvOyf0atdD0fL6e3BF6c3g@mail.gmail.com>
Subject: Latency log, add filename to record
From: chris meyers <chris.meyers.fsu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

https://github.com/axboe/fio/pull/3
The above patch modifies the CSV latency log (write_lat_log options)
by appending the filename to which the record is related. Said
differently, the filename to which the I/O was issued to. When I first
set out to add this feature I had indended to create a new log file in
order to distrubt the latency log file format as little as possible.
This, however, was not easily doable given the structure of the fio
code. Now, in order to still provide this feature while maintaining
the legacy latency file format I propose two options.
(1) A configuration options as an extention to write_lat_log. For example:
write_lat_log=mylogfile:with_filename
(2) As a seperate configuration option that modifies the write_lat_log
format. For example:
write_lat_log_with_filename=bool

This email is to start a discussion and solicit feedback on the
proposed feature as well as the cooresponding configuration trigger.

-Chris
