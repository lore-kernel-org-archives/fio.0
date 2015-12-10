Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:38799 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbbLJHBq (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 10 Dec 2015 02:01:46 -0500
Received: by igbxm8 with SMTP id xm8so7878200igb.1
        for <fio@vger.kernel.org>; Wed, 09 Dec 2015 23:01:46 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 10 Dec 2015 07:01:46 +0000
Message-ID: <CALjAwxhfyQ3ppw-MXoRwAkhk4+-LSJSTkZQa32ymKizKU0Ox-A@mail.gmail.com>
Subject: Exit all jobs on error
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

Is there an option to exit all jobs but only on error? If I have a job like this

[global]
stonewall=1
verify=crc32
rw=write
[pass1]
bs=4k
[pass2]
bs=8k

I want fio to stop if pass1 fails verification and for pass2 not to be
performed at all. I'm aware of "exitall" but using that will make fio
quit even if pass1 is successful.

-- 
Sitsofe | http://sucs.org/~sits/
