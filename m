Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53954 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab0KTHf0 (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 20 Nov 2010 02:35:26 -0500
Received: by iwn34 with SMTP id 34so470776iwn.19
        for <fio@vger.kernel.org>; Fri, 19 Nov 2010 23:35:25 -0800 (PST)
MIME-Version: 1.0
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Sat, 20 Nov 2010 11:04:44 +0330
Message-ID: <AANLkTikuenKFYwi1E005vgFdiHsXAANCAAToip_7woMS@mail.gmail.com>
Subject: Re: replay blktrace to different device
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Dear Sebastian

Did you find any way to reply trace on another device ?


Alireza Haghdoost


>> I'm running fio like this:
>> # fio --name=replay --filename=/dev/sdc --read_iolog=trace_input_fio
>> and it aborts with
>> fio: filesetup.c:855: get_file: Assertion `fio_file_open(f)' failed.
>I captured another trace, this time for /dev/sdc, tried again using it
>as input to read_iolog
>and got the same error message.
>So it looks like there is a general problem with "read_iolog" in fio 1.38?
>I can supply the "--debug=all" logfile if needed.
>Thanks!
>- Sebastian
--
