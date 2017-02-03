Return-Path: <fio-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:41407 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751120AbdBCTL1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Feb 2017 14:11:27 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcsf-fio@m.gmane.org>)
        id 1cZjGN-0003jY-TL
        for fio@vger.kernel.org; Fri, 03 Feb 2017 20:11:15 +0100
From: Slow bucks <frankwhitebe@gmail.com>
Subject: fio exit run on timeout of device?
Date: Fri, 3 Feb 2017 13:11:14 -0600
Message-ID: <o72kkc$v07$2@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
        format=flowed
Content-Transfer-Encoding: 7BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Is there a way to tell FIO to immediately exit if a device times out or 
hangs during a run?


