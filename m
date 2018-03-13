Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:38860 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752189AbeCMS4N (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 13 Mar 2018 14:56:13 -0400
Received: by mail-pf0-f182.google.com with SMTP id d26so279338pfn.5
        for <fio@vger.kernel.org>; Tue, 13 Mar 2018 11:56:12 -0700 (PDT)
From: Matt Freel <matt.freel@broadcom.com>
MIME-Version: 1.0
Date: Tue, 13 Mar 2018 12:56:10 -0600
Message-ID: <8d5a5fe209774d24b9df39cf6a226dbb@mail.gmail.com>
Subject: Proper way to shut down FIO in Linux
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I'm using FIO to run IOs to a number of block devices.  I'm looking for
the proper way to shut down all the threads that are spawned.

I'm doing the following:

/usr/bin/pkill --signal INT fio

Most of the time this works fine, but I do have cases where some of the
FIO processes remain open.  Eventually I get a 300s timeout and then
they're killed.

A couple questions:

1.	When these threads have to be ungracefully killed, do the results
still get counted in the output file?
a.	I'm using JSON output file
2.	Is there a better way I should be killing all the threads?
