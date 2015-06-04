Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:32883 "EHLO
	mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbbFDOZv (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 4 Jun 2015 10:25:51 -0400
Received: by qkhg32 with SMTP id g32so24553671qkh.0
        for <fio@vger.kernel.org>; Thu, 04 Jun 2015 07:25:50 -0700 (PDT)
MIME-Version: 1.0
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Thu, 4 Jun 2015 09:25:09 -0500
Message-ID: <CAB-428kC-cZ0wQczthe=-RwGO_sn9F7e3BdyWa2f4a3ZkgAu0g@mail.gmail.com>
Subject: [Suggestion] Aggregated Client/Server Stats Reporting
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

I am using fio in client/server mode to drive an intensive workload
and measure performance. However, lacking the aggregated performance
stats reporting is unpleasant and make my time hard to convince people
use fio instead of IOMeter in this use case.
For example a use case of 10 IO server driving a workload produce 10
different stats at the end of the experiment. However, it would be
great to aggregate these 10 stats at the end and produce one average
states as well as individual servers performance.

--Alireza
