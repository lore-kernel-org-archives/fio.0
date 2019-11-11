Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk1-f181.google.com ([209.85.222.181]:39063 "EHLO
        mail-qk1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbfKKQnv (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 11 Nov 2019 11:43:51 -0500
Received: by mail-qk1-f181.google.com with SMTP id 15so11724567qkh.6
        for <fio@vger.kernel.org>; Mon, 11 Nov 2019 08:43:49 -0800 (PST)
From: Vincent Fu <vincentfu@gmail.com>
Subject: testing roadmap for fio
Message-ID: <03e1f4a5-dfce-e856-ac18-0832d2e383ce@gmail.com>
Date: Mon, 11 Nov 2019 11:43:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

I would like to undertake an effort to contribute more regression tests 
to fio.

My initial thought is to add more jobs to t/jobs. Unlike the jobs 
currently there, these new jobs would not target specific bugs. Instead, 
the jobs would exercise a variety of fio's options and use 
run-fio-tests.py to examine the JSON output to confirm that the options 
specified were appropriately respected.

Does this sound like a reasonable approach? Are there better directions 
to focus my efforts?

Vincent

