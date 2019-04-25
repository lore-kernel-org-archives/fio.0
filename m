Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45324 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbfDYPwF (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Apr 2019 11:52:05 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F2BEEC0578F2
        for <fio@vger.kernel.org>; Thu, 25 Apr 2019 15:52:04 +0000 (UTC)
Received: from localhost (ovpn-116-243.ams2.redhat.com [10.36.116.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0FF860C70
        for <fio@vger.kernel.org>; Thu, 25 Apr 2019 15:52:04 +0000 (UTC)
Date: Thu, 25 Apr 2019 16:52:03 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Is the libiscsi engine patch applied correctly?
Message-ID: <20190425155203.GA11294@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

It seems like these two lines might be in the wrong order? (and the
same thing later in the file too)

https://github.com/axboe/fio/blob/afc22c98609ee80a99fbed24231181bdab2bc659/optgroup.h#L65-L66

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-builder quickly builds VMs from scratch
http://libguestfs.org/virt-builder.1.html

