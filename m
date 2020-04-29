Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-eopbgr690098.outbound.protection.outlook.com ([40.107.69.98]:8421
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726399AbgD2Di2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 28 Apr 2020 23:38:28 -0400
From: Hamilton Tobon Mosquera <htobonm@eafit.edu.co>
Subject: Sequential read/write with multiple threads
Message-ID: <af3fe93c-bd21-c991-b4ce-80037623b723@eafit.edu.co>
Date: Tue, 28 Apr 2020 23:38:23 -0400
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi there,

I'm trying to run some benchmarks using the ioegnines libaio and 
pvsync2. I'm trying to run sequential reads/writes and random 
read/writes in a file of 200G with a maximum of 4 jobs, that is, 
threads. I don't mix them, that is, I run sequentially or randomly 
reads/writes.

My question is this: when running sequentially, given that I'm using 4 
threads, is it really sequential?. Do the threads interfere with each 
other?, if yes, which options should I use to make each thread only 
issue requests to disjoint parts of the file, each of 50G (in case of 4 
threads). I tried using offset_increment, but sometimes it overflows on 
random requests, and for sequential requests the file size increases 
automatically, that is, the requests are going further the size of the 
file, but it does not crashes. More specifically, I get the file size in 
bytes, exactly 214748364800. I divide that number in the number of 
threads, and I use the result as the offset_increment. The file is 
created using the filecreate engine with size 200G.

Lastly, is it possible for each thread to issue random requests only in 
that piece of 50G, so that it does not overflows to other threads piece 
of file or even overflow outside the file?.

Perhaps I'm doing something wrong. Could someone please help me?.

Thank you.

Hamilton.




