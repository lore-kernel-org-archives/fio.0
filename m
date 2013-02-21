Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:59027 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab3BUFfe (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 21 Feb 2013 00:35:34 -0500
Received: by mail-wi0-f182.google.com with SMTP id hi18so7118304wib.9
        for <fio@vger.kernel.org>; Wed, 20 Feb 2013 21:35:33 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 21 Feb 2013 00:35:32 -0500
Message-ID: <CACTzACVBXK7nKXHCaaOxSE=2YN+WKjaDPtQqZkfgL1jNyVhxLg@mail.gmail.com>
Subject: Random vs Sequential Read in FIO
From: David N <android.wm.edu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I was using FIO to get response time of random reads and sequential
reads from phone's flash memory and I got like 9x greater response
time for random read. Since there is no seek time as in conventional
rotating storage, I'm wondering where this huge jump of random IO
response time comes from? How is the total IO delay actually
calculated in FIO?

Thanks much for your inputs.
David
