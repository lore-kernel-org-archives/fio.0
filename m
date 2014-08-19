Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:40237 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbaHSAmc (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 18 Aug 2014 20:42:32 -0400
Received: by mail-ie0-f178.google.com with SMTP id rd18so282973iec.37
        for <fio@vger.kernel.org>; Mon, 18 Aug 2014 17:42:32 -0700 (PDT)
Received: from [192.168.1.3] (65-128-141-191.mpls.qwest.net. [65.128.141.191])
        by mx.google.com with ESMTPSA id qd8sm92595igb.1.2014.08.18.17.42.30
        for <fio@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 18 Aug 2014 17:42:31 -0700 (PDT)
Message-ID: <53F29D76.9080108@gmail.com>
Date: Mon, 18 Aug 2014 19:42:30 -0500
From: Mark Nelson <mark.a.nelson@gmail.com>
MIME-Version: 1.0
Subject: multiple --name parameters with non-file engine?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Guys,

I'm using the librbd engine and trying to determine what exactly happens 
when multiple --name parameters are passed.  Primarily, I'm wondering if 
each fio process ends up writing to the same blocks on the rbd volume 
during sequential writes.  Looking at the code, I see a note that we 
pretend to deal with files even if the engine doesn't understand the 
concept of files:

https://github.com/axboe/fio/blob/master/engines/rbd.c#L405
https://github.com/axboe/fio/blob/master/filesetup.c#L1239

I'm not seeing anything (might be missing it) in the rbd engine or there 
that would partition the volume based on the process though.  Am I 
missing anything?

Thanks,
Mark
