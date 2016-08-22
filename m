Return-Path: <fio-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:59459 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S932454AbcHVQiF (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 22 Aug 2016 12:38:05 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcsf-fio@m.gmane.org>)
        id 1bbsEc-00029D-7m
        for fio@vger.kernel.org; Mon, 22 Aug 2016 18:38:02 +0200
From: Saeed <ionictea@gmail.com>
Subject: multiple entries for each second for bw/iop/xlat log files
Date: Mon, 22 Aug 2016 11:37:56 -0500
Message-ID: <npf9p3$6e3$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
        format=flowed
Content-Transfer-Encoding: 7BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Why are there multiple entries for each interval / second in the fio 
log generated?

1, 585142, 1, 4096
1, 4096000, 1, 4096
1, 4096000, 1, 4096
1, 0, 1, 4096
1, 0, 1, 4096
1, 4096000, 1, 4096
1, 0, 1, 4096
1, 0, 1, 4096
1, 4096000, 1, 4096
1, 0, 1, 4096
2, 4096000, 1, 4096
2, 4096000, 1, 4096
2, 4096000, 1, 4096
2, 0, 1, 4096
2, 4096000, 1, 4096
2, 4096000, 1, 4096
2, 4096000, 1, 4096
2, 0, 1, 4096
2, 0, 1, 4096
2, 0, 1, 4096


