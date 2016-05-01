Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:35889 "EHLO
	mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbcEATLj (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 1 May 2016 15:11:39 -0400
Received: by mail-lf0-f50.google.com with SMTP id u64so168237116lff.3
        for <fio@vger.kernel.org>; Sun, 01 May 2016 12:11:39 -0700 (PDT)
Received: from [192.168.0.103] (141.12.189.109.customer.cdi.no. [109.189.12.141])
        by smtp.googlemail.com with ESMTPSA id h8sm3743926lbb.27.2016.05.01.12.11.35
        for <fio@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Sun, 01 May 2016 12:11:36 -0700 (PDT)
From: Gurvinder Singh <gurvindersinghdahiya@gmail.com>
Subject: client/server test to write to single file from all clients
Message-ID: <a001b187-7ced-1295-2f6d-80039621aa88@gmail.com>
Date: Sun, 1 May 2016 21:11:35 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

First of all thanks for such a nice tool to do IO testing. I am
wondering if it is possible to test accessing a single file from
multiple clients to test distributed file system behavior.

The reason for this test is to see if it has different behavior than
having numjobs > 1 accessing same file running on same host.

Any thoughts on this are welcome.

Thanks,
Gurvinder
