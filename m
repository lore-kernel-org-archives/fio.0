Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout.micron.com ([137.201.242.129]:17436 "EHLO
        mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754077AbdDJRpQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 10 Apr 2017 13:45:16 -0400
Received: from mail.micron.com (bowex17f.micron.com [137.201.21.111])
        by mailout.micron.com (8.14.4/8.14.6) with ESMTP id v3AHjAVr018435
        for <fio@vger.kernel.org>; Mon, 10 Apr 2017 11:45:10 -0600
From: "Deyoung Hong (dhong)" <dhong@micron.com>
Subject: Adding IO engine
Date: Mon, 10 Apr 2017 17:45:09 +0000
Message-ID: <72a0d7083a3e46b4a4369c19d73c62fc@bowex36b.micron.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Jens,

I have a couple basic questions:

1)  If I want to submit a new IO engine with fio and it has a dependency on an external library, how does that work when fio is compiled?  Please also point me to info how to submit a new IO engine to be packaged with fio?

2)  I've seen cases where the ->iomem_alloc() function (i.e. for a custom IO engine) is invoked first by fio before ->get_file_size() or ->setup().  This causes an issue since IO memory allocation can have dependency on certain initialization (for the custom IO engine) that is done in ->get_file_size().   I just wonder if that's an fio bug or how it should be?   My current work around is to check in ->iomem_alloc() each time and do initializion first if has not.   

Thanks,
Deyoung

