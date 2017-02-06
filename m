Return-Path: <fio-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:58208 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751829AbdBFPzM (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 6 Feb 2017 10:55:12 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcsf-fio@m.gmane.org>)
        id 1calcm-0007eE-IV
        for fio@vger.kernel.org; Mon, 06 Feb 2017 16:54:40 +0100
From: Slow bucks <frankwhitebe@gmail.com>
Subject: randrepeat false for ssds
Date: Mon, 6 Feb 2017 09:54:23 -0600
Message-ID: <o7a678$p7c$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
        format=flowed
Content-Transfer-Encoding: 7BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Does it make sense to disable randrepeat on SSDs with the way data is 
written (always write to new block with empty pages)?


