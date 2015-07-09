Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yk0-f173.google.com ([209.85.160.173]:33192 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbbGIBzW (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 8 Jul 2015 21:55:22 -0400
Received: by ykeo3 with SMTP id o3so103727212yke.0
        for <fio@vger.kernel.org>; Wed, 08 Jul 2015 18:55:21 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 9 Jul 2015 09:55:21 +0800
Message-ID: <CAEg8mkz7MdEjZHukGX4AiaMF4hGKVPYcX3U3xszqAjjSFYEL4Q@mail.gmail.com>
Subject: ask a question about fio
From: john gong <johngong0791@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

hello All,

I wonder whether FIO can do below things in the same job?
1) sequential write
2) sequential read
3) randomly write
4) randomly read

Namely FIO do not need to spawn other processes to do the things respectively.
All things will be done in the same process.

Thanks in advance!

John.Gong
