Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:34621 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287AbbDYNDD (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 25 Apr 2015 09:03:03 -0400
Received: by iedfl3 with SMTP id fl3so113602149ied.1
        for <fio@vger.kernel.org>; Sat, 25 Apr 2015 06:03:03 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 25 Apr 2015 21:03:02 +0800
Message-ID: <CABtFm2U5t2=sM4MDKhaPn7n9nsJTSBUCSUeZ=9irt8EEBTogBQ@mail.gmail.com>
Subject: achieving a workload to get specific unique duplicate blocks
From: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Firstly, thanks before in hand. :)

Using FIO, what is the way to achieve a work load with specific number
of unique blocks duplicates for specific number of times. For Example,
i want a 252k block duplicates 1000 times and i want it to be the
unique block in the complete workload.

Another query is that, for a blocksize of 256k does the io buffers are
created at 256k and written to the disk and are all those 256k blocks
unique buffer?. Can there be a change that in a 256k block, the
smaller size buffers be the same?

-- 
Srinivasa R Chamarthy
