Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp2.provo.novell.com ([137.65.250.81]:57915 "EHLO
        smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729461AbeGQRIH (ORCPT
        <rfc822;groupwise-fio@vger.kernel.org:0:0>);
        Tue, 17 Jul 2018 13:08:07 -0400
Message-ID: <3e2d2b0388c994116ee7c8785fa96e8855d7b679.camel@suse.com>
Subject: fio, vsync and iovcnt
From: Martin Wilck <mwilck@suse.com>
Date: Tue, 17 Jul 2018 18:34:20 +0200
Content-Type: text/plain; charset="utf-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I hope this question isn't too stupid - how do I make fio use iovcnt >
1 with readv() / writev() ? No matter what I tried so far, it seems to
be using a single iovec entry only.

Thanks,
Martin

-- 
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)

