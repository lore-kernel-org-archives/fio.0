Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:49170 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab3JJRIg (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 10 Oct 2013 13:08:36 -0400
Received: by mail-lb0-f176.google.com with SMTP id y6so2344803lbh.21
        for <fio@vger.kernel.org>; Thu, 10 Oct 2013 10:08:34 -0700 (PDT)
MIME-Version: 1.0
From: "Brian L." <brianclam@gmail.com>
Date: Thu, 10 Oct 2013 10:08:13 -0700
Message-ID: <CAAAK+WXw_-gAJL9u9Bibvz=4aHVH2YYvgQRi2sMvekY6xDRR4A@mail.gmail.com>
Subject: IO scheduler
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi there,

I was wondering if you guys use NOOP IO scheduler when you are running fio?

I use the CFQ IO scheduler but I do put the OS into init 1 and run fio
process one at a time so that I can get accurate readings.

I was wondering what are people practice and experience in the real world.

Thanks,
Brian L.
