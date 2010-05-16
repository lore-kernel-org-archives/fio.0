Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yw0-f198.google.com ([209.85.211.198]:41447 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab0EPPub (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 16 May 2010 11:50:31 -0400
Received: by ywh36 with SMTP id 36so1993492ywh.4
        for <fio@vger.kernel.org>; Sun, 16 May 2010 08:50:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikDsv9H0S_fE9JkAJOn6dxIW_wnMmiIq13hidL7@mail.gmail.com>
References: <AANLkTikDsv9H0S_fE9JkAJOn6dxIW_wnMmiIq13hidL7@mail.gmail.com>
Date: Sun, 16 May 2010 17:50:30 +0200
Message-ID: <AANLkTilwHeA9olwqW5PFcvotNxuCqfoN5_iyUe6PokFh@mail.gmail.com>
Subject: Re: replay blktrace to different device
From: =?ISO-8859-1?Q?Sebastian_F=E4rber?= <faerber@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

> I'm running fio like this:
> # fio --name=replay --filename=/dev/sdc --read_iolog=trace_input_fio
> and it aborts with
> fio: filesetup.c:855: get_file: Assertion `fio_file_open(f)' failed.

I captured another trace, this time for /dev/sdc, tried again using it
as input to read_iolog
and got the same error message.
So it looks like there is a general problem with "read_iolog" in fio 1.38?
I can supply the "--debug=all" logfile if needed.

Thanks!

- Sebastian
