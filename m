Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726730AbeHUW3w (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 21 Aug 2018 18:29:52 -0400
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 0/2] fio: few enhancements
Date: Tue, 21 Aug 2018 12:08:22 -0700
Message-Id: <20180821190824.29928-1-mcgrof@kernel.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: andrey.o.kudryavtsev@intel.com, Luis Chamberlain <mcgrof@kernel.org>

I've been toying around with fio's output for a bit, mostly because
Intel's fiovisualizer [0] was the first graphing tool I found for fio, even
though gfio exists. The way fiovisualizer works is it reads terse
ouptut, parses that, and plots data. gfio on the other hand is a proper
built-in client, where communication is exchanged between client/server
and the client plots the data.

If you end up using scraper for terse data such as fiovisualizer with
the prospect to scrape data you will end up with different results if
you use a remote server as a backend.

While studying fio code I realized that the way fiovisualizer implements
graphing is perhaps the wrong / least optimal approach, but also that
fio terse output needed a bit of love for client/server relationship to
keep fidelity in terms of the expected output.

These are just two small enhancements which I hope wil make things
clearer.

[0] https://github.com/intel/fiovisualizer

Luis Chamberlain (2):
  client: respect terse output on client <--> backend relationship
  init: add semantics for all types of backends running

 backend.c  |  2 ++
 client.c   | 16 +++++++++++++---
 diskutil.c |  2 +-
 fio.h      |  8 ++++++++
 init.c     |  1 +
 stat.c     |  4 +++-
 6 files changed, 28 insertions(+), 5 deletions(-)

-- 
2.18.0


