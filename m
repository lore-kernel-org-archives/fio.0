Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.pl.sii.eu ([91.227.21.9]:59256 "EHLO mail.pl.sii.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965945AbdDTOJB (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 20 Apr 2017 10:09:01 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.pl.sii.eu (Postfix) with ESMTP id C408C6F675F
        for <fio@vger.kernel.org>; Thu, 20 Apr 2017 15:58:53 +0200 (CEST)
Received: from mail.pl.sii.eu ([127.0.0.1])
        by localhost (mail.pl.sii.eu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8DD3r6aSpf7H for <fio@vger.kernel.org>;
        Thu, 20 Apr 2017 15:58:53 +0200 (CEST)
Received: from localhost (roundcube121.pl.sii.eu [10.254.16.42])
        by mail.pl.sii.eu (Postfix) with ESMTP id A86346F668C
        for <fio@vger.kernel.org>; Thu, 20 Apr 2017 15:58:53 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 20 Apr 2017 16:03:16 +0200
From: kjaszczerski <kjaszczerski@pl.sii.eu>
Subject: FIO mmap options dictate a minimum block size of 4096 bytes
Message-ID: <625e4fdeac5a68286ce7277718a50be5@pl.sii.eu>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I'm trying to run FIO on mmap engine on 4k socket and 4k channel. I'd 
like to use wrokload with blocksize parameter value less than 4k, is it 
possible ?
