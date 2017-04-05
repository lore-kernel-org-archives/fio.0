Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:35995 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933306AbdDEREM (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 5 Apr 2017 13:04:12 -0400
Received: by mail-oi0-f42.google.com with SMTP id r203so22788192oib.3
        for <fio@vger.kernel.org>; Wed, 05 Apr 2017 10:04:12 -0700 (PDT)
MIME-Version: 1.0
From: Louwrentius <louwrentius@gmail.com>
Date: Wed, 5 Apr 2017 19:04:11 +0200
Message-ID: <CAL-AFxwpkdVHhO7d+bTWhsiTzEWiTP7di6+HSkzDvgooPx5zFQ@mail.gmail.com>
Subject: fio-plot, a tool to graph FIO JSON data
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

I've made 'fio-plot', a simple tool to create a graph from FIO JSON output.

https://github.com/louwrentius/fio-plot

The github link contains some examples in PNG format.

Ideas for interesting graph types are certainly welcome.
Maybe in the future, the y-axis can be defined dynamically.

The x-axis is currently fixed on queue-depths, tests may be run with
other conditions that
vary across tests that should be reflected on this x-axis.

A limitation of this tool is that it cannot (yet) handle benchmarks
with multiple jobs.

An obvious feature currently missing is to graph the raw log data
(iops, clat, lat. bw, etc)
and combine those graphs with various queue depths.

Feedback is welcome.

With regards,
Louwrentius
