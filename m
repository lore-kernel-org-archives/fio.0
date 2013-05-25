Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vb0-f42.google.com ([209.85.212.42]:34842 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab3EYBMi (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 24 May 2013 21:12:38 -0400
Received: by mail-vb0-f42.google.com with SMTP id w15so3200968vbf.29
        for <fio@vger.kernel.org>; Fri, 24 May 2013 18:12:38 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 24 May 2013 18:12:38 -0700
Message-ID: <CAF+0mvnU7GMsKrbArcECaD5Z0YtLxA6GtghQjOJtOxZHb=cxjQ@mail.gmail.com>
Subject: Question on --buffer_compress_percentage
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello fio group,

Can anyone tell me if --buffer_compress_percentage fills the buffer
with random data and reuses that data or if it refills with random
data for each submit?  If you want the latter behavior should you
combine with --refill_buffers?

Thanks for your help!

-Matt
