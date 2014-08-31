Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f70.google.com ([209.85.218.70]:37647 "EHLO
	mail-oi0-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaHaFip (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 31 Aug 2014 01:38:45 -0400
Received: by mail-oi0-f70.google.com with SMTP id u20so22617517oif.5
        for <fio@vger.kernel.org>; Sat, 30 Aug 2014 22:38:44 -0700 (PDT)
MIME-Version: 1.0
From: Surendar Chandra <surendar@datrium.com>
Date: Sat, 30 Aug 2014 22:38:24 -0700
Message-ID: <CAO+GKh1Y8Fxp+3vaSrtUvyp6NkTQi9ca7gi1j4rL0VGMQ6_z5g@mail.gmail.com>
Subject: specifying iodepth (libaio) remotely in server/client mode
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I was hoping something like
  fio --client=remote --iodepth=13 script.fio

would let me set the iodepth for this job remotley but it doesn't seem
to work.  BTW, terse output does not show the io depth used to
generate the results, right? Thnks much
