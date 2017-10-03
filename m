Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33707 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751184AbdJCJ4p (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 3 Oct 2017 05:56:45 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 72A69883C6
        for <fio@vger.kernel.org>; Tue,  3 Oct 2017 09:56:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A44E5C89D
        for <fio@vger.kernel.org>; Tue,  3 Oct 2017 09:56:45 +0000 (UTC)
Received: from zmail24.collab.prod.int.phx2.redhat.com (zmail24.collab.prod.int.phx2.redhat.com [10.5.83.30])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 64A7241F77
        for <fio@vger.kernel.org>; Tue,  3 Oct 2017 09:56:45 +0000 (UTC)
Date: Tue, 3 Oct 2017 05:56:45 -0400 (EDT)
From: Erwan Velu <evelu@redhat.com>
Message-ID: <1152612183.12823334.1507024605339.JavaMail.zimbra@redhat.com>
In-Reply-To: <677167325.12822827.1507024453234.JavaMail.zimbra@redhat.com>
Subject: A few fixes
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Jens,

After running the scan-build tool from clang, I produced a few commits you can find on a PR :

https://github.com/axboe/fio/pull/469/commits

Cheers,
Erwan
