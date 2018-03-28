Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753937AbeC1Ppd (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 28 Mar 2018 11:45:33 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7843764DC
        for <fio@vger.kernel.org>; Wed, 28 Mar 2018 15:45:33 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DF2163750
        for <fio@vger.kernel.org>; Wed, 28 Mar 2018 15:45:33 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: Status of python3 for fio?
Message-ID: <e2032302-c19a-0e4a-2a44-ecb03807b7e7@redhat.com>
Date: Wed, 28 Mar 2018 10:45:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Fedora is moving more and more towards python3.  (TBH, as a non-python
expert, I don't know all the details...)

I see that python2.7 is hardcoded in several scripts, and Jens though
there were possibly some patches "floating out there" to switch
the various scripts to python3.  Does anyone know the status of
this work?

Thanks,
-Eric
