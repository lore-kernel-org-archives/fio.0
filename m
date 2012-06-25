Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49533 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab2FYJvq (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 25 Jun 2012 05:51:46 -0400
Received: by vbbff1 with SMTP id ff1so1827970vbb.19
        for <fio@vger.kernel.org>; Mon, 25 Jun 2012 02:51:45 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 25 Jun 2012 15:21:45 +0530
Message-ID: <CAMZBPnc3_hmxXNJsVyPo2RVk5C0CQykiQAu8-Gop2Cxgcyifcw@mail.gmail.com>
Subject: Is there a way to choose randomness %?
From: Neependra Khare <neependra.khare@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

Lets say I want to read/write 4G of data to a file/disk and want only 25% of be
total IO to be random and rest to be sequential.

I see there is "rw_sequencer" option by which I can use with
"rw=<str>:nr", where
"nr" is offset modifier. I think if I know the block size the then I
can figure out when
 to choose the random offset after doing certain sequential IO to get
desired random %.

Does above is applicable to each thread? i.e. Does each thread would choose
random offset after doing the "nr" sequential IOs or it global setting.

Also is there a way to give just the desired random % without worrying
about the size and
block size.

--
Regards,
Neependra
